"""
猫省省 — AI 分析流水线
拍照 → 图像分类 → 特征提取 → 案例匹配 → LLM 综合分析 → 分层结果
"""
import json, base64, io, re, os
from typing import Optional
from openai import OpenAI
import numpy as np

# ============================================================
# Config
# ============================================================
DEEPSEEK_API_KEY = os.environ.get("DEEPSEEK_API_KEY", "")
DEEPSEEK_BASE_URL = "https://api.deepseek.com"
CASES_PATH = "../cases.json"

# ============================================================
# Vector Store (numpy-based — 零依赖，后续切 pgvector 只改此类)
# ============================================================
class VectorStore:
    """In-memory vector store using numpy cosine similarity"""
    
    def __init__(self, dim: int = 512):
        self.dim = dim
        self.vectors: np.ndarray = None       # N x dim
        self.cases: list = []
        self._load_cases()
    
    def _load_cases(self):
        """Load cases from JSON and build vectors"""
        with open(CASES_PATH, 'r', encoding='utf-8') as f:
            self.cases = json.load(f)
        
        vectors = []
        for case in self.cases:
            text = f"{case.get('title','')} {case.get('symptom_text','')} {case.get('image_features','')}"
            vec = self._text_to_vec(text)
            vectors.append(vec)
        
        self.vectors = np.array(vectors, dtype=np.float32)
        # Normalize for cosine similarity
        norms = np.linalg.norm(self.vectors, axis=1, keepdims=True)
        norms[norms == 0] = 1
        self.vectors = self.vectors / norms
    
    def _text_to_vec(self, text: str) -> np.ndarray:
        """Simple TF-IDF-like embedding using character n-gram hashing"""
        vec = np.zeros(self.dim, dtype=np.float32)
        # Character bigrams for Chinese text
        for i in range(len(text)-1):
            bigram = text[i:i+2]
            h = hash(bigram) % self.dim
            vec[h] += 1
        # Also add unigrams
        for ch in text:
            h = hash(ch) % self.dim
            vec[h] += 0.3
        return vec
    
    def search(self, query_text: str, top_k: int = 5) -> list:
        """Search similar cases by cosine similarity"""
        if self.vectors is None or len(self.vectors) == 0:
            return []
        
        query_vec = self._text_to_vec(query_text)
        q_norm = np.linalg.norm(query_vec)
        if q_norm > 0:
            query_vec = query_vec / q_norm
        
        # Cosine similarity
        scores = np.dot(self.vectors, query_vec)
        top_indices = np.argsort(scores)[::-1][:top_k]
        
        results = []
        for idx in top_indices:
            if scores[idx] > 0:
                results.append({
                    "score": float(scores[idx]),
                    "case": self.cases[idx],
                    "index": int(idx)
                })
        return results


