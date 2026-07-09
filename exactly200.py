#!/usr/bin/env python3
"""Exactly 7 cases to hit 200"""
import json
with open('D:/hermes-workspace/projects/maoshengsheng/cases.json','r',encoding='utf-8') as f:
    cases = json.load(f)
E=[\
{"id":"gen-015","category":"general","title":"猫驱虫日程完整指南","symptom_text":"体内驱虫:幼猫2周龄开始每2周到12周,每月到6月龄,之后每3-6月。体外驱虫:每月一次。注意不同驱虫药覆盖不同寄生虫谱。","risk_level":"low","possible_causes":["N/A"],"home_treatment":"按日程。选药:大宠爱(塞拉菌素—体内外广谱)、福来恩(仅体外跳蚤蜱虫)。","when_to_see_vet":"发现寄生虫→就医","typical_cost_range":"体内20-60元/次;体外50-120元/次","typical_duration":"终身","keywords":["驱虫","日程","体内","体外","幼猫"]},
{"id":"gen-016","category":"general","title":"猫粮配料表怎么看","symptom_text":"看保证分析值:蛋白大于30%干物质,脂肪大于9%,纤维小于5%。成分表第一位应是动物蛋白(非谷物)。计算碳水:100%减蛋白减脂肪减纤维减水分减灰分等于碳水,小于25%较好。注意鲜肉含水70%,排第一位不等于蛋白高。","risk_level":"low","possible_causes":["N/A"],"home_treatment":"按方法选粮。湿粮碳水通常比干粮更低。","when_to_see_vet":"N/A","typical_cost_range":"0元","typical_duration":"终身","keywords":["猫粮","配料表","蛋白","碳水","选粮"]},
{"id":"gen-017","category":"general","title":"猫咪几个月算成年或老年","symptom_text":"幼猫0-12月。成年1-7岁。中年7-10岁。老年10-15岁。超老大于15岁。不同阶段营养需求和体检频率不同。老年猫体检半年一次。","risk_level":"low","possible_causes":["N/A"],"home_treatment":"按年龄段调整饮食和体检频率。","when_to_see_vet":"老年猫半年一次体检","typical_cost_range":"0元","typical_duration":"N/A","keywords":["年龄","幼猫","成年","老年","体检"]},
{"id":"gen-018","category":"general","title":"猫能吃的人类食物","symptom_text":"可以少量作为零食(小于10%日热量):水煮鸡胸肉、蛋黄、南瓜、蓝莓、三文鱼。绝对不能:洋葱、大蒜、巧克力、葡萄、木糖醇、酒精、咖啡、生面团、夏威夷果。牛奶大部分猫乳糖不耐。","risk_level":"low","possible_causes":["N/A"],"home_treatment":"人类食物只能是非常偶尔的零食。","when_to_see_vet":"误食有毒食物→急诊","typical_cost_range":"0元","typical_duration":"终身","keywords":["人类食物","能吃","零食","洋葱","巧克力"]},
{"id":"gen-019","category":"general","title":"猫一天睡多久算正常","symptom_text":"猫一天睡12-18小时(平均15小时)。幼猫和老年猫可睡20小时。猫是晨昏型动物——白天睡、凌晨和傍晚活跃——不是懒。睡眠模式突然改变才需警惕。","risk_level":"low","possible_causes":["正常生理"],"home_treatment":"正常。如果突然大幅改变(不睡或睡得过多)才就医。","when_to_see_vet":"睡眠模式突然改变","typical_cost_range":"0元","typical_duration":"终身","keywords":["睡眠","嗜睡","正常","15小时"]},
{"id":"gen-020","category":"general","title":"猫咪为什么呼噜—不止是开心","symptom_text":"猫呼噜不止表达愉悦——猫也在疼痛、紧张、分娩、临终时呼噜。呼噜频率20-150Hz被认为有治疗作用(促进骨骼愈合和减轻疼痛)。不要因为猫在呼噜就认为它不痛。","risk_level":"low","possible_causes":["正常——多功能的交流加自我疗愈信号"],"home_treatment":"了解呼噜的多重含义。如果猫同时有异常行为,呼噜不代表它舒适。","when_to_see_vet":"N/A","typical_cost_range":"0元","typical_duration":"终身","keywords":["呼噜","疼痛","开心","治疗","频率"]},
{"id":"skin-015","category":"skin","title":"猫癣vs过敏vs精神性脱毛—怎么区分","symptom_text":"三者的鉴别:猫癣为脱毛加皮屑加可能红,真菌感染,用Wood灯或DTM培养。过敏为对称脱毛加舔秃加皮肤光滑,做食物排除试验。精神性为舔秃加皮肤正常加发生在应激后,需先排除身体原因。可以先用Wood灯排除猫癣,再食物排除排除过敏,最后考虑精神性。不要一脱毛就上激素药。","risk_level":"low","possible_causes":["鉴别诊断"],"home_treatment":"先用Wood灯或DTM培养排除猫癣。再做食物排除试验。最后考虑精神性。","when_to_see_vet":"不确定→就医确诊","typical_cost_range":"0-300元","typical_duration":"取决于病因","keywords":["鉴别","猫癣","过敏","精神性","脱毛"],"evidence":{"source":"Vet Dermatol","key_stats":["系统排除法从猫癣到过敏到精神性是标准流程","超过60%的过度理毛猫有可治疗的身体原因"],"evidence_level":"A"}},
]
cases.extend(E)
from collections import Counter
cats = Counter(c['category'] for c in cases)
print(f"TOTAL: {len(cases)} cases")
ev = sum(1 for c in cases if c.get('evidence'))
print(f"Evidence: {ev}/{len(cases)} ({ev*100//len(cases)}%)")
print(f"{'✅ HIT 200+!' if len(cases) >= 200 else '❌'}")
with open('D:/hermes-workspace/projects/maoshengsheng/cases.json','w',encoding='utf-8') as f:
    json.dump(cases, f, ensure_ascii=False, indent=2)
