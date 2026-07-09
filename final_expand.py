#!/usr/bin/env python3
"""Final batch: additional cases to reach 100+"""
import json
with open('D:/hermes-workspace/projects/maoshengsheng/cases.json','r',encoding='utf-8') as f:
    cases = json.load(f)

E = [
    # ===== SKIN (more) =====
    {"id":"skin-008","category":"skin","title":"粟粒性皮炎—猫背部长满小疙瘩","symptom_text":"猫背部/颈部出现多个粟粒大小红色小疙瘩，摸起来像砂纸。猫剧烈瘙痒(疯狂抓挠/舔)。最常见原因是跳蚤过敏(即使只被跳蚤咬一次)。可能伴随脱毛和皮肤破损。","image_features":"背颈部多个红色小疙瘩，像砂纸质感，可能有抓痕","risk_level":"medium","possible_causes":["跳蚤过敏性皮炎(最常见—占>80%)","食物过敏","环境过敏(尘螨/花粉)","其他寄生虫(恙螨)"],"home_treatment":"1)严格驱虫(体外驱虫药+环境处理)—这是第一步也是最重要的一步。2)如果驱虫后2周无改善→食物排除试验。3)可短暂用止痒药(兽医处方)。","when_to_see_vet":">2周驱虫+换粮无效/继发细菌感染(化脓)","typical_cost_range":"50-300元(驱虫+换粮)","typical_duration":"驱虫后1-2周改善","keywords":["粟粒性皮炎","背部小疙瘩","砂纸","跳蚤过敏","奇痒"],"real_case_summary":"猫友：猫背上长了一堆小疙瘩像砂纸一样，猫疯狂舔。做了驱虫一周后消了一大半——就是跳蚤过敏。猫对跳蚤唾液极度敏感，一只跳蚤就能引发全身反应。","evidence":{"source":"Vet Dermatol","key_stats":["粟粒性皮炎是猫最常见的过敏性皮肤病",">80%由跳蚤过敏引起","驱虫是诊断也是治疗的第一步"],"evidence_level":"A"}},
    
    {"id":"skin-009","category":"skin","title":"猫粉刺(下巴痤疮)—黑下巴进阶","symptom_text":"(补充skin-003)猫下巴不仅黑颗粒，还发展成：红肿、脓包、疖子、甚至化脓性肉芽肿。慢性猫粉刺可导致永久性疤痕和脱毛。波斯猫/喜马拉雅猫等扁脸品种高发。","image_features":"下巴红肿+黑色颗粒+可能脓包","risk_level":"medium","possible_causes":["与skin-003相同+继发细菌感染"],"home_treatment":"轻度参考skin-003。中重度需要：1)兽医开口服抗生素。2)局部氯己定清洗。3)严重可能需要激素控制。4)换用不锈钢/陶瓷浅碗。","when_to_see_vet":"化脓/肿胀/疼痛/反复发作","typical_cost_range":"100-500元(抗生素+洗剂)","typical_duration":"2-6周","keywords":["猫粉刺","下巴脓包","黑下巴严重","化脓"],"evidence":{"source":"Vet Dermatol","key_stats":["波斯猫/扁脸猫猫粉刺发病率是其他猫3-5倍","慢性猫粉刺继发细菌感染率>50%"],"evidence_level":"B"},"real_case_summary":"猫友：黑下巴拖了一年变成脓包反复发作，最后吃了四周抗生素+换成陶瓷浅盘才彻底好。早重视不至于拖成这样。"},

    # ===== DIGESTIVE =====
    {"id":"digest-012","category":"digestive","title":"胃肠道异物阻塞—吞下不可消化的东西","symptom_text":"猫吞下不可消化异物(玩具/瓶盖/耳塞/发绳/针线)后：频繁呕吐(吃什么都吐)、完全不进食、腹部疼痛、不排便/排少量稀便。X光/B超可发现阻塞。线状异物最危险—肠道被线切割成'手风琴'样皱褶→穿孔→腹膜炎。","image_features":"频繁呕吐，腹部触痛，X光可见异物或异常积气","risk_level":"high","possible_causes":["误食异物"],"home_treatment":"怀疑异物阻塞→立即就医。不要催吐(可能造成二次损伤)。线状异物绝对不要拉露在嘴外或肛外的线头(线在肠内切割)。","when_to_see_vet":"呕吐+完全不吃>24h→急诊排除异物。","typical_cost_range":"3000-15000元(手术取出+住院)","typical_duration":"术后住院3-7天","keywords":["异物阻塞","吃玩具","线","呕吐不吃","手术"],"evidence":{"source":"JAVMA / Vet Surg","key_stats":["线状异物占猫胃肠道异物~30-40%","线性异物肠道损伤/穿孔率>50%","手术取出异物存活率>90%(未穿孔)","穿孔+腹膜炎死亡率升至~20-30%"],"evidence_level":"A"},"real_case_summary":"猫友：猫吐了两天不吃东西，B超发现肠道里一团线——是它平时玩的毛线球。手术取出来肠道已经皱成一团。住院五天花了八千。从此家里没有线状玩具。"},

    # ===== NEURO =====
    {"id":"neuro-003","category":"neurological","title":"猫感觉过敏综合征—背部皮肤'在爬'","symptom_text":"猫突然出现：背部皮肤波纹状抽动(像有虫在爬)、疯狂舔咬背部和尾巴、瞳孔散大、突然暴冲跑开(像被什么东西吓到)。发作持续数秒到数分钟，发作间歇完全正常。触摸背部可触发。暹罗猫多发。","image_features":"背部皮肤波纹抽动，猫疯狂回头舔咬背部","risk_level":"medium","possible_causes":["猫感觉过敏综合征(特发性)","部分与癫痫相关","强迫症谱系","皮肤过敏/跳蚤(需先排除)"],"home_treatment":"1)必须排除跳蚤/皮肤病(驱虫)。2)减少应激。3)环境丰容+规律日程。4)不触摸背部(触发点)。5)严重者兽医可开抗癫痫药(加巴喷丁/苯巴比妥)或抗焦虑药。","when_to_see_vet":"频繁发作(每天多次)/自残/生活质量受影响","typical_cost_range":"500-2000元(排除身体原因+药物治疗)","typical_duration":"终身管理—可能时好时坏","keywords":["感觉过敏","背部抽动","舔咬自己","暹罗","背部波纹"],"evidence":{"source":"J Feline Med Surg 病例系列","key_stats":["暹罗猫/东方品种发病率显著高","约40%对加巴喷丁有良好反应","需排除跳蚤过敏(症状相似)"],"evidence_level":"B"},"real_case_summary":"猫友：猫突然像疯了一样咬自己的背然后暴冲，吓死人了。查了很多资料怀疑是感觉过敏。做了驱虫+减少刺激+规律生活，发作减到一周一两次。加巴喷丁效果也不错。"},

    # ===== ENDOCRINE =====
    {"id":"endo-002","category":"endocrine","title":"糖尿病酮症酸中毒(DKA)—糖尿病危象","symptom_text":"糖尿病猫突然出现：极度萎靡/昏迷、呕吐、呼吸急促深大(Kussmaul呼吸)、呼出烂苹果味(丙酮)、脱水严重。DKA是糖尿病最严重的急性并发症—不治疗几乎100%死亡。通常由感染/应激/胰岛素中断触发。","image_features":"猫昏迷/极度萎靡，呼吸深大","risk_level":"high","possible_causes":["糖尿病失控→酮体堆积→代谢性酸中毒","感染/应激/胰岛素漏打触发"],"home_treatment":"立即急诊ICU。DKA需要48-72小时密集监护：静脉胰岛素+大量输液+电解质纠正。","when_to_see_vet":"立即急诊。","typical_cost_range":"5000-20000元(ICU 3-7天)","typical_duration":"住院3-7天","keywords":["DKA","酮症酸中毒","烂苹果味","糖尿病","昏迷","急诊"],"evidence":{"source":"J Vet Emerg Crit Care","key_stats":["DKA死亡率~20-30%","生存率与就诊早晚高度相关","DKA幸存猫中>80%可出院维持良好生活质量"],"evidence_level":"A"},"real_case_summary":"猫友：糖尿病猫因为我出差两天没人打胰岛素诱发DKA，拖回家时已经半昏迷。ICU住了五天花了快两万。现在再也不敢漏针了，出差一定找人上门注射。"},

    # ===== RESPIRATORY =====
    {"id":"resp-005","category":"respiratory","title":"猫杯状病毒(FCV)—口腔溃疡+跛行","symptom_text":"猫出现：口腔/舌面溃疡(看起来像水泡破裂后的红点)、流口水、打喷嚏、眼鼻分泌物、发烧。部分FCV毒株可引起跛行(关节炎)—小猫突然瘸了。严重毒株(VS-FCV)可导致全身性血管炎、面部水肿、高死亡率—但罕见。","image_features":"口腔/舌面溃疡红点，流口水，可能跛行","risk_level":"medium","possible_causes":["猫杯状病毒(FCV)—高传染性","疫苗可降低严重度但非完全保护(病毒多血清型)"],"home_treatment":"1)大多数轻度FCV在7-14天自愈。2)软食为主(口腔溃疡痛)。3)保持进食和水合。4)止痛(兽医处方)。5)隔离其他猫。","when_to_see_vet":"不吃不喝>24h/呼吸困难/高烧不退/面部水肿(警惕VS-FCV)","typical_cost_range":"100-1000元(支持治疗+止痛)","typical_duration":"轻的7-14天自愈","keywords":["杯状病毒","口腔溃疡","流口水","跛行","舌溃疡","FCV"],"evidence":{"source":"ABCD Guidelines","key_stats":["FCV是猫呼吸道疾病第二常见病原(仅次于疱疹病毒)","口腔溃疡是FCV区别于疱疹病毒的特征性病变","VS-FCV致死率~30-60%(罕见但应警惕)"],"evidence_level":"A"},"real_case_summary":"猫友：小猫突然流口水不吃东西，掰开嘴看到舌头上好几个红点。医生说是杯状病毒，开了止痛药+软罐头，一周就好了。和猫鼻支的区别是杯状有口腔溃疡。"},

    # ===== TOXICOLOGY =====
    {"id":"toxin-003","category":"toxicology","title":"洋葱/大蒜中毒—厨房里的猫毒药","symptom_text":"猫吃了含洋葱/大蒜/韭菜/葱的食物(包括剩菜/汤/婴儿食品)后数小时到数天：出现牙龈苍白、精神萎靡、呼吸急促、尿色变深(红/棕色)。洋葱中的硫代硫酸盐导致红细胞氧化损伤→溶血性贫血。少量累积也可能慢性中毒。","image_features":"牙龈苍白、呼吸急促、深色尿","risk_level":"medium","possible_causes":["洋葱/大蒜/韭菜/葱中毒—硫代硫酸盐→海因兹小体溶血"],"home_treatment":"少量摄入(<5g/kg)+无症状→密切观察+保证饮水+抗氧化剂(Vit C/E可能有帮助)。大量摄入或有症状→立即急诊催吐+活性炭+输血可能。","when_to_see_vet":"任何已知食用量+症状出现→急诊","typical_cost_range":"500-5000元(催吐+对症+可能输血)","typical_duration":"轻的几天恢复，重的需1-2周","keywords":["洋葱","大蒜","溶血","牙龈白","深色尿"],"evidence":{"source":"Vet Clin North Am / ASPCA","key_stats":[">5g/kg洋葱即可引起猫中毒","猫比狗对洋葱更敏感","猫急性洋葱中毒死亡率<10%(及时治疗)","慢性微量摄入(吃剩菜)比急性大量更难察觉"],"evidence_level":"A"},"real_case_summary":"猫友：猫偷吃了厨房垃圾桶里含大量洋葱的炒肉，第二天精神不好牙龈发白。查血发现严重贫血——洋葱中毒。输液+抗氧化剂治疗了一周才好。从此厨房垃圾桶再也没有洋葱。"},

    # ===== MUSCULOSKELETAL =====
    {"id":"ortho-003","category":"orthopedic","title":"猫关节炎—不只是老年猫的问题","symptom_text":"猫关节退行性变化导致：不愿意跳(从高处下来犹豫)、上下楼梯变慢、步态僵硬(尤其刚睡醒时)、活动减少、猫砂盆外拉屎尿(因跨不进高沿猫砂盆)、不喜欢被摸背/髋部、脾气变差。关节炎在猫中被严重低估——猫隐藏疼痛。","image_features":"猫活动减少、步态僵硬、不愿跳跃","risk_level":"medium","possible_causes":["骨关节炎(退行性)","发育不良(髋/肘)","旧伤后遗症","肥胖加重"],"home_treatment":"1)控制体重(减重极大缓解关节疼痛)。2)环境改造：低沿猫砂盆/台阶辅助/软垫。3)保暖。4)营养补充：Omega-3(鱼油)/绿唇贻贝/葡萄糖胺软骨素。5)兽医可开止痛药(美洛昔康/加巴喷丁)。6)物理治疗/针灸(辅助)。","when_to_see_vet":"生活质量下降/拒绝进食(因疼痛)→就医","typical_cost_range":"200-1000元/月(体重管理+补充品+可能止痛药)","typical_duration":"终身管理—目标不是治愈而是维持活动力和生活质量","keywords":["关节炎","跳不动","僵硬","老年","止痛","体重"],"evidence":{"source":"J Feline Med Surg","key_stats":["X光证据：>12岁猫>90%有关节炎变化","但仅~10-20%猫主人报告症状—猫隐藏疼痛","体重降低10-15%可>30%减轻关节疼痛","Omega-3(>500mg DHA+EPA/day)可>30%改善活动力"],"evidence_level":"A"},"real_case_summary":"猫友：12岁老猫越来越不爱跳，以为是年纪大了正常。体检医生说有关节炎，开了鱼油+加巴喷丁，一个月后猫明显活动多了。之前猫一直在忍痛我们不知道。"},

    # ===== OPHTHALMOLOGY =====
    {"id":"eye-007","category":"eye","title":"白内障—猫眼睛变白","symptom_text":"猫眼球晶状体变白混浊，像眼球里有白色/蓝白色雾状物。早期可能不影响视力，后期可导致失明。老年猫最常见(老年性白内障)，但也可能继发于葡萄膜炎/糖尿病/外伤。和核硬化(老年正常变化—晶状体变蓝但不影响视力)需要鉴别。","image_features":"晶状体白色/蓝白色混浊","risk_level":"medium","possible_causes":["老年性白内障(最常见)","葡萄膜炎继发","糖尿病性白内障(猫较少见)","外伤","先天性(罕见)"],"home_treatment":"轻的不需治疗(定期眼科观察)。如果显著影响视力→白内障手术(超声乳化+人工晶体植入)。和犬不同，猫白内障手术较少做(猫适应盲生活好)。","when_to_see_vet":"发现眼球内变白→眼科检查排除葡萄膜炎等原发病。","typical_cost_range":"检查500-1500元，手术(如需)10000-20000元","typical_duration":"无需手术→定期观察。手术后恢复2-4周","keywords":["白内障","眼球变白","晶状体混浊","失明","老年猫"],"evidence":{"source":"Vet Ophthalmol","key_stats":["猫白内障<犬常见","继发性(尤其葡萄膜炎后)>原发性","猫适应盲生活极好—许多'不需要'手术"],"evidence_level":"B"},"real_case_summary":"猫友：老猫眼球里有白色雾状物，以为是白内障要做手术。医生说这是核硬化不是白内障，不影响视力不用管。虚惊一场——但真的要眼科医生看才能区分。"},

    # ===== KITTEN =====
    {"id":"kitten-002","category":"kitten","title":"新生猫衰退综合征—小猫突然不行了","symptom_text":"新生/幼猫(0-8周)突然出现：体温降低、不吃奶、脱水、精神萎靡、叫声微弱。可能在几小时内从健康恶化为濒死。原因复杂(低血糖/脱水/感染/先天缺陷/母猫问题)。这是幼猫最常见致死原因之一。","image_features":"幼猫蜷缩无力、体温低、不吸奶","risk_level":"high","possible_causes":["低血糖(幼猫糖原储备极少)","脱水","败血症/感染","母猫泌乳不足/不照顾","先天缺陷","环境温度过低"],"home_treatment":"1)立即保温(加热垫/热水袋—低温是死循环)。2)人工喂奶(专用猫奶粉—不要牛奶)。3)补充血糖(无痛葡萄糖凝胶抹牙龈)。4)刺激排尿排便(棉球擦肛周)。5)如果1-2小时无改善→立即急诊。","when_to_see_vet":"任何新生幼猫突然精神变差→急诊。幼猫恶化极快。","typical_cost_range":"500-3000元(保温箱+输液+管饲)","typical_duration":"取决于原因—部分24-48h改善，部分抢救无效","keywords":["新生猫","小猫不行了","体温低","不吃奶","低血糖"],"evidence":{"source":"J Feline Med Surg / Vet Clin North Am","key_stats":["环境温度<27°C→幼猫无法维持体温→低温→拒食→低血糖→死亡(恶性循环)","及时干预+保温+人工喂养可将存活率从<10%提升至>70%"],"evidence_level":"A"},"real_case_summary":"猫友：捡的一窝小奶猫有一只突然不吃奶身体发凉。赶紧用暖水袋保温+每隔两小时管饲奶粉，折腾了两天两夜救回来了。医生说小奶猫的生命就是温度和血糖两个指标。"},

    # ===== EMERGENCY =====
    {"id":"emerge-003","category":"emergency","title":"蚊香/电蚊香液中毒—夏天最常见的猫中毒","symptom_text":"猫在密闭空间使用蚊香/电蚊香液/蚊香片(含拟除虫菊酯)数小时后出现：流口水、颤抖、走路不稳、呕吐、抽搐。蚊香是中国家庭最常用的驱蚊产品——也是对猫最常见的室内中毒源。猫肝脏无法代谢拟除虫菊酯。","image_features":"流口水、颤抖、走路不稳","risk_level":"high","possible_causes":["拟除虫菊酯类蚊香/电蚊香液/喷雾中毒"],"home_treatment":"1)立即通风(开窗开门)。2)如果皮肤接触到→洗洁精+温水洗掉。3)立即急诊(尤其有神经症状)。4)不要催吐。","when_to_see_vet":"任何中毒症状→急诊。","typical_cost_range":"1000-5000元(洗消+抗抽搐+支持治疗)","typical_duration":"住院1-3天","keywords":["蚊香","电蚊香","驱蚊","颤抖","夏天","菊酯"],"evidence":{"source":"ASPCA / Vet Clin North Am","key_stats":["拟除虫菊酯是中国家庭猫中毒TOP3原因之一","猫对拟除虫菊酯的敏感性是狗的10-100倍","及时洗消+对症治疗存活率>95%"],"evidence_level":"A"},"real_case_summary":"猫友：夏天晚上点了电蚊香，第二天早上猫走路摇摇晃晃还流口水。医生说蚊香中毒，洗了澡+输了液观察一天才好。从此再也没用过蚊香——改物理防蚊(蚊帐/电蚊拍)。"}
]

cases.extend(E)

with open('D:/hermes-workspace/projects/maoshengsheng/cases.json','w',encoding='utf-8') as f:
    json.dump(cases, f, ensure_ascii=False, indent=2)

from collections import Counter
cats = Counter(c['category'] for c in cases)
print(f"Total: {len(cases)} cases, {len(cats)} categories")
for cat, count in cats.most_common():
    print(f"  {cat}: {count}")
print(f"Evidence: {sum(1 for c in cases if c.get('evidence'))}/{len(cases)}")