# ============================================================
# AI Pipeline
# ============================================================
class CatHealthAI:
    """Orchestrates the full AI pipeline"""
    
    CATEGORIES = {
        "skin": "皮肤/毛发问题（猫癣、脱毛、黑下巴、过敏）",
        "digestive": "消化问题（呕吐、腹泻、软便、便秘）",
        "urinary": "泌尿问题（尿血、尿闭、乱尿）",
        "eye": "眼部问题（红肿、流泪、分泌物）",
        "respiratory": "呼吸道问题（喷嚏、咳嗽、鼻涕）",
        "oral": "口腔问题（口炎、牙病、流口水）",
        "other": "其他问题"
    }
    
    def __init__(self):
        self.vs = VectorStore()
        self.llm = OpenAI(
            api_key=DEEPSEEK_API_KEY,
            base_url=DEEPSEEK_BASE_URL
        )
    
    def classify_image(self, image_base64: str) -> dict:
        """Step 1: Classify what the image is about"""
        prompt = f"""分析这张猫相关的图片。判断它属于哪一类问题，只输出JSON:
{{
    "category": "skin/digestive/urinary/eye/respiratory/oral/other",
    "description": "简短描述图片内容(中文,30字内)",
    "urgency_guess": "low/medium/high"
}}

图片数据: [base64 image, {len(image_base64)} bytes]"""
        
        resp = self.llm.chat.completions.create(
            model="deepseek-chat",
            messages=[{"role": "user", "content": prompt}],
            temperature=0.3,
            max_tokens=150
        )
        try:
            result = json.loads(resp.choices[0].message.content)
        except:
            result = {"category": "other", "description": "无法识别", "urgency_guess": "medium"}
        return result
    
    def extract_features(self, image_classification: dict) -> str:
        """Step 2: Build feature text for similarity search"""
        return f"{image_classification.get('category','')} {image_classification.get('description','')}"
    
    def match_cases(self, features: str, top_k: int = 5) -> list:
        """Step 3: Find similar cases"""
        return self.vs.search(features, top_k=top_k)
    
    def synthesize(self, classification: dict, matches: list, cat_info: dict = None) -> dict:
        """Step 4: LLM synthesizes a recommendation based on similar cases"""
        case_summaries = []
        for m in matches[:5]:
            c = m['case']
            case_summaries.append(
                f"- [{c['risk_level'].upper()}] {c['title']}: {c.get('symptom_text','')[:150]}\n"
                f"  处理: {c.get('home_treatment','')[:200]}\n"
                f"  就医指征: {c.get('when_to_see_vet','')[:150]}"
            )
        
        cat_context = ""
        if cat_info:
            cat_context = f"猫的基本信息：品种={cat_info.get('breed','未知')}，年龄={cat_info.get('age','未知')}，体重={cat_info.get('weight','未知')}kg"
        
        prompt = f"""你是猫省省AI助手。用户上传了一张猫咪相关图片，你需要基于相似案例给出建议。

【重要约束】
1. 不做诊断！不说"你的猫得了X病"。说"和数据库中X案例相似"。
2. 分层输出：低风险给居家方案，中风险建议咨询，高风险推就医。
3. 每个建议附"就医指征"（什么情况下必须去）。
4. 回复末尾附免责声明。

图片分类: {json.dumps(classification, ensure_ascii=False)}
{cat_context}

相似案例(按匹配度排序):
{chr(10).join(case_summaries)}

请输出JSON格式:
{{
    "risk_level": "low/medium/high",
    "summary": "一句话总结(中文,30字内)",
    "possible_causes": ["原因1","原因2"],
    "home_care": "居家处理建议(中文,多段落,可包含具体药品名和价格)",
    "when_to_see_vet": "什么情况下必须就医(中文,具体症状触发条件)",
    "similar_cases_count": 数字,
    "disclaimer": "AI辅助信息工具，不替代兽医诊断。紧急情况立即就医。"
}}"""
        
        resp = self.llm.chat.completions.create(
            model="deepseek-chat",
            messages=[{"role": "user", "content": prompt}],
            temperature=0.5,
            max_tokens=800
        )
        
        try:
            content = resp.choices[0].message.content
            # Extract JSON from response
            json_match = re.search(r'\{.*\}', content, re.DOTALL)
            result = json.loads(json_match.group()) if json_match else {}
        except:
            result = {
                "risk_level": "medium",
                "summary": classification.get('description', '无法分析'),
                "possible_causes": ["信息不足，建议再次拍照或描述症状"],
                "home_care": "请重新拍摄更清晰的照片，或直接描述猫的症状。",
                "when_to_see_vet": "如果猫精神萎靡、不进食、呕吐腹泻持续>24小时，请立即就医。",
                "similar_cases_count": len(matches),
                "disclaimer": "AI辅助信息工具，不替代兽医诊断。紧急情况立即就医。"
            }
        
        # Enrich with matched case references
        result["matched_cases"] = [
            {
                "id": m['case']['id'],
                "title": m['case']['title'],
                "risk_level": m['case']['risk_level'],
                "real_case_summary": m['case'].get('real_case_summary', ''),
                "score": round(m['score'], 3)
            }
            for m in matches[:5]
        ]
        
        return result
    
    def analyze(self, image_base64: str = None, image_text: str = None, cat_info: dict = None) -> dict:
        """Run the full pipeline"""
        # Step 1: Classify
        if image_base64:
            classification = self.classify_image(image_base64)
        elif image_text:
            classification = {
                "category": "other",
                "description": image_text[:100],
                "urgency_guess": "medium"
            }
        else:
            return {"error": "请提供图片或症状描述"}
        
        # Step 2: Features
        features = self.extract_features(classification)
        
        # Step 3: Match
        matches = self.match_cases(features)
        
        # Step 4: Synthesize
        result = self.synthesize(classification, matches, cat_info)
        
        # Add metadata
        result["classification"] = classification
        result["pipeline_version"] = "1.0.0"
        
        return result


# Singleton
_ai_instance: Optional[CatHealthAI] = None

def get_ai() -> CatHealthAI:
    global _ai_instance
    if _ai_instance is None:
        _ai_instance = CatHealthAI()
    return _ai_instance
