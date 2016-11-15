-- translation for ManeuveringPackage

return {
	["maneuvering"] = "军争篇",

	["fire_slash"] = "火杀",
	[":fire_slash"] = "基本牌<br /><b>时机</b>：出牌阶段<br /><b>目标</b>：攻击范围内的一名角色<br /><b>效果</b>：对目标角色造成1点火焰伤害。",

	["thunder_slash"] = "雷杀",
	[":thunder_slash"] = "基本牌<br /><b>时机</b>：出牌阶段<br /><b>目标</b>：攻击范围内的一名角色<br /><b>效果</b>：对目标角色造成1点雷电伤害。",

	["analeptic"] = "酒",
	[":analeptic"] = "基本牌<br /><b>时机</b>：出牌阶段/你处于濒死状态时<br /><b>目标</b>：你<br /><b>效果</b>：目标角色本回合使用的下一张【杀】将要造成的伤害+1/目标角色回复1点体力。",
	["#UnsetDrankEndOfTurn"] = "%from 回合结束，%to 的【<font color=\"yellow\"><b>酒</b></font>】效果消失",

	["fan"] = "贽殿遮那",
	[":fan"] = "装备牌·武器<br /><b>攻击范围</b>：４<br /><b>武器技能</b>：你可以将一张普通【杀】当火【杀】使用。",

	["guding_blade"] = "米斯特汀",
	[":guding_blade"] = "装备牌·武器<br /><b>攻击范围</b>：２<br /><b>武器技能</b>：锁定技。每当你使用【杀】对目标角色造成伤害时，若该角色没有手牌，此伤害+1。",
	["#GudingBladeEffect"] = "%from 的【<font color=\"yellow\"><b>米斯特汀</b></font>】效果被触发， %to 没有手牌，伤害从 %arg 增加至 %arg2",

	["vine"] = "移动教会",
	[":vine"] = "装备牌·防具<br /><b>防具技能</b>：锁定技。【南蛮入侵】、【万箭齐发】和普通【杀】对你无效。每当你受到火焰伤害时，此伤害+1。",
	["#VineDamage"] = "%from 的防具【<font color=\"yellow\"><b>移动教会</b></font>】效果被触发，火焰伤害由 %arg 点增加至 %arg2 点",

	["silver_lion"] = "王玉",
	[":silver_lion"] = "装备牌·防具<br /><b>防具技能</b>：锁定技。每当你受到伤害时，若此伤害大于1点，防止多余的伤害。每当你失去装备区里的【王玉】后，你回复1点体力。",
	["#SilverLion"] = "%from 的防具【%arg2】防止了 %arg 点伤害，减至 <font color=\"yellow\"><b>1</b></font> 点",

	["fire_attack"] = "异端审判",
	[":fire_attack"] = "锦囊牌<br /><b>时机</b>：出牌阶段<br /><b>目标</b>：一名有手牌的角色<br /><b>效果</b>：目标角色展示一张手牌，然后你可以弃置一张与所展示牌花色相同的手牌令其受到1点火焰伤害。",
	["@fire-attack"] = "%src 展示的牌的花色为 %arg，请弃置一张与其花色相同的手牌",

	["iron_chain"] = "铁索连环",
	[":iron_chain"] = "锦囊牌<br /><b>时机</b>：出牌阶段<br /><b>目标</b>：一至两名角色<br /><b>效果</b>：横置或重置目标角色的武将牌。<br />重铸：将此牌置入弃牌堆并摸一张牌。",

	["supply_shortage"] = "弹尽油绝",
	[":supply_shortage"] = "延时锦囊牌<br /><b>时机</b>：出牌阶段<br /><b>目标</b>：距离1的一名其他角色<br /><b>效果</b>：将此牌置于目标角色判定区内。其判定阶段进行判定：若结果不为梅花，其跳过摸牌阶段。然后将【弹尽油绝】置入弃牌堆。",

	["hualiu"] = "骅骝",
}
