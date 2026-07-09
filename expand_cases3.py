#!/usr/bin/env python3
"""Batch 3: fill remaining categories to reach 60+ cases"""
import json

with open('D:/hermes-workspace/projects/maoshengsheng/cases.json', 'r', encoding='utf-8') as f:
    cases = json.load(f)

new_cases = [
    # Skin
    {"id":"skin-006","category":"skin","title":"猫癣反复发作 — 环境未消毒","symptom_text":"猫癣治好了又复发，反复在同一个位置或新的位置出现。可能家人也被传染。","image_features":"反复出现的脱毛斑，可能在治愈位置旁边出现新斑","risk_level":"medium","possible_causes":["环境真菌孢子未清除","免疫力持续低下","未坚持用药到足够疗程"],"home_treatment":"1)环境用二氧化氯或次氯酸彻底消毒(沙发/地毯/猫窝/猫爬架)。2)紫外线灯辅助消毒。3)治疗至少持续到症状消失后2周。4)补充维生素B/不饱和脂肪酸。5)多晒太阳。6)家庭成员同时检查自身有无感染。","when_to_see_vet":"反复超过2个月/继发细菌感染/考虑口服抗真菌药","typical_cost_range":"50-200元(消毒用品+外用药)","typical_duration":"彻底环境消毒+全程治疗4-8周","keywords":["猫癣","反复","环境消毒","传染人","真菌"],"real_case_summary":"猫友：猫癣好了又长，反反复复半年。最后发现是沙发里的真菌孢子没杀掉，用二氧化氯彻底熏了一遍就好了。"},
    
    # Digestive
    {"id":"digest-009","category":"digestive","title":"猫吃塑料/纸 — 异食癖","symptom_text":"猫频繁舔/咬/吞食塑料制品、纸箱、布料等非食物物品。可能同时呕吐塑料碎片或排泄物中有异物。","image_features":"猫啃咬塑料/纸/布等","risk_level":"medium","possible_causes":["营养缺乏(纤维不足)","无聊/焦虑","强迫症行为","早离乳的口欲期未满足"],"home_treatment":"1)收好所有塑料/线/小物件。2)增加互动和玩具减少无聊。3)提供可咀嚼的安全替代品(猫草/猫薄荷玩具)。4)猫粮换成高纤配方。5)增加湿粮比例增加饱腹感。","when_to_see_vet":"吞食大量异物/呕吐/便秘/拒食(可能肠道阻塞)","typical_cost_range":"0-100元(玩具+环境调整)","typical_duration":"行为调整2-4周","keywords":["异食癖","吃塑料","啃纸","无聊","吞异物"],"real_case_summary":"猫友：我家猫疯狂舔塑料袋，怎么制止都没用。兽医说可能是无聊或营养问题，增加了每天互动时间+换了粮，两周后好了很多。"},
    {"id":"digest-010","category":"digestive","title":"胰腺炎 — 剧烈呕吐不吃","symptom_text":"猫突然剧烈呕吐(一天多次)、精神极度萎靡、完全不吃不喝、腹部触痛(不让碰肚子)、可能把自己蜷成一团。常见诱因：吃了高脂肪食物/人类食物。","image_features":"猫蜷缩、呕吐物多次、精神极差","risk_level":"high","possible_causes":["急性胰腺炎","高脂饮食诱发","特发性"],"home_treatment":"不要居家处理。禁食禁水，立即送医。","when_to_see_vet":"立即急诊。胰腺炎可致命。","typical_cost_range":"3000-10000元(住院输液+止痛+胰酶+鼻饲管)","typical_duration":"住院5-10天","keywords":["胰腺炎","剧烈呕吐","腹痛","不吃","急诊"],"real_case_summary":"猫友：过年给猫吃了两块红烧肉，第二天开始剧烈呕吐，确诊胰腺炎，住了8天院花了7000。猫绝对不能吃人类油腻食物。"},
    
    # Eye
    {"id":"eye-003","category":"eye","title":"第三眼睑突出 — 眼睛里有粉色膜","symptom_text":"猫眼角内侧出现粉红色或白色膜状物(第三眼睑/瞬膜)覆盖部分眼球。可能单侧或双侧。猫精神食欲可能正常。","image_features":"眼角内侧粉色/白色膜状物覆盖部分眼球","risk_level":"medium","possible_causes":["肠胃不适/寄生虫(霍纳氏综合征可能)","脱水","眼部感染","神经系统问题","特发性"],"home_treatment":"1)观察是否伴随腹泻呕吐(肠道问题常引起第三眼睑突出)。2)保证饮水。3)驱虫。4)如果精神食欲正常且无其他症状→观察24-48小时。","when_to_see_vet":"超过48小时/双侧同时/伴有其他神经症状(瞳孔大小不一/走路歪斜)","typical_cost_range":"100-500元(检查+驱虫)","typical_duration":"肠道相关问题解决后几天内恢复","keywords":["第三眼睑","瞬膜","粉色膜","眼角","霍纳氏"],"real_case_summary":"猫友：猫眼睛突然长出一层粉膜，吓得以为要瞎了。兽医检查后说有寄生虫，驱虫后两天就好了。原来肠胃问题也会引起眼睛反应。"},
    
    # Behavioral  
    {"id":"behav-003","category":"behavioral","title":"新猫旧猫打架 — 多猫不合","symptom_text":"新猫进家后，原住民和新猫持续互哈、追逐、打架(不是玩耍那种)。可能造成双方应激：乱尿、躲藏、食欲下降。","image_features":"两只猫对峙、炸毛、哈气","risk_level":"medium","possible_causes":["领地意识","引入方式不当(直接见面未隔离)","个性不合"],"home_treatment":"1)退回到隔离阶段：新猫单独房间5-7天，只通过门缝交换气味。2)交换彼此的毛巾/毯子熟悉气味。3)费洛蒙扩散器(多猫和谐款)。4)正面见面时同时给零食建立正向关联。5)多点设置食水砂盆减少竞争。6)不要打骂—会加剧应激。","when_to_see_vet":"打架导致受伤/一方完全不敢出来超过一周/体重下降","typical_cost_range":"100-300元(费洛蒙)","typical_duration":"2-6周逐步适应","keywords":["两只猫打架","新猫","隔离","哈气","领地"],"real_case_summary":"猫友：新猫到家直接跟原住民见面，两只打了一周。后来退回到隔离重新来，按步骤交换气味+费洛蒙，两周后和平共处。多猫引入不能心急。"},
    {"id":"behav-004","category":"behavioral","title":"分离焦虑 — 主人出门猫叫/破坏","symptom_text":"主人出门后，猫持续嚎叫、破坏家具、乱尿(通常在主人物品上)、过度 grooming 舔秃。主人回来后猫极度粘人。","image_features":"被破坏的家具、在主人衣物上乱尿的痕迹","risk_level":"medium","possible_causes":["分离焦虑","环境缺乏刺激","过度依赖主人"],"home_treatment":"1)出门前不搞仪式感(悄悄走)。2)出门时留益智玩具/藏食。3)开电视/收音机制造背景声音。4)费洛蒙扩散器。5)回家后不过度补偿性关注。6)考虑养第二只猫(如果猫喜欢同伴)。","when_to_see_vet":"行为调整4周无效/严重自残(舔到秃皮流血)/考虑抗焦虑药物","typical_cost_range":"100-400元(费洛蒙+益智玩具)","typical_duration":"行为调整4-8周","keywords":["分离焦虑","嚎叫","破坏","主人出门","粘人"],"real_case_summary":"猫友：疫情期间天天在家，复工后猫开始在我床上尿+抓门嚎叫。装了摄像头看到我走后猫一直叫。后来出门给藏食玩具+收音机开着，慢慢好了。"},
    
    # Respiratory
    {"id":"resp-003","category":"respiratory","title":"猫哮喘/咳嗽 — 像要吐毛球但吐不出","symptom_text":"猫出现阵发性咳嗽，脖子伸长、贴近地面、发出类似要吐毛球的声音但什么都没吐出来。可能伴随呼吸急促或张口呼吸。发作间歇正常。","image_features":"猫伸长脖子贴近地面咳嗽，没有东西吐出","risk_level":"medium","possible_causes":["猫哮喘/过敏性支气管炎","刺激性气味(香薰/烟/清洁剂)","猫砂粉尘","空气污染"],"home_treatment":"1)移除家中香薰/香水/烟/刺激性清洁剂。2)换无尘猫砂。3)加湿器+空气净化器。4)记录发作频率和诱因。5)如果偶尔发作(月<2次)且发作后精神食欲正常→可在下次体检时提。","when_to_see_vet":"发作频率增加/每次持续超过1分钟/张口呼吸/牙龈发紫(缺氧)/猫精神变差","typical_cost_range":"500-3000元(检查+吸入器+可能需要的激素治疗)","typical_duration":"终身管理，控制后可减少发作","keywords":["咳嗽","哮喘","吐不出","伸长脖子","香薰","粉尘"],"real_case_summary":"猫友：猫隔三差五像要吐毛球但什么也没有，刚开始以为便秘。医生说是哮喘，可能和我的香薰有关。停了香薰+换了无尘猫砂后发作少了很多。"},
    
    # Ear
    {"id":"ear-001","category":"ear","title":"耳血肿 — 耳朵肿得像饺子","symptom_text":"猫耳廓突然肿胀、变厚、像个充水的小气球。通常由猫频繁抓挠或剧烈甩头导致耳内血管破裂。可能有耳螨或耳炎作为原发问题。","image_features":"耳廓肿胀，像充水的气球","risk_level":"medium","possible_causes":["耳螨/耳炎导致频繁抓挠甩头→血管破裂","外伤","凝血功能障碍(少见)"],"home_treatment":"需要就医。小的血肿可能自行吸收但需要治疗原发耳病。大的需要穿刺引流或手术。","when_to_see_vet":"发现耳廓肿胀即就医。拖延会导致耳廓变形(菜花耳)。","typical_cost_range":"500-3000元(穿刺/手术+耳病治疗)","typical_duration":"治疗1-2周，恢复2-4周","keywords":["耳血肿","耳朵肿","饺子耳","甩头","抓耳"],"real_case_summary":"猫友：猫耳朵突然肿了，以为被蜜蜂蛰了。医生说耳血肿，是耳螨引起的剧烈甩头导致。先处理耳血肿再治耳螨，一共花了2000左右。"},
    
    # Parasite
    {"id":"para-002","category":"parasite","title":"体外寄生虫 — 蜱虫/虱子","symptom_text":"猫身上(尤其在头颈部/耳后)发现附着的小虫子。蜱虫呈灰褐色豆形，吸血后膨胀。虱子较小，白色或淡黄，附着在毛发根部。猫可能抓挠该区域。常见于户外猫或接触过草丛的猫。","image_features":"毛发间/皮肤上附着的蜱虫(灰褐豆形)或虱子(白色小点)","risk_level":"medium","possible_causes":["户外活动接触草丛","其他动物传播"],"home_treatment":"1)蜱虫：用专用蜱虫夹或细镊子夹住头部(不是身体)缓慢旋转拔出。不要用手拔/挤/涂酒精/涂凡士林。不要留下口器在皮肤里。2)虱子：体外驱虫药即可。3)拔蜱后伤口用碘伏消毒。4)保存拔出的蜱虫(放密封袋)以便确定品种。5)环境清洁。","when_to_see_vet":"蜱虫口器残留皮肤内/叮咬处红肿化脓/猫发热/精神差(可能传播疾病)/大量蜱虫附着","typical_cost_range":"0-80元(蜱虫夹+体外驱虫药)","typical_duration":"拔除后即时解决，预防需定期驱虫","keywords":["蜱虫","虱子","体外寄生虫","户外","拔蜱"],"real_case_summary":"猫友：带猫去草地遛了一圈回来发现耳朵后面有个灰豆子，吓死了。百度说不能硬拔，用蜱虫夹转出来的。之后再也不带去草地了。"},
    
    # Injury
    {"id":"injury-001","category":"injury","title":"猫打架受伤 — 抓伤/咬伤","symptom_text":"猫和其他猫打架后出现抓痕、咬痕、或小的穿刺伤口(咬伤的典型伤口很小但很深)。伤口可能化脓、周围肿胀、猫舔舐该区域。户外猫更常见。","image_features":"抓痕或小圆孔状伤口，周围可能红肿化脓","risk_level":"medium","possible_causes":["猫打架（户外猫/多猫家庭冲突）"],"home_treatment":"1)小抓痕：碘伏消毒即可，猫自愈能力强。2)咬伤穿刺伤口：特别注意！外表小但内部深，容易感染化脓→建议就医清创。3)戴伊丽莎白圈防舔。4)如果猫未打狂犬疫苗且是被未知猫咬伤→必须就医。","when_to_see_vet":"咬伤穿刺伤口/伤口化脓/猫发热/精神变差/被流浪猫咬伤","typical_cost_range":"50-1000元(简单消毒到清创缝合)","typical_duration":"抓伤5-7天，咬伤1-2周","keywords":["打架","抓伤","咬伤","伤口","化脓","碘伏"],"real_case_summary":"猫友：猫打架回来脖子上有个小洞，没在意。三天后肿了鸡蛋大一个脓包，去医院切开引流，花了800。咬伤外表小里面大，一定要重视。"},
    
    # Poison
    {"id":"poison-001","category":"emergency","title":"对猫有毒的常见家居物品","symptom_text":"【这是预警信息，非症状描述】以下常见物品对猫有毒：退热药(布洛芬/对乙酰氨基酚→1片可致命)、洋葱/大蒜/韭菜、巧克力、葡萄/葡萄干、木糖醇(口香糖/牙膏)、清洁剂/消毒剂、精油(茶树油/薄荷油等)、蚊香/电蚊香液(拟除虫菊酯类)。","image_features":"N/A","risk_level":"high","possible_causes":["中毒"],"home_treatment":"怀疑中毒：1)不要催吐(可能造成二次伤害)。2)记录可能的毒物名称和大概数量。3)立即送急诊，带上毒物包装。4)不要喂水喂奶(民间偏方有害)。","when_to_see_vet":"怀疑任何中毒 → 立即急诊，不要观望。","typical_cost_range":"视毒物和程度，2000-15000元","typical_duration":"住院1-7天","keywords":["中毒","退热药","洋葱","巧克力","百合","精油","蚊香","急诊"],"real_case_summary":"猫友：猫翻垃圾桶吃了一小片洋葱，晚上就吐了精神也不好。送急诊打了催吐针+输液观察了一晚，还好量少。从此所有洋葱都锁柜子里。"},
]

cases.extend(new_cases)

with open('D:/hermes-workspace/projects/maoshengsheng/cases.json', 'w', encoding='utf-8') as f:
    json.dump(cases, f, ensure_ascii=False, indent=2)

from collections import Counter
cats = Counter(c['category'] for c in cases)
print(f"Total: {len(cases)} cases")
for cat, count in cats.most_common():
    print(f"  {cat}: {count}")
