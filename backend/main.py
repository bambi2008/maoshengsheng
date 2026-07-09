"""
猫省省 API — FastAPI Backend
"""
from fastapi import FastAPI, File, UploadFile, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import Optional, List
import base64, json, time, uuid

from ai_pipeline import get_ai

app = FastAPI(
    title="猫省省 API",
    description="猫奴的AI省钱助手 — 拍照分析+比价+避坑",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================================================
# Models
# ============================================================
class CatInfo(BaseModel):
    breed: Optional[str] = None
    age: Optional[str] = None
    weight: Optional[float] = None
    gender: Optional[str] = None
    neutered: Optional[bool] = None

class AnalyzeRequest(BaseModel):
    image_base64: Optional[str] = None
    symptom_text: Optional[str] = None
    cat_info: Optional[CatInfo] = None

class AnalyzeResponse(BaseModel):
    request_id: str
    risk_level: str
    summary: str
    possible_causes: List[str]
    home_care: str
    when_to_see_vet: str
    similar_cases_count: int
    matched_cases: List[dict]
    classification: dict
    disclaimer: str
    pipeline_version: str
    elapsed_ms: float

class SearchRequest(BaseModel):
    query: str  # Drug name or product name
    type: str = "drug"  # drug / product

class SearchResponse(BaseModel):
    query: str
    results: List[dict]

# ============================================================
# Endpoints
# ============================================================
@app.get("/")
async def root():
    return {"name": "猫省省 API", "version": "1.0.0", "status": "running"}

@app.get("/health")
async def health():
    """Health check"""
    return {"status": "ok", "timestamp": time.time()}

@app.post("/analyze", response_model=AnalyzeResponse)
async def analyze(req: AnalyzeRequest):
    """
    核心端点：拍照分析
    接受图片(base64)或文字描述，返回AI分析结果
    """
    start = time.time()
    request_id = uuid.uuid4().hex[:12]
    
    if not req.image_base64 and not req.symptom_text:
        raise HTTPException(status_code=400, detail="请提供图片或症状描述")
    
    ai = get_ai()
    
    # Build cat_info dict
    cat_info = None
    if req.cat_info:
        cat_info = {
            "breed": req.cat_info.breed,
            "age": req.cat_info.age,
            "weight": req.cat_info.weight,
            "gender": req.cat_info.gender,
            "neutered": req.cat_info.neutered
        }
    
    result = ai.analyze(
        image_base64=req.image_base64,
        image_text=req.symptom_text,
        cat_info=cat_info
    )
    
    elapsed = (time.time() - start) * 1000
    
    return AnalyzeResponse(
        request_id=request_id,
        risk_level=result.get("risk_level", "medium"),
        summary=result.get("summary", ""),
        possible_causes=result.get("possible_causes", []),
        home_care=result.get("home_care", ""),
        when_to_see_vet=result.get("when_to_see_vet", ""),
        similar_cases_count=result.get("similar_cases_count", 0),
        matched_cases=result.get("matched_cases", []),
        classification=result.get("classification", {}),
        disclaimer=result.get("disclaimer", "AI辅助信息工具，不替代兽医诊断。紧急情况立即就医。"),
        pipeline_version=result.get("pipeline_version", "1.0.0"),
        elapsed_ms=round(elapsed, 1)
    )

@app.post("/analyze/upload")
async def analyze_upload(file: UploadFile = File(...), cat_info: str = Form(None)):
    """上传图片文件进行分析"""
    contents = await file.read()
    image_base64 = base64.b64encode(contents).decode('utf-8')
    
    cat_info_dict = None
    if cat_info:
        try:
            cat_info_dict = json.loads(cat_info)
        except:
            pass
    
    req = AnalyzeRequest(image_base64=image_base64, cat_info=CatInfo(**cat_info_dict) if cat_info_dict else None)
    return await analyze(req)

@app.post("/analyze/text")
async def analyze_text(req: AnalyzeRequest):
    """仅通过文字描述分析"""
    if not req.symptom_text:
        raise HTTPException(status_code=400, detail="请提供症状描述")
    return await analyze(req)

@app.post("/search/drug")
async def search_drug(req: SearchRequest):
    """药品比价搜索"""
    # MVP: 返回预设的常用药比价数据
    drug_prices = json.load(open("../data/drug_prices.json", 'r', encoding='utf-8'))
    
    results = []
    q = req.query.lower()
    for drug in drug_prices:
        if q in drug['name'].lower() or q in drug.get('generic','').lower():
            results.append(drug)
    
    return SearchResponse(query=req.query, results=results[:10])

@app.get("/cases/{case_id}")
async def get_case(case_id: str):
    """获取案例详情"""
    cases = json.load(open("../cases.json", 'r', encoding='utf-8'))
    for c in cases:
        if c['id'] == case_id:
            return c
    raise HTTPException(status_code=404, detail="案例未找到")

@app.get("/cases/category/{category}")
async def list_cases_by_category(category: str, limit: int = 20):
    """按品类列出案例"""
    cases = json.load(open("../cases.json", 'r', encoding='utf-8'))
    filtered = [c for c in cases if c.get('category') == category][:limit]
    return {"category": category, "count": len(filtered), "cases": filtered}

@app.get("/knowledge/alternatives")
async def get_alternatives(category: str = None):
    """获取平替清单"""
    data = json.load(open("../knowledge/alternatives.json", 'r', encoding='utf-8'))
    if category:
        return [a for a in data if a.get('category') == category]
    return data

# ============================================================
# Startup
# ============================================================
@app.on_event("startup")
async def startup():
    """预加载AI pipeline"""
    get_ai()
    print("✅ 猫省省 API 启动完成")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)
