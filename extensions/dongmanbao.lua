module("extensions.dongmanbao",package.seeall)--游戏包
extension=sgs.Package("dongmanbao")--增加拓展包

--势力
--[[
do
    require  "lua.config"
	local config = config
	local kingdoms = config.kingdoms
            table.insert(kingdoms,"real")
            table.insert(kingdoms,"magic")
            table.insert(kingdoms,"science")
	config.color_de = "#FF77FF"
end
]]
sgs.LoadTranslationTable{
	["real"] = "现世",
	["magic"] = "魔法",
	["science"] = "科学",
}

--函数
local function easyTalk(room, logtype)
	local log =  sgs.LogMessage()
	log.type = logtype
	room:sendLog(log)
end

local function touhou_logmessage(logtype,logfrom,logarg,logto,logarg2)
	local alog = sgs.LogMessage()
	alog.type = logtype
	alog.from = logfrom
	if logto then
		alog.to:append(logto)
	end
	if logarg then
		alog.arg = logarg
	end
	if logarg2 then
		alog.arg2 = logarg2
	end
	local room = logfrom:getRoom()
	room:sendLog(alog)
end

local function doLog(logtype,logfrom,logarg,logto,logarg2)
	local alog = sgs.LogMessage()
	alog.type = logtype
	alog.from = logfrom
	if logto then
		alog.to:append(logto)
	end
	if logarg then
		alog.arg = logarg
	end
	if logarg2 then
		alog.arg2 = logarg2
	end
	local room = logfrom:getRoom()
	room:sendLog(alog)
end

local function touhou_shuffle(atable)
	local count = #atable
	for i = 1, count do
		local j = math.random(1, count)
		atable[j], atable[i] = atable[i], atable[j]
	end
	return atable
end


local function anime_playersbyskillname(roomplayer,skillname)
	if not skillname then roomplayer:speak("anime_playersbyskillname-skillname is nil") return end
	local room = roomplayer:getRoom()
	local splist = sgs.SPlayerList()
	for _, pp in sgs.qlist(room:getAlivePlayers()) do
		if pp:hasSkill(skillname) then
			splist:append(pp)
		end
	end
	return splist
end


-------------------------------------------------------------------------------------------------------------
--完成
--Mikoto = sgs.General(extension, "Mikoto", "science", 4, false,false,false)
Louise = sgs.General(extension, "Louise", "magic", 3, false,false,false)
Saito = sgs.General(extension, "Saito", "magic", 4, true,true,false)
Eustia = sgs.General(extension, "Eustia", "magic", 3,false, false, false)
Touma = sgs.General(extension, "Touma", "science", 4)
Okarin = sgs.General(extension, "Okarin", "science", 4)
--Nanami = sgs.General(extension, "Nanami", "real", 3, false)
Taiga = sgs.General(extension, "Taiga", "real", 3, false)
SE_Kirito = sgs.General(extension, "SE_Kirito", "science", 3)
SE_Asuna = sgs.General(extension, "SE_Asuna", "science", 3, false)
SE_Eren = sgs.General(extension, "SE_Eren", "science", 4)
Kuroko = sgs.General(extension, "Kuroko", "science", 3, false,false,false)
HYui = sgs.General(extension, "HYui", "real", 3, false,false,false)
--HYui_sub = sgs.General(extension, "HYui_sub", "real", 3, false,true,true)
Alice = sgs.General(extension, "Alice", "science", 3, false,false,false)
Sakamoto = sgs.General(extension, "Sakamoto", "science", 4)
Kanade = sgs.General(extension, "Kanade", "real", 3, false,false,false)
Rena = sgs.General(extension, "Rena", "real", 3, false,false,false)
Rena_black = sgs.General(extension, "Rena_black", "real", 3, false,true,true)
Saber = sgs.General(extension, "Saber", "magic", 4, false,false,false)
Kirei = sgs.General(extension, "Kirei", "magic", 3, true,false,false)
--Tomoya = sgs.General(extension, "Tomoya", "real", 4, true,false,false)
--Tomoya_sub = sgs.General(extension, "Tomoya_sub", "real", 4, true,true,true)
Accelerator = sgs.General(extension, "Accelerator", "science", 1, true,true,false)
Shino = sgs.General(extension, "Shino", "science", 3, false,false,false)
Misaka_Imouto = sgs.General(extension, "Misaka_Imouto", "science", 2, false,false,false)
Tukasa = sgs.General(extension, "Tukasa", "real", 3, false,false,false)
--Natsume_Rin = sgs.General(extension, "Natsume_Rin", "real", 99, false,false,false)
--Natsume_Rin_sub = sgs.General(extension, "Natsume_Rin_sub", "real", 99, false,true,true)
Lelouch = sgs.General(extension, "Lelouch", "science", 2, true,true,false)
Leafa = sgs.General(extension, "Leafa", "science", 3, false,false,false)
Reimu = sgs.General(extension, "Reimu", "touhou", 3, false,false,false)
Kuroneko = sgs.General(extension, "Kuroneko", "real", 3, false,false,false)
-- Sugisaki = sgs.General(extension, "Sugisaki", "real", 3, true,false,false)
Kuroyukihime = sgs.General(extension, "Kuroyukihime", "science", 4, false,false,false)
--Kuroyukihime_sub = sgs.General(extension, "Kuroyukihime_sub", "science", 4, false,true,true)
Nagase = sgs.General(extension, "Nagase", "real", 3, false,false,false)
Kazehaya = sgs.General(extension, "Kazehaya", "real", 3, true,false,false)
--Kazehaya_sub = sgs.General(extension, "Kazehaya_sub", "real", 3, true,true,true)
Ayase = sgs.General(extension, "Ayase", "real", 3, false,false,false)
--Akarin = sgs.General(extension, "Akarin", "real", 3, false,false,false)
Hikigaya = sgs.General(extension, "Hikigaya", "real", 4, true,false,false)
Chiyuri = sgs.General(extension, "Chiyuri", "science", 3, false,false,false)
AiAstin = sgs.General(extension, "AiAstin", "magic", 3, false,false,false)
-- Hakaze = sgs.General(extension, "Hakaze", "magic", 3, false,false,false)
Kotori = sgs.General(extension, "Kotori", "magic", 3, false,false,false)
--Kotori_sub = sgs.General(extension, "Kotori_sub", "magic", 3, true,true,true)
Kotori_white = sgs.General(extension, "Kotori_white", "magic", 3, false,true,true)
Aria = sgs.General(extension, "Aria", "science", 3, false,false,false)
Reki = sgs.General(extension, "Reki", "science", 3, false,false,false)
Ange = sgs.General(extension, "Ange", "magic", 3, false,false,false)
--Ange2 = sgs.General(extension, "Ange2", "magic", 3, true,true,true)
Rivaille = sgs.General(extension, "Rivaille", "science", 3, true,false,false)
Asagi = sgs.General(extension, "Asagi", "magic", 3, false,false,false)
Riko = sgs.General(extension, "Riko", "science", 2, false,false,false)
Kurumi = sgs.General(extension, "Kurumi", "magic", 3, false,false,false)
Sakura = sgs.General(extension, "Sakura", "magic", 3, false,false,false)
-- Eugeo = sgs.General(extension, "Eugeo", "science", 3, true,false,false)
--Eugeo_sub = sgs.General(extension, "Eugeo_sub", "science", 3, true,true,true)
Rika = sgs.General(extension, "Rika", "real", 3, false,false,false)
Eucliwood = sgs.General(extension, "Eucliwood", "magic", 3, false,false,false)
Eu_Zombie = sgs.General(extension, "Eu_Zombie", "magic", 5, true,true,true)
-- Yuri = sgs.General(extension, "Yuri", "real", 3, false,false,false)
Setsuna = sgs.General(extension, "Setsuna", "diva", 3, false,false,false)
Yukina = sgs.General(extension, "Yukina", "magic", 3, false,false,false)
-- K1 = sgs.General(extension, "K1", "real", 4, true,false,false)
--Junko = sgs.General(extension, "Junko", "real", 3, false,false,false)
Batora = sgs.General(extension, "Batora", "magic", 4, true,true,false)
Shirayuki = sgs.General(extension, "Shirayuki", "science", 4, false,false,false)
Saki = sgs.General(extension, "Saki", "real", 4, false,false,false)
Sayaka = sgs.General(extension, "Sayaka", "magic", 3, false,false,false)
Majyo = sgs.General(extension, "Majyo", "magic", 4, false,true,true)
Kinpika = sgs.General(extension, "Kinpika", "magic", 3, true,false,false)
Kiritsugu = sgs.General(extension, "Kiritsugu", "magic", 4, true,false,false)
Yakumo = sgs.General(extension, "Yakumo", "magic", 4, true,true,false)
Yukino = sgs.General(extension, "Yukino", "real", 3, false,false,false)
Yyui = sgs.General(extension, "Yyui", "real", 3, false,false,false)
Chiyo = sgs.General(extension, "Chiyo", "real", 3, false,false,false)
Eugen = sgs.General(extension, "Eugen", "kancolle", 3, false,true,false)



-- YingbiGet = sgs.CreateTriggerSkill{
-- 	name = "#YingbiGet",
-- 	frequency = sgs.Skill_Compulsory,
-- 	events = {sgs.EventPhaseStart},
-- 	on_trigger = function(self, event, player, data)
-- 		if player:isAlive() then
-- 			if event == sgs.EventPhaseStart then
-- 				if player:getPhase() == sgs.Player_Start then
-- 					local room = player:getRoom()
-- 					player:gainMark("@ying",1)
-- 					if not player:getMark("@ying") ==2 or player:hasSkill("se_paoji") then
-- 						room:broadcastSkillInvoke("Yingbi")
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end,
-- }


-- Dianci = sgs.CreateTriggerSkill{
-- 	name = "Dianci",
-- 	frequency = sgs.Skill_Wake,
-- 	events = {sgs.EventPhaseStart},
-- 	on_trigger = function(self, event, player, data)
-- 		local room = player:getRoom()
-- 		player:gainMark("@waked")
-- 		room:loseMaxHp(player)
-- 		room:acquireSkill(player, "se_paoji")
-- 		room:broadcastSkillInvoke("Dianci")
-- 		room:doLightbox("Dianci$", 3000)
-- 		return false
-- 	end,
-- 	can_trigger = function(self, target)
-- 		if target then
-- 			if target:isAlive() and target:hasSkill(self:objectName()) then
-- 				if target:getPhase() == sgs.Player_Draw then
-- 					if target:getMark("@waked") == 0 then
-- 						local counts = target:getMark("@ying")
-- 						return counts >= 2
-- 					end
-- 				end
-- 			end
-- 		end
-- 		return false
-- 	end
-- }

-- se_paojicard = sgs.CreateSkillCard{
-- 	name = "se_paojicard",
-- 	target_fixed = false,
-- 	will_throw = true,
-- 	filter = function(self, targets, to_select)
-- 		return #targets == 0
-- 	end,
-- 	on_use = function(self, room, source, targets)
-- 		local target = targets[1]
-- 		local count = source:getMark("@ying")
-- 		if count == 0 then return end
-- 		local prompt = "paoji_1"
-- 		if count > 1 then
-- 			prompt = string.format(prompt.."+".."paoji_2")
-- 		end
-- 		local choice = room:askForChoice(source,"se_paoji",prompt)
-- 		local coins = string.sub(choice,7,-1)
-- 		source:loseMark("@ying", coins)
-- 		--room:broadcastSkillInvoke("se_paoji")
-- 		local judge = sgs.JudgeStruct()
-- 		judge.pattern = ".|spade"
-- 		judge.good = true
-- 		judge.negative = false
-- 		judge.reason = self:objectName()
-- 		judge.who = source
-- 		judge.play_animation = true
-- 		judge.time_consuming = true
-- 		room:judge(judge)
-- 		local suit = judge.card:getSuit()
-- 		local damage = sgs.DamageStruct()
-- 		damage.card = nil
-- 		if suit == sgs.Card_Spade then
-- 			damage.damage = math.pow(2,coins)
-- 		else
-- 			damage.damage = math.pow(2,coins - 1)
-- 		end
-- 		if damage.damage > 2 then
-- 			room:doLightbox("se_paoji$", 2500)
-- 		else
-- 			room:doLightbox("se_paoji$", 800)
-- 		end
-- 		damage.from = source
-- 		damage.to = target
-- 		damage.nature = sgs.DamageStruct_Thunder
-- 		room:damage(damage)
-- 	end,
-- }

-- se_paoji = sgs.CreateViewAsSkill{
-- 	name = "se_paoji",
-- 	n = 0,
-- 	view_as = function(self, cards)
-- 		return se_paojicard:clone()
-- 	end,
-- 	enabled_at_play = function(self, player)
-- 		return player:getMark("@ying") > 0 and not player:hasUsed("#se_paojicard")
-- 	end,
-- }





-- Mikoto:addSkill(YingbiGet)
-- Mikoto:addSkill(Yingbi)
-- extension:insertRelatedSkills("#YingbiGet", "Yingbi")
-- Mikoto:addSkill(Dianci)
-- extension:addToSkills(se_paoji)
-- Mikoto:addWakeTypeSkillForAudio("se_paoji")





--露易丝

XuwuDistance = sgs.CreateDistanceSkill{
	name = "#XuwuDistance",
	correct_func = function(self, from, to)
		if to:hasSkill(self:objectName()) then
			local moli = to:getPile("moli")
			local count = moli:length()
			return math.floor(count/2)
		end
	end
}


Xuwu = sgs.CreateTriggerSkill{
	name = "Xuwu",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.CardUsed},
	on_trigger = function(self, event, player, data)
		if player:isAlive() then
			if event == sgs.CardUsed then
				if player:getPhase() == sgs.Player_Play then
					use = data:toCardUse()
					local card = use.card
					if card:isNDTrick() then
						if player:hasSkill(self:objectName()) then
							local room = player:getRoom()
							room:drawCards(player, 1)
							local judge = sgs.JudgeStruct()
							judge.pattern = "."
							judge.reason = self:objectName()
							judge.who = player
							room:judge(judge)
							local id = judge.card:getEffectiveId()
							player:addToPile("moli", id)
							room:broadcastSkillInvoke("Xuwu")
							return true
						end
					end
				end
			end
		end
	end,
}

XuwuClear = sgs.CreateDetachEffectSkill{
	name = "Xuwu",
	pilename = "moli",
}

se_cairen = sgs.CreateViewAsSkill{
	name = "se_cairen",
	n = 0,
	view_as = function(self, cards)
		return se_cairencard:clone()
	end,
	enabled_at_play = function(self, player)
		return player:getPile("moli"):length() > 3
	end,
}

se_cairencard = sgs.CreateSkillCard{
	name = "se_cairencard",
	target_fixed = true,
	will_throw = true,
	filter = function(self, targets, to_select)
		return true
	end,
	on_use = function(self, room, source, targets)
		local moli = source:getPile("moli")
		local count = moli:length()
		local id
		if count < 4 then
			return
		else
			room:fillAG(moli, source)
			id = room:askForAG(source, moli, false, self:objectName())
			room:clearAG(source)
			if id == -1 then
				return
			end
		end
		local card = sgs.Sanguosha:getCard(id)
		room:throwCard(card, nil, nil)
		--room:broadcastSkillInvoke("se_cairen")
		room:doLightbox("se_cairen$", 2000)
		--room:setPlayerMark(source,"se_cairen",source:getMaxHp())

		if source:getGeneralName() == "Louise" then
			room:changeHero(source,"Saito",true, false, false, true)
		else
			room:changeHero(source,"Saito",true, false, true, true)
		end
		local num = source:getHandcardNum()
		if num < 5 then
			room:drawCards(source, 5-num)
		end
	end,
}


Beizeng = sgs.CreateTriggerSkill{
	name = "Beizeng",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local count = player:getMark("@shouhu")
		if count>1 then
			if player:isAlive() and player:hasSkill(self:objectName()) then
				if player:getPhase() == sgs.Player_Finish then
					if room:askForSkillInvoke(player, self:objectName()) then
						player:loseMark("@shouhu",2)
						local list = room:getAlivePlayers()
						local dest = room:askForPlayerChosen(player, list, "Beizeng")
						room:broadcastSkillInvoke("Beizeng")
						room:loseMaxHp(dest)
						room:loseHp(dest)
					end
				return false
				end
			end
		end
	end,
}


Louise:addSkill(XuwuDistance)
Louise:addSkill(Xuwu)
Louise:addSkill(XuwuClear)
extension:insertRelatedSkills("Xuwu", "#XuwuDistance")
extension:insertRelatedSkills("Xuwu", "#Xuwu-clear")
Louise:addSkill(se_cairen)
Louise:addSkill(Beizeng)


sgs.LoadTranslationTable{
["dongmanbao"] = "动漫包-SE",
["Xuwu"] = "虚无「零成功率」",
[":Xuwu"] = "锁定技。每当你使用非延时类锦囊牌时 ，若此牌不是【金色宣言】，你取消之并摸一张牌，然后将牌堆顶牌置于你的武将牌上，称为“魔力”；当其他角色与你计算距离时，始终+X（X为“魔力”数量的一半，向下取整）。",
["moli"] = "魔力",
["$Xuwu"] = "好像稍微有点失败了呐。",
["se_cairen"] = "才人「唤来才人」",
["se_cairen"] = "才人「唤来才人」",
["se_cairencard"] = "才人「唤来才人」",
["$se_cairen"] = "你们对露易丝做了些什么！！",
["se_cairen$"] = "image=image/animate/se_cairen.png",
[":se_cairen"] = "出牌阶段，若你拥有4枚或以上的“魔力”，你可以将一张“魔力”置入弃牌堆，然后变身为平贺才人并将手牌数补至5。",
["Beizeng"] = "倍增「explosion」",
["beizeng"] = "倍增「explosion」",
[":Beizeng"] = "弃牌阶段开始时，你可以弃置2枚“守护”标记，指定一名角色并令其减1点体力上限并失去1点体力。",
["$Beizeng"] = "「explosion」！",
["Louise"] = "露易丝",
["&Louise"] = "露易丝",
["@Louise"] = "零之使魔",
["#Louise"] = "零之",
["~Louise"] = "...不要！...",
["designer:Louise"] = "Sword Elucidator",
["cv:Louise"] = "钉宫理惠",
["illustrator:Louise"] = "节操Staff",
["se_zhijian"] = "智剑「デルフリンガー」",
["$se_zhijian1"] = "唉...为什么我要勉强地做这种事情啊...（デルフリンガー）那当然是，为了你喜欢的女人了。",
[":se_zhijian"] = "出牌阶段限一次，你可以将一张“魔力”置入弃牌堆，然后你选择一名角色进行拼点：若你赢，你进行一次判定，然后摸X张牌（X为判定结果的点数且至少为6）。",
["se_zhijiancard"] = "智剑",
["se_hengsao"] = "横扫「以一对七万」",
["$se_hengsao1"] = "デルフリンガー...（干啥？） 我会...死吗...",
["$se_hengsao2"] = "可恶！！......",
[":se_hengsao"] = "出牌阶段，你可以失去2点体力，然后对至多三名角色各造成一点伤害，并获得一个“守护”标记。",
["se_hengsaocard"] = "横扫",
["@shouhu"] = "守护",
["huanhui"] = "唤回「继续被虐待-。-」",
[":huanhui"] = "结束阶段开始时，你须变身为露易丝并回复体力至体力上限。",
["Saito"] = "平賀才人",
["&Saito"] = "平賀才人",
["@Saito"] = "零之使魔",
["#Saito"] = "零之使魔",
["~Saito"] = "露易丝...果然我还是不想死啊...",
["designer:Saito"] = "Sword Elucidator",
["cv:Saito"] = "日野聪",
["illustrator:Saito"] = "节操Staff",
["Saito_sound"] = "----平賀才人台词",
["&Saito_sound"] = "----平賀才人台词",
["#Saito_sound"] = "台词向",
["~Saito_sound"] = "露易丝...果然我还是不想死啊...",
["designer:Saito_sound"] = "Sword Elucidator",
["cv:Saito_sound"] = "日野聪",
["illustrator:Saito_sound"] = "节操Staff",
}


se_zhijian = sgs.CreateViewAsSkill{
	name = "se_zhijian",
	n = 0,
	view_as = function(self, cards)
		return se_zhijiancard:clone()
	end,
	enabled_at_play = function(self, player)
		return player:getPile("moli"):length() > 0 and not sgs.Self:hasFlag("se_zhijiancard_used")
	end,
}

se_zhijiancard = sgs.CreateSkillCard{
	name = "se_zhijiancard",
	target_fixed = true,
	will_throw = true,
	filter = function(self, targets, to_select)
		return #targets == 0
	end,
	on_use = function(self, room, source, targets)
		room:setPlayerFlag(source,"se_zhijiancard_used")
		local moli = source:getPile("moli")
		local count = moli:length()
		local id
		if count < 1 then
			return
		else
			room:fillAG(moli, source)
			id = room:askForAG(source, moli, false, self:objectName())
			room:clearAG(source)
			if id == -1 then
				return
			end
		end
		local card = sgs.Sanguosha:getCard(id)
		room:throwCard(card, nil, nil)
		local list = room:getAlivePlayers()
		local targets = sgs.SPlayerList()
		local emptylist = sgs.PlayerList()
		for _,p in sgs.qlist(list) do
			if not p:isKongcheng() then
				targets:append(p)
			end
		end
		if targets:isEmpty() then return false end
		local target = room:askForPlayerChosen(source, targets, self:objectName())
		--room:broadcastSkillInvoke("se_zhijian")
		local success = source:pindian(target, self:objectName(), nil)
		if success then
			local room = source:getRoom()
			local judge = sgs.JudgeStruct()
			judge.pattern = "."
			judge.reason = self:objectName()
			judge.who = source
			room:judge(judge)
			local number = judge.card:getNumber()
			if number < 6 then
				number = 6
			end
			room:drawCards(source, number)
		end
	end,
}


se_hengsao = sgs.CreateViewAsSkill{
	name = "se_hengsao",
	n = 0,
	view_as = function(self, cards)
		return se_hengsaocard:clone()
	end,
}

se_hengsaocard = sgs.CreateSkillCard{
	name = "se_hengsaocard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select) --必须
		if #targets <3 then
			return true
		end
	end,
	feasible = function(self, targets)
		return #targets > 0
	end,
	on_use = function(self, room, source, targets)
		--KOF
		if room:getAllPlayers(true):length() == 2 then
			room:loseHp(source, 1)
		else
			room:loseHp(source, 2)
		end
		--room:broadcastSkillInvoke("se_hengsao")
		if source:isAlive() then
			local theDamage = sgs.DamageStruct()
			theDamage.from = source
			theDamage.to = targets[1]
			theDamage.damage = 1
			theDamage.nature = sgs.DamageStruct_Normal
			room:damage(theDamage)
			if #targets >= 2 then
				local theDamage = sgs.DamageStruct()
				theDamage.from = source
				theDamage.to = targets[2]
				theDamage.damage = 1
				theDamage.nature = sgs.DamageStruct_Normal
				room:damage(theDamage)
			end
			if #targets == 3 then
				local theDamage = sgs.DamageStruct()
				theDamage.from = source
				theDamage.to = targets[3]
				theDamage.damage = 1
				theDamage.nature = sgs.DamageStruct_Normal
				room:damage(theDamage)
			end
			--KOF
			if room:getAllPlayers(true):length() > 2 then
				source:gainMark("@shouhu",1)
			end
		end
	end,
}

huanhui = sgs.CreateTriggerSkill{
	name = "huanhui", --必须
	frequency = sgs.Skill_Frequent,
	events = {sgs.EventPhaseChanging}, --必须
	on_trigger = function(self, event, player, data) --必须
		local change = data:toPhaseChange()
		local phase = change.to
		if phase == sgs.Player_Finish then
			local room = player:getRoom()
			if player:getGeneralName() == "Saito" then
				room:changeHero(player,"Louise",true, false, false, true)
			else
				room:changeHero(player,"Louise",true, false, true, true)
			end
			--room:setPlayerProperty(player, "maxhp", player:getMark("se_cairen"))
			--room:setPlayerProperty(player, "hp", player:getMark("se_cairen"))
		end
	end,
}


Saito:addSkill(se_zhijian)
Saito:addSkill(se_hengsao)
Saito:addSkill(huanhui)




--尤斯蒂娅


jinghua = sgs.CreateTriggerSkill{
	name = "jinghua", --必须
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.TurnStart}, --必须
	on_trigger = function(self, event, player, data) --必须
		if player:isAlive() and player:hasSkill(self:objectName()) then
			local room = player:getRoom()
			if room:askForSkillInvoke(player, self:objectName()) then
				local list = room:getAlivePlayers()
				local dest = room:askForPlayerChosen(player, list, "jinghua")
				local card = room:askForCard(player, ".", "@jinghua", data)
				--KOF
				if room:getAllPlayers(true):length() == 2 and not card then return end
				room:broadcastSkillInvoke("jinghua")
				room:setEmotion(dest, "skills/purify")
				if room:getAllPlayers(true):length() > 2 then
					room:obtainCard(dest, card, false)
				end
				local choice = room:askForChoice(dest, self:objectName().."%", "jinghua_getcard+jinghua_drawcard+jinghua_recover")
				if choice == "jinghua_getcard" then
					local judge = dest:getJudgingArea()
					if judge:length() > 0 then
						local id = room:askForCardChosen(player, dest, "j", "jinghua")
						room:obtainCard(player, id, true)
					end
				elseif choice == "jinghua_recover" then
					local re = sgs.RecoverStruct()
					re.who = dest
					room:recover(dest,re,true)
				else
					room:drawCards(player, 1)
					room:drawCards(dest, 1)
				end
			end
		end
	end,
}



jiushu = sgs.CreateTriggerSkill{
	name = "jiushu",
	frequency = sgs.Skill_Limited,
	limit_mark = "@tsubasa",
	events = {sgs.AskForPeachesDone},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.AskForPeachesDone then
			local dying_data = data:toDying()
			local source = dying_data.who
			local mygod= room:findPlayerBySkillName("jiushu")
			if mygod then
				if mygod:isAlive() and source:getHp() < 1 then
					if room:askForSkillInvoke(mygod, "jiushu", data) then
						mygod:loseMark("@tsubasa")
						local maxhp = source:getMaxHp()
						local num = source:getHandcardNum()
						room:setPlayerProperty(source, "hp", sgs.QVariant(maxhp))
						if maxhp > 8 then
							maxhp = 8
						end
						if maxhp - num > 0 then
							source:drawCards(maxhp - num)
						end
						room:broadcastSkillInvoke("jiushu")
						room:doLightbox("jiushu$", 3000)
					end
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		local room = target:getRoom()
		local mygod= room:findPlayerBySkillName("jiushu")
		if mygod then
			if mygod:hasSkill(self:objectName()) then
				if mygod:isAlive() then
					return mygod:getMark("@tsubasa") > 0
				end
			end
		end
		return false
	end
}



Eustia:addSkill(jinghua)
Eustia:addSkill(jiushu)
sgs.LoadTranslationTable{
["jinghua"] = "净化「天使·净化之力」",
["#jinghua"] = "想让缇娅酱怎样净化你？ (*/▽＼*)",
[":jinghua"] = "回合开始前，你可以交给一名角色一张牌并令其选择一项：1、令你获得其判定区内的一张牌。2、令你和其各摸一张牌。3、令其回复一点体力。",
["$jinghua1"] = "您的身上...没有哪里痛吧？",
["$jinghua2"] = "不...我很开心能够帮上忙。",
["@jinghua"] = "请选择一张手牌或跳过。",
["jinghua_getcard"] = "让其获得你判定区内的一张牌",
["jinghua_recover"] = "令你回复一点体力",
["jinghua_drawcard"] = "其和你各摸一张牌。",
["jiushu"] = "救赎",
["jiushu$"] = "image=image/animate/jiushu.png",
["jiushuCard"] = "救赎「親愛なる世界へ」",
["$jiushu"] = "凯伊姆先生...请您保重身体...我会为...凯伊姆先生的幸福...永远、永远地...祈祷...",
[":jiushu"] = "限定技。一名角色求桃阶段结束时，若该角色仍处于濒死状态，你可以使其回复体力至X，然后令其补充手牌至X张（X不超过8）。X为该角色的体力上限。",
["@tsubasa"] = "净化之翼",
["Eustia"] = "尤斯蒂娅",
["&Eustia"] = "尤斯蒂娅",
["@Eustia"] = "秽翼的尤斯蒂娅",
["#Eustia"] = "圣子",
["~Eustia"] = "我并没有牺牲自己哦，所以今后也永远都会和您在一起。",
["designer:Eustia"] = "Sword Elucidator",
["cv:Eustia"] = "南條愛乃",
["illustrator:Eustia"] = "瀬菜モナコ",
}

--把妹之手（完成）


Huansha = sgs.CreateTriggerSkill{
	name = "Huansha",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageInflicted},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.DamageInflicted then
			local victim = damage.to
			local source = damage.from
			if victim and victim:isAlive() then
				if damage.nature == sgs.DamageStruct_Fire or damage.nature == sgs.DamageStruct_Thunder then
					local list = room:getAlivePlayers()
					for _,p in sgs.qlist(list) do
						if p:hasSkill("Huansha") then
							if p:isKongcheng() then return end
							if p:askForSkillInvoke(self:objectName(), data) then
								room:broadcastSkillInvoke("Huansha")
								if not source then
									if damage.damage >= 2 then
										room:doLightbox("Huansha$", 2000)
									else
										room:doLightbox("Huansha_Short$", 800)
									end
									return true
								else
									if source:isKongcheng() or (not source:isKongcheng() and p:pindian(source, "Huansha",nil)) then
										local card = room:askForCardChosen(p, source, "he", self:objectName())
										room:obtainCard(p,card)
										if damage.damage >= 2 then
											room:doLightbox("Huansha$", 2000)
										else
											room:doLightbox("Huansha_Short$", 800)
										end
										return true
									else
										if source:isDead() then return end
										local damage2=sgs.DamageStruct()
										damage2.from = source
										damage2.to = p
										damage2.damage = damage.damage
										room:damage(damage2)
										if source:isDead() then return end
										local damage3=sgs.DamageStruct()
										damage3.from = p
										damage3.to = source
										room:damage(damage3)
										damage.damage = 0
										data:setValue(damage)
										return true
									end
								end
							end
						end
					end
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}

SE_Dapo = sgs.CreateTriggerSkill{
	name = "SE_Dapo",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Dying},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.Dying then
			local dying_data = data:toDying()
			local source = dying_data.who
			local mygod= room:findPlayerBySkillName("SE_Dapo")
			if not mygod then return end
			if mygod:isAlive() then
				if mygod:getMaxHp() > source:getMaxHp() and source and source:getRole() ~= "lord" then
					if mygod:getHp() == 1 then
						room:broadcastSkillInvoke("SE_Dapo")
						room:doLightbox("SE_Dapo$", 3000)
						if mygod:getRole() == "lord" then
							room:setPlayerProperty(source,"role",sgs.QVariant("loyalist"))
						else
							room:setPlayerProperty(source,"role",sgs.QVariant(mygod:getRole()))
						end
						local right = true
						for _,p in sgs.qlist(room:getAlivePlayers()) do
							if p:getRole() == "rebel" or p:getRole() == "renegade" then
								right = false
							end
						end
						if right then
							local winner = room:getLord():objectName()
							for _,p in sgs.qlist(room:getAllPlayers(true)) do
								if (p:getRole() == "loyalist") then
									winner = string.format(winner.."+"..p:objectName())
								end
							end
							room:gameOver(winner)
						end
					end
				end
			end
		end
	end
}

Touma:addSkill(Huansha)
Touma:addSkill(SE_Dapo)
sgs.LoadTranslationTable{
["Huansha"] = "幻杀「幻想杀手Imagine Breaker」",
[":Huansha"] = "每当一名角色受到一次属性伤害时，你可以与伤害来源进行拼点：若你赢，你取消该伤害并获得其一张牌；若你未赢，你承受与原伤害等值的普通伤害，对伤害来源造成一点伤害，然后取消原伤害。若无伤害来源或伤害来源没有手牌时，你可以防止此伤害。 ",
["$Huansha"] = "救人用不着什么理由吧。",
["$Huansha1"] = "救人用不着什么理由吧。",
["$Huansha2"] = "我自然担心啊！",
["Huansha$"] = "image=image/animate/Huansha.png",
["Huansha_Short$"] = "image=image/animate/Huansha_Short.png",
["SE_Dapo"] = "打破「友情破颜拳」",
[":SE_Dapo"] = "锁定技。每当体力上限少于你的一名角色濒死时，若你为主公且你的体力为1，其将身份改变为忠臣；若你与其均不为主公且你的体力为1，其将身份改变为与你相同。",
["$SE_Dapo"] = "那就没办法了...我要杀掉啊...你那无聊的幻想！",
["SE_Dapo$"] = "image=image/animate/SE_Dapo.png",
["Touma"] = "上条当麻",
["&Touma"] = "上条当麻",
["@Touma"] = "魔法禁书目录",
["#Touma"] = "把妹之手",
["~Touma"] = "...不幸啊！...",
["designer:Touma"] = "Sword Elucidator",
["cv:Touma"] = "阿部敦",
["illustrator:Touma"] = "悠理なゆた",
}

--冈部伦太郎



se_tiaoyuecard = sgs.CreateSkillCard{
	name = "se_tiaoyuecard",
	target_fixed = true,
	will_throw = false,
	on_use = function(self, room, source, targets)
		local times = source:getMark("@time")
		local timepoints = source:getMark("@timepoint")
		local chang = self:subcardsLength()
		if timepoints > 0 then
			if source:getMark("Benhuihe") == 0 and chang == 0 then
				--room:broadcastSkillInvoke("se_tiaoyue")
				room:doLightbox("se_tiaoyue$", 2000)
				local cards = source:getPile("shikongcundang")
				for i=1, cards:length(), 1 do
					if cards:at(i) ~= -1 then
						room:moveCardTo(sgs.Sanguosha:getCard(cards:at(i)), source, sgs.Player_PlaceHand, false)
					end
				end
				local hp_to = source:getMark("@timepoint")
				local hp = source:getHp()
				if hp < hp_to then
					local theRecover = sgs.RecoverStruct()
					theRecover.recover = hp_to - hp
					theRecover.who = source
					room:recover(source,theRecover)
				end
				source:loseAllMarks("@timepoint")
				source:loseMark("@time")
			end
		end
	end
}



se_tiaoyue = sgs.CreateViewAsSkill{
	name = "se_tiaoyue",
	n = 0,
	view_as = function(self, cards)
		if #cards == 0 then
			local se_tiaoyue_Card = se_tiaoyuecard:clone()
			return se_tiaoyue_Card
		end
	end,
	enabled_at_play = function(self, player)
		return player:getMark("@time") > 0 and player:getMark("@timepoint") > 0
	end
}

se_shixiancard = sgs.CreateSkillCard{
	name = "se_shixiancard",
	target_fixed = true,
	will_throw = false,
	on_use = function(self, room, source, targets)
		local times = source:getMark("@time")
		local timepoints = source:getMark("@timepoint")
		local chang = self:subcardsLength()
		if timepoints == 0 then
			if chang == 0 then
				source:gainMark("Benhuihe")
			elseif chang > 0 then
				--room:broadcastSkillInvoke("se_shixian")
				source:gainMark("Benhuihe")
				source:addToPile("shikongcundang", self)
				local hp = source:getHp()
				source:gainMark("@timepoint", hp)
				room:drawCards(source, chang)
			end
		end
	end
}

se_shixianVS = sgs.CreateViewAsSkill{
	name = "se_shixian",
	n = 999,
	view_filter = function(self, selected, to_select)
		return true
	end,
	view_as = function(self, cards)
		if #cards > 0 then
			local se_shixian_Card = se_shixiancard:clone()
			for i=1, #cards, 1 do
				local id = cards[i]:getId()
				se_shixian_Card:addSubcard(id)
			end
			return se_shixian_Card
		end
	end,
	enabled_at_play = function(self, player)
		return player:getMark("@time") > 0 and player:getMark("Benhuihe") == 0 and player:getMark("@timepoint") == 0
	end
}

se_shixian = sgs.CreateTriggerSkill{
	name = "se_shixian",
	view_as_skill = se_shixianVS,
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.GameStart, sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		if event == sgs.GameStart and player:hasSkill(self:objectName()) then
			player:loseAllMarks("Benhuihe")
			player:loseAllMarks("@time")
			player:gainMark("@time", 2)
		elseif event == sgs.EventPhaseStart then
			if player:isAlive() and player:hasSkill(self:objectName()) then
				if player:getPhase() == sgs.Player_Finish then
					if player:getMark("Benhuihe") > 0 then
						player:loseAllMarks("Benhuihe")
					end
				end
			end
		end
	end
}

se_shixianKeep = sgs.CreateMaxCardsSkill{
	name = "#se_shixianKeep",
	extra_func = function(self, target)
		if target:hasSkill(self:objectName()) then
			local powers = target:getPile("shikongcundang")
			local hp = target:getHp()
			if powers:length() > hp then
				return powers:length() - hp
			else
				return 0
			end
		end
	end
}

se_shixianClear = sgs.CreateDetachEffectSkill{
	name = "se_shixian",
	pilename = "shikongcundang",
}

Okarin:addSkill(se_shixian)
Okarin:addSkill(se_shixianClear)
Okarin:addSkill(se_shixianKeep)
extension:insertRelatedSkills("se_shixian", "#se_shixian-clear")
extension:insertRelatedSkills("se_shixian", "#se_shixianKeep")
Okarin:addSkill(se_tiaoyue)

sgs.LoadTranslationTable{
["se_shixian"] = "时线「世界线1.41」",
["shixian"] = "时线「世界线1.41」",
["se_shixiancard"] = "时线",
["$se_shixian1"] = "我的名字是凤凰院凶真，是要破坏树结构造的男人。失败什么的，没可能的。",
["$se_shixian2"] = "这...果然是瞬间移动？...",
["@time"] = "时空",
["@timepoint"] = "时间点",
["shikongcundang"] = "时空存档",
[":se_shixian"] = "游戏开始时，你获得三枚“时空”标记。出牌阶段，若你没有“时间点”标记，你可以将任意数量的牌放置于你的武将牌上，称为“时间碎片”，然后摸等量的牌并获得X枚“时间点”标记。当“时间碎片”的数量大于X时，你的手牌上限为“时间碎片”的数量。（X为你的当前体力值）",
["se_tiaoyue"] = "跳跃「未来道具8号机」",
["tiaoyue"] = "跳跃「未来道具8号机」",
["se_tiaoyuecard"] = "跳跃",
["$se_tiaoyue"] = "给我跳啊！！...",
["se_tiaoyue$"] = "image=image/animate/se_tiaoyue.png",
[":se_tiaoyue"] =  "出牌阶段限一次，若你有“时间点”，你可以弃置1枚“时空”标记，然后你将体力回复至Y点并获得所有“时间碎片”（Y为“时间点”的数量）。",
["Okarin"] = "岡部倫太郎",
["&Okarin"] = "岡部倫太郎",
["@Okarin"] = "命运石之门",
["#Okarin"] = "鳳凰院兇真",
["~Okarin"] = "...这算什么！...",
["designer:Okarin"] = "Sword Elucidator",
["cv:Okarin"] = "宫野真守",
["illustrator:Okarin"] = "5pb",
}


--逢坂大河


Zhudao = sgs.CreateTriggerSkill{
	name = "Zhudao",
	frequency = sgs.Skill_Frequent,
	events = {sgs.CardsMoveOneTime},
	on_trigger = function(self, event, player, data)
		local move = data:toMoveOneTime()
		local places = move.from_places
		local source = move.from
		if source and source:objectName() == player:objectName() then
			if places:contains(sgs.Player_PlaceEquip) then
				local n = 0
				for _,place in sgs.qlist(places) do
					if place == sgs.Player_PlaceEquip then
						n = n + 1
					end
				end
				local room = player:getRoom()
				for i = 1, n, 1 do
					if room:askForSkillInvoke(player, self:objectName()) then
						room:broadcastSkillInvoke("Zhudao")
						room:doLightbox("Zhudao$", 800)
						local list = room:getAlivePlayers()
						local from = room:askForPlayerChosen(player, list, "Laiyuan")


							if not from:isAllNude() then
								local card_id = room:askForCardChosen(player, from, "hej", self:objectName())
								if card_id ~= -1 then
									local card = sgs.Sanguosha:getCard(card_id)
									local place = room:getCardPlace(card_id)
									local i = -1
									--room:drawCards(player,1)
									if place == sgs.Player_PlaceEquip then
										if card:isKindOf("Weapon") then
											i = 1
										end
										if card:isKindOf("Armor") then
											i = 2
										end
										if card:isKindOf("DefensiveHorse") then
											i = 3
										end
										if card:isKindOf("OffensiveHorse") then
											i = 4
										end
									end
									local tos = sgs.SPlayerList()
									local list = room:getAlivePlayers()
									--room:drawCards(player,1)
									for _,p in sgs.qlist(list) do
										if i ~= -1 then
											if i == 1 then
												if not p:getWeapon() then
													tos:append(p)
												end
											end
											if i == 2 then
												if not p:getArmor() then
													tos:append(p)
												end
											end
											if i == 3 then
												if not p:getDefensiveHorse() then
													tos:append(p)
												end
											end
											if i == 4 then
												if not p:getOffensiveHorse() then
													tos:append(p)
												end
											end
										else
											if not player:isProhibited(p, card) and not p:containsTrick(card:objectName()) then
												tos:append(p)
											end
										end
									end
									--room:drawCards(player,1)
									if tos:isEmpty() then return false end
									local to = room:askForPlayerChosen(player, tos, "Quxiang")
									if to then
										local reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_TRANSFER, player:objectName(), self:objectName(), "")
										room:moveCardTo(card, from, to, place, reason)
									end
								end
							end
						room:setPlayerProperty(player, "faceup", sgs.QVariant(true))
					end
				end
			end
		end
		return false
	end
}

Sixu = sgs.CreateTriggerSkill{
	name = "Sixu",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		if player:isAlive() and player:hasSkill(self:objectName()) then
			if player:getPhase() == sgs.Player_Play then
					local room = player:getRoom()
					if room:askForSkillInvoke(player, self:objectName()) then
						room:broadcastSkillInvoke("Sixu")
						local list = room:getAlivePlayers()
						local from = room:askForPlayerChosen(player, list, "Laiyuan")


							if not from:isAllNude() then
								local card_id = room:askForCardChosen(player, from, "hej", self:objectName())
								if card_id == -1 then return end
								local card = sgs.Sanguosha:getCard(card_id)
								local place = room:getCardPlace(card_id)
								local i = -1
								--room:drawCards(player,1)
								if place == sgs.Player_PlaceEquip then
									if card:isKindOf("Weapon") then
										i = 1
									end
									if card:isKindOf("Armor") then
										i = 2
									end
									if card:isKindOf("DefensiveHorse") then
										i = 3
									end
									if card:isKindOf("OffensiveHorse") then
										i = 4
									end
								end
								local tos = sgs.SPlayerList()
								local list = room:getAlivePlayers()
								--room:drawCards(player,1)
								for _,p in sgs.qlist(list) do
									if i ~= -1 then
										if i == 1 then
											if not p:getWeapon() then
												tos:append(p)
											end
										end
										if i == 2 then
											if not p:getArmor() then
												tos:append(p)
											end
										end
										if i == 3 then
											if not p:getDefensiveHorse() then
												tos:append(p)
											end
										end
										if i == 4 then
											if not p:getOffensiveHorse() then
												tos:append(p)
											end
										end
									else
										if not player:isProhibited(p, card) and not p:containsTrick(card:objectName()) then
											tos:append(p)
										end
									end
								end
								--room:drawCards(player,1)
								if tos:isEmpty() then return false end
								local to = room:askForPlayerChosen(player, tos, "Quxiang")
								if to then
									local reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_TRANSFER, player:objectName(), self:objectName(), "")
									room:moveCardTo(card, from, to, place, reason)
								end
							end


						local from = room:askForPlayerChosen(player, list, "Laiyuan")


							if not from:isAllNude() then
								local card_id = room:askForCardChosen(player, from, "hej", self:objectName())
								if card_id == -1 then return end
								local card = sgs.Sanguosha:getCard(card_id)
								local place = room:getCardPlace(card_id)
								local i = -1
								--room:drawCards(player,1)
								if place == sgs.Player_PlaceEquip then
									if card:isKindOf("Weapon") then
										i = 1
									end
									if card:isKindOf("Armor") then
										i = 2
									end
									if card:isKindOf("DefensiveHorse") then
										i = 3
									end
									if card:isKindOf("OffensiveHorse") then
										i = 4
									end
								end
								local tos = sgs.SPlayerList()
								local list = room:getAlivePlayers()
								--room:drawCards(player,1)
								for _,p in sgs.qlist(list) do
									if i ~= -1 then
										if i == 1 then
											if not p:getWeapon() then
												tos:append(p)
											end
										end
										if i == 2 then
											if not p:getArmor() then
												tos:append(p)
											end
										end
										if i == 3 then
											if not p:getDefensiveHorse() then
												tos:append(p)
											end
										end
										if i == 4 then
											if not p:getOffensiveHorse() then
												tos:append(p)
											end
										end
									else
										if not player:isProhibited(p, card) and not p:containsTrick(card:objectName()) then
											tos:append(p)
										end
									end
								end
								--room:drawCards(player,1)
								if tos:isEmpty() then return false end
								local to = room:askForPlayerChosen(player, tos, "Quxiang")
								if to then
									local reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_TRANSFER, player:objectName(), self:objectName(), "")
									room:moveCardTo(card, from, to, place, reason)
								end
							end
						if room:getAllPlayers(true):length() > 2 then
							player:skip(sgs.Player_Discard)
						end
						player:turnOver()
					end

			end
		end
		return false
	end
}


SixuDef = sgs.CreateTriggerSkill{
	name = "#SixuDef",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DamageInflicted},
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
			if not player:faceUp() then
				if event == sgs.DamageInflicted then
					if player:hasSkill(self:objectName()) then
						if damage.damage == 1 then
							local room = player:getRoom()
							room:broadcastSkillInvoke("SixuDef")
							return true
						end
					end
				end
			end
		return false
	end,
	can_trigger = function(self, target)
		return target
	end
}


Taiga:addSkill(Zhudao)
Taiga:addSkill(Sixu)
Taiga:addSkill(SixuDef)
extension:insertRelatedSkills("Sixu", "#SixuDef")

sgs.LoadTranslationTable{
["Zhudao"] = "竹刀「萌虎必杀」",
["Laiyuan"] = "请选择牌的来源。",
["Quxiang"] = "请选择牌的去向。",
[":Zhudao"] = "每当你失去一张装备区里的牌时，可以将场上的一张牌移动到另一名角色区域里的相应位置，并将你的武将牌翻回正面。",
["Zhudao$"] = "image=image/animate/Zhudao.png",
["$Zhudao1"] = "...给我忘掉！...",
["$Zhudao2"] = "没问题...只要用这个用力敲打脑门...就算不会断气，至少可以让记忆消失得一干二净...",
["Sixu"] = "思绪「私奔·出走」",
[":Sixu"] = "出牌阶段结束时，你可以将场上的两张牌依次移动到另一名角色区域里的相应位置，然后跳过你的弃牌阶段并将武将牌翻面。每当你受到一次伤害时，若你的武将牌背面朝上且此伤害为1，你防止此伤害。",
["$Sixu1"] = "那个...我们...打算私奔！",
["$Sixu2"] = "我要改变，接受一切。",
["$SixuDef"] = "什么嘛...还想让你大吃一惊的。",
["Taiga"] = "逢坂大河",
["&Taiga"] = "逢坂大河",
["@Taiga"] = "龙与虎",
["#Taiga"] = "掌中萌虎",
["~Taiga"] = "完全不行啊...不管怎么做...都还是喜欢着龙儿啊...",
["designer:Taiga"] = "Sword Elucidator",
["cv:Taiga"] = "钉宫理惠",
["illustrator:Taiga"] = "画楽多",
}

--桐人

se_erdao=sgs.CreateViewAsSkill{
	name="se_erdao",
	n=2,
	view_filter = function(self, selected, to_select)
		return #selected<2 and to_select:isKindOf("Weapon")
	end,
	view_as = function(self, cards)
		if #cards==2 then
			local EDcard=se_erdaocard:clone()
			EDcard:addSubcard(cards[1]:getId())
			EDcard:addSubcard(cards[2]:getId())
			EDcard:setSkillName(self:objectName())
			return EDcard
		end
	end,
	enabled_at_play = function(self,player)
		return true
	end
}

se_erdaocard = sgs.CreateSkillCard{
	name = "se_erdaocard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		if #targets == 0 then
			local subcards = self:getSubcards()
			if subcards:length() > 1 then
				return true
			end
		end
	end,
	on_use = function(self, room, source, targets)
		local dest = targets[1]
		local subcards = self:getSubcards()
		if subcards:length() < 2 then
			return
		end
		--room:broadcastSkillInvoke("se_erdao")
		room:doLightbox("se_erdao$", 2000)
		for i = 1, dest:getHp() do
			if not source:isAlive() then return end
			local card
			if math.floor(i/3) * 3 + 1 == i then
				card = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
			elseif math.floor(i/3) * 3 + 2 == i then
				card = sgs.Sanguosha:cloneCard("fire_slash", sgs.Card_NoSuit, 0)
			else
				card = sgs.Sanguosha:cloneCard("thunder_slash", sgs.Card_NoSuit, 0)
			end
			card:setSkillName(self:objectName())
			local use = sgs.CardUseStruct()
			use.from = source
			use.to:append(dest)
			use.card = card
			room:useCard(use, false)
		end
	end
}

se_erdaoTwice = sgs.CreateTriggerSkill{
	name = "se_erdao",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.CardFinished},
	view_as_skill = se_erdao,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local use = data:toCardUse()
		if not use.to:isEmpty() and use.to:at(0):isDead() then return false end
		if use.card:isKindOf("Nullification") then return false end
		if use.card:isKindOf("Collateral") and not use.to:at(0):getWeapon() then return false end
		if (use.card:isKindOf("Snatch") or use.card:isKindOf("Dismantlement")) and use.to and use.to:at(0):getCards("hej"):isEmpty() then return false end
		if use.card:isKindOf("GodSalvation") or use.card:isKindOf("AmazingGrace") or use.card:isKindOf("AOE") or use.card:isKindOf("IronChain") then return false end
		if use.card:isNDTrick() then
			if not player:hasFlag("se_erdaoTwice_used") then
				if room:askForSkillInvoke(player, "se_erdaoTwice", data) then
					local bcard = sgs.Sanguosha:cloneCard(string.lower(use.card:objectName()),use.card:getSuit(), use.card:getNumber())
					bcard:setSkillName(self:objectName())
					room:setPlayerFlag(player,"se_erdaoTwice_used")
					room:broadcastSkillInvoke("se_erdaoTwice")
					local newuse = sgs.CardUseStruct()
					newuse.from = use.from
					newuse.to = use.to
					newuse.card = bcard
					room:useCard(newuse)
				end
			end
			if player:hasFlag("se_erdaoTwice_used") then
				if player:getMark("@Yuzorano") > 0 and not player:hasFlag("se_erdaoTwiceY_used") then
					if room:askForSkillInvoke(player, "se_erdaoTwice", data) then
						local ccard = sgs.Sanguosha:cloneCard(string.lower(use.card:objectName()),use.card:getSuit(), use.card:getNumber())
						ccard:setSkillName(self:objectName())
						room:setPlayerFlag(player,"se_erdaoTwiceY_used")
						room:broadcastSkillInvoke("se_erdaoTwice")
						local newuse = sgs.CardUseStruct()
						newuse.from = use.from
						newuse.to = use.to
						newuse.card = ccard
						room:useCard(newuse)
					end
				end
			end
		end
	end
}





SE_Shanguang = sgs.CreateTriggerSkill{
	name = "SE_Shanguang",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageCaused},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.DamageCaused then
			local victim = damage.to
			if victim and victim:isAlive() then
				if not victim:isNude() then
					if victim:objectName() ~= player:objectName() then
						if damage.nature == sgs.DamageStruct_Normal then
							if room:askForSkillInvoke(player, self:objectName(), data) then
								room:broadcastSkillInvoke("SE_Shanguang")
								room:doLightbox("SE_Shanguang$", 800)
								local Hp = player:getHp()
								--KOF
								if room:getAllPlayers(true):length() == 2 then
									Hp = player:getMaxHp()
								end
								for i=1, player:getMaxHp()+1-Hp, 1 do
									if not victim:isNude() then
										local card = room:askForCardChosen(player, victim, "he", self:objectName())
										room:obtainCard(player, card)
									end
								end
								local list = room:getAlivePlayers()
								for _,p in sgs.qlist(list) do
									if p:getMark("@Yuzorano") > 0 then
										if room:askForSkillInvoke(p, "Yuzora_Shanguang", data) then
											if not victim:isNude() then
												local card = room:askForCardChosen(player, victim, "he", self:objectName())
												room:obtainCard(player, card)
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		return false
	end
}


se_yekong=sgs.CreateViewAsSkill{
	name="se_yekong",
	n = 0,
	view_as = function(self, cards)
		return se_yekongcard:clone()
	end,
	enabled_at_play = function(self, player)
		return player:getMark("@Yuzora") > 0
	end,
}


se_yekongcard = sgs.CreateSkillCard{
	name = "se_yekongcard",
	target_fixed = true,
	will_throw = true,
	filter = function(self, targets, to_select)
		return true
	end,
	on_use = function(self, room, source, targets)
		local count = source:getMark("@Yuzora")
		if count == 0 then
			return
		else
			source:loseAllMarks("@Yuzora")
		end
		if source:isAlive() then
			source:gainMark("@Yuzorano", 3)
			--room:broadcastSkillInvoke("se_yekong")
			room:doLightbox("se_yekong$", 3000)
		end
	end
}

se_yekongRe = sgs.CreateTriggerSkill{
	name = "se_yekong", --必须
	frequency = sgs.Skill_Limited,
	limit_mark = "@Yuzora",
	view_as_skill = se_yekong,
	events = {sgs.TurnStart}, --必须
	on_trigger = function(self, event, player, data) --必须
		if player:isAlive() and player:hasSkill(self:objectName()) and player:getMark("@Yuzorano") > 0 then
			local room = player:getRoom()
			player:loseMark("@Yuzorano",1)
			if room:askForSkillInvoke(player, "se_yekongRe", data) then
				for i = 1, 2, 1 do
					local list = room:getAlivePlayers()
					local dest = room:askForPlayerChosen(player, list, "se_yekongRe")
					room:broadcastSkillInvoke("se_yekong")
					local theRecover = sgs.RecoverStruct()
					theRecover.recover = 1
					theRecover.who = dest
					room:recover(dest,theRecover)
				end
			end
		end
	end,
}

SE_Dixian = sgs.CreateTriggerSkill{
	name = "SE_Dixian",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Damaged},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if player:isAlive() and player:hasSkill(self:objectName()) and damage.nature == sgs.DamageStruct_Normal then
			if room:askForSkillInvoke(player, self:objectName(), data) then
				room:broadcastSkillInvoke("SE_Dixian")
				local da = data:toDamage()
				local source = da.from
				local damage = sgs.DamageStruct()
				damage.from = player
				damage.to = source
				local log = sgs.LogMessage()
				log.type = "#TriggerSkill"
				log.from = player
				log.arg = self:objectName()
				room:damage(damage)
				--KOF
				if room:getAllPlayers(true):length() == 2 then return end
				local judge = sgs.JudgeStruct()
				judge.pattern = "."
				judge.good = true
				judge.negative = false
				judge.reason = self:objectName()
				judge.who = player
				judge.time_consuming = true
				room:judge(judge)
				card = judge.card
				local list = room:getAlivePlayers()
				local dest = room:askForPlayerChosen(player, list, "SE_Dixian")
				room:moveCardTo(card, dest, sgs.Player_PlaceHand, true)
				local damage2 = sgs.DamageStruct()
				damage2.from = player
				damage2.to = dest
				damage2.nature = sgs.DamageStruct_Fire
				local log = sgs.LogMessage()
				log.type = "#TriggerSkill"
				log.from = player
				log.arg = self:objectName()
				room:damage(damage2)
			end
		end
	end
}


SE_ShanguangX = sgs.CreateDistanceSkill{
	name = "SE_ShanguangX",
	correct_func = function(self, from, to)
		if from:hasSkill("SE_ShanguangX") then
			return - from:getMaxHp() + from:getHp() - 1
		end
	end,
}



SE_Kirito:addSkill(se_yekongRe)
SE_Kirito:addSkill(se_erdaoTwice)
SE_Kirito:addSkill("fengbi")
SE_Asuna:addSkill(SE_Shanguang)
SE_Asuna:addSkill(SE_Dixian)

sgs.LoadTranslationTable{
["se_erdao"] = "二刀「星爆气流斩」",
["se_erdao$"] = "image=image/animate/se_erdao.png",
["se_erdaocard"] = "二刀「星爆气流斩」",
["se_erdao"] = "二刀「星爆气流斩」",
["#se_erdaoTwice"] = "二刀",
["se_erdaoTwice"] = "二刀",
["$se_erdaoTwice"] = "只能用那个了么...但是！",
["$se_erdao1"] = "星爆气流斩！！",
["$se_erdao2"] = "去吧...哥哥...上啊！  啊啊啊啊啊啊啊！！！",
[":se_erdao"] = "出牌阶段，你可以弃置两张武器牌并指定一名角色，视为你对其使用其当前体力值数目的【杀】（不计入回合次数限制），顺序依次为【杀】【火杀】【雷杀】的循环；出牌阶段限一次，每当你的一张单体锦囊牌结算后，你可以额外对目标角色使用此牌。",
["se_yekong"] = "夜空「夜空之剑·ReleaseRellection」",
["se_yekong$"] = "image=image/animate/se_yekong.png",
["se_yekongRe"] = "夜空「夜空之剑·ReleaseRellection」",
["@Yuzorano"] = "夜空之剑·ReleaseRellection",
["@Yuzora"] = "夜空之剑",
[":se_yekong"] = "限定技。出牌阶段，直到你第三个回合开始前，你获得以下效果：1.你使用“二刀②”可以额外结算一次；2.你可以令“闪光”的获得牌数+1；3.你可以令“剑舞”的消耗减半；3.回合开始前，你可以指定至多两名角色，令他们回复共计2点体力。",
["$se_yekong"] = "谢谢...各位！",
["SE_Dixian"] = "地陷「创世之神·丝提西亚」",
["$SE_Dixian1"] = "..我是不能原谅只是站在这里等待的自己！",
["$SE_Dixian2"] = "赶上了...赶上了！神啊...！",
[":SE_Dixian"] = "每当你受到一次无属性伤害后，你可以对伤害来源造成1点伤害并进行一次判定，然后你令一名角色获得此判定牌并对其造成1点火焰伤害。",
["SE_Kirito"] = "桐人",
["&SE_Kirito"] = "桐人",
["@SE_Kirito"] = "刀剑神域",
["#SE_Kirito"] = "黑の剑士",
["~SE_Kirito"] = "对不起，亚丝娜...至少你要活下去！...",
["designer:SE_Kirito"] = "Sword Elucidator; Lolihime",
["cv:SE_Kirito"] = "松岡禎丞",
["illustrator:SE_Kirito"] = "SL@原稿修羅場",
["SE_Shanguang"] = "闪光「细剑·闪烁之光」",
["SE_Shanguang$"] = "image=image/animate/SE_Shanguang.png",
["Yuzora_Shanguang"] = "是否允许闪光的额外发动？",
["$SE_Shanguang1"] = "不要！！！！！！",
["$SE_Shanguang2"] = "（连续斩杀声）",
[":SE_Shanguang"] = "每当你对一名角色造成一次无属性伤害时，你可以获得其X+1张牌（X为你已损失的体力）。",
["SE_Asuna"] = "亚丝娜",
["&SE_Asuna"] = "亚丝娜",
["@SE_Asuna"] = "刀剑神域",
["#SE_Asuna"] = "白の闪光",
["~SE_Asuna"] = "对不起呐...再见了...",
["designer:SE_Asuna"] = "Sword Elucidator",
["cv:SE_Asuna"] = "戶松遙",
["illustrator:SE_Asuna"] = "なかじまゆか",
}

--艾伦





se_chouyuan=sgs.CreateViewAsSkill{
	name="se_chouyuan",
	n = 0,
	limit_mark = "@hates",
	view_as = function(self, cards)
		return se_chouyuancard:clone()
	end,
	enabled_at_play = function(self, player)
		return player:getMark("@hates") > 0
	end,
}


se_chouyuancard = sgs.CreateSkillCard{
	name = "se_chouyuancard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		return #targets == 0
	end,
	on_use = function(self, room, source, targets)
		local count = source:getMark("@hates")
		if count == 0 then
			return
		else
			source:loseAllMarks("@hates")
		end
		local dest = targets[1]
		if dest:isAlive() then
			dest:gainMark("@juren")
			--room:broadcastSkillInvoke("se_chouyuan")
			room:doLightbox("se_chouyuan$", 3000)
			room:acquireSkill(source, "SE_Qixin")
			local list = room:getAlivePlayers()
			for _,p in sgs.qlist(list) do
				if p:isAlive() and p:getMark("@juren") ==0 then
					room:setFixedDistance(p, dest, 1)
				end
			end
		end
	end
}


SE_Qixin = sgs.CreateTriggerSkill{
	name = "SE_Qixin",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.TargetConfirmed},
	on_trigger = function(self, event, player, data)
		if player:isAlive() and player:hasSkill("SE_Qixin") then
			local use = data:toCardUse()
			local targets = use.to
			local card = use.card
			local room = player:getRoom()
			if card:isKindOf("Slash") or card:isKindOf("Duel") then
				if use.from:objectName() == player:objectName() then
					for _,target in sgs.qlist(targets) do
						if target:getMark("@juren") > 0 then
							if room:askForSkillInvoke(player, self:objectName()) then
								room:broadcastSkillInvoke("SE_Qixin")
								room:doLightbox("SE_Qixin$", 800)
								for _, ap in sgs.qlist(room:getOtherPlayers(player)) do
									if player:isDead() then return end
									local choice = room:askForChoice(ap, self:objectName(), "Qixin_setcard+Qixin_slashto")
									if choice == "Qixin_slashto" then
										local slash = room:askForUseSlashTo(ap, target, string.format("SE_Qixin:%s",target:objectName()), false)
										if not slash then
											local list = room:getOtherPlayers(player)
											local gg = room:askForPlayerChosen(player, list, "SE_Qixin")
											room:drawCards(gg, 1)
										end
									else
										local list = room:getOtherPlayers(player)
										local gg = room:askForPlayerChosen(player, list, "SE_Qixin")
										room:drawCards(gg, 1)
									end
								end
							end
						end
					end
				end
			end
		end
	end
}

SE_Eren:addSkill(se_chouyuan)
extension:addToSkills(SE_Qixin)
SE_Eren:addWakeTypeSkillForAudio("SE_Qixin")


sgs.LoadTranslationTable{
["se_chouyuan"] = "仇怨",
["se_chouyuan"] = "仇怨",
["se_chouyuancard"] = "仇怨",
[":se_chouyuan"] = "限定技。出牌阶段你可以令一名角色获得1枚“巨人”标记。当除该角色外的角色于该角色计算距离时，始终为1，然后获得“齐心”直到游戏结束；场上所有角色对其结算距离时始终为1。",
["$se_chouyuan"] = "...我要把你们全都驱逐掉！...一匹也不留！",
["SE_Qixin"] = "齐心",
["se_chouyuan$"] = "image=image/animate/se_chouyuan.png",
["SE_Qixin$"] = "image=image/animate/SE_Qixin.png",
[":SE_Qixin"] = "你每对拥有“巨人”标记的角色打出一张【杀】或【相爱相杀】，你可以使场上所有你以外的角色依次选择一项：1、对该角色打出一张【杀】。2、让你选择一名你以外的角色摸一张牌。",
["Qixin_setcard"] = "让艾伦选择一名角色摸一张牌。",
["Qixin_slashto"] = "对目标打出一张【杀】",
["$SE_Qixin1"] = "人类的反击...现在才要开始呢！",
["$SE_Qixin2"] = "固定炮整备四班！准备战斗！目标是...眼前的超大型巨人！",
["@hates"] = "仇怨",
["@juren"] = "巨人",
["SE_Eren"] = "艾伦",
["&SE_Eren"] = "艾伦",
["@SE_Eren"] = "进击的巨人",
["#SE_Eren"] = "驱逐巨人的先锋",
["~SE_Eren"] = "是因为...我太弱小了？...弱小的人...就只能等着任受宰割么！",
["designer:SE_Eren"] = "Sword Elucidator",
["cv:SE_Eren"] = "梶裕贵",
["illustrator:SE_Eren"] = "WIT",
["SE_Eren_sound"] = "----艾伦台词",
["&SE_Eren_sound"] = "----艾伦台词",
["#SE_Eren_sound"] = "台词向",
["~SE_Eren_sound"] = "是因为...我太弱小了？...弱小的人...就只能等着任受宰割么！",
["designer:SE_Eren_sound"] = "Sword Elucidator",
["cv:SE_Eren_sound"] = "梶裕贵",
["illustrator:SE_Eren_sound"] = "WIT",
}


------------------------------------------------------------------------------------------------------------------------------

--第二期
--白井黑子（完成）



se_shunshan=sgs.CreateViewAsSkill{
	name="se_shunshan",
	n = 0,
	view_as = function(self, cards)
		return se_shunshancard:clone()
	end,
	enabled_at_play = function(self, player)
		return not player:hasFlag("se_shunshan_used")
	end,
}

se_shunshancard = sgs.CreateSkillCard{
	name = "se_shunshancard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		return #targets == 0
	end,
	on_use = function(self, room, source, targets)
		if #targets > 1 then return end
		room:setPlayerFlag(source, "se_shunshan_used")
		local target = targets[1]
		room:swapSeat(source, target)
		local list = room:getAlivePlayers()
		local can_list = sgs.SPlayerList()
		for _,p in sgs.qlist(list) do
			local dist = source:distanceTo(p)
			if dist <= 1 and p:objectName() ~= source:objectName() then
				can_list:append(p)
			end
		end
		if can_list:isEmpty() then return false end
		local dest = room:askForPlayerChosen(source, can_list, "se_shunshan")
		--room:broadcastSkillInvoke("se_shunshan")
		dest:gainMark("@Stop")
		if not dest:hasSkill("se_shunshanKeep") then
			room:acquireSkill(dest, "se_shunshanKeep", false)
			--KOF
			if room:getAllPlayers(true):length() > 2 then
				room:acquireSkill(dest, "se_shunshanStopped", false)
				dest:setMark("Stopped",1)
			end
			if room:getAllPlayers(true):length() == 2 then
				dest:setMark("Stopped",0)
			end
		end
	end
}

se_shunshanKeep = sgs.CreateMaxCardsSkill{
	name = "se_shunshanKeep",
	extra_func = function(self, target)
		if target:getMark("@Stop") > 0 then
			local stops = target:getMark("@Stop")
			if stops > 3 then
				stops = 3
			end
			if stops > target:getMaxHp() then
				return -target:getMaxHp()
			end
			return math.min(-stops + target:getMaxHp() - target:getHp(), 0)
		end
	end
}

se_shunshanStopped = sgs.CreateDistanceSkill{
	name = "se_shunshanStopped",
	correct_func = function(self, from, to)
		if from:getMark("@Stop") > 0 and from:getMark("Stopped") > 0 then
			return 1
		end
	end
}

--[[
se_shunshan_Another = sgs.CreateTriggerSkill{
	name = "#se_shunshan_Another",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		if player:isAlive() and player:hasSkill(self:objectName()) then
			if player:getPhase() == sgs.Player_Play then
					local room = player:getRoom()
					if room:askForSkillInvoke(player, "se_shunshan_Another", data) then
						local list = room:getAlivePlayers()
						local dest = room:askForPlayerChosen(player, list, "se_shunshan_Another")
						room:broadcastSkillInvoke("se_shunshan")
						room:swapSeat(player, dest)
					end
			end
		end
	end
}
]]
se_chongjing=sgs.CreateViewAsSkill{
	name="se_chongjing",
	n = 0,
	view_as = function(self, cards)
		return se_chongjingcard:clone()
	end,
	enabled_at_play = function(self, player)
		return player:getMark("@longing") > 0
	end,
}

se_chongjingcard = sgs.CreateSkillCard{
	name = "se_chongjingcard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		return #targets == 0 and not to_select:isMale()
	end,
	on_use = function(self, room, source, targets)
		local dest = targets[1]
		if dest:objectName() == source:objectName() then return end
		local count = source:getMark("@longing")
		if count == 0 then
			return
		else
			source:loseAllMarks("@longing")
		end
		if dest:isAlive() then
			dest:gainMark("@Sister")
			--room:broadcastSkillInvoke("se_chongjing")
			room:doLightbox("se_chongjing$", 3000)
			if not dest:hasSkill("se_chongjing_Attack") then
				room:acquireSkill(dest, "se_chongjing_Attack", false)
			end
		end
	end
}

se_chongjing_Attack = sgs.CreateTriggerSkill{
	name = "se_chongjing_Attack",
	frequency = sgs.Skill_Frequent,
	events = {sgs.DamageCaused, sgs.DamageInflicted},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.DamageCaused then
			local victim = damage.to
			local source = damage.from
			if victim and victim:isAlive() then
					local list = room:getAlivePlayers()
					for _,p in sgs.qlist(list) do
						if p:getMark("@Sister") > 0 and p:objectName() == source:objectName() then
							if p:askForSkillInvoke(self:objectName(), data) then
								room:broadcastSkillInvoke("se_chongjing_Attack")
								victim:gainMark("@Stop")
								if p:getGeneralName() == "Mikoto" then
									victim:gainMark("@Stop")
								end
							end
						end
					end
			end
		elseif event == sgs.DamageInflicted then
			local source = damage.from
			local victim = damage.to
			if source and source:isAlive() then
					local list = room:getAlivePlayers()
					for _,p in sgs.qlist(list) do
						if p:getMark("@Sister") > 0 and p:objectName() == victim:objectName() then
							if p:askForSkillInvoke(self:objectName(), data) then
								room:broadcastSkillInvoke("se_chongjing_Attack")
								source:gainMark("@Stop")
								if p:getGeneralName() == "Mikoto" then
									source:gainMark("@Stop")
								end
							end
						end
					end
			end
		end
		return false
	end
}

se_chongjingMark = sgs.CreateTriggerSkill{
	name = "#se_chongjingMark",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
		player:loseAllMarks("@longing")
		player:gainMark("@longing", 1)
	end
}

se_chongjingStart = sgs.CreateTriggerSkill{
	name = "#se_chongjingStart",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DrawNCards},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if player:hasSkill(self:objectName()) then
				local counts = player:getMark("@longing")
				local count = data:toInt() + counts
				data:setValue(count)
		end
	end,
}

se_jieshu=sgs.CreateViewAsSkill{
	name="se_jieshu",
	n = 0,
	view_as = function(self, cards)
		return se_jieshucard:clone()
	end,
	enabled_at_play = function(self, player)
		return true
	end,
}


se_jieshucard = sgs.CreateSkillCard{
	name = "se_jieshucard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		return #targets == 0 and to_select:getMark("@Stop") > 0
	end,
	on_use = function(self, room, source, targets)
		local target = targets[1]
		target:loseAllMarks("@Stop")
	end
}


Kuroko:addSkill(se_chongjing)
Kuroko:addSkill(se_chongjingMark)
Kuroko:addSkill(se_chongjingStart)
extension:insertRelatedSkills("se_chongjing", "#se_chongjingMark")
extension:insertRelatedSkills("se_chongjing", "#se_chongjingStart")
Kuroko:addSkill(se_shunshan)
Kuroko:addSkill(se_jieshu)

extension:addToSkills(se_chongjing_Attack)
extension:addToSkills(se_shunshanKeep)
extension:addToSkills(se_shunshanStopped)
Kuroko:addWakeTypeSkillForAudio("se_chongjing_Attack")
sgs.LoadTranslationTable{
["se_shunshan"] = "瞬闪「空间移动能力」",
["se_shunshan_Another"] = "瞬闪「空间移动能力」",
["se_shunshancard"] = "瞬闪「空间移动能力」",
["shunshan"] = "瞬闪「空间移动能力」",
["$se_shunshan1"] = "我是「风机委员」，现在以损坏公物和抢劫现行犯的罪名逮捕你们！",
["$se_shunshan2"] = "哦呵呵呵呵，您要是忘了我的能力可是会让我很困扰的哦。",
["$se_shunshan3"] = "我是「风机委员」，我在这里的理由就没必要说明了吧。",
[":se_shunshan"] = "出牌阶段限一次，你可以与一名角色交换位置，然后指定与你距离为1的一名角色，令其获得1枚“定身”标记。拥有“定身”标记的角色的手牌上限-X（X为其“定身”标记的数量且至多为3）；当其与除其外的角色计算距离时，始终+1。",
["se_chongjing"] = "憧憬「姐姐大人」",
["chongjing"] = "憧憬「姐姐大人」",
["se_chongjing$"] = "image=image/animate/se_chongjing.png",
["$se_chongjing"] = "啊啊~お姉様...お姉様...お姉様!お姉様!お姉様!!!!!!!!!!!",
[":se_chongjing"] = "限定技。出牌阶段，你可以令一名其他女性角色获得1枚“お姉様”标记。每当拥有“お姉様”标记的角色造成或受到一次伤害时，其可以令其或对方获得1枚“定身”标记。若如此做且目标角色为御坂美琴，其额外获得1枚“定身”标记。此技能发动前，摸牌阶段，你额外摸一张牌。",
["se_chongjing_Attack"] = "お姉様の辅助",
["$se_chongjing_Attack"] = "这光芒是...お姉様！",
["se_jieshu"] = "解束「解除束缚」",
["jieshu"] = "解束「解除束缚」",
[":se_jieshu"] = "出牌阶段，你可以令一名其他角色弃置其所有“定身”标记。",
["$se_jieshu"] = "欢迎回来，过激犯人。",
["Kuroko"] = "白井黒子",
["&Kuroko"] = "白井黒子",
["@Kuroko"] = "魔法禁书目录",
["#Kuroko"] = "空间移动能力者",
["@longing"] = "憧憬",
["@Sister"] = "お姉様",
["@Stop"] = "定身",
["~Kuroko"] = "姐姐大人......",
["designer:Kuroko"] = "Sword Elucidator",
["cv:Kuroko"] = "新井里美",
["illustrator:Kuroko"] = "厩戸王子",
}

--平泽唯


dai = sgs.CreateTriggerSkill{
	name = "dai",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.CardResponded},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local card = data:toCardResponse().m_card
		if (card:isKindOf("Jink") or card:isKindOf("Slash")) and player:hasSkill(self:objectName()) then
			if room:askForSkillInvoke(player, self:objectName(), data) then
				room:broadcastSkillInvoke("dai")
				local judge = sgs.JudgeStruct()
				judge.pattern = "."
				judge.good = true
				judge.reason = self:objectName()
				judge.who = player
				judge.time_consuming = true
				room:judge(judge)
				local suit = judge.card:getSuit()
				if suit == sgs.Card_Spade or suit == sgs.Card_Club then
					player:gainMark("@daiwei",1)
				else
					local list = room:getAlivePlayers()
					if list:isEmpty() then return false end
					local dest = room:askForPlayerChosen(player, list, self:objectName())
					local theRecover = sgs.RecoverStruct()
					theRecover.recover = 1
					theRecover.who = dest
					room:recover(dest,theRecover)
				end
			end
		end
		return false
	end,
	priority = 3
}



daiVS = sgs.CreateTriggerSkill{
	name = "#daiVS",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.AskForPeachesDone},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local dying_data = data:toDying()
		local source = dying_data.who
		local mygod= room:findPlayerBySkillName("dai")
			if mygod then
				--KOF
				if mygod:isAlive() and source:getHp() < 1 and mygod:getMark("@daiwei") >1 and room:getAllPlayers(true):length() > 2 then
					if room:askForSkillInvoke(mygod, "daiVS", data) then
						mygod:loseMark("@daiwei", 2)
						local theRecover = sgs.RecoverStruct()
						theRecover.recover = 1
						theRecover.who = source
						room:recover(source,theRecover)
						room:broadcastSkillInvoke("dai")
						room:doLightbox("dai$", 3000)
					end
				end
			end
		return false
	end,
	can_trigger = function(self, target)
		local room = target:getRoom()
		local mygod= room:findPlayerBySkillName("dai")
		if mygod then
			if mygod:hasSkill(self:objectName()) then
				if mygod:isAlive() then
					return mygod:getMark("@daiwei") >1
				end
			end
		end
		return false
	end
}



zhuchang = sgs.CreateTriggerSkill{
	name = "zhuchang",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.HpRecover},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if player:hasFlag("zhuchang_use") then return end
		local list = room:getAlivePlayers()
		if player:getHp() ~= player:getMaxHp() then
			for _,p in sgs.qlist(list) do
				if p:hasSkill("zhuchang") then
					room:setPlayerFlag(player,"zhuchang_search")
					if room:askForSkillInvoke(p, "zhuchang", data) then
						room:broadcastSkillInvoke("zhuchang")
						room:setPlayerFlag(player,"zhuchang_use")
						local re = sgs.RecoverStruct()
						re.who = player
						room:recover(player,re,true)
						room:setPlayerFlag(player,"-zhuchang_use")
					end
					room:setPlayerFlag(player,"-zhuchang_search")
				end
			end
		end
	end
}

zhuchangClone = sgs.CreateTriggerSkill{
	name = "zhuchangClone",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.HpRecover},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if player:hasFlag("zhuchang_use") then return end
		if player:hasSkill("zhuchang") then return end
		local list = room:getAlivePlayers()
		if player:getHp() ~= player:getMaxHp() then
			for _,p in sgs.qlist(list) do
				if p:hasSkill("zhuchang") then
					room:setPlayerFlag(player,"zhuchang_search")
					if room:askForSkillInvoke(p, "zhuchang", data) then
						room:broadcastSkillInvoke("zhuchang")
						room:setPlayerFlag(player,"zhuchang_use")
						local re = sgs.RecoverStruct()
						re.who = player
						room:recover(player,re,true)
						room:setPlayerFlag(player,"-zhuchang_use")
					end
					room:setPlayerFlag(player,"-zhuchang_search")
				end
			end
		end
	end
}


zhuchangCloneGet = sgs.CreateTriggerSkill{
	name = "#zhuchangCloneGet",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local list = room:getAlivePlayers()
		for _,p in sgs.qlist(list) do
			if not p:hasSkill("zhuchang") then
				room:acquireSkill(p, "zhuchangClone", false)
			end
		end
	end
}



HYui:addSkill(dai)
extension:addToSkills(zhuchangClone)
HYui:addSkill(daiVS)
extension:insertRelatedSkills("dai", "#daiVS")
HYui:addSkill(zhuchang)
HYui:addSkill(zhuchangCloneGet)
extension:insertRelatedSkills("zhuchang", "#zhuchangCloneGet")

sgs.LoadTranslationTable{
["dai"] = "呆  「天然呆」",
["dai$"] = "image=image/animate/dai.png",
["daiVS"] = "呆  「天然呆」",
["$dai1"] = "我刚开始听说轻音部的时候，还以为是轻松~的音乐的意思呢。",
["$dai2"] = "好孩子好孩子~",
["$dai3"] = "啊，等一下~上厕所上厕所~",
["@daiwei"] = "呆唯",
[":dai"] = "每当你使用或打出一张【闪】或打出一张【杀】后，你可以进行一次判定：若结果为黑色，你获得1枚“呆唯”标记；若结果为红色，你指定一名角色回复1点体力。每当其他角色于濒死状态未被救回，你可以弃置2枚“呆唯”标记，令其体力回复至1点。",
["zhuchang"] = "主唱「治愈系声线」",
["zhuchangClone"] = "现场「轻音部演唱会现场」",
[":zhuchangClone"] = "「轻音部演唱会现场」 你可以作为技能 “主唱” 的目标。",
["$zhuchang1"] = "那么，接下来的曲目是「私の恋はホチキス」！",
["$zhuchang2"] = "「ふわふわタイム」",
["$zhuchang3"] = "「U & I」",
[":zhuchang"] = " 每当一名角色回复一次体力时，你可以令其额外回复1点体力。",
["HYui"] = "平沢唯",
["&HYui"] = "平沢唯",
["@HYui"] = "轻音少女",
["#HYui"] = "呆唯",
["~HYui"] = "这是汗~~...呜呜~~",
["designer:HYui"] = "Sword Elucidator",
["cv:HYui"] = "豊崎爱生",
["illustrator:HYui"] = "らぐほのえりか",
}


--爱丽丝



sgs.TianmingPattern = {"pattern"}
se_tianming = sgs.CreateViewAsSkill{
	name = "se_tianming",
	n = 0,
	view_filter = function(self, selected, to_select)
		return true
	end,
	view_as = function(self, cards)
		local pattern = sgs.TianmingPattern[1]
		if pattern == "slash" then
			local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit,0)
			slash:setSkillName(self:objectName())
			return slash
		elseif pattern == "jink" then
			local jink = sgs.Sanguosha:cloneCard("jink", sgs.Card_NoSuit,0)
			jink:setSkillName(self:objectName())
			return jink
		elseif pattern == "nullification" then
			local nullification = sgs.Sanguosha:cloneCard("nullification", sgs.Card_NoSuit,0)
			nullification:setSkillName(self:objectName())
			return nullification
		end
	end,
	enabled_at_play = function(self, player)
		if sgs.Slash_IsAvailable(player) and player:getMark("@Tianming") > 11 then
			sgs.TianmingPattern = {"slash"}
			return true
		end
		return false
	end,
	enabled_at_response = function(self, player, pattern)
		if (pattern == "jink" and player:getMark("@Tianming") > 16 ) or (pattern == "slash" and player:getMark("@Tianming") > 11) or (pattern == "nullification" and player:getMark("@Tianming") > 22) then
			sgs.TianmingPattern = {pattern}
			return true
		end
		return false
	end,
	enabled_at_nullification = function(self, player)
		if player:getMark("@Tianming") > 22 then
			sgs.TianmingPattern = {"nullification"}
			return true
		end
		return false
	end
}

se_tianmingWore = sgs.CreateTriggerSkill{
	name = "se_tianming",
	view_as_skill = se_tianming,
	frequency = sgs.Skill_Notfrequent,
	events = {sgs.CardResponded, sgs.TargetConfirmed, sgs.CardFinished, sgs.TurnStart, sgs.GameStart, sgs.EventAcquireSkill, sgs.CardAsked},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.CardResponded then
			local resp = data:toCardResponse()
			local card = resp.m_card
			if card:getSkillName() == "se_tianming" then
				if card:isKindOf("Slash") then
					player:loseMark("@Tianming", 12)
				elseif card:isKindOf("Jink") then
					player:loseMark("@Tianming", 17)
				end
			end
		elseif event == sgs.TargetConfirmed then
			local use = data:toCardUse()
			if use.from:objectName() == player:objectName() then
				if use.card:getSkillName() == "se_tianming" then
					if use.card:isKindOf("Slash") then
						player:loseMark("@Tianming", 12)
					end
				end
			end
		elseif event == sgs.CardFinished then
			local use = data:toCardUse()
			if use.from:objectName() == player:objectName() then
				if use.card:getSkillName() == "se_tianming" then
					if use.card:isKindOf("Nullification") then
						player:loseMark("@Tianming", 23)
					end
				end
			end
		elseif event == sgs.CardAsked then
			local ask = data:toString()
			if ask == "jink" then
				room:setPlayerFlag(player,"jink_to")
			elseif ask == "slash" then
				room:setPlayerFlag(player,"slash_to")
			elseif ask == "nullification" then
				room:setPlayerFlag(player,"null_to")
			end
		elseif event == sgs.TurnStart then
			local room = player:getRoom()
			if room:getAllPlayers(true):length() == 2 then
				player:gainMark("@Tianming", 10)
			else
				player:gainMark("@Tianming", 32)
			end
		elseif event == sgs.GameStart or (event == sgs.EventAcquireSkill and data:toString() == "se_tianming") then
			player:loseAllMarks("@Tianming")
			player:gainMark("@Tianming", 72)
		end
	end
}


se_jianwu=sgs.CreateViewAsSkill{
	name="se_jianwu",
	n = 0,
	view_as = function(self, cards)
		return se_jianwucard:clone()
	end,
	enabled_at_play = function(self, player)
		if player:getMark("@Tianming") > 129 then
			return true
		end
	end,
}


se_jianwucard = sgs.CreateSkillCard{
	name = "se_jianwucard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select) --必须
		if #targets <3 then
			return true
		end
	end,
	feasible = function(self, targets)
		return #targets > 0
	end,
	on_use = function(self, room, source, targets)
		local list = room:getAlivePlayers()
		for _,p in sgs.qlist(list) do
			if p:getMark("@Yuzorano") > 0 then
				if room:askForSkillInvoke(p, "Yuzora_se_jianwu", data) then
					source:gainMark("@Tianming", 65)
				end
			end
		end
		source:loseMark("@Tianming", 130)
		--room:broadcastSkillInvoke("se_jianwu")
		room:doLightbox("se_jianwu$", 2000)
		if source:isAlive() then
			targets[1]:turnOver()
			room:setEmotion(targets[1], "skills/leaf")
			room:loseHp(targets[1])
			if #targets >= 2 then
				targets[2]:turnOver()
				room:setEmotion(targets[2], "skills/leaf")
				room:loseHp(targets[2])
			end
			if #targets == 3 then
				targets[3]:turnOver()
				room:setEmotion(targets[3], "skills/leaf")
				room:loseHp(targets[3])
			end
		end
	end,
}


se_kanhu=sgs.CreateViewAsSkill{
	name="se_kanhu",
	n = 0,
	view_as = function(self, cards)
		return se_kanhucard:clone()
	end,
	enabled_at_play = function(self, player)
		return player:getMark("@Tianming") > 19 and not sgs.Self:hasFlag("se_kanhucard_used")
	end,
}


se_kanhucard = sgs.CreateSkillCard{
	name = "se_kanhucard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select) --必须
		return  #targets == 0
	end,
	on_use = function(self, room, source, targets)
		room:setPlayerFlag(source,"se_kanhucard_used")
		source:loseMark("@Tianming", 20)
		--room:broadcastSkillInvoke("se_kanhu")
		local re = sgs.RecoverStruct()
		re.who = targets[1]
		room:recover(targets[1],re,true)
		if targets[1]:getGeneralName() == "SE_Kirito" then
			local re = sgs.RecoverStruct()
			re.who = targets[1]
			room:recover(targets[1],re,true)
		end
	end,
}




Alice:addSkill(se_tianmingWore)
Alice:addSkill(se_jianwu)
Alice:addSkill(se_kanhu)

sgs.LoadTranslationTable{
["se_tianming"] = "天命「天命运算」",
["se_tianming"] = "天命「天命运算」",
["$se_tianming"] = "呼叫窗口！剩下的天命...",
["@Tianming"] = "天命",
[":se_tianming"] = "游戏开始时，你获得72枚“天命”标记；回合开始前，你获得32枚“天命”标记。每当你需使用或打出一张【杀】时，你可以弃置12枚“天命”标记，视为你使用或打出一张【杀】；每当你需使用或打出一张【闪】时，你可以弃置17枚“天命”标记，视为你使用或打出一张【闪】；每当你需使用一张【金色宣言】时，你可以弃置23枚“天命”标记，视为你使用一张【金色宣言】。",
["se_jianwu"] = "剑舞「金木犀之剑·ReleaseRellection」",
["jianwu"] = "剑舞「金木犀之剑·ReleaseRellection」",
["se_jianwu$"] = "image=image/animate/se_jianwu.png",
["se_jianwucard"] = "剑舞「金木犀之剑·ReleaseRellection」",
["$se_jianwu"] = "ReleaseRellection！",
["Yuzora_se_jianwu"] = "是否允许剑舞天命回复一半？",
[":se_jianwu"] = "出牌阶段，你可以弃置130枚“天命”标记并指定至多三名角色，令他们各失去1点体力并将角色牌翻面。",
["se_kanhu"] = "看护「神圣术治疗」",
["kanhu"] = "看护「神圣术治疗」",
["se_kanhucard"] = "看护「神圣术治疗」",
[":se_kanhu"] = "出牌阶段限一次，你可以弃置20枚“天命”标记并指定一名已受伤的角色，令其回复1点体力。若目标角色为桐人，你令其额外回复1点体力。",
["Alice"] = "爱丽丝",
["&Alice"] = "爱丽丝",
["@Alice"] = "刀剑神域",
["#Alice"] = "金色の骑士",
["~Alice"] = "太过分了...篡改记忆不说，连行动都要受到控制吗？...",
["designer:Alice"] = "Sword Elucidator",
["cv:Alice"] = "",
["illustrator:Alice"] = "",
}

--坂本龙太


SE_Xianjing = sgs.CreateTriggerSkill{
	name = "SE_Xianjing",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Damaged},
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local source = damage.from
		if source then
			local room = player:getRoom()
			if room:askForSkillInvoke(player, self:objectName(), data) then
				room:broadcastSkillInvoke(self:objectName())
				local judge = sgs.JudgeStruct()
				judge.pattern = "."
				judge.good = true
				judge.reason = self:objectName()
				judge.who = player
				judge.time_consuming = true
				room:judge(judge)
				local suit = judge.card:getSuit()
				if suit == sgs.Card_Spade or suit == sgs.Card_Club then
					source:turnOver()
				else
					if not player:hasSkill("yingzi") then
							room:acquireSkill(player, "yingzi")
						elseif player:isAlive() and  player:hasSkill("yingzi") and not player:hasSkill("zhuren") then
							room:acquireSkill(player, "zhuren")
						elseif player:isAlive() and  player:hasSkill("zhuren") and not player:hasSkill("paoxiao") then
							room:acquireSkill(player, "paoxiao")
						elseif player:isAlive() and  player:hasSkill("paoxiao") and not player:hasSkill("luagonglue") then
							room:acquireSkill(player, "luagonglue")
						elseif player:isAlive() and  player:hasSkill("luagonglue") and not player:hasSkill("SE_Zishang") then
							room:acquireSkill(player, "SE_Zishang")
						elseif player:isAlive()	and player:hasSkill("SE_Zishang") and not player:hasSkill("LuaBaozou") then
							room:acquireSkill(player, "LuaBaozou")
					end
				end
			end
		end
		return false
	end,
}


SE_Boming = sgs.CreateTriggerSkill{
	name = "SE_Boming",
	frequency = sgs.Skill_Limited,
	events = {sgs.AskForPeachesDone},
	limit_mark = "@HIMIKO",
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.AskForPeachesDone then
			local dying_data = data:toDying()
			local source = dying_data.who
			local mygod= room:findPlayerBySkillName("SE_Boming")
			if mygod then
				if mygod:isAlive() and source:getHp() < 1 and mygod:getMark("@HIMIKO") >0 then
					local i = 0
					if mygod:hasSkill("yingzi") then
						i = i + 1
					end
					if mygod:hasSkill("zhuren") then
						i = i + 1
					end
					if mygod:hasSkill("paoxiao") then
						i = i + 1
					end
					if mygod:hasSkill("luagonglue") then
						i = i + 1
					end
					if mygod:hasSkill("SE_Zishang") then
						i = i + 1
					end
					if mygod:hasSkill("LuaBaozou") then
						i = i + 1
					end
					if i > 0 and room:askForSkillInvoke(mygod, "SE_Boming", data) then
						mygod:loseMark("@HIMIKO")

            if mygod:hasSkill("yingzi") then
  						room:detachSkillFromPlayer(mygod, "yingzi")
  					end
  					if mygod:hasSkill("zhuren") then
  						room:detachSkillFromPlayer(mygod, "zhuren")
  					end
  					if mygod:hasSkill("paoxiao") then
  						room:detachSkillFromPlayer(mygod, "paoxiao")
  					end
  					if mygod:hasSkill("luagonglue") then
  						room:detachSkillFromPlayer(mygod, "luagonglue")
  					end
  					if mygod:hasSkill("SE_Zishang") then
  						room:detachSkillFromPlayer(mygod, "SE_Zishang")
  					end
  					if mygod:hasSkill("LuaBaozou") then
  						room:detachSkillFromPlayer(mygod, "LuaBaozou")
  					end

						HpMax = source:getMaxHp()
						if HpMax < i then i = HpMax end
						room:setPlayerProperty(source, "hp", sgs.QVariant(i))
						room:broadcastSkillInvoke("SE_Boming")
						room:doLightbox("SE_Boming$", 3000)
					end
				end
			end
			return false
		end
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}


Sakamoto:addSkill(SE_Xianjing)
Sakamoto:addSkill(SE_Boming)

sgs.LoadTranslationTable{
["SE_Xianjing"] = "陷阱「坂本の计谋」",
[":SE_Xianjing"] = "每当你受到一次伤害后，你可以进行一次判定：若结果为红色，你获得1枚“陷阱”标记；若结果为黑色，你令伤害来源翻面。若你的“陷阱”标记数量大于0，你获得“英姿”；大于1，你获得“助人”；大于2，你获得“咆哮”；大于3，你获得 “攻略”；大于4，你获得“自伤”；大于5，你获得“暴走”。",
["$SE_Xianjing1"] = "...别动！敢动一下我就用撞击型砸你了。",
["$SE_Xianjing2"] = "你果然很厉害！但是...玩BTOOOM我可不会输！",
["$SE_Xianjing3"] = "真是个惨痛的教训...是该和之前天真的自己告别的时候了！",
["$SE_Xianjing4"] = "乖乖认输吧！否则我会毫不留情地干掉你！...",
["SE_Boming"] = "搏命「坂本の抉择」",
["SE_Boming$"] = "image=image/animate/SE_Boming.png",
[":SE_Boming"] = "限定技。每当一名角色的濒死状态结束后，你可以弃置所有“陷阱”标记并失去1点体力，然后令其体力回复至X（X为你弃置的“陷阱”标记数且至多为6）。",
["$SE_Boming"] = "我怎么可能抛弃你呢！...不论现实世界...还是虚拟世界！",
["Sakamoto"] = "坂本竜太",
["&Sakamoto"] = "坂本竜太",
["@Sakamoto"] = "BTOOOM!",
["#Sakamoto"] = "神级玩家",
["~Sakamoto"] = "...为什么...为什么会变成这样啊！...",
["designer:Sakamoto"] = "Sword Elucidator",
["cv:Sakamoto"] = "本乡奏多",
["illustrator:Sakamoto"] = "MAD HOUSE",
}


--立华奏
se_qiyuan = sgs.CreateViewAsSkill{
	name="se_qiyuan",
	n=0,
	limit_mark = "@se_qiyuan",
	view_as=function(self,cards)
		return se_qiyuancard:clone()
	end,
	enabled_at_play=function(self,player)
		return player:getMark("@se_qiyuan") > 0
	end
}

se_qiyuancard = sgs.CreateSkillCard{
	name = "se_qiyuancard",
	target_fixed = true,
	will_throw = true,
	on_use = function(self, room, source, targets)
		if source:getMark("@se_qiyuan") == 0 then return end
		local deathplayer = {}
		for _,p in sgs.qlist(room:getPlayers()) do
			if p:isDead() and p:getMaxHp() >= 1 then
				table.insert(deathplayer,p:getGeneralName())
			end
		end
		if #deathplayer==0 then
			local log =  sgs.LogMessage()
			log.type = "#se_qiyuan_noDeath"
			room:sendLog(log)
			return
		end
		local ap = room:askForChoice(source,"se_qiyuan%",table.concat(deathplayer,"+"))
		if ap == "" then return end
		local player
		for _,p in sgs.qlist(room:getPlayers()) do
			if p:getGeneralName() == ap and p:isDead() then
				player=p
			end
		end
		if not player then return end
		source:loseMark("@se_qiyuan")
		--room:broadcastSkillInvoke("se_qiyuan")
		room:doLightbox("se_qiyuan$", 3000)
		room:revivePlayer(player)
		local skill_list = player:getVisibleSkillList()
		for _,skill in sgs.qlist(skill_list) do
			if player:hasSkill(skill) then
				room:detachSkillFromPlayer(player, skill:objectName())
			end
		end
		local maxhp = player:getMaxHp()
		room:setPlayerProperty(player, "hp", sgs.QVariant(maxhp))
		player:drawCards(3)
		room:setPlayerFlag(player,"se_qiyuan_ed")
		if source:getRole() == "lord" then
			room:setPlayerProperty(player,"role",sgs.QVariant("loyalist"))
		else
			room:setPlayerProperty(player,"role",sgs.QVariant(source:getRole()))
		end
	end,
}


Lichang =  sgs.CreateTriggerSkill{
	name="Lichang",
	frequency = sgs.Skill_NotFrequent,
	events={sgs.CardAsked},
	on_trigger=function(self,event,player,data)
		local room = player:getRoom()
		if event == sgs.CardAsked then
			local pattern = sgs.Sanguosha:getCurrentCardUsePattern()
			if pattern == "jink" then
				if not player:hasSkill("Lichang") then return end
				local list = room:getAlivePlayers()
				local maxhp = true
				for _,p in sgs.qlist(list) do
					if p:getHp() > player:getHp() then
						maxhp = false
					end
				end
				if maxhp then return false end
				if room:askForSkillInvoke(player,"Lichang",data) then
					room:broadcastSkillInvoke(self:objectName())
					local jinkcard = sgs.Sanguosha:cloneCard("jink",sgs.Card_NoSuit,0)
					jinkcard:setSkillName("Lichang")
					room:provide(jinkcard)
					return true
				end
			end
		end
	end
}

se_shouren=sgs.CreateViewAsSkill{
	name="se_shouren",
	n = 0,
	view_as = function(self, cards)
		return se_shourencard:clone()
	end,
	enabled_at_play = function(self, player)
		return not sgs.Self:hasFlag("se_shourencard_used")
	end,
}


se_shourencard = sgs.CreateSkillCard{
	name = "se_shourencard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select) --必须
		return  #targets == 0
	end,
	on_use = function(self, room, source, targets)
		room:setPlayerFlag(source,"se_shourencard_used")
		--room:broadcastSkillInvoke("se_shouren")
		local target = targets[1]
		local hp = target:getHp()
		room:loseHp(target, 1)
		--KOF
		if hp == 1 and room:getAllPlayers(true):length() > 2 then
			target:turnOver()
			if source:hasSkill("Lichang") then room:detachSkillFromPlayer(source, "Lichang") end
		end
		local msg = sgs.LogMessage()
		msg.type = "#addMaxHp"
		msg.from = target
		msg.arg = 1
		room:sendLog(msg)
	end,
}




Kanade:addSkill(se_qiyuan)
Kanade:addSkill(Lichang)
Kanade:addSkill(se_shouren)


sgs.LoadTranslationTable{
["se_qiyuan"] = "祈愿「死后战线解放」",
["#se_qiyuan"] = "嗯...复活谁呢？",
["qiyuan"] = "祈愿「死后战线解放」",
["se_qiyuancard"] = "祈愿「死后战线解放」",
["$se_qiyuan1"] = "因为...我是来向你说声谢谢的。",
["$se_qiyuan2"] = "结弦...拜托你，刚才的那番话请再说一次...",
["@se_qiyuan"] = "祈愿",
["se_qiyuan$"] = "image=image/animate/se_qiyuan.png",
["#se_qiyuan_noDeath"] = "当前场上没有角色死亡或没有可用对象。",
[":se_qiyuan"] = "限定技。出牌阶段，你可以指定一名已死亡的角色，令其复活并失去所有技能，然后摸三张牌并加入你的阵营。",
["Lichang"] = "力场「Distortion“扭曲力场”」",
["Lichang:jink"] = "力场「Distortion“扭曲力场”」",
["$Lichang"] = "「Guardskill Distortion」",
[":Lichang"] = "每当你需使用或打出一张【闪】时，若你的当前体力值不为全场最大，可以视为你使用或打出一张【闪】。",
["se_shouren"] = "手刃「Handsonic “音速手刃”」",
["shouren"] = "手刃「Handsonic “音速手刃”」",
["se_shourencard"] = "手刃「Handsonic “音速手刃”」",
["$se_shouren1"] = "「Guardskill Handsonic」",
["$se_shouren2"] = "「Handsonic Version2」",
["#addMaxHp"] = "%from 增加 %arg 点体力上限。",
[":se_shouren"] = "出牌阶段限一次，你可以指定一名角色，令其失去1点体力。若如此做且该角色的体力值变为0，你令其将武将牌翻面，然后失去技能“力场”。",
["Kanade"] = "立华奏",
["&Kanade"] = "立华奏",
["@Kanade"] = "Angel Beats!",
["#Kanade"] = "天使",
["~Kanade"] = "赐予我生命，真的...很感谢...",
["designer:Kanade"] = "Sword Elucidator",
["cv:Kanade"] = "花泽香菜",
["illustrator:Kanade"] = "Na-Ga",
}

--龙宫礼奈

--~
KeaiStart =  sgs.CreateTriggerSkill{
	name="#KeaiStart",
	frequency = sgs.Skill_Compulsory,
	events={sgs.GameStart,  sgs.EventAcquireSkill},
	on_trigger=function(self,event,player,data)
		if event == sgs.GameStart or (event == sgs.EventAcquireSkill and data:toString() == "Keai") then
			if player:getMark("@Heihua_Rena") == 0 and player:getMark("@Putong_Rena") == 0 then
				player:gainMark("@Putong_Rena")
			end
		end
	end
}

--~
ChaidaoChange = sgs.CreateTriggerSkill{
	name = "#ChaidaoChange",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Damaged},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if player:getMark("@Heihua_Rena") == 0 and player:hasSkill("Chaidao") then
			room:broadcastSkillInvoke("Chaidao")
			player:loseAllMarks("@Heihua_Rena")
			player:loseAllMarks("@Putong_Rena")
			room:doLightbox("Chaidao$", 800)
			player:gainMark("@Heihua_Rena")
			if player:getGeneralName() == "Rena" then
				room:changeHero(player, "Rena_black",false, false, false, false)
			elseif player:getGeneral2Name() == "Rena" then
				room:changeHero(player, "Rena_black",false, false, true, false)
			end
		end
	end
}
--~
ZizhuChange = sgs.CreateTriggerSkill{
	name = "#ZizhuChange",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.EventPhaseEnd and player:getPhase()==sgs.Player_Finish then
			if player:getMark("@Heihua_Rena") > 0 and player:hasSkill("Zizhu") then
				room:broadcastSkillInvoke("Zizhu")
				player:loseAllMarks("@Heihua_Rena")
				player:loseAllMarks("@Putong_Rena")
				if player:getGeneralName() == "Rena_black" then
					room:changeHero(player, "Rena",false, false, false, false)
				elseif player:getGeneral2Name() == "Rena_black" then
					room:changeHero(player, "Rena",false, false, true, false)
				elseif player:hasSkill("Keai") then
					player:gainMark("@Putong_Rena")
				end
			end
		end
	end
}

--~
Zizhu = sgs.CreateTriggerSkill{
	name = "Zizhu",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.TurnStart},
	on_trigger = function(self, event, player, data)
		if player:getMark("@Heihua_Rena") == 0 then return end
		local room = player:getRoom()
		if player:getJudgingArea():length() > 0 then
			if room:askForSkillInvoke(player,self:objectName(),data) then
				room:broadcastSkillInvoke(self:objectName())
				local move = sgs.CardsMoveStruct()
				for _, trick in sgs.qlist(player:getJudgingArea()) do
					move.card_ids:append(trick:getEffectiveId())
				end

				move.reason = sgs.CardMoveReason(0x01,"","Zizhu","")
				move.to_place = sgs.Player_DiscardPile
				room:moveCardsAtomic(move, true)
			end
		end
	end
}


Keai = sgs.CreateTriggerSkill{
	name = "Keai",
	frequency = sgs.Skill_Frequent,
	events = {sgs.CardsMoveOneTime},
	on_trigger = function(self, event, player, data)
		if player:getMark("@Putong_Rena") == 0 then return end
		local room = player:getRoom()
		local move = data:toMoveOneTime()
		local source = move.from
		if source then
			if source:objectName() ~= player:objectName() then
				if move.to_place == sgs.Player_DiscardPile then
					local reason = move.reason.m_reason
					local flag = false
					if bit32.band(reason, sgs.CardMoveReason_S_MASK_BASIC_REASON) == sgs.CardMoveReason_S_REASON_DISCARD then
						flag = true
					end
					if reason == 0x3A then
						flag = true
					end
					if reason == 0x01 then
						flag = true
					end
					if flag then
						local luoyingMove = sgs.CardsMoveStruct()
						luoyingMove.to = player
						luoyingMove.to_place = sgs.Player_PlaceHand
						local ids = sgs.QList2Table(move.card_ids)
						local places = move.from_places
						for i = 1, #ids, 1 do
							local id = ids[i]
							local place = places[i]
							if id ~= -1 then
								local suit = sgs.Sanguosha:getCard(id):getSuit()
								local card = sgs.Sanguosha:getCard(id)
								if suit == sgs.Card_Heart then
									if place ~= sgs.Player_PlaceDelayedTrick then
										if card:isKindOf("TrickCard") or card:isKindOf("EquipCard") then
											if place ~= sgs.Player_PlaceSpecial then
												if room:getCardPlace(id) == sgs.Player_DiscardPile then
													luoyingMove.card_ids:append(id)
												end
											end
										end
									end
								end
							end
						end
						if not luoyingMove.card_ids:isEmpty() then
							luoyingMove.reason = sgs.CardMoveReason(0x27,"","Keai","")
							if player:askForSkillInvoke(self:objectName(), data) then
								room:broadcastSkillInvoke(self:objectName())
								room:moveCardsAtomic(luoyingMove, true)
							end
						end
					end
				end
			end
		end
		return false
	end,
}

Chaidao = sgs.CreateTriggerSkill{
	name = "Chaidao",
	frequency = sgs.Skill_Frequent,
	events = {sgs.CardsMoveOneTime},
	on_trigger = function(self, event, player, data)
		if player:getMark("@Heihua_Rena") == 0 then return end
		local room = player:getRoom()
		local move = data:toMoveOneTime()
		local source = move.from
		if source then
			if source:objectName() ~= player:objectName() then
				if move.to_place == sgs.Player_DiscardPile then
					local reason = move.reason.m_reason
					local flag = false
					if bit32.band(reason, sgs.CardMoveReason_S_MASK_BASIC_REASON) == sgs.CardMoveReason_S_REASON_DISCARD then
						flag = true
					end
					if reason == 0x3A then
						flag = true
					end
					if reason == 0x01 then
						flag = true
					end
					if flag then
						local luoyingMove = sgs.CardsMoveStruct()
						luoyingMove.to = player
						luoyingMove.to_place = sgs.Player_PlaceHand
						local ids = sgs.QList2Table(move.card_ids)
						local places = move.from_places
						for i = 1, #ids, 1 do
							local id = ids[i]
							local place = places[i]
							if id ~= -1 then
								local suit = sgs.Sanguosha:getCard(id):getSuit()
								if suit ~= sgs.Card_Heart and suit ~= sgs.Card_Diamond then
									if place ~= sgs.Player_PlaceSpecial then
										if room:getCardPlace(id) == sgs.Player_DiscardPile then
											luoyingMove.card_ids:append(id)
										end
									end
								end
							end
						end
						if not luoyingMove.card_ids:isEmpty() then
							luoyingMove.reason = sgs.CardMoveReason(0x27,"","Chaidao","")
							if player:askForSkillInvoke(self:objectName(), data) then
								if luoyingMove.card_ids:length() > 1 then
									room:broadcastSkillInvoke(self:objectName())
								end
								room:moveCardsAtomic(luoyingMove, true)
							end
						end
					end
				end
			end
		end
		return false
	end,
}


Rena:addSkill(Zizhu)
Rena:addSkill(Keai)
Rena:addSkill(KeaiStart)
Rena:addSkill(Chaidao)
Rena:addSkill(ChaidaoChange)
Rena:addSkill(ZizhuChange)
extension:insertRelatedSkills("Keai", "#KeaiStart")
extension:insertRelatedSkills("Zizhu", "#ZizhuChange")
extension:insertRelatedSkills("Chaidao", "#ChaidaoChange")
Rena_black:addSkill("Zizhu")
Rena_black:addSkill("Keai")
Rena_black:addSkill("#KeaiStart")
Rena_black:addSkill("Chaidao")
Rena_black:addSkill("#ChaidaoChange")
Rena_black:addSkill("#ZizhuChange")


sgs.LoadTranslationTable{
["@Heihua_Rena"] = "黑化的礼奈",
["@Putong_Rena"] = "普通的礼奈",
["Zizhu"] = "自主「自行摆脱L5」",
["$Zizhu1"] = "不要！...我不要！...",
["$Zizhu2"] = "...为什么我会对这么喜欢的朋友做出那么可怕的事情！...",
[":Zizhu"] = "转化技。通常状态下，你拥有标记“普通”并拥有技能“可爱”。每当你受到一次后，你须将你的标记翻面为“黑化”，将“可爱”转化为“柴刀”。回合开始前，若你的标记为“黑化”且你的判定区里有牌，你可以弃置判定区里的牌；回合结束后，你须将标记翻回“普通”。",
["Keai"] = "可爱「好想带回家！」",
["$Keai1"] = "真好真好！好想带回家~~",
["$Keai2"] = "啊呜~~这个真棒啊！好想带回家！~~",
[":Keai"] = "每当其他角色的♥锦囊牌或装备牌因弃置、使用、打出或判定置入弃牌堆时，你可以获得之。",
["Chaidao"] = "柴刀「黑化暴走」",
["Chaidao$"] = "image=image/animate/Chaidao.png",
["$Chaidao1"] = "你骗人！！...",
["$Chaidao2"] = "啊哈哈哈！啊哈哈哈哈哈！！！啊哈哈哈哈哈！！！",
["$Chaidao3"] = "明明那么相信你...明明那么相信你！！...",
[":Chaidao"] = "每当其他角色的黑色牌因弃置、使用、打出或判定置入弃牌堆时，你可以获得之。",
["Rena"] = "龙宫礼奈",
["&Rena"] = "龙宫礼奈",
["@Rena"] = "寒蝉鸣泣之时",
["#Rena"] = "柴刀女",
["~Rena"] = "......相信我...",
["designer:Rena"] = "Sword Elucidator",
["cv:Rena"] = "中原麻衣",
["illustrator:Rena"] = "Studio DEEN",
["Rena_black"] = "龙宫礼奈レナ",
["&Rena_black"] = "龙宫礼奈",
["#Rena_black"] = "柴刀女",
["~Rena_black"] = "......",
["designer:Rena_black"] = "Sword Elucidator",
["cv:Rena_black"] = "中原麻衣",
["illustrator:Rena_black"] = "Studio DEEN",
}


--Saber


se_shengjian = sgs.CreateViewAsSkill{
	name = "se_shengjian",
	n = 0,
	view_as = function(self, cards)
		return se_shengjiancard:clone()
	end,
	enabled_at_play = function(self, player)
		return not sgs.Self:hasFlag("se_shengjiancard_used")
	end,
}

se_shengjiancard = sgs.CreateSkillCard{
	name = "se_shengjiancard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select) --必须
		return #targets ==0
	end,
	on_use = function(self, room, source, targets)
		source:turnOver()
		--room:broadcastSkillInvoke("se_shengjian")
		room:setPlayerFlag(source,"se_shengjiancard_used")
		local force = math.abs(source:getEquips():length() - targets[1]:getEquips():length())
		if force >= 3 then
			room:doLightbox("se_shengjian$", 3000)
		end
		if force > 0 then
			local theDamage = sgs.DamageStruct()
			theDamage.from = source
			theDamage.to = targets[1]
			theDamage.damage = force
			theDamage.nature = sgs.DamageStruct_Normal
			room:damage(theDamage)
		end
		if targets[1]:getEquips():length() > 0 then
			local move = sgs.CardsMoveStruct()
			for _, equip in sgs.qlist(targets[1]:getEquips()) do
				move.card_ids:append(equip:getEffectiveId())
			end
			move.reason.m_reason = sgs.CardMoveReason_S_REASON_NATURAL_ENTER
			move.to_place = sgs.Player_DiscardPile
			room:moveCardsAtomic(move, true)
		end
		--KOF
		if room:getAllPlayers(true):length() == 2 then
			if force > 0 then
				targets[1]:drawCards(force)
			end
		end
	end,
}

Jianqiao = sgs.CreateTriggerSkill{
	name = "Jianqiao",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageInflicted, sgs.AskForPeachesDone, sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.DamageInflicted then
			local damage = data:toDamage()
			if damage.to and damage.to:hasSkill(self:objectName()) then
				local x = math.random(1,3)
				if x == 1 then
					room:broadcastSkillInvoke("Jianqiao", 1)
					local msg = sgs.LogMessage()
					msg.type = "#Jianqiao_stop"
					msg.from = damage.to
					room:sendLog(msg)
					return true
				end
			end
		elseif event == sgs.AskForPeachesDone then
			local dying = data:toDying()
			if not dying.who or dying.who:isDead() or not dying.who:hasSkill(self:objectName()) then return end
			local theRecover = sgs.RecoverStruct()
			theRecover.who =  dying.who
			room:broadcastSkillInvoke("Jianqiao", 2)
			room:recover(dying.who,theRecover)
		else
			if player:isAlive() and player:hasSkill(self:objectName()) and player:getPhase() == sgs.Player_Finish then
				transfer_to = room:askForPlayerChosen(player, room:getOtherPlayers(player), self:objectName(), "@jianqiao-prompt", true)
				if transfer_to then
					room:broadcastSkillInvoke("Jianqiao", 3)
					room:detachSkillFromPlayer(player, self:objectName())
					room:acquireSkill(transfer_to, self:objectName())
				end
			end
		end
		return false
	end,
}

Saber:addSkill(se_shengjian)
Saber:addSkill(Jianqiao)
sgs.LoadTranslationTable{
["se_shengjian"] = "圣剑「约束胜利之剑」",
["shengjian"] = "圣剑「约束胜利之剑」",
["se_shengjiancard"] = "圣剑「约束胜利之剑」",
["se_shengjian$"] = "image=image/animate/se_shengjian.png",
[":se_shengjian"] = "出牌阶段限一次，你可以将武将牌翻面，然后对一名角色造成X点伤害并将其装备区里的所有牌置入弃牌堆（X为你与其装备牌数的差的绝对值）。",
["$se_shengjian1"] = "Ex...calibur！！！！！！",
["$se_shengjian2"] = "（以第三道令咒，再次下令）不要！！！！（saber，把圣杯毁掉。）",
["$se_shengjian3"] = "Ex...calibur！！！！！！",
["$se_shengjian4"] = "Excalibur！！！",
["#Jianqiao_stop"] = "%from 的avalon阻止了本次伤害。",
["Jianqiao"] = "剑鞘「远离尘世的理想乡」",
["$Jianqiao1"] = "不要紧...治疗已经派上用场了。",
["$Jianqiao2"] = "Avalon！！",
[":Jianqiao"] = "回合结束时，你可以将这个技能转交给其他角色。锁定技。每当你受到一次伤害时，有1/3概率防止此伤害；你离开濒死阶段时回复一点体力。",
["@jianqiao-prompt"] = "选择一名角色并将「剑鞘」转交之，可以取消。",
["Saber"] = "Saber",
["&Saber"] = "Saber",
["@Saber"] = "Fate Zero",
["#Saber"] = "吾王",
["~Saber"] = "这也许全都是...对我这个不懂的人心的君王的惩罚吧...",
["designer:Saber"] = "Sword Elucidator",
["cv:Saber"] = "川澄绫子",
["illustrator:Saber"] = "しらび",
}

--言峰綺礼

Yuyue = sgs.CreateTriggerSkill{
	name = "Yuyue",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Damage},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.Damage then
				local list = room:getAlivePlayers()
				for _,p in sgs.qlist(list) do
					if p:hasSkill("Yuyue") then
						if p:askForSkillInvoke(self:objectName(), data) then
							room:broadcastSkillInvoke(self:objectName())
							local damage_num = damage.damage
							p:drawCards(damage_num)
							if damage_num > 1 then
								room:doLightbox("Yuyue$", 800)
							end
						end
					end
				end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}


Xianhai = sgs.CreateTriggerSkill{
	name = "Xianhai",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageCaused},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.DamageCaused then
			local victim = damage.to
			if victim and victim:isAlive() then
				if victim:getHp() - damage.damage > 0 then return end
				local list = room:getAlivePlayers()
				for _,p in sgs.qlist(list) do
					if p:hasSkill("Xianhai") then
						if p:askForSkillInvoke(self:objectName(), data) then
							room:broadcastSkillInvoke(self:objectName())
							local list = room:getAlivePlayers()
							local dest = room:askForPlayerChosen(p, list, "Xianhai")
							damage.from = dest
							data:setValue(damage)
						end
					end
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}

Kirei:addSkill(Yuyue)
Kirei:addSkill(Xianhai)

sgs.LoadTranslationTable{
["Yuyue"] = "愉悦「追求愉悦」",
[":Yuyue"] = "锁定技。每当一名角色造成一次伤害后 ，你摸等同于此伤害数量的牌。",
["Yuyue$"] = "image=image/animate/Yuyue.png",
["$Yuyue1"] = "啊哈哈哈哈哈哈哈哈！怎么了...我到底怎么了~！...",
["$Yuyue2"] = "多么的邪恶！多么的残酷！这便是我的愿望？",
["$Yuyue3"] = "这样的毁灭！这样的悲鸣！居然是我的愉悦？",
["Xianhai"] = "陷害「阴谋与剧本」",
["$Xianhai1"] = "酒的味道...比想象中的还要善变...",
["$Xianhai2"] = "为了庆祝你独当一面，我要送你一件礼物。",
[":Xianhai"] = "每当一名角色造成伤害时，若该伤害可以令目标进入濒死，你可以指定该伤害的来源。",
["Kirei"] = "言峰綺礼",
["&Kirei"] = "言峰綺礼",
["@Kirei"] = "Fate Zero/Fate Stay Night",
["#Kirei"] = "麻婆神父",
["~Kirei"] = "他在渴望自己生命的诞生！...求你了...别杀掉它！那是...",
["designer:Kirei"] = "Sword Elucidator",
["cv:Kirei"] = "中田讓治",
["illustrator:Kirei"] = "zihad",
}

--冈崎朋也

se_zhurencard = sgs.CreateSkillCard{
	name = "se_zhurencard",
	target_fixed = false,
	will_throw = false,
	filter = function(self, targets, to_select)
		return to_select:objectName() ~= sgs.Self:objectName()
	end,
	on_use = function(self, room, source, targets)
		local target
		if #targets == 0 then
			local list = room:getAlivePlayers()
			for _,player in sgs.qlist(list) do
				if player:objectName() ~= source:objectName() then
					target = player
					break
				end
			end
		else
			target = targets[1]
		end
		--room:broadcastSkillInvoke("se_zhuren")
		room:obtainCard(target, self, false)
	end
}
se_zhuren = sgs.CreateViewAsSkill{
	name = "se_zhuren",
	n = 999,
	view_filter = function(self, selected, to_select)
		local max_num = sgs.Self:getMaxHp() - sgs.Self:getHp() + 1
		return #selected < max_num
	end,
	view_as = function(self, cards)
		if #cards > 0 then
			local card = se_zhurencard:clone()
			for _,cd in pairs(cards) do
				card:addSubcard(cd)
			end
			return card
		end
	end,
	enabled_at_play = function(self, player)
		return not player:hasUsed("#se_zhurencard")
	end
}

se_zhuren_End = sgs.CreateTriggerSkill{
	name = "#se_zhuren_End",
	frequency = sgs.Skill_Frequent,
	events = {sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		if player:isAlive() and player:hasSkill(self:objectName()) then
			if player:getPhase() == sgs.Player_Discard then
					local room = player:getRoom()
					if player:askForSkillInvoke(self:objectName(), data) then
						local card_num = player:getHandcardNum()
						if card_num < 4 then
							player:drawCards(4 - card_num)
						end
					end
			end
		end
	end
}

Daolu = sgs.CreateTriggerSkill{
	name = "Daolu",
	frequency = sgs.Skill_Wake,
	events = {sgs.AskForPeachesDone},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local dying_data = data:toDying()
		local source = dying_data.who
		if not source:hasSkill("Daolu") then return end
		local choice = room:askForChoice(player, self:objectName(), "Nagisa_Protector+Tomoyo_Couple+Fuko_summoner")
		room:loseMaxHp(player)
		room:setPlayerProperty(player, "hp", sgs.QVariant(2))
		if choice == "Nagisa_Protector" then
			room:broadcastSkillInvoke("DaoluA")
			room:doLightbox("DaoluA$", 3000)
			player:gainMark("@NagisaMark")
			room:acquireSkill(player, "se_diangong")
			local list = room:getAlivePlayers()
			for i = 1,3,1 do
				local dest = room:askForPlayerChosen(player, list, "se_diangong_st")
				if not dest:hasSkill("se_diangong_def") then
					room:acquireSkill(dest, "se_diangong_def")
				end
			end
			if not player:hasSkill("se_diangong_def") then
				room:acquireSkill(player, "se_diangong_def")
			end
		elseif choice == "Tomoyo_Couple" then
			room:broadcastSkillInvoke("DaoluB")
			room:doLightbox("DaoluB$", 3000)
			player:gainMark("@Tomoyo")
			room:acquireSkill(player, "Shouyang")
			local list = room:getAlivePlayers()
			local targets = sgs.SPlayerList()
			local emptylist = sgs.PlayerList()
			for _,p in sgs.qlist(list) do
				if p:objectName()~=player:objectName() then
					targets:append(p)
				end
			end
			local dest = room:askForPlayerChosen(player, targets, "Shouyang_st")
			room:acquireSkill(dest, "Shouyang_ed")
		elseif choice == "Fuko_summoner" then
			room:broadcastSkillInvoke("DaoluC")
			room:doLightbox("DaoluC$", 3000)
			player:gainMark("@Fuko")
			room:acquireSkill(player, "Haixing")
		end
		return false
	end,
	can_trigger = function(self, target)
		if target then
			return target:getMark("@NagisaMark") == 0 and target:getMark("@Tomoyo") == 0 and target:getMark("@Fuko") == 0
		end
		return false
	end
}

se_diangong_def = sgs.CreateTriggerSkill{
	name = "#se_diangong_def",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DamageInflicted},
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local room = player:getRoom()
			if damage.card:isKindOf("Lightning") then
				if event == sgs.DamageInflicted then
					if player:hasSkill(self:objectName()) then
						damage.damage = 0
						data:setValue(damage)
						room:broadcastSkillInvoke("se_diangong")
						return
					end
				end
			end
		return false
	end,
	can_trigger = function(self, target)
		return target
	end
}

se_diangong = sgs.CreateViewAsSkill{
	name ="se_diangong",
	n = 1,
	view_filter = function(self,selected,to_select)
		return #selected<1 and not to_select:isEquipped() and to_select:isBlack()
	end,
	view_as =function(self,cards)
		if #cards == 1 then
			local card = sgs.Sanguosha:cloneCard("lightning",cards[1]:getSuit(),cards[1]:getNumber())
			card:addSubcard(cards[1]:getId())
			card:setSkillName("se_diangong")
			return card
		end
	end,
	enabled_at_play = function(self,player)
		return true
	end,
}

Shouyang_ed = sgs.CreateTriggerSkill{
	name = "#Shouyang_ed",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DamageCaused},
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local room = player:getRoom()
		local victim = damage.to
				if event == sgs.DamageCaused then
					if victim:hasSkill(self:objectName()) then
						local target
						local list = room:getAlivePlayers()
						for _,p in sgs.qlist(list) do
							if p:hasSkill("Shouyang") then
								target = p
								break
							end
						end
						damage.to = target
						data:setValue(damage)
						room:broadcastSkillInvoke("Shouyang")
						return
					end
				end
		return false
	end,
	can_trigger = function(self, target)
		return target
	end
}

Shouyang = sgs.CreateTriggerSkill{
	name = "Shouyang",
	frequency = sgs.Skill_Frequent,
	events = {sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		if player:isAlive() and player:hasSkill(self:objectName()) then
			if player:getPhase() == sgs.Player_Finish then
				local room = player:getRoom()
				if player:askForSkillInvoke(self:objectName(), data) then
					room:broadcastSkillInvoke(self:objectName())
					player:drawCards(player:getMaxHp() - player:getHp() + 1)
				end
			end
		end
	end
}

Haixing = sgs.CreateTriggerSkill{
	name = "Haixing",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Dying},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local dying_data = data:toDying()
		local source = dying_data.who
		local mygod= room:findPlayerBySkillName("Haixing")
			if mygod then
				if mygod:isAlive() and source then
					if room:askForSkillInvoke(mygod, "Haixing", data) then
						local card = room:askForDiscard(mygod,"Haixing",1,1,false,false)
						if card then
							room:broadcastSkillInvoke("Haixing")
							local judge = sgs.JudgeStruct()
							judge.pattern = "."
							judge.reason = self:objectName()
							judge.who = mygod
							judge.time_consuming = true
							room:judge(judge)
							if judge.card:getNumber() > 8 then
								local theRecover = sgs.RecoverStruct()
								theRecover.who = source
								room:recover(source,theRecover)
							end
							if judge.card and judge.card:isRed() then
								local theRecover = sgs.RecoverStruct()
								theRecover.who = source
								room:recover(source,theRecover)
							end
						end
					end
				end
			end

	end
}

DaoluA = sgs.CreateTriggerSkill{
	name = "DaoluA",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Dying},
	on_trigger = function(self, event, player, data)
	end
}

DaoluB = sgs.CreateTriggerSkill{
	name = "DaoluB",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Dying},
	on_trigger = function(self, event, player, data)
	end
}

DaoluC = sgs.CreateTriggerSkill{
	name = "DaoluC",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Dying},
	on_trigger = function(self, event, player, data)
	end
}
--[[
Tomoya:addSkill(se_zhuren)
Tomoya:addSkill(se_zhuren_End)
extension:insertRelatedSkills("se_zhuren", "#se_zhuren_End")
Tomoya:addSkill(Daolu)

extension:addToSkills(se_diangong_def)
extension:addToSkills(se_diangong)
extension:insertRelatedSkills("se_diangong", "#se_diangong_def")
extension:addToSkills(Shouyang_ed)
extension:addToSkills(Shouyang)
extension:insertRelatedSkills("Shouyang", "#Shouyang_ed")
extension:addToSkills(Haixing)
extension:addToSkills(DaoluA)
extension:addToSkills(DaoluB)
extension:addToSkills(DaoluC)


Tomoya:addWakeTypeSkillForAudio("se_diangong")
Tomoya:addWakeTypeSkillForAudio("Shouyang")
Tomoya:addWakeTypeSkillForAudio("Haixing")
]]

--真·一方通行

Fanshe = sgs.CreateTriggerSkill{
	name = "Fanshe",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageInflicted},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.DamageInflicted then
			if player:isAlive() then
				if player:hasSkill(self:objectName()) then
					if not player:isNude() then
						if room:askForSkillInvoke(player, "Fanshe", data) then
							local damage = data:toDamage()
							local target = damage.from
							local value = sgs.QVariant()
							value:setValue(damage)
							room:setTag("FansheDamage", value)
							if room:askForDiscard(player,"Fanshe",1,1,false,true) then
								room:broadcastSkillInvoke("Fanshe")
								local tag = room:getTag("FansheDamage")
								local damage1 = tag:toDamage()
								damage1.to = target
								damage1.transfer = true
								room:damage(damage1)
								return true
							end
						end
					end
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target
	end,
	priority = 2
}

BianhuaCard = sgs.CreateSkillCard{
	name = "BianhuaCard",
	target_fixed = true,
	will_throw = true,
	on_use = function(self, room, source, targets)
		--room:broadcastSkillInvoke("Bianhua")
		local cards = room:getNCards(5)
		local left = cards
		room:fillAG(cards, source)
		local card_id = room:askForAG(source, cards, true, self:objectName())
		if card_id then
			room:takeAG(source,card_id)
			left:removeOne(card_id)
		end
		room:clearAG(source)
		local move = sgs.CardsMoveStruct()
		move.card_ids = left
		move.to_place = sgs.Player_DiscardPile
		room:moveCardsAtomic(move,false)
	end
}

Bianhua = sgs.CreateViewAsSkill{
	name = "Bianhua",
	n = 1,
	view_filter = function(self, selected, to_select)
		return true
	end,
	view_as = function(self, cards)
		if #cards == 1 then
			local Bianhua_Card = BianhuaCard:clone()
			Bianhua_Card:addSubcard(cards[1])
			Bianhua_Card:setSkillName(self:objectName())
			return Bianhua_Card
		end
	end,
	enabled_at_play = function(self, player)
		local used = player:usedTimes("#BianhuaCard")
		return used < 5
	end
}

Heiyi = sgs.CreateTriggerSkill{
	name = "Heiyi",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Dying},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local dying_data = data:toDying()
		local source = dying_data.who
		if source:hasSkill(self:objectName()) then
			if room:askForSkillInvoke(source, "Heiyi", data) then
				room:broadcastSkillInvoke("Heiyi")
				local list = room:getAlivePlayers()
				for i = 1,list:length(),1 do
					local dest = room:askForPlayerChosen(source, list, "Heiyi")
					if not dest:isNude() then
						room:doLightbox("Heiyi$", 800)
						local id = room:askForCardChosen(player, dest, "hej", "sunhaodiao")
						room:throwCard(id, dest, source)
					end
				end
				source:drawCards(list:length())
			end
		end
	end
}

Baiyi = sgs.CreateTriggerSkill{
	name = "Baiyi",
	frequency = sgs.Skill_Limited,
	limit_mark = "@LastOrder",
	events = {sgs.Dying},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local dying_data = data:toDying()
		local source = dying_data.who
		local mygod= room:findPlayerBySkillName("Baiyi")
			if mygod then
				if mygod:isAlive() and mygod:objectName() ~= source:objectName() and source and mygod:getMark("@LastOrder") > 0 then
					if room:askForSkillInvoke(mygod, "Baiyi", data) then
						room:broadcastSkillInvoke("Baiyi")
						room:doLightbox("Baiyi$", 3000)
						local list = room:getAlivePlayers()
						local num = 0
						for _,p in sgs.qlist(list) do
							num = num + p:getHandcardNum()
						end
						source:drawCards(num)
						mygod:loseMark("@LastOrder")
					end
				end
			end

	end
}

Wangluo = sgs.CreateMaxCardsSkill{
	name = "Wangluo",
	extra_func = function(self, target)
		if target:hasSkill(self:objectName()) then
			local num = target:getSiblings():length()
			return num + 1
		end
	end
}

WangluoLaugh = sgs.CreateTriggerSkill{
	name = "#WangluoLaugh",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		if player:isAlive() and player:hasSkill(self:objectName()) then
			if player:getPhase() == sgs.Player_Discard then
				if player:getHandcardNum() > player:getHp() then
					local room = player:getRoom()
					room:broadcastSkillInvoke("Wangluo")
					room:doLightbox("Wangluo$", 800)
				end
			end
		end
	end
}

Accelerator:addSkill(Fanshe)
Accelerator:addSkill(Bianhua)
Accelerator:addSkill(Heiyi)
Accelerator:addSkill(Baiyi)
Accelerator:addSkill(Wangluo)
Accelerator:addSkill(WangluoLaugh)
extension:insertRelatedSkills("Wangluo", "#WangluoLaugh")
sgs.LoadTranslationTable{
["Fanshe"] = "反射「矢量操作1」",
["Fanshe$"] = "image=image/animate/Fanshe.png",
[":Fanshe"] = "每当你受到一次伤害时，你可以弃置一张牌并对伤害来源造成等同于此伤害数值的伤害，然后你防止你受到的此伤害。",
["$Fanshe1"] = "不好意思，这前面可是一方通行！",
["$Fanshe2"] = "就算如此，我也决定在那小鬼面前，一直自称为最强。",
["$Fanshe3"] = "（狂笑）演出辛苦了！",
["$Fanshe4"] = "（狂笑）原来是木原君啊！",
["Bianhua"] = "变化「矢量操作2」",
["bianhua"] = "变化「矢量操作2」",
["BianhuaCard"] = "变化「矢量操作2」",
[":Bianhua"] = "<font color=\"green\"><b>出牌阶段限五次，</b></font>你可以弃置一张牌，然后展示牌堆顶的五张牌并获得其中一张牌，将其余的牌置入弃牌堆。",
["$Bianhua1"] = "用不着惊讶吧，我不过是变换了下脚底所施加的动量的矢量罢了。",
["$Bianhua2"] = "呃，你挺有意思的嘛。",
["$Bianhua3"] = "你该不会，忘记本大爷的存在了吧！",
["Heiyi"] = "黑翼「不同于这个世界的有机」",
["Heiyi$"] = "image=image/animate/Heiyi.png",
["$Heiyi1"] = "木原！！！！！！",
["$Heiyi2"] = "杀了他！",
["@LastOrder"] = "Last Order",
[":Heiyi"] = "每当你进入濒死状态时，你可以依次弃置场上X张牌，然后摸X张牌（X为场上存活角色数）。",
["Baiyi"] = "白翼「守护而战」",
["Baiyi$"] = "image=image/animate/Baiyi.png",
[":Baiyi"] = "限定技。每当一名其他角色进入濒死状态时，你可以令该角色摸X张牌（X为所有角色手牌数之和）。",
["$Baiyi"] = "最后之作！！",
["Wangluo"] = "网络「最后之作·御坂网络」",
["Wangluo$"] = "image=image/animate/Wangluo.png",
[":Wangluo"] = "锁定技。你的手牌上限+X（X为场上存活角色数）。",
["$Wangluo1"] = "哦！御坂的存在终于得到承认了，万岁！御坂御坂王婆卖瓜自卖自夸道~",
["$Wangluo2"] = "人睡觉时的表情是最诚实的呢~御坂御坂用冒牌京都腔说道~",
["$Wangluo3"] = "这次换御坂守护他了~御坂御坂试着坦白说道~",
["Accelerator"] = "真·一方通行",
["&Accelerator"] = "一方通行",
["@Accelerator"] = "魔法禁书目录",
["#Accelerator"] = "罪愆中的英雄",
["~Accelerator"] = "......",
["designer:Accelerator"] = "Sword Elucidator",
["cv:Accelerator"] = "冈本信彦",
["illustrator:Accelerator"] = "テルヤ",
}

--第三次
--第三次制作---------------------------------------------------------------------------------------------------------------
--朝田诗乃

SE_Juji = sgs.CreateTriggerSkill{
	name = "SE_Juji",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.TargetConfirmed, sgs.SlashProceed, sgs.GameStart, sgs.EventAcquireSkill},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.GameStart or (event == sgs.EventAcquireSkill and data:toString() == self:objectName()) then
			local list = room:getAlivePlayers()
			for _,p in sgs.qlist(list) do
				room:setFixedDistance(player, p, 1)
			end
		elseif event == sgs.TargetConfirmed then
			local use = data:toCardUse()
			local card = use.card
			local source = use.from
			local room = player:getRoom()
			if card:isKindOf("Slash") then
				if source:objectName() == player:objectName() then
					local phase = player:getPhase()
					if phase == sgs.Player_Play then
						local range = player:getAttackRange()
						local targets = use.to
						for _,target in sgs.qlist(targets) do
							if not target:inMyAttackRange(player) then
								if card:getNumber() ~= 0 then
									room:broadcastSkillInvoke("SE_Juji")
								end
								local msg = sgs.LogMessage()
								msg.type = "#SE_Juji_XD"
								room:sendLog(msg)
								room:setPlayerFlag(target, "SE_JujiTarget")
							end
						end
					end
				end
			end
		elseif event == sgs.SlashProceed then
			local effect = data:toSlashEffect()
			local dest = effect.to
			if dest:hasFlag("SE_JujiTarget") then
				room:setPlayerFlag(dest, "-SE_JujiTarget")
				room:setEmotion(dest, "snipe")
				room:slashResult(effect, nil)
				return true
			end
		end
		return false
	end
}

SE_JujiClear = sgs.CreateDetachEffectSkill{
	name = "SE_Juji",
	on_skill_detached = function(self, room, player)
		for _,p in sgs.qlist(room:getAlivePlayers()) do
			room:removeFixedDistance(player, p, 1)
		end
	end,
}

se_jianyu = sgs.CreateViewAsSkill{
	name = "se_jianyu",
	n = 0,
	view_as = function(self, cards)
		return se_jianyucard:clone()
	end,
	enabled_at_play = function(self, player)
		return not sgs.Self:hasFlag("se_jianyucard_used")
	end,
}

se_jianyucard = sgs.CreateSkillCard{
	name = "se_jianyucard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select) --必须
		if #targets <sgs.Self:getLostHp()+1 then
			return true
		end
	end,
	feasible = function(self, targets)
		return #targets > 0
	end,
	on_use = function(self, room, source, targets)
		--room:broadcastSkillInvoke("se_jianyu")
		room:setPlayerFlag(source,"se_jianyucard_used")
		room:doLightbox("se_jianyu$", 800)
		if #targets > 0 then
			local card = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
			card:setSkillName(self:objectName())
			local use = sgs.CardUseStruct()
			use.from = source
			for _,target in ipairs(targets) do
				use.to:append(target)
			end
			use.card = card
			room:useCard(use, false)
		end
	end,
}


Shino:addSkill(SE_Juji)
Shino:addSkill(SE_JujiClear)
extension:insertRelatedSkills("SE_Juji", "#SE_Juji-clear")
Shino:addSkill(se_jianyu)

sgs.LoadTranslationTable{
["#SE_Juji_XD"] = "由于<font color = 'gold'><b>狙击「PGM Ultima Ratio HecateII」</b></font>的效果，该「杀」强制无法被闪避。",
["SE_Juji"] = "狙击「PGM Ultima Ratio HecateII」",
["$SE_Juji1"] = "碰~！(枪声）下一个！",
["$SE_Juji2"] = "结束了！碰！碰！碰！（枪声）",
[":SE_Juji"] = "锁定技。当你与其他角色计算距离时，始终为1；出牌阶段，你使用的【杀】不能被攻击范围内没有你的角色的【闪】响应。",
["se_jianyu"] = "箭雨「提拉莉雅·无制限歼灭」",
["se_jianyu"] = "箭雨「提拉莉雅·无制限歼灭」",
["se_jianyu$"] = "image=image/animate/se_jianyu.png",
["se_jianyucard"] = "箭雨「提拉莉雅·无制限歼灭」",
["$se_jianyu1"] = "那个男人，有着能在战场中笑的强大，干掉那个男人，我也会....",
["$se_jianyu2"] = "还有什么....是我能做的",
[":se_jianyu"] = "出牌阶段限一次，你可以指定X+1名角色（X为你已损失的体力），视为你对他们使用一张【杀】。",
["Shino"] = "朝田诗乃",
["&Shino"] = "朝田诗乃",
["@Shino"] = "刀剑神域",
["#Shino"] = "深蓝の狙击手",
["~Shino"] = "怎么会！不可能！",
["designer:Shino"] = "Sword Elucidator",
["cv:Shino"] = "泽城美雪",
["illustrator:Shino"] = "A-1",
}

--御坂妹


se_qidiancard = sgs.CreateSkillCard{
	name = "se_qidiancard",
	target_fixed = true,
}

se_qidianvs = sgs.CreateViewAsSkill{
	name = "se_qidian",
	n = 1,
	view_filter = function(self, selected, to_select)
		return #selected<1
	end,
	view_as = function(self, cards)
		if #cards == 1 then
			local card = se_qidiancard:clone()
			card:addSubcard(cards[1])
			card:setSkillName("se_qidian")
			return card
		end
	end,
	enabled_at_play = function()
		return false
	end,
	enabled_at_response = function(self, player, pattern)
		return pattern == "@se_qidian"
	end
}

se_qidian = sgs.CreateTriggerSkill{
	name = "se_qidian",
	frequency = sgs.Skill_NotFrequent,
	view_as_skill = se_qidianvs,
	events = {sgs.AskForRetrial},
	priority = -2,
	can_trigger = function(self,player)
		return player:hasSkill(self:objectName())
	end,
	on_trigger = function(self,event,player,data)
		if player:hasSkill(self:objectName()) then
			if player:askForSkillInvoke(self:objectName(), data) then
				local room = player:getRoom()
				local list = room:getAlivePlayers()
				local judge = data:toJudge()
				local pattern = "@se_qidian"
				local prompt = string.format("#se_qidian:%s:%s:%s",player:objectName(),judge.who:objectName(),judge.reason)
				local card = room:askForCard(player, pattern, prompt, data, sgs.Card_MethodResponse, judge.who, true, self:objectName())
				if card then
					room:broadcastSkillInvoke("se_qidian")
					room:doLightbox("se_qidian$", 800)
					room:retrial(card, player, judge, self:objectName())
					local dest = room:askForPlayerChosen(player,list,self:objectName())
					local damage = sgs.DamageStruct()
					damage.card = nil
					damage.from = player
					damage.to = dest
					damage.nature = sgs.DamageStruct_Thunder
					room:damage(damage)
				end
			end
		end
	end
}

SE_Weigong = sgs.CreateTriggerSkill{
	name = "SE_Weigong",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DrawNCards},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		room:broadcastSkillInvoke("SE_Weigong")
		if player:hasSkill(self:objectName()) then
			local num = room:getAlivePlayers():length()
			if num < 4 then
				num = 4
			end
			local count = data:toInt() + math.random(1,math.ceil(num/2))
			data:setValue(count)
		end
	end,
}

SE_Weigong_end = sgs.CreateMaxCardsSkill{
	name = "#SE_Weigong_end",
	extra_func = function(self, player)
		if player:hasSkill("SE_Weigong") then
			local num = player:getSiblings():length()
			if num < 3 then
				num = 3
			end
			local hp = player:getHp()
			return math.ceil((num+1)/2)
		end
	end
}

Misaka_Imouto:addSkill(se_qidian)
Misaka_Imouto:addSkill(SE_Weigong)
Misaka_Imouto:addSkill(SE_Weigong_end)
extension:insertRelatedSkills("SE_Weigong", "#SE_Weigong_end")

sgs.LoadTranslationTable{
["se_qidian"] = "起电「电力驱动」",
["se_qidian"] = "起电「电力驱动」",
["se_qidian$"] = "image=image/animate/se_qidian.png",
["@se_qidian"] = "起电「电力驱动」",
["#se_qidian"] = "<font color = 'gold'><b>%src</b></font>的改判回合，可以发动<font color = 'gold'><b>起电「电力驱动」</b></font>来修改<font color = 'gold'><b>%dest</b></font>的<font color = 'gold'><b>%arg</b></font>判定。",
["#se_qidianvs"] = "起电「电力驱动」",
["~se_qidian"] = "点击技能→选择1张牌→点击<font color = '#66ccff'><b>确定</b></font>",
["$se_qidian1"] = "虽然我不能理解这话的意思，但不知为何这话让我很受影响。御坂直率地叙述自己的感想道。",
["$se_qidian2"] = "把手放到这个位置是出于御坂的意思，并非你的错。御坂回答道。",
["$se_qidian3"] = "即使是实验品，御坂对这个小鸡仔的性命也...",
[":se_qidian"] = "每当一名角色的判定牌生效前，你可以打出一张牌代替之，然后对一名角色造成1点雷电伤害。",
["SE_Weigong"] = "妹達「妹属性」",
["#SE_Weigong_end"] = "妹達「妹属性」",
["$SE_Weigong1"] = "我是她妹妹。御坂立即回答道。",
["$SE_Weigong2"] = "御坂对自己的心理状态怀有疑问。为了我这个能随意制造替换，要多少有多少的仿制品，你想要做什么？御坂再三问道。",
["$SE_Weigong3"] = "晒一下~御坂若无其事地向原型显摆他买给我的项链。",
[":SE_Weigong"] = "锁定技。你的手牌上限+X；摸牌阶段，你随机额外摸1至X张牌（X为场上存活人数的一半且至少为2，向下取整）。",
["Misaka_Imouto"] = "御坂妹",
["&Misaka_Imouto"] = "御坂妹",
["@Misaka_Imouto"] = "魔法禁书目录",
["#Misaka_Imouto"] = "活出自身",
["~Misaka_Imouto"] = "（一方通行）嘿...",
["designer:Misaka_Imouto"] = "Sword Elucidator",
["cv:Misaka_Imouto"] = "佐々木望",
["illustrator:Misaka_Imouto"] = "Ogata",
}

--柊司
--[[
SE_Maoshi = sgs.CreateProhibitSkill{
	name = "SE_Maoshi",
	is_prohibited = function(self, from, to, card)
		if to and to:hasSkill(self:objectName()) then
			if card and card:isKindOf("Supply_shortage") or card:isKindOf("Indulgence") or card:isKindOf("Lightning") then --or card:isKindOf("EquipCard") then
				return true
			end
		end
		if from:objectName() == to:objectName() then
			if from:hasSkill(self:objectName()) then
				if card:isKindOf("EquipCard") then
					return true
				end
			end
		end
	end
}
]]

SE_Maoshi = sgs.CreateTriggerSkill{
	name = "SE_Maoshi",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.CardsMoveOneTime, sgs.CardUsed},
	on_trigger = function(self, event, player, data)
		if event == sgs.CardsMoveOneTime then
			local move = data:toMoveOneTime()
			local source = move.to
			if source and source:objectName() == player:objectName() then
				local room = player:getRoom()
				for _,card_id in sgs.qlist(move.card_ids) do
					local card = sgs.Sanguosha:getCard(card_id)
					local place = move.to_place
					if place == sgs.Player_PlaceEquip then
						--KOF
						if room:getAllPlayers(true):length() == 2 then
							local target = player:getNextAlive()
							if not target:isNude() then
								local card_id2=room:askForCardChosen(player,target,"he",self:objectName())
								room:obtainCard(player, card_id2)
							end
						else
							room:moveCardTo(card,player,sgs.Player_DiscardPile,true)
						end
					end
				end
			end
		elseif event == sgs.CardUsed then
			use = data:toCardUse()
			if use.to:length() > 0 and use.to:at(0):objectName() == player:objectName() then
				local card = use.card
				if card:isKindOf("EquipCard") then
					if player:hasSkill(self:objectName()) then
						local room = player:getRoom()
						room:moveCardTo(card,player,sgs.Player_DiscardPile,true)
					end
				end
			end
		end
		return false
	end
}


se_zhiyucard = sgs.CreateSkillCard{
	name = "se_zhiyucard",
	target_fixed = false,
	will_throw = false,
	filter = function(self, targets, to_select)
		return to_select:objectName() ~= sgs.Self:objectName()
	end,
	on_use = function(self, room, source, targets)
		local target
		if #targets == 0 then
			local list = room:getAlivePlayers()
			for _,player in sgs.qlist(list) do
				if player:objectName() ~= source:objectName() then
					target = player
					break
				end
			end
		else
			target = targets[1]
		end
		--room:broadcastSkillInvoke("se_zhiyu")
		room:obtainCard(target, self, true)
	end
}
se_zhiyu = sgs.CreateViewAsSkill{
	name = "se_zhiyu",
	n = 999,
	view_filter = function(self, selected, to_select)
		return to_select:isKindOf("EquipCard") or to_select:getSuit() == sgs.Card_Heart
	end,
	view_as = function(self, cards)
		if #cards > 0 then
			local card = se_zhiyucard:clone()
			for _,cd in pairs(cards) do
				card:addSubcard(cd)
			end
			return card
		end
	end,
	enabled_at_play = function(self, player)
		return true
	end
}


se_zhiyuGetRe = sgs.CreateTriggerSkill{
	name = "#se_zhiyu",
	frequency = sgs.Skill_Frequent,
	events = {sgs.CardsMoveOneTime},
	on_trigger = function(self, event, player, data)
		if player:isAlive() then
			if player:hasSkill(self:objectName()) then
				if event == sgs.CardsMoveOneTime then
					local move = data:toMoveOneTime()
					local source = move.from
					if source and source:objectName() == player:objectName() then
						local places = move.from_places
						local room = player:getRoom()
						if (places:contains(sgs.Player_PlaceHand) or places:contains(sgs.Player_PlaceEquip)) and move.to and move.to:objectName() ~= player:objectName() then
							local invoke = false
							for _,cardid in sgs.qlist(move.card_ids) do
								if cardid == -1 then return end
								local card=sgs.Sanguosha:getCard(cardid)
								if card and card:isKindOf("EquipCard") or (card:getSuit() == sgs.Card_Heart and player:isWounded() ) then
									invoke = true
									break
								end
							end
							if invoke then
								if player:askForSkillInvoke("se_zhiyu", data) then
									room:broadcastSkillInvoke("SE_Maoshi")
									for _,cardid in sgs.qlist(move.card_ids) do
										if cardid == -1 then return end
										local card=sgs.Sanguosha:getCard(cardid)
										if card and card:isKindOf("EquipCard") then
											player:drawCards(1)
										end
										if card:getSuit() == sgs.Card_Heart then
											if player:isWounded() then
												local re = sgs.RecoverStruct()
												re.who = player
												room:recover(player, re, true)
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target
	end
}


se_liaolivs = sgs.CreateViewAsSkill{
	name = "se_liaoli",
	n=1,
	view_filter = function(self, selected, to_select)
		return #selected == 0
	end,
	view_as = function(self, cards)
		if #cards == 1 then
			local W1card = se_liaolicard:clone()
			W1card:addSubcard(cards[1])
			W1card:setSkillName(self:objectName())
			return W1card
		end
    end,
	enabled_at_play = function(self,player)
		return not player:hasFlag("se_liaoli_used")
	end
}

se_liaolicard = sgs.CreateSkillCard{
	name="se_liaolicard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		return #targets == 0 and to_select:getMark("@se_liaoli")==0
	end,
	on_use=function(self,room,source,targets)
		targets[1]:gainMark("@se_liaoli")
		touhou_logmessage("#se_liaoli",targets[1])
		local x =source:objectName()
		--room:broadcastSkillInvoke("se_liaoli")
		room:setPlayerMark(source,"se_liaoli_source"..x,1)
		room:setPlayerMark(targets[1],"se_liaoli_target"..x,targets[1]:getMark("se_liaoli_target"..x)+1)
		room:setPlayerFlag(source, "se_liaoli_used")
	end
}

se_liaoli=sgs.CreateTriggerSkill{
	name="#se_liaoli",
	frequency=sgs.Skill_Limited,
	events={sgs.EventPhaseStart},
	view_as_skill = se_liaolivs,
	can_trigger=function(self,player)
		return true
	end,
	on_trigger=function(self,event,player,data)
		local room = player:getRoom()
		if event == sgs.EventPhaseStart and player:getPhase() == sgs.Player_RoundStart then
			local tukasas = anime_playersbyskillname(player,self:objectName())
			if tukasas:isEmpty() then
				for _, pp in sgs.qlist(room:getAlivePlayers()) do
					pp:loseAllMarks("@se_liaoli")
				end
				return
			end
			local sb
			for _,pp in sgs.qlist(room:getAlivePlayers()) do
				if pp:getMark("@se_liaoli")>0 and pp:getPhase() == sgs.Player_RoundStart then
					sb = pp
				end
			end
			if not sb then return end
			for _,tukasa in sgs.qlist(tukasas) do
				local x = tukasa:objectName()
				if sb:getMark("se_liaoli_target"..x)>0 and tukasa:getMark("se_liaoli_source"..x)>0 then
					room:setPlayerMark(sb,"se_liaoli_target"..x, sb:getMark("se_liaoli_target"..x)-1)
					sb:loseAllMarks("@se_liaoli")
					room:broadcastSkillInvoke("se_liaoli")
					room:doLightbox("se_liaoli$", 800)
					local judges = sb:getJudgingArea()
					local num = judges:length()
						if judges:length() > 0 then
							local move = sgs.CardsMoveStruct()
							for _,judge in sgs.qlist(judges) do
								move.card_ids:append(judge:getEffectiveId())
							end
							move.reason.m_reason = sgs.CardMoveReason_S_REASON_NATURAL_ENTER
							move.to_place = sgs.Player_DiscardPile
							room:moveCardsAtomic(move, true)
							sb:drawCards(num)
							if room:getDrawPile():length()==0 then room:swapPile() end
								local n = room:getDrawPile():length()
								local z=0
								for i=0,n do
									local acard = sgs.Sanguosha:getCard(room:getDrawPile():at(i))
									if acard and acard:isKindOf("EquipCard") then
										tukasa:obtainCard(acard)
										z=z+1
										if z==1 then break end
									end
								end
								if z == 0 then
									room:swapPile()
									local n = room:getDrawPile():length()
									for i=0,n do
										local acard = sgs.Sanguosha:getCard(room:getDrawPile():at(i))
										if acard and acard:isKindOf("EquipCard") then
											tukasa:obtainCard(acard)
											z=z+1
											if z==1 then break end
										end
									end
							end
							if num > 1 then
								tukasa:drawCards(num-1)
							end
						else
							sb:drawCards(1)
							if room:getDrawPile():length()==0 then room:swapPile() end
								local n = room:getDrawPile():length()
								local z=0
								for i=0,n do
									local acard = sgs.Sanguosha:getCard(room:getDrawPile():at(i))
									if acard and acard:isKindOf("EquipCard") then
										tukasa:obtainCard(acard)
										z=z+1
										if z==1 then break end
									end
								end
								if z == 0 then
									room:swapPile()
									local n = room:getDrawPile():length()
									for i=0,n do
										local acard = sgs.Sanguosha:getCard(room:getDrawPile():at(i))
										if acard and acard:isKindOf("EquipCard") then
											tukasa:obtainCard(acard)
											z=z+1
											if z==1 then break end
										end
									end
								end
						end
				end
			end
		end
	end
}



Tukasa:addSkill(SE_Maoshi)
Tukasa:addSkill(se_zhiyu)
Tukasa:addSkill(se_zhiyuGetRe)
extension:insertRelatedSkills("se_zhiyu", "#se_zhiyuGetRe")
Tukasa:addSkill(se_liaolivs)
Tukasa:addSkill(se_liaoli)
extension:insertRelatedSkills("se_liaoli", "#se_liaoli")


sgs.LoadTranslationTable{
["SE_Maoshi"] = "冒失",
["$SE_Maoshi1"] = "比如泡方便炒面时泡得都没汤可倒了",
["$SE_Maoshi2"] = "我的手机，手机被……",
["$SE_Maoshi3"] = "这是肿么啦...",
[":SE_Maoshi"] = "每当你的一张♥牌因拼点、获得或于你的弃牌阶段外的弃置移动到你的区域外时，你可以回复1点体力；每当你的一张装备牌因拼点、获得或于你的弃牌阶段外的弃置移动到你的区域外时，你可以摸一张牌。每当一张牌置入你的装备区时，你将之置入弃牌堆。",
["se_liaoli"] = "料理",
["se_liaoli"] = "料理",
["se_liaoli$"] = "image=image/animate/se_liaoli.png",
["#se_liaoli"]="<font color = 'gold'><b>料理</b></font>效果将在 %from  的回合开始阶段开始时发动",
["@se_liaoli"]="料理",
["se_liaolicard"] = "料理",
["$se_liaoli1"] = "诶~准备做什么呢？",
["$se_liaoli2"] = "好了久等了~",
["$se_liaoli3"] = "我做了蛋糕哦~要吃吗?",
[":se_liaoli"] = "出牌阶段限一次，可以弃置一张牌并指定一名角色，该角色的回合开始时，弃置其判定区里的所有牌，然后其摸X张牌，你获得牌堆中第一张装备牌并摸X-1张牌（X为弃置的牌数且至少为1）。 ",
["se_zhiyu"] = "治愈",
["se_zhiyu"] = "治愈",
["se_zhiyucard"] = "治愈",
["$se_zhiyu1"] = "好可爱~",
["$se_zhiyu2"] = "很喜欢~",
["$se_zhiyu3"] = "加油~",
["$se_zhiyu4"] = "虽然我废话很多，但这个没关系。",
["$se_zhiyu5"] = "我讲不出那么有趣的故事，我是小司。",
[":se_zhiyu"] = "出牌阶段，你可以将任意数量的♥牌或装备牌交给一名其他角色。",
["Tukasa"] = "柊司",
["&Tukasa"] = "柊司",
["@Tukasa"] = "Lucky Star!",
["#Tukasa"] = "天然",
["~Tukasa"] = "总有一天，肯定会……",
["designer:Tukasa"] = "yxl88205",
["cv:Tukasa"] = "福原香织",
["illustrator:Tukasa"] = "竜胆",
}



--真·鲁鲁修·V·布列塔尼亚

SE_Geass_start = sgs.CreateTriggerSkill{
	name = "#SE_Geass_start",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		room:broadcastSkillInvoke("SE_Geass")
		local list = room:getAlivePlayers()
		local role = player:getRole()
		if role == "lord" then
			for _,p in sgs.qlist(list) do
				if p:getRole() == "loyalist" then
					p:gainMark("@Geass")
				end
			end
		elseif role == "loyalist" then
			local lord = room:getLord()
			room:setPlayerProperty(player, "role", sgs.QVariant("lord"))
			room:setPlayerProperty(lord, "role", sgs.QVariant(role))
			if list:length() > 4 then
				local count = player:getMaxHp()
				local mhp = sgs.QVariant()
				mhp:setValue(count+1)
				room:setPlayerProperty(player, "maxhp", mhp)
				room:setPlayerProperty(player, "hp", mhp)
				room:loseMaxHp(lord)
			end
			for _,p in sgs.qlist(list) do
				if p:getRole() == "loyalist" then
					p:gainMark("@Geass")
				end
			end
		elseif role == "rebel" then
			for _,p in sgs.qlist(list) do
				if p:getRole() == "rebel" and p:objectName() ~= player:objectName() then
					p:gainMark("@Geass")
				end
			end
		end
	end
}

SE_Geass = sgs.CreateViewAsSkill{
	name = "SE_Geass",
	n = 0,
	view_as = function(self, cards)
		return SE_GeassCard:clone()
	end,
	enabled_at_play = function(self, player)
		return true
	end,
}

SE_GeassCard = sgs.CreateSkillCard{
	name = "SE_GeassCard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select) --必须
		return #targets == 0 and to_select:getMark("@Geass") == 0 and to_select:getRole() ~= "lord"
	end,
	on_use = function(self, room, source, targets)
		--room:broadcastSkillInvoke("SE_Geass")
		local target = targets[1]
		local role = source:getRole()
		local list = room:getAlivePlayers()
		local self_people = 1
		if role == "lord" then
			for _,p in sgs.qlist(list) do
				if p:getRole() == "loyalist" then
					self_people = self_people + 1
				end
			end
		elseif role == "rebel" then
			for _,p in sgs.qlist(list) do
				if p:getRole() == "rebel" and p:objectName() ~= source:objectName() then
					self_people = self_people + 1
				end
			end
		end
		if self_people >= list:length()/2 then
			local log =  sgs.LogMessage()
			log.type = "#morethanhalf"
			room:sendLog(log)
			return
		end
		room:doLightbox("SE_Geass$", 2000)
		if role == "lord" then
			room:setPlayerProperty(target, "role", sgs.QVariant("loyalist"))
			target:gainMark("@Geass")
		elseif role == "rebel" then
			room:setPlayerProperty(target, "role", sgs.QVariant("rebel"))
			target:gainMark("@Geass")
		elseif role == "renegade" then
			room:setPlayerProperty(target, "role", sgs.QVariant("renegade"))
			target:gainMark("@Geass")
		end
	end,
}

SE_Zhihui = sgs.CreateTriggerSkill{
	name = "SE_Zhihui",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageCaused},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.DamageCaused then
			local victim = damage.to
			if victim and victim:isAlive() then
				if victim:hasSkill("SE_Zhihui") then
					if victim:askForSkillInvoke(self:objectName(), data) then
						room:broadcastSkillInvoke("SE_Zhihui")
						local list = room:getAlivePlayers()
						local use_list = sgs.SPlayerList()
						for _,p in sgs.qlist(list) do
							if p:getMark("@Geass") > 0 then
								use_list:append(p)
							end
						end
						local dest = room:askForPlayerChosen(victim, use_list, "SE_Zhihui")
						room:doLightbox("SE_Zhihui$", 800)
						if dest then
							damage.to = dest
							data:setValue(damage)
						end
					end
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}


Lelouch:addSkill(SE_Geass_start)
Lelouch:addSkill(SE_Geass)
extension:insertRelatedSkills("SE_Geass", "#SE_Geass_start")
Lelouch:addSkill(SE_Zhihui)

sgs.LoadTranslationTable{
["SE_Geass"] = "服从「Geass绝对服从」",
["se_geass"] = "服从「Geass绝对服从」",
["SE_Geass$"] = "image=image/animate/SE_Geass.png",
["SE_GeassCard"] = "服从「Geass绝对服从」",
["$SE_Geass1"] = "鲁鲁修·V·布列塔尼亚在此命令，你们要成为我的奴隶！",
["$SE_Geass2"] = "鲁鲁修·V·布列塔尼亚在此命令，把Damocles的钥匙交给我！",
["@Geass"] = "Geass",
["#morethanhalf"] = "您的阵营并非处于劣势，无法使用Geass。",
[":SE_Geass"] = "<font color=\"yellow\"><b>变态技，</b></font>游戏开始时，你令与你所属阵营相同的角色获得1枚GEASS标记；若你为忠臣，你与主公交换身份牌。出牌阶段，若你所属阵营的人数小于场上一半时，你可以指定一名角色，令其获得1枚GEASS标记并加入你的阵营。每名角色限一次。 ",
["SE_Zhihui"] = "指挥「牺牲棋子」",
["SE_Zhihui$"] = "image=image/animate/SE_Zhihui.png",
["$SE_Zhihui"] = "All Hail Lelouch!",
[":SE_Zhihui"] = "每当一名角色对你造成一次伤害时，你可以将此伤害转移给拥有GEASS标记的一名角色。",
["Lelouch"] = "真·鲁鲁修",
["&Lelouch"] = "真·鲁鲁修",
["@Lelouch"] = "叛逆的鲁鲁修",
["#Lelouch"] = "暗之皇子",
["~Lelouch"] = "这也是对你的惩罚...你要作为正义的使者，一直戴着面具...再也无法以枢木朱雀的身份活下去了...",
["designer:Lelouch"] = "Sword Elucidator",
["cv:Lelouch"] = "福山润",
["illustrator:Lelouch"] = "SUNRISE",
}

----------------------------------------------------------------------------------------------------------

--第四次
--莉法

SE_Zhuzhen = sgs.CreateTriggerSkill{
	name = "SE_Zhuzhen",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.CardsMoveOneTime, sgs.CardUsed},
	on_trigger = function(self, event, player, data)
		if event == sgs.CardsMoveOneTime then
			local move = data:toMoveOneTime()
			local source = move.from
			if source and source:objectName() == player:objectName() then
				local room = player:getRoom()
				if move.to then
					if move.to:objectName() ~= source:objectName() then
						for _,card_id in sgs.qlist(move.card_ids) do
							local card = sgs.Sanguosha:getCard(card_id)
							if card and card:isKindOf("EquipCard") then
								if room:askForSkillInvoke(player, "SE_Zhuzhen_Equip", data) then
									room:broadcastSkillInvoke("SE_Zhuzhen")
									room:doLightbox("SE_Zhuzhen$", 800)
									if player:getPhase() == sgs.Player_NotActive then
										local list = room:getAlivePlayers()
										local to = room:askForPlayerChosen(player, list, "SE_Zhuzhen_Equip_Out")
										to:obtainCard(card)
									else
										local list = room:getOtherPlayers(player)
										local to = room:askForPlayerChosen(player, list, "SE_Zhuzhen_Equip")
										to:obtainCard(card)
									end
								end
							end
						end
					end
				else
					for _,card_id in sgs.qlist(move.card_ids) do
						local card = sgs.Sanguosha:getCard(card_id)
						if card and card:isKindOf("EquipCard") then
							if room:askForSkillInvoke(player, "SE_Zhuzhen_Equip", data) then
								room:broadcastSkillInvoke("SE_Zhuzhen")
								room:doLightbox("SE_Zhuzhen$", 800)
								if player:getPhase() == sgs.Player_NotActive then
									local list = room:getAlivePlayers()
									local to = room:askForPlayerChosen(player, list, "SE_Zhuzhen_Equip_Out")
									to:obtainCard(card)
								else
									local list = room:getOtherPlayers(player)
									local to = room:askForPlayerChosen(player, list, "SE_Zhuzhen_Equip")
									to:obtainCard(card)
								end
							end
						end
					end
				end
			end
		elseif event == sgs.CardUsed then
			if player:getPhase() == sgs.Player_Play then
				use = data:toCardUse()
				local card = use.card
				if card:isNDTrick() then
					local room = player:getRoom()
					if room:askForSkillInvoke(player, "SE_Zhuzhen_Trick") then
						local list = room:getOtherPlayers(player)
						room:broadcastSkillInvoke("SE_Zhuzhen")
						local to = room:askForPlayerChosen(player, list, "SE_Zhuzhen_Trick")
						to:obtainCard(card)
					end
				end
			end
		end
		return false
	end
}

SE_Huifu = sgs.CreateTriggerSkill{
	name = "SE_Huifu",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.EventPhaseEnd and player:getPhase()==sgs.Player_RoundStart then
			if player:hasSkill(self:objectName()) then
				local use = false
				for _,p in sgs.qlist(room:getAlivePlayers()) do
					if p:getHp() > player:getHp() then
						use = true
						break
					end
				end
				if use then
					room:broadcastSkillInvoke("SE_Huifu")
					local over = player:getHp() + 1 >= player:getMaxHp()
					room:setPlayerProperty(player, "hp", sgs.QVariant(player:getHp() + 1))
					if over then
						local card_id = -1
						for _,id in sgs.qlist(room:getDrawPile()) do
							local card = sgs.Sanguosha:getCard(id)
							if card and (card:isKindOf("EquipCard") or card:isKindOf("TrickCard")) then
								card_id = id
								break
							end
						end

						if card_id == -1 then
							player:drawCards(1)
							return
						end
						room:obtainCard(player, card_id)
					end


				end
			end
		end
		return false
	end
}

Leafa:addSkill(SE_Zhuzhen)
Leafa:addSkill(SE_Huifu)

sgs.LoadTranslationTable{
["SE_Zhuzhen"] = "助阵「好妹妹~」",
["SE_Zhuzhen$"] = "image=image/animate/SE_Zhuzhen.png",
["SE_Zhuzhen_Trick"] = "助阵（锦囊牌）",
["SE_Zhuzhen_Equip"] = "助阵（装备牌）",
["SE_Zhuzhen_Equip_Out"] = "助阵（装备牌）",
["$SE_Zhuzhen1"] = "呐，加油啊。为了自己喜欢的人，就这么轻言放弃可不行啊。",
["$SE_Zhuzhen2"] = "飞吧~无论是何处，翱翔于无尽的蓝天。",
["$SE_Zhuzhen3"] = "（桐人）借剑一用~ （莉法）..唉？桐人？",
["$SE_Zhuzhen4"] = "（桐人）后面就拜托了！ （莉法）交给我吧！",
[":SE_Zhuzhen"] = "每当你于回合外失去一张装备牌时，你可以将之交给一名角色；你的回合内，每当你使用一张非延时类锦囊牌或失去一张装备牌后，你可以令一名其他角色获得之。",
["SE_Huifu"] = "回复「索尔斯·无制限自动回复」",
["$SE_Huifu1"] = "（恢复系咒语）",
["$SE_Huifu2"] = "啊，危险...",
[":SE_Huifu"] = "锁定技。回合开始时，若你的当前体力值不为场上最多或之一，你自然增加一点体力。若你因此而体力不少于自己的体力上限，你从牌堆摸一张随机的锦囊牌或装备牌。",
["Leafa"] = "莉法",
["&Leafa"] = "莉法",
["@Leafa"] = "刀剑神域",
["#Leafa"] = "风の剑士",
["~Leafa"] = "以为...终于能好好地看看我了...但是！...如果是这样...还不如一直对我冷漠就好... ",
["designer:Leafa"] = "Sword Elucidator",
["cv:Leafa"] = "竹達彩奈",
["illustrator:Leafa"] = "うえはら",
}

--博丽灵梦



SE_Mengfeng = sgs.CreateTriggerSkill{
	name = "SE_Mengfeng",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if player:getPhase()==sgs.Player_RoundStart then
			if room:askForSkillInvoke(player, self:objectName(), data) then
				room:broadcastSkillInvoke("SE_Mengfeng")
				room:setPlayerFlag(player, "SE_Mengfeng")
				if not player:isSkipped(sgs.Player_Judge) then
					player:skip(sgs.Player_Judge)
				end
				if not player:isSkipped(sgs.Player_Draw) then
					player:skip(sgs.Player_Draw)
				end
				if not player:isSkipped(sgs.Player_Play) then
					player:skip(sgs.Player_Play)
				end
				if not player:isSkipped(sgs.Player_Discard) then
					player:skip(sgs.Player_Discard)
				end
			end
		elseif player:getPhase() == sgs.Player_Finish then
			if player:hasFlag("SE_Mengfeng") then
				--KOF
				if room:getAllPlayers(true):length() == 2 then
					local target = player:getNextAlive()
					room:loseHp(target)
				else
					local list = room:getOtherPlayers(player)
					local target = room:askForPlayerChosen(player, list, self:objectName())
					room:doLightbox("SE_Mengfeng$", 1200)
					local choice = room:askForChoice(player,self:objectName(),"TurnOver_target+LoseHp_target")
					if choice == "TurnOver_target" then
						target:turnOver()
					else
						room:loseHp(target)
					end
					local value = sgs.QVariant()
					value:setValue(target)
					room:setTag("SE_MengfengTarget", value)
				end
			end
		end
	end
}
SE_MengfengGive = sgs.CreateTriggerSkill{
	name = "#SE_MengfengGive",
	frequency = sgs.Skill_Frequent,
	events = {sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local tag = room:getTag("SE_MengfengTarget")
		if tag then
			local target = tag:toPlayer()
			room:removeTag("SE_MengfengTarget")
			if target and target:isAlive() then
				target:gainAnExtraTurn()
				room:setPlayerFlag(target, "SE_Mengfeng_Turn")
			end
		end
	end,
	can_trigger = function(self, target)
		if target then
			return target:getPhase() == sgs.Player_Finish
		end
		return false
	end
}

SE_Nagong = sgs.CreateTriggerSkill{
	name = "SE_Nagong",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if player:getPhase()==sgs.Player_RoundStart then
			local Musessou
			for _,p in sgs.qlist(room:getAlivePlayers()) do
				if p:hasSkill("SE_Nagong") then
					Musessou = p
					break
				end
			end
			if Musessou and Musessou:objectName() ~= player:objectName() then
				--KOF
				if room:getAllPlayers(true):length() == 2 then
					if not player:isNude() then
						local idn = room:askForCardChosen(player,player,"he",self:objectName())
						room:obtainCard(Musessou,idn,false)
						if Musessou:getHp() < 2 and not player:isNude() then
							local idn2 = room:askForCardChosen(player,player,"he",self:objectName())
							room:obtainCard(Musessou,idn2,false)
						end
					end
					return
				end
				if player:isNude() then return end
				if room:askForSkillInvoke(player, self:objectName(), data) then
					room:broadcastSkillInvoke("SE_Nagong")
					local idn = room:askForCardChosen(player,player,"he",self:objectName())
					if idn then
						room:obtainCard(Musessou,idn,false)
						if room:askForSkillInvoke(player, "SE_Nagong_Geiqian_2", data) then
							if player:isNude() then return end
							local idn2 = room:askForCardChosen(player,player,"he",self:objectName())
							if idn2 then
								room:obtainCard(Musessou,idn2,false)
								local re = sgs.RecoverStruct()
								re.who = player
								room:recover(player,re,true)
							end
						end
						if player:hasFlag("SE_Mengfeng_Turn") then
							Musessou:drawCards(1)
						end
					end
				end
			end
		end
	end,
	can_trigger  = function(self, target)
		return target ~= nil
	end
}

Reimu:addSkill(SE_Mengfeng)
Reimu:addSkill(SE_MengfengGive)
extension:insertRelatedSkills("SE_Mengfeng", "#SE_MengfengGive")
Reimu:addSkill(SE_Nagong)

sgs.LoadTranslationTable{
["SE_Mengfeng"] = "梦封「梦想封印」",
["SE_Mengfeng$"] = "image=image/animate/SE_Mengfeng.png",
["TurnOver_target"] = "令该角色翻面。",
["LoseHp_target"] = "令该角色失去一点体力。",
["$SE_Mengfeng1"] = "隐藏于博丽的力量啊，绽放吧！",
["$SE_Mengfeng2"] = "Spell Card 灵符 梦想封印！！",
[":SE_Mengfeng"] = "回合开始时，你可以进入结束阶段并指定一名角色，其于此回合结束后获得一个额外的回合，然后你选择一项：令其武将牌翻面，或令其失去1点体力。",
["SE_Nagong"] = "纳贡「赛钱箱」",
["$SE_Nagong1"] = "还给我赛钱箱！",
["$SE_Nagong2"] = " 魔理沙：呐是那么重要的赛钱箱吗？ 博丽灵梦：魔理沙你是不会懂的。",
["SE_Nagong_Geiqian"] = "纳贡「赛钱箱」",
["SE_Nagong_Geiqian_2"] = "纳贡「赛钱箱」",
[":SE_Nagong"] = "其他角色的回合开始时，其可以交给你至多两张牌。若如此做且交给你的牌数量为2，该角色回复1点体力，若此回合为“梦封”效果获得的额外回合，你摸一张牌。",
["Reimu"] = "博麗霊夢",
["&Reimu"] = "博麗霊夢",
["@Reimu"] = "東方project",
["#Reimu"] = "無節操の巫女",
["~Reimu"] = "唉。。（毫无表情地）魔理沙是对的确实是异变呀我搞错了真对不住啊———— （魔理沙）完全都没放入感情！！",
["designer:Reimu"] = "紅白無節操",
["cv:Reimu"] = "中原麻衣",
["illustrator:Reimu"] = "A-1",
}

--黑猫

SE_Yishi = sgs.CreateTriggerSkill{
	name = "SE_Yishi",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.EventPhaseStart then
			local targets = sgs.SPlayerList()
			if player:getPhase()==sgs.Player_RoundStart then
				local list = room:getAlivePlayers()
				for _,p in sgs.qlist(list) do
					if p:isMale() then
						targets:append(p)
					end
				end
				if targets:isEmpty() then return false end
				if room:askForSkillInvoke(player, self:objectName(), data) then
					local target = room:askForPlayerChosen(player,targets,"SE_Yishi")
					room:broadcastSkillInvoke("SE_Yishi")
					room:doLightbox("SE_Yishi$", 800)
					if target:getHp() - target:getMaxHp() < 3 then
						room:setPlayerProperty(target, "hp", sgs.QVariant(target:getHp() + 1))
					end
					local hp_sub = target:getHp() - player:getHp()
					if hp_sub > 0 then
						if hp_sub < 7 then
							player:drawCards(hp_sub)
						else
							player:drawCards(6)
						end
					end
				else
					player:drawCards(1)
				end
			end
		end
	end
}

se_dushe = sgs.CreateViewAsSkill{
	name = "se_dushe",
	n = 0,
	view_as = function(self, cards)
		return se_dushecard:clone()
	end,
	enabled_at_play = function(self, player)
		return not sgs.Self:hasFlag("se_dushecard")
	end,
}

se_dushecard = sgs.CreateSkillCard{
	name = "se_dushecard",
	target_fixed = true,
	will_throw = true,
	filter = function(self, targets, to_select)
		return #targets == 0 and not to_select:isKongcheng()
	end,
	on_use = function(self, room, source, targets)
		local list = room:getAlivePlayers()
		local targets = sgs.SPlayerList()
		local emptylist = sgs.PlayerList()
		for _,p in sgs.qlist(list) do
			if not p:isKongcheng() and p:objectName() ~= source:objectName() then
				targets:append(p)
			end
		end
		if targets:isEmpty() then return false end
		local target = room:askForPlayerChosen(source, targets, self:objectName())
		--room:broadcastSkillInvoke("se_dushe")
		local success = source:pindian(target, self:objectName(), nil)
		if success then
			if not target:isKongcheng() then
				local card = room:askForCardChosen(source,target,"h",self:objectName())
				room:obtainCard(source, card)
			end
			local choice = room:askForChoice(source,"se_dushecard","se_dushe_Discard+se_dushe_Damage")
			if choice == "se_dushe_Discard" then
				if room:askForCard(source, ".black", "se_dushe_Discard", sgs.QVariant(), self:objectName()) then
					if target:getEquips():length() > 0 then
						local move = sgs.CardsMoveStruct()
						for _, equip in sgs.qlist(target:getEquips()) do
							move.card_ids:append(equip:getEffectiveId())
						end
						move.reason.m_reason = sgs.CardMoveReason_S_REASON_NATURAL_ENTER
						move.to_place = sgs.Player_DiscardPile
						room:moveCardsAtomic(move, true)
					end
				end
			elseif choice == "se_dushe_Damage" then
				if room:askForCard(source, ".red", "se_dushe_Damage", sgs.QVariant(), self:objectName()) then
					local damage = sgs.DamageStruct()
					damage.from = target
					damage.to = target
					room:damage(damage)
				end
			else
			end
		else
			target:drawCards(1)
			room:setPlayerFlag(source,"se_dushecard")
		end
	end,
}

Kuroneko:addSkill(SE_Yishi)
Kuroneko:addSkill(se_dushe)

sgs.LoadTranslationTable{
["SE_Yishi"] = "仪式「命运记录」",
["SE_Yishi$"] = "image=image/animate/SE_Yishi.png",
["$SE_Yishi1"] = "请和我交往吧。",
["$SE_Yishi2"] = "我喜欢你，对君之爱，胜于世间万千，思君之情，亘古至斯，唯有此心，不逊他人，纵使魂消魄散，湮没于这尘世间，若有来生，爱你依旧。",
["$SE_Yishi3"] = "记载着在不久的将来，等待着恋人们的命运之预言书，大概是这种东西。而且还是为了实现我崇高愿望而进行的仪式阶段记录。",
["$SE_Yishi4"] = "和你交往之后，应该做些什么，我通宵在进行着思考与模拟。",
["$SE_Yishi5"] = "那个，前辈说要做的话，也是可以做的哦。",
[":SE_Yishi"] = "回合开始时，你可以选择一项：1.令体力不大于其体力上限+3一名男性角色回复1点体力，若该角色的体力多于你，你摸X张牌（X为你与其体力之差且至多为6）；2.摸一张牌。",
["se_dushe"] = "毒舌「“诅杀你哦！”」",
["se_dushe"] = "毒舌「“诅杀你哦！”」",
["se_dushecard"] = "毒舌「“诅杀你哦！”」",
["se_dushe_Discard"] = "弃置一张黑色手牌，并弃置对方装备区的所有牌。",
["se_dushe_Damage"] = "弃置一张红色手牌，令其受到自身造成的一点伤害",
["$se_dushe1"] = "梅露露，难道就是那个星尘☆小魔女梅露露么？那个小屁孩和脑残和狂热分子和尼特族家里蹲才会看的粪作？",
["$se_dushe2"] = "话说我最讨厌的字应该是从内容上来说异常值得批判的无知的猪吧，貌似你也是它们的伙伴呢，那就快来“噗”一声啊。",
["$se_dushe3"] = "你不会懂的，放弃吧。",
["$se_dushe4"] = "竟然能够到的这个地方，值得嘉奖呢。",
["$se_dushe5"] = "长点自知之明吧笨蛋！为什么我要和你这个...区区人类干那种不知羞耻的事。",
["$se_dushe6"] = "一个人的自我满足？自慰作品？谁管你啊，我只想把我自己想做的，自己真正在做的呈现出来而已。",
["$se_dushe7"] = "明明能和妹妹一起玩色情游戏，却不能和我玩文字游戏么？",
[":se_dushe"] = "出牌阶段，你可以与一名其他角色拼点：若你赢，你获得该角色一张手牌并选择一项：弃置一张黑色手牌并弃置其装备区里的所有牌，或弃置一张红色手牌，令该角色对其造成1点伤害；若你没赢，该角色摸一张牌，你失去“毒舌”直到回合结束。",
["Kuroneko"] = "五更琉璃",
["&Kuroneko"] = "五更琉璃",
["@Kuroneko"] = "我的妹妹不可能这么可爱！",
["#Kuroneko"] = "堕天圣黑猫",
["~Kuroneko"] = "很，很难受啊，不要这样。",
["designer:Kuroneko"] = "黑猫roy",
["cv:Kuroneko"] = "花泽香菜",
["illustrator:Kuroneko"] = "AIC",
}


--黑雪姬
se_xunyucard = sgs.CreateSkillCard{
	name = "se_xunyucard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		if sgs.Self:getMark("@SE_Chaopin_Red") > 0 then
			return to_select:objectName() ~= sgs.Self:objectName()
		end
		return sgs.Self:inMyAttackRange(to_select) and to_select:objectName() ~= sgs.Self:objectName()
	end,
	on_use = function(self, room, source, targets)
		local target
		if #targets == 0 then
			local list = room:getAlivePlayers()
			for _,player in sgs.qlist(list) do
				if player:objectName() ~= source:objectName() then
					target = player
					break
				end
			end
		else
			target = targets[1]
		end
		--room:broadcastSkillInvoke("se_xunyu")
		room:doLightbox("se_xunyu$", 300)
		if source:getMark("@SE_Chaopin_Blue") == 0 then
			room:obtainCard(target, self, false)
		end
		local use = sgs.CardUseStruct()
		local card = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
		local hp = target:getHp()
		card:setSkillName(self:objectName())
		use.from = source
		use.to:append(target)
		use.card = card
		room:useCard(use, false)
		if not target:isNude() and source:getMark("@SE_Chaopin_Blue") == 0 then
			local id = room:askForCardChosen(source, target, "he", "se_xunyu")
			room:obtainCard(source, id, false)
		end
	end
}

se_xunyu_damage = sgs.CreateTriggerSkill{
	name = "#se_xunyu_damage",
	frequency = sgs.Skill_Frequent,
	events = {sgs.Damage},
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local target = damage.to
		local slash = damage.card
		if slash then
			if slash:isKindOf("Slash") and slash:getSkillName() == "se_xunyucard" then
				if target:objectName() ~= player:objectName() then
					if not damage.chain then
						if not damage.transfer then
							local room = player:getRoom()
							if player:getMark("@SE_Chaopin_Red") > 0 then
								if not target:inMyAttackRange(player) then
									room:loseHp(target)
								end
							end
						end
					end
				end
			end
		end
		return false
	end
}



se_xunyu = sgs.CreateViewAsSkill{
	name = "se_xunyu",
	n = 1,
	view_filter = function(self, selected, to_select)
		if sgs.Self:getMark("@SE_Chaopin_Red") > 0 then
			return true
		end
		return #selected == 0 and  not to_select:isEquipped()
	end,
	view_as = function(self, cards)
		if #cards == 1 then
			local card = se_xunyucard:clone()
			card:addSubcard(cards[1])
			return card
		end
		if sgs.Self:getMark("@SE_Chaopin_Red") > 0 then
			if #cards == 0 then
				local card = se_xunyucard:clone()
				return card
			end
		end
	end,
	enabled_at_play = function(self, player)
		if player:getMark("@SE_Chaopin_Blue") > 0 then
			return player:usedTimes("#se_xunyucard") < 3
		end
		return not player:hasUsed("#se_xunyucard")
	end
}

SE_Heiyang = sgs.CreateTriggerSkill{
	name = "SE_Heiyang",
	frequency = sgs.Skill_Wake,
	events = {sgs.TurnStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		player:gainMark("@waked")
		room:loseMaxHp(player)
		player:drawCards(2)
		room:acquireSkill(player, "SE_Chaopin")
		--room:acquireSkill(player, "qingguo")
		room:broadcastSkillInvoke("SE_Heiyang")
		room:doLightbox("SE_Heiyang$", 3000)
		return false
	end,
	can_trigger = function(self, target)
		if target then
			if target:isAlive() and target:hasSkill(self:objectName()) then
				if target:getMark("@waked") == 0 then
					local room = target:getRoom()
					for _,p in sgs.qlist(room:getAlivePlayers()) do
						if p:getMark("@waked") == 1 then
							return true
						end
						if p:getHp() == 1 and p:objectName() ~= target:objectName() then
							return true
						end
					end
				end
			end
		end
		return false
	end
}

SE_Chaopin = sgs.CreateTriggerSkill{
	name = "SE_Chaopin", --必须
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.TurnStart}, --必须
	on_trigger = function(self, event, player, data) --必须
		if player:isAlive() and player:hasSkill(self:objectName()) then
			local room = player:getRoom()
			if player:hasSkill("keji") then
				room:detachSkillFromPlayer(player,"keji")
			end
			if player:getMark("@SE_Chaopin_Red") > 0 then
				player:loseAllMarks("@SE_Chaopin_Red")
			end
			if player:getMark("@SE_Chaopin_Blue") > 0 then
				player:loseAllMarks("@SE_Chaopin_Blue")
			end
			if player:getMark("@SE_Chaopin_Green") > 0 then
				player:loseAllMarks("@SE_Chaopin_Green")
			end
			if room:askForSkillInvoke(player, self:objectName()) then
				local choice = room:askForChoice(player, self:objectName(), "SE_Chaopin_Red+SE_Chaopin_Blue+SE_Chaopin_Green")
				if choice == "SE_Chaopin_Red" then
					room:broadcastSkillInvoke("SE_Chaopin", 1)
					player:gainMark("@SE_Chaopin_Red")
				elseif choice == "SE_Chaopin_Blue" then
					room:broadcastSkillInvoke("SE_Chaopin", 2)
					player:gainMark("@SE_Chaopin_Blue")
				else
					room:broadcastSkillInvoke("SE_Chaopin", 3)
					player:gainMark("@SE_Chaopin_Green")
					room:acquireSkill(player, "keji")
				end
			end
		end
	end,
}

Kuroyukihime:addSkill(se_xunyu)
Kuroyukihime:addSkill(SE_Heiyang)
Kuroyukihime:addSkill(se_xunyu_damage)
extension:insertRelatedSkills("se_xunyu", "#se_xunyu_damage")
extension:addToSkills(SE_Chaopin)
Kuroyukihime:addWakeTypeSkillForAudio("SE_Chaopin")

sgs.LoadTranslationTable{
["se_xunyu$"] = "image=image/animate/se_xunyu.png",
["SE_Heiyang$"] = "image=image/animate/SE_Heiyang.png",
["SE_Chaopin_Red"] = "红，你发动“黑扬”时，无范围限制，且无需交给对方手牌，当你造成伤害的目标攻击范围内没有你时，该角色流失一点体力。",
["SE_Chaopin_Blue"] = "蓝，你发动“黑扬”时，交给对方一张手牌改为弃置一张手牌，且发动次数最多为3。",
["SE_Chaopin_Green"] = "绿，你获得“克己”",
["@SE_Chaopin_Red"] = "Overdrive-红",
["@SE_Chaopin_Blue"] = "Overdrive-蓝",
["@SE_Chaopin_Green"] = "Overdrive-绿",
["se_xunyu"] = "迅羽",
["se_xunyu"] = "迅羽",
["se_xunyucard"] = "迅羽",
["#se_xunyu_damage"] = "迅羽",
["$se_xunyu"] = "Death By Embracing",
[":se_xunyu"] = "出牌阶段限一次，你可以将一张手牌交给你攻击范围内的一名其他角色，视为对其使用一张【杀】（此【杀】不计入出牌阶段使用限制），此【杀】结算后，若你没有“蓝”标记，你获得目标角色一张牌。",
["SE_Heiyang"] = "黑扬「黑扬之羽蝶」",
["$SE_Heiyang"] = "此刻，我就让你一睹我的真正姿态。",
[":SE_Heiyang"] = "觉醒技。回合开始前，若场上有已觉醒的其他角色或有当前体力值为1的其他角色，你须减1点体力上限并摸两张牌，获得“超频”。",
["SE_Chaopin"] = "超频「Overdrive」",
["$SE_Chaopin1"] = "想加速的更快吗，少年？",
["$SE_Chaopin2"] = "Death By Piercing",
["$SE_Chaopin3"] = "Overdrive ModeGreen",
[":SE_Chaopin"] = "回合开始前，你可以选择一项：1.弃置1枚“绿”标记或“蓝”并获得1枚“红”标记；2.弃置1枚“红”标记或“蓝”标记并获得1枚“绿”标记；3.弃置1枚“红”标记或“绿”标记并获得1枚“蓝”标记。若你拥有“红”标记，你使用“迅羽”时攻击范围无限且可以不交给目标角色手牌，若该角色的攻击范围内没有你，其失去1点体力；若你拥有“蓝”标记，将“迅羽”的“将一张手牌交给你攻击范围内的一名其他角色”改为“弃置你攻击范围内一名其他角色的一张手牌”，“出牌阶段限一次”改为“出牌阶段限X次（X为场上存活角色数）”；若你拥有“绿”标记，你获得“克己”。",
["Kuroyukihime"] = "黒雪姫",
["&Kuroyukihime"] = "黒雪姫",
["@Kuroyukihime"] = "加速世界",
["#Kuroyukihime"] = "黑之睡莲",
["~Kuroyukihime"] = "总有一天，我们肯定能再次相会。",
["designer:Kuroyukihime"] = "昂翼天使",
["cv:Kuroyukihime"] = "三澤紗千香",
["illustrator:Kuroyukihime"] = "SUNRISE",
}



--永瀬伊織

SE_Qifen = sgs.CreateTriggerSkill{
	name = "SE_Qifen",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		if player:getPhase() == sgs.Player_Finish then
			if player:hasSkill(self:objectName()) then
				local room = player:getRoom()
				if room:askForSkillInvoke(player, self:objectName()) then
					for _,p in sgs.qlist(room:getAlivePlayers()) do
						p:drawCards(1)
					end
					room:broadcastSkillInvoke("SE_Qifen")
					room:doLightbox("SE_Qifen$", 800)
					local lost_hp = player:getMaxHp() - player:getHp()
					if lost_hp > 0 then
						for _,p in sgs.qlist(room:getOtherPlayers(player)) do
							if not p:isNude() then
								local card = room:askForCardChosen(player, p, "he", self:objectName())
								if card then
									room:obtainCard(player,card)
								end
							end
						end
						--KOF
						if room:getAllPlayers(true):length() == 2 and player:getHp() <= 1 then
							for _,p in sgs.qlist(room:getOtherPlayers(player)) do
								if not p:isNude() then
									local card = room:askForCardChosen(player, p, "he", self:objectName())
									if card then
										room:obtainCard(player,card)
									end
								end
							end
						end
					end
				end
			end
		end
	end,
	can_trigger = function(self, target)
		return target
	end
}

SE_Mishi = sgs.CreateTriggerSkill{
	name = "SE_Mishi",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Dying},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local dying_data = data:toDying()
		local source = dying_data.who
		local mygod= room:findPlayerBySkillName("SE_Mishi")
		if mygod then
			if mygod:isAlive() and source and not mygod:hasFlag("SE_Mishi_used") then
				local list = room:getAlivePlayers()
				local targets = sgs.SPlayerList()
				if room:askForSkillInvoke(mygod, "SE_Mishi", data) then
					room:broadcastSkillInvoke("SE_Mishi")
					room:setPlayerFlag(mygod,"SE_Mishi_used")
					local cardsid = sgs.IntList()
					local cards = mygod:getHandcards()
					if cards then
						for _,acard in sgs.qlist(cards) do
							cardsid:append(acard:getEffectiveId())
						end
					end
					if cardsid then
						room:fillAG(cardsid)
						room:getThread():delay(2000)
						for _,p in sgs.qlist(list) do
							room:clearAG(p)
						end
					end
					room:doLightbox("SE_Mishi$", 800)
					room:loseHp(mygod)
					room:loseHp(source)
					if source:isAlive() then
						if not source:isNude() then
							local card = room:askForCardChosen(mygod, source, "he", self:objectName())
							if card then
								room:obtainCard(mygod,card)
							end
						end
					end
				end
			end
		end
	end
}

SE_Zhufu = sgs.CreateTriggerSkill{
	name = "SE_Zhufu",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if player:getPhase()==sgs.Player_Draw then
			if player:hasSkill(self:objectName()) then
				if room:askForSkillInvoke(player, self:objectName(), data) then
					local target = room:askForPlayerChosen(player,  room:getOtherPlayers(player), self:objectName())
					local card_num = player:getHandcardNum() - target:getHandcardNum()
					if card_num > 7 then card_num = 7 end
					if card_num > 0 then
						room:broadcastSkillInvoke("SE_Zhufu")
						target:drawCards(card_num)
					end
				end
			end
		end
	end
}


Nagase:addSkill(SE_Qifen)
Nagase:addSkill(SE_Mishi)
Nagase:addSkill(SE_Zhufu)

sgs.LoadTranslationTable{
["SE_Mishi$"] = "image=image/animate/SE_Mishi.png",
["SE_Qifen$"] = "image=image/animate/SE_Qifen.png",
["SE_Qifen"] = "气氛「察言观色」",
["$SE_Qifen1"] = "一眼120元~ （太一）还收费么...不过还是很有良心的定价呢...",
["$SE_Qifen2"] = "那么稻叶儿~这次来点色情吧！",
["$SE_Qifen3"] = "是啊是啊，太一希望我和稻叶儿，谁脱？",
["$SE_Qifen4"] = "15:50，八重樫太一，要求两名女社员脱掉衣服。",
["$SE_Qifen5"] = "最喜欢了~哥哥。（太一）哥..哥哥？  我觉得太一应该喜欢我叫你哥哥。",
["$SE_Qifen6"] = "...喜欢是喜欢，为什么你会知道...  女人的直觉~  真可怕...这是永濑迎合对方喜好而变换角色时的本领吗？...",
[":SE_Qifen"] = "结束阶段开始时，你可以令所有角色各摸一张牌，若你已受伤，你分别从每名角色处获得1张牌。",
["SE_Mishi"] = "迷失「低沉黑化」",
["$SE_Mishi1"] = "不要把你的价值观强加给我。",
["$SE_Mishi2"] = "大家都不明白...够了...受够了...",
["$SE_Mishi3"] = "饶不了...绝对！牵连我之外的人，不管怎么道歉也不原谅！",
["$SE_Mishi4"] = "要让他们哭天...还是喊地好呢...要让你们怎么偿还呢！...",
[":SE_Mishi"] = "每当一名角色进入濒死状态时，你可以展示你的所有手牌，然后令你与其各失去1点体力。若如此做且该角色于濒死状态被救回，你获得其一张牌。每阶段限一次。",
["SE_Zhufu"] = "祝福「最重要的伙伴们」",
["$SE_Zhufu1"] = "不对...这样说很奇怪。我永远都想做稻叶儿的朋友。拜托了，让我做你的朋友吧！",
["$SE_Zhufu2"] = "能和你恋爱过真是太好了。",
["$SE_Zhufu3"] = "全力全心，今天也努力去享受生活吧！",
[":SE_Zhufu"] = "摸牌阶段开始时，你可以令一名其他角色将手牌补至X张（X为你的手牌数且至多为7）。",
["Nagase"] = "永瀬伊織",
["&Nagase"] = "永瀬伊織",
["@Nagase"] = "恋爱随意链接",
["#Nagase"] = "真正的自己",
["~Nagase"] = "啊..永瀬！！",
["designer:Nagase"] = "Sword Elucidator",
["cv:Nagase"] = "豊崎爱生",
["illustrator:Nagase"] = "れい",
}


--風早翔太
SE_Xiuse = sgs.CreateTriggerSkill{
	name = "SE_Xiuse",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageComplete},
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local room = player:getRoom()
			if event == sgs.DamageComplete then
				if player:hasSkill(self:objectName()) and player:isAlive() then
					if room:askForSkillInvoke(player, self:objectName(), data) then
						local list = room:getAlivePlayers()
						local targets = sgs.SPlayerList()
						for _,p in sgs.qlist(list) do
							if not p:isMale() then
								targets:append(p)
							end
						end
						local target = room:askForPlayerChosen(player,  targets, self:objectName())
						if target then
							room:broadcastSkillInvoke("SE_Xiuse")
							target:turnOver()
							target:drawCards(player:getHp())
						end
					end
				end
			end
		return false
	end,
	can_trigger = function(self, target)
		return target
	end
}

SE_Shuanglang_target = sgs.CreateTriggerSkill{
	name = "#SE_Shuanglang_target", --必须
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.TurnStart, sgs.DamageInflicted}, --必须
	on_trigger = function(self, event, player, data) --必须
		if event == sgs.TurnStart then
			if player:isAlive() and not player:faceUp() then
				local room = player:getRoom()
				local Godsan=room:findPlayerBySkillName("SE_Shuanglang")
				if Godsan then
					if room:askForSkillInvoke(Godsan, "SE_Shuanglang_start", data) then
						room:broadcastSkillInvoke("SE_Shuanglang")
						room:doLightbox("SE_Shuanglang$", 800)
						player:turnOver()
						player:drawCards(1)
					end
				end
			end
		elseif event == sgs.DamageInflicted then
			if player:isAlive() and not player:faceUp() and player:hasSkill(self:objectName()) then
				local room = player:getRoom()
				local Godsan=room:findPlayerBySkillName("SE_Shuanglang")
				if Godsan then
					if room:askForSkillInvoke(Godsan, "SE_Shuanglang", data) then
						room:broadcastSkillInvoke("SE_Shuanglang")
						room:doLightbox("SE_Shuanglang$", 800)
						player:turnOver()
						player:drawCards(1)
						Godsan:drawCards(1)
					end
				end
			end
		end
	end
}

SE_Shuanglang = sgs.CreateTriggerSkill{
	name = "SE_Shuanglang",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		for _,p in sgs.qlist(room:getAlivePlayers()) do
			room:acquireSkill(p, "#SE_Shuanglang_target", false)
		end
	end
}

SE_Lianmu = sgs.CreateTriggerSkill{
	name = "SE_Lianmu",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		if player:getPhase() == sgs.Player_Finish then
			if player:hasSkill(self:objectName()) then
				local room = player:getRoom()
				--KOF
				if room:getAllPlayers(true):length() == 2 then
					player:turnOver()
					player:drawCards(1)
					return
				end
				if room:askForSkillInvoke(player, self:objectName()) then
					player:turnOver()
					local list = room:getAlivePlayers()
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(list) do
						if not p:isMale() then
							targets:append(p)
						end
					end
					local target = room:askForPlayerChosen(player,  targets, self:objectName())
					if target then
						room:broadcastSkillInvoke("SE_Lianmu")
						if target:getHp() >= target:getMaxHp() then
							target:drawCards(2)
						else
							local re = sgs.RecoverStruct()
							re.who = target
							room:recover(target,re,true)
						end
					end
				else
					player:drawCards(1)
				end
			end
		end
	end,
	can_trigger = function(self, target)
		return target
	end
}
Kazehaya:addSkill(SE_Xiuse)
Kazehaya:addSkill(SE_Shuanglang)
Kazehaya:addSkill(SE_Lianmu)
extension:addToSkills(SE_Shuanglang_target)
extension:insertRelatedSkills("SE_Shuanglang", "#SE_Shuanglang_target")

sgs.LoadTranslationTable{
["SE_Shuanglang$"] = "image=image/animate/SE_Shuanglang.png",

["SE_Xiuse"] = "羞涩「必杀の羞涩」",
["$SE_Xiuse1"] = "啊，不好意思，你刚才说什么？",
["$SE_Xiuse2"] = "不要再看这边了，我现在超脸红的。",
["$SE_Xiuse3"] = "虫子，是虫子啦。",
[":SE_Xiuse"] = "每当你受到的伤害结算结束时，你可以令一名异性角色将武将牌翻面并摸X张牌（X为你的当前体力值）。",
["SE_Shuanglang_start"] = "爽朗（回合开始时）",
["SE_Shuanglang"] = "爽朗「爽朗的微笑驱散雾霭」",
["$SE_Shuanglang1"] = "既然不讨厌我，为什么要躲着我？",
["$SE_Shuanglang2"] = "嗯，我明白的，绝对不会告诉别人的，真的（笑）。",
[":SE_Shuanglang"] = "每当武将牌背面朝上的一名角色的回合开始前，你可以令其将武将牌翻面并摸一张牌；每当武将牌背面朝上的一名角色受到一次伤害时，你可以令其将武将牌翻面并摸一张牌，然后你摸一张牌。",
["SE_Lianmu"] = "恋慕「爱してる」",
["$SE_Lianmu1"] = "我说啊，只是顺便问问，交往什么的，你怎么想？",
["$SE_Lianmu2"] = "大概，我自己也没有考虑过交往的事情吧...背景音（爽子）：我，我懂得太少，根本没办法回答...",
["$SE_Lianmu3"] = "我，不想放弃，我，喜欢她。",
["$SE_Lianmu4"] = "所以，刚刚那个表情可以留给我吗？让我独占...",
[":SE_Lianmu"] = "锁定技。结束阶段结束时，你选择一项：1.将武将牌翻面，然后令已受伤的一名异性角色回复1点体力；2.将武将牌翻面，然后令未受伤的一名异性角色摸两张牌；3.摸一张牌。",
["Kazehaya"] = "風早翔太",
["&Kazehaya"] = "風早翔太",
["@Kazehaya"] = "好想告诉你",
["#Kazehaya"] = "爽朗君",
["~Kazehaya"] = "让你哭泣了，对不起；总是让你为难，对不起；只顾着把自己心里想说的说了，对不起...",
["designer:Kazehaya"] = "黄金堂下卧麒麟; 黑猫roy",
["cv:Kazehaya"] = "浪川大輔",
["illustrator:Kazehaya"] = "Production I.G",
}

--新垣あやせ
SE_Feiti = sgs.CreateTriggerSkill{
	name = "SE_Feiti",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		if player:getPhase() == sgs.Player_Finish then
			if player:hasSkill(self:objectName()) then
				local room = player:getRoom()
				if room:askForSkillInvoke(player, self:objectName()) then
					local list = sgs.SPlayerList()
					for _,p in sgs.qlist(room:getAlivePlayers()) do
						if p:isMale() then
							list:append(p)
						end
					end
					if list:length() == 0 then return end
					local Kyousuke = room:askForPlayerChosen(player, list, "SE_Feiti")
					room:setPlayerFlag(Kyousuke,"SE_Feiti_Target")
					local j = sgs.JudgeStruct()
					j.play_animation=true
					j.good = true
					j.pattern = "."
					j.who = Kyousuke
					room:judge(j)
					local num =j.card:getNumber()
					local getCard = false
					local choice = room:askForChoice(player,"SE_Feiti","SE_Feiti_Get+SE_Feiti_Not_Get")
					if choice == "SE_Feiti_Get" then
						room:setPlayerFlag(Kyousuke,"SE_Feiti_Good")
						getCard = true
					end
					room:broadcastSkillInvoke("SE_Feiti")
					for i=1, num do
						Kyousuke:turnOver()
						room:getThread():delay(250)
						if getCard then
							Kyousuke:drawCards(1)
						end
					end
					if Kyousuke:faceUp() then
						local damage = sgs.DamageStruct()
						damage.to = Kyousuke
						damage.from = player
						room:damage(damage)
					else
						Kyousuke:drawCards(1)
					end
				end
			end
		end
	end,
	can_trigger = function(self, target)
		return target
	end
}

SE_Menghei = sgs.CreateTriggerSkill{
	name = "SE_Menghei",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Damaged},
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local room = player:getRoom()
			if event == sgs.Damaged then
				local source = damage.to
				if source then
					if source:isAlive() then
						if source:hasSkill(self:objectName()) then
							if room:askForSkillInvoke(source, self:objectName(), data) then
								local list = sgs.SPlayerList()
								local danteng = damage.from
								for _,p in sgs.qlist(room:getAlivePlayers()) do
									if danteng:distanceTo(p) <= 1 then
										list:append(p)
									end
								end
								room:broadcastSkillInvoke("SE_Menghei")
								local The_vic = room:askForPlayerChosen(source, list, "SE_Menghei")
								room:loseHp(The_vic)
								--KOF
								if room:getAllPlayers(true):length() == 2 then
									if not source:getNextAlive():isMale() then
										source:drawCards(1)
									end
								end
							end
						end
					end
				end
			end
		return false
	end,
	can_trigger = function(self, target)
		return true
	end
}

se_gaobai=sgs.CreateViewAsSkill{
	name="se_gaobai",
	n = 0,
	view_as = function(self, cards)
		return se_gaobaicard:clone()
	end,
	enabled_at_play = function(self, player)
		return player:getMark("@Gaobai") > 0
	end,
}

se_gaobaicard = sgs.CreateSkillCard{
	name = "se_gaobaicard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		return #targets == 0 and to_select:isMale()
	end,
	on_use = function(self, room, source, targets)
		local dest = targets[1]
		local count = source:getMark("@Gaobai")
		if count == 0 then
			return
		else
			source:loseAllMarks("@Gaobai")
		end
		room:doLightbox("se_gaobai$", 3000)
		--room:broadcastSkillInvoke("se_gaobai")
		--
		if dest:isAlive() then
			room:setPlayerProperty(dest, "maxhp", sgs.QVariant(4))
			room:setPlayerProperty(dest, "hp", sgs.QVariant(4))
		end
	end
}

se_gaobaiMark = sgs.CreateTriggerSkill{
	name = "#se_gaobaiMark",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
		if event == sgs.GameStart then
			player:loseAllMarks("@Gaobai")
			player:gainMark("@Gaobai", 1)
		end
	end
}

Ayase:addSkill(SE_Feiti)
Ayase:addSkill(SE_Menghei)
Ayase:addSkill(se_gaobai)
Ayase:addSkill(se_gaobaiMark)
extension:insertRelatedSkills("se_gaobai", "#se_gaobaiMark")

sgs.LoadTranslationTable{
["SE_Feiti"] = "飞踢「旋风飞踢」",
["se_feiti"] = "飞踢「旋风飞踢」",
["SE_Feiti_Get"] = "令其摸牌。",
["SE_Feiti_Not_Get"] = "不令其摸牌。",
["$SE_Feiti1"] = "哥哥，我听说了哦！连你都沉迷进去可怎么办啊！",
["$SE_Feiti2"] = "绫濑！和我结婚吧！（...）",
["$SE_Feiti3"] = "别误会了~我只会性骚扰你~（...）",
["$SE_Feiti4"] = "这个月的我买了哦~看吧看吧~Lovely my angel 绫濑碳~ （...）",
["$SE_Feiti5"] = "",
[":SE_Feiti"] = "结束阶段开始时，你可以令一名男性角色进行一次判定，你令该角色将武将牌翻面X次，然后你可以令其摸X张牌（X为判定结果的点数），若该角色的武将牌正面朝上，你对其造成1点伤害；若该角色的武将牌背面朝上，其摸一张牌。",
["SE_Menghei"] = "萌黑「菜刀乱挥」",
["$SE_Menghei1"] = "那么，桐乃，现在开始我们两个一起，去杀了那个碍事的哥哥吧~",
["$SE_Menghei2"] = "哇啊啊...会被杀掉的！！  才不会杀你啦~",
["$SE_Menghei3"] = "！..我只是单纯提出问题而已，不..不要说些奇怪的话！  喂！这很可怕啊喂！",
["$SE_Menghei4"] = "哥哥，你竟然在我洗澡的时候对这么小的女孩出手！",
[":SE_Menghei"] = "每当你受到其他角色造成的一次伤害后，你可以令该角色距离1以内的一名角色失去1点体力。",
["se_gaobai"] = "告白",
["se_gaobai"] = "告白",
["@Gaobai"] = "告白",
["se_gaobai$"] = "image=image/animate/se_gaobai.png",
["$se_gaobai"] = "哥哥你真是个不得了的大骗子！是色狼，变态，妹控，萝莉控，而且还是抖M！每次见到我都对我性骚扰，还惹我生气！但无论什么时候都老好人的，又爱管闲事！...迟钝又不讲理，却很温柔...总是...总是欺骗我...但是我喜欢...那样的你...",
[":se_gaobai"] = "限定技。出牌阶段，你可以令一名男性角色的体力上限增加或减少至4，然后令其将体力补至体力上限。",
["Ayase"] = "新垣绫濑",
["&Ayase"] = "新垣绫濑",
["@Ayase"] = "我的妹妹不可能这么可爱！",
["#Ayase"] = "黑化天使",
["~Ayase"] = "再见了哥哥...我最..讨厌你了~",
["designer:Ayase"] = "Sword Elucidator",
["cv:Ayase"] = "早見沙織",
["illustrator:Ayase"] = "スカイ",
}


--あかりん
SE_Touming = sgs.CreateTriggerSkill{
	name = "SE_Touming",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		if player:getPhase() == sgs.Player_Discard then
			if player:hasSkill(self:objectName()) then
				local room = player:getRoom()
				local num = player:getHandcardNum()
				player:setMark("SE_Touming_num",num)
			end
		elseif player:getPhase() == sgs.Player_Finish then
			if player:hasSkill(self:objectName()) then
				local room = player:getRoom()
				local num = player:getHandcardNum()
				if player:getMark("SE_Touming_num") == num then
					if room:askForSkillInvoke(player, self:objectName(), data) then
						room:broadcastSkillInvoke("SE_Touming")
						room:doLightbox("SE_Touming$", 1500)
						player:turnOver()
						player:drawCards(room:getAlivePlayers():length())
					end
				end
			end
		end
	end,
	can_trigger = function(self, target)
		return target
	end
}

--[[SE_ToumingAF=sgs.CreateProhibitSkill{
	name = "#SE_ToumingAF",
	is_prohibited=function(self,from,to,card)
		if to and to:hasSkill(self:objectName()) then
			if card and (card:isKindOf("AmazingGrace") or card:isKindOf("GodSalvation") or card:isKindOf("Peach") or card:isKindOf("Analeptic")) then return end
			if from and from:objectName() == to:objectName() then return false end
			if not to:faceUp() then
				return true
			end
		end
	end
}]]


SE_ToumingNT = sgs.CreateTriggerSkill{
	name = "#SE_ToumingNT",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DamageDone,sgs.PreHpLost},
	on_trigger = function(self,event,player,data)
		local room = player:getRoom()
		if player:hasSkill(self:objectName()) then
			if not player:faceUp() then
				room:broadcastSkillInvoke("SE_ToumingNT")
				player:drawCards(1)
				return true
			end
		end
	end,
	priority = 8
}

SE_Tuanzi = sgs.CreateTriggerSkill{
	name = "SE_Tuanzi",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.CardUsed},
	on_trigger = function(self, event, player, data)
		if event == sgs.CardUsed then
			if player:getPhase() == sgs.Player_Play then
				local use = data:toCardUse()
				local card = use.card
				if (card:isKindOf("TrickCard") and card:isBlack()) or card:isKindOf("BasicCard") then
					local room = player:getRoom()
					if room:askForSkillInvoke(player, "SE_Tuanzi", data) then
						room:broadcastSkillInvoke("SE_Tuanzi")
						local move = sgs.CardsMoveStruct()
						move.card_ids:append(card:getEffectiveId())
						move.to_place = sgs.Player_DrawPile
						move.reason.m_reason=sgs.CardMoveReason_S_REASON_PUT
						room:moveCardsAtomic(move,true)
					end
				end
			end
		end
		return false
	end
}



--Akarin:addSkill(SE_Touming)
--Akarin:addSkill(SE_ToumingAF)
--Akarin:addSkill(SE_ToumingNT)
--Akarin:addSkill(SE_Tuanzi)

--比企谷八幡
SE_Zishang = sgs.CreateTriggerSkill{
	name = "SE_Zishang",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageCaused},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.DamageCaused then
			local victim = damage.to
			if (not victim:hasSkill("SE_Zishang")) and victim:isAlive() then
				local list = room:getAlivePlayers()
				for _,p in sgs.qlist(list) do
					if p:hasSkill("SE_Zishang") then
						if p:askForSkillInvoke(self:objectName(), data) then
							--KOF
							if room:getAllPlayers(true):length() == 2 then
								local da = sgs.DamageStruct()
								da.from = p
								da.to = p
								room:damage(da)
								if not victim:isNude() then
									local cardid = room:askForCardChosen(victim, victim, "he", self:objectName())
									room:obtainCard(p, cardid)
								end
								victim:turnOver()
								return false
							end
							room:broadcastSkillInvoke("SE_Zishang")
							room:doLightbox("SE_Zishang$", 1000)
							damage.to = p
							data:setValue(damage)
							damage.from:drawCards(1)
							damage.from:turnOver()
						end
					end
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}

SE_Zibi = sgs.CreateTriggerSkill{
	name = "SE_Zibi",
	frequency = sgs.Skill_Frequent,
	events = {sgs.CardUsed,sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		if event == sgs.CardUsed then
			if player:getPhase() == sgs.Player_Play then
				local use = data:toCardUse()
				for _,p in sgs.qlist(use.to) do
					if p:objectName() ~= player:objectName() then
						player:gainMark("@Zibi_not")
					end
				end
			end
		elseif event == sgs.EventPhaseEnd then
			if player:getPhase() == sgs.Player_Finish then
				if player:getMark("@Zibi_not") == 0 then
					local room = player:getRoom()
					if room:askForSkillInvoke(player,"SE_Zibi") then
						room:broadcastSkillInvoke("SE_Zibi")
						local choice = room:askForChoice(player,self:objectName(),"SE_Zibi_R+SE_Zibi_D")
						if choice == "SE_Zibi_R" then
							local re = sgs.RecoverStruct()
							re.who = player
							room:recover(player, re, true)
						else
							player:drawCards(2)
						end
					end
				else
					player:loseAllMarks("@Zibi_not")
				end
			end
		end
		return false
	end
}

Hikigaya:addSkill(SE_Zishang)
Hikigaya:addSkill(SE_Zibi)

sgs.LoadTranslationTable{
["SE_Zishang"] = "自伤",
["SE_Zishang$"] = "image=image/animate/SE_Zishang.png",
["$SE_Zishang1"] = "喂，我可是超像大人的吧，发着牢骚，撒着肮脏的谎言，还做着卑鄙的勾当哦。",
["$SE_Zishang2"] = "好用的家伙就被组织不停的利用，用到倒下为止才是这个世间的常态。",
["$SE_Zishang3"] = "做不好的家伙再勉强也没有意义，还是把专业的叫来比较好。",
["$SE_Zishang4"] = "[叶山]为什么，只用哪种方法啊...（关门声）",
["$SE_Zishang5"] = "[平塚]比企谷，帮助别人并不能成为伤害自己的理由啊...",
["$SE_Zishang6"] = "女生是一种只会对帅哥产生兴趣，并妄图与其发展为不好纯洁男女关系的种族，换句话说，就是我的敌人！（回忆音：做朋友不就好了么？）",
["$SE_Zishang7"] = "改变也是一种逃避吧，为什么不能肯定现在的自己和过去的自己呢？",
["$SE_Zishang8"] = "既然雪之下贯彻了她自己的方法，那么我也要用自己的方法，堂堂正正，直截了当的，用卑鄙差劲又阴暗的做法。",
["$SE_Zishang9"] = "一样的，我们都是最底层世界的居民。",
[":SE_Zishang"] = "当场上一名其他角色即将受到伤害时，你可以选择由自己承担此伤害，然后令伤害来源的角色牌摸1张牌并翻面。 ",
["SE_Zibi"] = "自闭",
["@Zibi_not"] = "大老师",
["SE_Zibi_R"] = "恢复一点体力。",
["SE_Zibi_D"] = "摸两张牌。",
["$SE_Zibi1"] = "这世上有许多即使去了也没用的事...",
["$SE_Zibi2"] = "如果说到重在参与的话，参加到[不参加]这一势力也一定有着其特殊的意义。",
["$SE_Zibi3"] = "这才是我常年自闭生活培养出来的能力--自闭男迷彩！",
["$SE_Zibi4"] = "享受青春的蠢货现充们，爆炸吧！",
["$SE_Zibi5"] = "呐，雪之下......和我...[雪乃]抱歉，那不可能。",
["$SE_Zibi6"] = "错的不是我，是社会！",
[":SE_Zibi"] = "若你的出牌阶段没有指定其他角色为目标，则回合结束后你回复一点体力或摸取两张牌。",
["Hikigaya"] = "比企谷八幡",
["&Hikigaya"] = "比企谷八幡",
["@Hikigaya"] = "果然我的青春恋爱喜剧搞错了",
["#Hikigaya"] = "现充爆裂使",
["~Hikigaya"] = "即使如此...我，我...我！...我想要真实。（俺は本物がほしい）",
["designer:Hikigaya"] = "黑猫roy",
["cv:Hikigaya"] = "江口拓也",
["illustrator:Hikigaya"] = "Brain's Base",
}

--仓嶋千百合

se_huanyuan_Pre = sgs.CreateTriggerSkill{
	name = "#se_huanyuan_Pre",
	frequency = sgs.Skill_Frequent,
	events = {sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		if event == sgs.EventPhaseEnd then
			if player:getPhase() == sgs.Player_Finish then
				local room = player:getRoom()
				for _,p in sgs.qlist(room:getAlivePlayers()) do
					p:setMark("se_huanyuan_Pre_Hp",p:getHp())
					p:setMark("se_huanyuan_Pre_MaxHp",p:getMaxHp())
					p:setMark("se_huanyuan_Pre_Handcards",p:getHandcardNum())
				end
			end
		end
		return false
	end
}


se_huanyuan = sgs.CreateViewAsSkill{
	name = "se_huanyuan",
	n = 1,
	view_filter = function(self, selected, to_select)
		return #selected < 1 and not to_select:isEquipped()
	end,
	view_as = function(self,cards)
		if #cards == 1 then
			local card = se_huanyuancard:clone()
			card:setSkillName(self:objectName())
			card:addSubcard(cards[1])
			return card
		end
	end,
	enabled_at_play = function(self, player)
		return not player:hasFlag("se_huanyuan_used") and not player:isKongcheng() and player:getMark("se_huanyuan_Pre_MaxHp") > 0
	end,
}

se_huanyuancard = sgs.CreateSkillCard{
	name="se_huanyuancard",
	will_throw = true,
	filter = function(self, selected, to_select)
		return #selected < 1
	end,
	on_use = function(self,room,source,targets)
		local choice = room:askForChoice(source, self:objectName(), "se_huanyuan_Draw+se_huanyuan_Hp")
		--room:broadcastSkillInvoke("se_huanyuan")
		room:doLightbox("se_huanyuan$", 1000)
		room:setEmotion(targets[1], "skills/huanyuan")
		if choice == "se_huanyuan_Draw" then
			local card_num = targets[1]:getMark("se_huanyuan_Pre_Handcards")
			if card_num - targets[1]:getHandcardNum() > 0 then
				targets[1]:drawCards(card_num - targets[1]:getHandcardNum())
			end
		else
			local Maxhp = targets[1]:getMark("se_huanyuan_Pre_MaxHp")
			local hp = targets[1]:getMark("se_huanyuan_Pre_Hp")
			room:setPlayerProperty(targets[1], "maxhp", sgs.QVariant(Maxhp))
			room:setPlayerProperty(targets[1], "hp", sgs.QVariant(hp))
		end
		room:setPlayerFlag(source,"se_huanyuan_used")
	end
}

se_chengling=sgs.CreateViewAsSkill{
	name="se_chengling",
	n = 0,
	limit_mark = "@LimeBell",
	view_as = function(self, cards)
		return se_chenglingcard:clone()
	end,
	enabled_at_play = function(self, player)
		return player:getMark("@LimeBell") > 0
	end,
}

se_chenglingcard = sgs.CreateSkillCard{
	name = "se_chenglingcard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		return #targets < 2 and to_select:objectName() ~= sgs.Self:objectName()
	end,
	feasible = function(self, targets)
		return #targets > 0
	end,
	on_use = function(self, room, source, targets)
		source:loseMark("@LimeBell")
		--room:broadcastSkillInvoke("se_chengling")
		--KOF
		if room:getAllPlayers(true):length() == 2 then
			room:doLightbox("se_chengling$", 1500)
			targets[1]:throwAllMarks(true)
			targets[1]:clearPrivatePiles()
			return
		end
		room:doLightbox("se_chengling$", 3000)
		local general = targets[1]:getGeneralName()
		room:changeHero(targets[1], general, true, true, false, false)
		room:setPlayerProperty(targets[1], "hp", sgs.QVariant(targets[1]:getMaxHp()))
		if targets[1]:getMark("@waked") > 0 then
			targets[1]:loseAllMarks("@waked")
		end
		if #targets == 2 then
			local general2 = targets[2]:getGeneralName()
			room:changeHero(targets[2], general2, true, true, false, false)
			room:setPlayerProperty(targets[2], "hp", sgs.QVariant(targets[2]:getMaxHp()))
			if targets[2]:getMark("@waked") > 0 then
				targets[2]:loseAllMarks("@waked")
			end
		end
	end
}


Chiyuri:addSkill(se_huanyuan_Pre)
Chiyuri:addSkill(se_huanyuan)
Chiyuri:addSkill(se_chengling)
-- Chiyuri:addSkill(se_chenglingMark)
-- extension:insertRelatedSkills("se_chengling", "#se_chenglingMark")
--Chiyuri:addSkill(SE_Huwei)

sgs.LoadTranslationTable{
["se_huanyuan"] = "还原",
["se_huanyuancard"] = "还原",
["se_huanyuan"] = "还原",
["se_huanyuan$"] = "image=image/animate/se_huanyuan.png",
["$se_huanyuan1"] = "但...但是，起码这件事让我一份力吧，土豆沙拉和火腿奶酪三明治，都是小春喜欢的吧。",
["$se_huanyuan2"] = "我只是希望你能认为自己永远有着两个挚友，所以...",
["$se_huanyuan3"] = "那是因为，我的能力不是「治癒」啊。",
["$se_huanyuan4"] = "所以我理解了。我的能力不是「治癒」，而是「时间倒流」的力量。",
["$se_huanyuan5"] = "最喜欢！最喜欢你们两个了！",
["se_huanyuan_Draw"] = "使其补充手牌至你上一回合结束时的手牌数。",
["se_huanyuan_Hp"] = "令其恢复至你上一回合结束时的体力和体力上限。",
--[[["SE_Huwei_help"] = "失去一点体力，令其回复一点体力。",
["SE_Huwei_not"] = "不进行技能。",]]
[":se_huanyuan"] = "出牌阶段限一次，你可以弃置一张手牌并指定一名角色，你选择一项：令其将手牌补至X（X为你上回合结束阶段结束时该角色的手牌数），或令其将体力和体力上限还原至你上回合结束阶段结束时该角色的体力和体力上限。你不能于你的第一回合使用此技能。 ",
["se_chengling"] = "橙铃「Lime Bell」",
["se_chengling"] = "橙铃「Lime Bell」",
["se_chengling$"] = "image=image/animate/se_chengling.png",
["@LimeBell"] = "橙铃",
["$se_chengling1"] = "我之所以对你言听计从，是为了提高必杀技的级别，扩展可以倒流的时间。然后，就是瞄准了今天这个唯一的机会。我从来都没有成为过你的伙伴！",
["$se_chengling2"] = "柠檬召唤！",
[":se_chengling"] = "限定技。出牌阶段，你可以令至多两名其他角色将武将牌、体力和体力上限恢复至游戏开始时的状态，然后将觉醒复原。",
["Chiyuri"] = "仓嶋千百合",
["&Chiyuri"] = "仓嶋千百合",
["@Chiyuri"] = "加速世界",
["#Chiyuri"] = "时间逆流",
["~Chiyuri"] = "为什么...会变成这样啊！为什么...非得被说得那么过分！",
["designer:Chiyuri"] = "昂翼天使",
["cv:Chiyuri"] = "豊崎愛生",
["illustrator:Chiyuri"] = "SUNRISE",
}

--艾·亚斯汀
SE_Shouzang = sgs.CreateTriggerSkill{
	name = "SE_Shouzang",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Dying},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local dying_data = data:toDying()
		local source = dying_data.who
		local mygod= room:findPlayerBySkillName("SE_Shouzang")
			if mygod then
				if mygod:isAlive() and not mygod:hasFlag("SE_Shouzang_X") then
					local orin_num = mygod:getHandcardNum()+mygod:getEquips():length()
					local num = source:getMaxHp()
					if orin_num >= num then
						if room:askForSkillInvoke(mygod, "SE_Shouzang", data) then
							if room:askForDiscard(mygod,self:objectName(),num,num,false,true) then
								if mygod:getHandcardNum()+mygod:getEquips():length() <= orin_num - num then
									room:broadcastSkillInvoke("SE_Shouzang")
									room:doLightbox("SE_Shouzang$", 1500)
									local killer = sgs.DamageStruct()
									killer.from = mygod
									room:killPlayer(source, killer)
								end
							end
						else
							room:setPlayerFlag(mygod,"SE_Shouzang_X")
						end
					else
						room:setPlayerFlag(mygod,"SE_Shouzang_X")
					end
				end
			end
		return false
	end,
	can_trigger = function(self, target)
		return true
	end
}

SE_Xiangren = sgs.CreateTriggerSkill{
	name = "SE_Xiangren",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Dying,sgs.Damaged, sgs.Death},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.Dying then
			local dying_data = data:toDying()
			local source = dying_data.who
			local mygod= room:findPlayerBySkillName("SE_Xiangren")
				if mygod and mygod:getMark("@Father_daughter") < 1 and mygod:getMark("faDaUsed") == 0 then
					if mygod:isAlive() and source:getHp() < 1 and source:isMale() and source:isAlive() then
						if room:askForSkillInvoke(mygod, "SE_Xiangren", data) then
							room:broadcastSkillInvoke("SE_Xiangren")
							room:doLightbox("SE_Xiangren$", 3000)
							mygod:gainMark("@Father_daughter")
							source:gainMark("@Father_daughter")
							mygod:setMark("faDaUsed", 1)
							room:acquireSkill(source, self:objectName())
							for _,p in sgs.qlist(room:getOtherPlayers(source)) do
								for _,card in sgs.qlist(p:getHandcards()) do
									if card:isRed() then
										source:obtainCard(card)
										break
									end
								end
							end
						end
					end
				end
			return false
		elseif event == sgs.Death then
			local death = data:toDeath()
			if death.who:objectName() == player:objectName() then
				if player:getMark("@Father_daughter") == 1 then
					for _,p in sgs.qlist(room:getOtherPlayers(player)) do
						if p:getMark("@Father_daughter") == 1 then
							room:broadcastSkillInvoke("SE_Xiangren_death")
							p:gainAnExtraTurn()
							p:gainAnExtraTurn()
							p:gainAnExtraTurn()
							player:loseAllMarks("@Father_daughter")
							p:loseAllMarks("@Father_daughter")
						end
					end
				end
			end
		end
	end,
	can_trigger = function(self, target)
		return true
	end
}

SE_Shenmin = sgs.CreateTriggerSkill{
	name = "SE_Shenmin",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Death},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local death = data:toDeath()
		if death.who:objectName() == player:objectName() then
			local mygod= room:findPlayerBySkillName("SE_Shenmin")
			if mygod then
				if mygod:isAlive() then
					room:broadcastSkillInvoke("SE_Shenmin")
					--KOF
					if room:getAllPlayers(true):length() == 2 then
						room:setPlayerProperty(mygod, "maxhp", sgs.QVariant(mygod:getMaxHp()+1))
					end
					local re = sgs.RecoverStruct()
					re.who=mygod
					room:recover(mygod,re,true)
					mygod:gainMark("@shenmin")
					--KOF
					if room:getAllPlayers(true):length() == 2 then
						mygod:gainAnExtraTurn()
						mygod:gainAnExtraTurn()
					end
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target~= nil
	end
}


SE_ShenminKeep = sgs.CreateMaxCardsSkill{
	name = "#SE_ShenminKeep",
	extra_func = function(self, target)
		if target:getMark("@shenmin") > 0 then
			local shenmin = target:getMark("@shenmin")
			return shenmin
		end
	end
}


AiAstin:addSkill(SE_Shouzang)
AiAstin:addSkill(SE_Xiangren)
AiAstin:addSkill(SE_Shenmin)
AiAstin:addSkill(SE_ShenminKeep)
extension:insertRelatedSkills("SE_Shenmin", "#SE_ShenminKeep")


sgs.LoadTranslationTable{
["@Father_daughter"] = "父女",
["@shenmin"] = "神悯",
["SE_Shouzang"] = "收葬",
["SE_Shouzang$"] = "image=image/animate/SE_Shouzang.png",
["SE_Shenmin_add"] = "体力值增加1",
["SE_Shenmin_minus"] = "体力值减少1",
["$SE_Shouzang1"] = "我是守墓人...不，我要成为守墓人。",
["$SE_Shouzang2"] = "听清楚了嘛，我可是货真价实的、守墓人啊！",
[":SE_Shouzang"] = " 每当一名角色进入濒死状态时，你可以弃置X张牌，然后视为你杀死该角色（X为该角色的体力上限）。",
["SE_Xiangren"] = "相认",
["SE_Xiangren$"] = "image=image/animate/SE_Xiangren.png",
["$SE_Xiangren1"] = "我是艾，是被称作汉普尼汉伯特的人类和被称作阿尔法的守墓人的，女儿。",
["$SE_Xiangren2"] = "我不会逃！直到就出父亲大人为止！",
["$SE_Xiangren3"] = "我的名字是...奇兹那（羁绊）·亚斯汀，所以你的名字应该叫，艾（爱）·亚斯汀。",
["$SE_Xiangren_death"] = "",
[":SE_Xiangren"] = "限定技。每当一名男性角色进入濒死状态时，你可以令其获得除该角色以外的角色的各至多一张红色手牌，若其于濒死状态被救回，你与其处于父女状态。每当处于父女状态的角色死亡后，处于父女状态的另一名角色获得三个额外的回合。",
["SE_Shenmin"] = "神悯",
["SE_ShenminAll"] = "神悯",
[":SE_ShenminAll"] = "你处于神悯之下。",
["$SE_Shenmin"] = "如果神抛弃了世界，我就去拯救这个世界。",
[":SE_Shenmin"] = "锁定技。每当一名角色死亡后，你回复1点体力；你的手牌上限+X（X为已死亡的人数）。",
["AiAstin"] = "艾",
["&AiAstin"] = "艾",
["@AiAstin"] = "神不在的星期天",
["#AiAstin"] = "终焉的墓旅人",
["~AiAstin"] = "...我出发了！",
["designer:AiAstin"] = "黑猫roy",
["cv:AiAstin"] = "豊崎愛生",
["illustrator:AiAstin"] = "Madhouse",
}

--五河琴里
SE_Niepan = sgs.CreateTriggerSkill{
	name = "SE_Niepan",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Damaged},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if player:isAlive() and player:hasSkill(self:objectName()) then
			room:broadcastSkillInvoke("SE_Niepan")
			local recover = sgs.RecoverStruct()
			recover.who = player
			room:recover(player, recover)
		end
	end
}

se_jiangui = sgs.CreateViewAsSkill{
	name = "se_jiangui",
	n = 0,
	view_as = function(self, cards)
		local card = se_jianguicard:clone()
		card:setSkillName(self:objectName())
		return card
	end,
	enabled_at_play = function(self, player)
		return not player:hasUsed("#se_jianguicard")
	end
}
se_jianguicard = sgs.CreateSkillCard{
	name = "se_jianguicard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
	if #targets <10 then
			return to_select:objectName() ~= sgs.Self:objectName()
		end
	end,
	feasible = function(self, targets)
		return #targets > 0
	end,
	on_use = function(self, room, source, targets)
		--room:broadcastSkillInvoke("se_jiangui")
		room:doLightbox("se_jiangui$", 1500)
		for _,target in ipairs(targets) do
			local flame = sgs.DamageStruct()
			flame.from = source
			flame.to = target
			flame.damage = 1
			flame.nature = sgs.DamageStruct_Fire
			room:damage(flame)
		end

		for _,wore in ipairs(targets) do
			if not wore:isNude() then
				local id = room:askForCardChosen(source, wore, "hej", "se_jiangui")
				room:throwCard(id, wore, source)
			end
			if not wore:isNude() then
				local id = room:askForCardChosen(source, wore, "hej", "se_jiangui")
				room:throwCard(id, wore, source)
			end
		end

		source:drawCards(3)
	end
}

SE_Wufan = sgs.CreateTriggerSkill{
	name = "SE_Wufan",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.TurnStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.TurnStart then
			if player:hasSkill("SE_Niepan") then
				room:detachSkillFromPlayer(player,"SE_Niepan")
			end
			if player:hasSkill("se_jiangui") then
				room:detachSkillFromPlayer(player,"se_jiangui")
			end
			if player:getMark("@Efreet") >= 1 then
				if room:askForSkillInvoke(player, self:objectName()) then
					player:loseMark("@Efreet")
					room:broadcastSkillInvoke("SE_Wufan", math.random(1, 3))
					room:doLightbox("SE_Wufan$", 2000)
					room:acquireSkill(player, "SE_Niepan")
					room:acquireSkill(player, "se_jiangui")
				end
			end
		end
	end
}

SE_WufanMark = sgs.CreateTriggerSkill{
	name = "#SE_WufanMark",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart,sgs.TurnStart,sgs.AskForPeachesDone},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.GameStart then
			player:loseAllMarks("@Efreet")
			--KOF
			if room:getAllPlayers(true):length() == 2 then
				player:gainMark("@Efreet", 2)
			else
				player:gainMark("@Efreet", 3)
			end
		elseif event == sgs.TurnStart then
			if player:getMark("@Efreet") < 1 then
				room:broadcastSkillInvoke("SE_Wufan", 4)
				room:doLightbox("SE_Wufan_Change$", 3000)
				if player:hasSkill("SE_Niepan") then
					room:detachSkillFromPlayer(player,"SE_Niepan")
				end
				if player:hasSkill("se_jiangui") then
					room:detachSkillFromPlayer(player,"se_jiangui")
				end
				if player:getGeneralName() == "Kotori" then
					room:changeHero(player, "Kotori_white",false, false, false, true)
				else
					room:changeHero(player, "Kotori_white",false, false, true, true)
				end
			end
		elseif event == sgs.AskForPeachesDone then
			local dying_data = data:toDying()
			local source = dying_data.who
			if source:hasSkill(self:objectName()) then
				source:gainMark("@Efreet", 1)
			end
		end
	end
}


Kotori:addSkill(SE_WufanMark)
Kotori:addSkill(SE_Wufan)
extension:insertRelatedSkills("SE_Wufan", "#SE_WufanMark")
extension:addToSkills(SE_Niepan)
extension:addToSkills(se_jiangui)
Kotori:addWakeTypeSkillForAudio("SE_Niepan")
Kotori:addWakeTypeSkillForAudio("se_jiangui")

sgs.LoadTranslationTable{
["se_jiangui$"] = "image=image/animate/se_jiangui.png",
["SE_Wufan$"] = "image=image/animate/SE_Wufan.png",
["SE_Wufan_Change$"] = "image=image/animate/SE_Wufan_Change.png",
["@Efreet"] = "Efreet",
["SE_Niepan"] = "涅槃「伤势复原」",
["$SE_Niepan1"] = "你还真是会玩啊。",
["$SE_Niepan2"] = "虽然对我来说你能吓的丧失斗志那是最好...",
["$SE_Niepan3"] = "哎呀这就打完了吗？你完全可以在认真点哦。",
[":SE_Niepan"] = "唤醒技。锁定技。你受到一次伤害后，回复一点体力。",
["se_jiangui"] = "奸鬼「灼烂歼鬼（Camael）」",
["$se_jiangui1"] = "燃烧吧！灼烂歼鬼（Camael）！",
["$se_jiangui2"] = "灼烂歼鬼（Camael）·炮（Megiddo）！",
[":se_jiangui"] = "唤醒技。出牌阶段限一次，你可以指定任意名其他角色，对这些角色造成一点火焰伤害，弃置这些角色各两张牌，然后摸三张牌。",
["SE_Wufan"] = "五番「神威灵装·五番（Elohim Gibor）」",
["$SE_Wufan1"] = "神威灵装·五番（Elohim Gibor）！",
["$SE_Wufan2"] = "拿起枪来。战斗还没结束呢。战争还没结束呢。",
["$SE_Wufan3"] = "来吧，我们还能继续厮杀呢。这可是你期盼的战斗，是你希望的争斗啊！",
["$SE_Wufan4"] = "喜欢！我也最喜欢你了！最喜欢哥哥了！是世界上最爱的人！",
[":SE_Wufan"] = "游戏开始时，你获得3枚 Efreet 标记；每当你处于濒死状态被救回，你获得一枚 Efreet 标记。回合开始前，若你没有 Efreet 标记，你失去所有技能。准备阶段，你可以弃置一个 Efreet 标记，并获得<font color=\"#bc64a4\"><b>「涅槃」</b></font>和<font color=\"#bc64a4\"><b>「灼烂歼鬼（Camael）」</b></font>",
["Kotori"] = "五河琴里",
["&Kotori"] = "五河琴里",
["@Kotori"] = "Date A Live",
["#Kotori"] = "炎魔妹妹",
["~Kotori"] = "（士道）求你了...不要从我这里夺走琴里！她救了我...没有她，就不会有现在的我！...求你了！",
["designer:Kotori"] = "御坂20623",
["cv:Kotori"] = "竹達彩奈",
["illustrator:Kotori"] = "ちゃわん",
["Kotori_white"] = "五河琴里",
["&Kotori_white"] = "五河琴里",
["#Kotori_white"] = "软妹妹",
["~Kotori_white"] = "呜呜...好可怕...病毒...好可怕...",
["designer:Kotori_white"] = "御坂20623",
["cv:Kotori_white"] = "竹達彩奈",
["illustrator:Kotori_white"] = "...",
}


--萌战
local function isBaskervilles(player)
	if player:isAlive() then
		if player:getMark("@Baskervilles") == 1 then
			return true
		end
	end
	return false
end

local function getBaskervillesNum(room)
	local num = 0
	for _,p in sgs.qlist(room:getAlivePlayers()) do
		if isBaskervilles(p) then
			num = num + 1
		end
	end
	return num
end

SE_Baskervilles_make = sgs.CreateTriggerSkill{
	name = "#SE_Baskervilles_make",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.GameStart then
			player:gainMark("@Baskervilles", 1)
		end
	end
}

--巴斯克维尔小队
--巴斯克维尔-亚里亚
SE_Shuangqiang = sgs.CreateTriggerSkill{
	name = "SE_Shuangqiang",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageCaused},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.DamageCaused then
			local victim = damage.to
			local p = damage.from
			if victim and victim:isAlive() then
				if victim:objectName() ~= player:objectName() and damage.nature == sgs.DamageStruct_Normal then
					if p:getEquips():length() < 2 then return end
					if room:askForSkillInvoke(player, self:objectName(), data) then
						room:broadcastSkillInvoke("SE_Shuangqiang")
						room:doLightbox("SE_Shuangqiang$", 800)
						if room:getDrawPile():length()< 4 then room:swapPile() end
						local cards = room:getDrawPile()
						local heart = 0
						local spade = 0
						local club = 0
						local diamond = 0
						for i = 1, 4, 1 do
							local cardsid1=cards:at(i-1)
							room:showCard(p,cardsid1)
							local c =sgs.Sanguosha:getCard(cardsid1)
							if c:getSuit() == sgs.Card_Heart then
								heart = heart + 1
							elseif  c:getSuit() == sgs.Card_Diamond then
								diamond = diamond + 1
							elseif  c:getSuit() == sgs.Card_Club then
								club = club + 1
							elseif  c:getSuit() == sgs.Card_Spade then
								spade = spade + 1
							end
							local reason=sgs.CardMoveReason()
							reason.m_reason   = sgs.CardMoveReason_S_REASON_THROW
							reason.m_playerId = p:objectName()
							room:moveCardTo(c, nil, sgs.Player_DiscardPile, reason,true)
						end
						local damageValue = math.max(heart, spade, diamond, club)
						damage.damage = damageValue
						if damageValue > 2 then
							room:doLightbox("SE_Shuangqiang$", 1500)
						end
						data:setValue(damage)
					end
				end
			end
		end
		return false
	end
}

SE_Xinlai = sgs.CreateTriggerSkill{
	name = "SE_Xinlai",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Damage},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.Damage then
			local list = room:getAlivePlayers()
			for _,p in sgs.qlist(list) do
				if p:hasSkill("SE_Xinlai") then
					local attacker = damage.from
					if isBaskervilles(attacker) then
						if p:askForSkillInvoke(self:objectName(), data) then
							if attacker:askForSkillInvoke(self:objectName(), data) then
								local damage_num = damage.damage
								room:broadcastSkillInvoke(self:objectName())
								room:doLightbox("SE_Xinlai$", 800)
								local num = 0
								for _,guy in sgs.qlist(room:getAlivePlayers()) do
									if isBaskervilles(guy) then
										local newdata = sgs.QVariant()
										newdata:setValue(guy)
										local prompt = string.format("Give Card to:"..guy:getGeneralName())
										local choice = room:askForChoice(p,"SE_Xinlai",prompt.."+".."SE_Xinlai_Not", newdata)
										if choice == prompt then
											guy:drawCards(damage_num)
											num = num + 1
										end
									end
								end
							end
						end
					end
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}

Aria:addSkill(SE_Shuangqiang)
Aria:addSkill(SE_Xinlai)
Aria:addSkill(SE_Baskervilles_make)
sgs.LoadTranslationTable{
["@Baskervilles"] = "巴斯克维尔",
[":@Baskervilles"] = "萌战",
["&@Baskervilles"] = "Sky Blue",
["SE_Shuangqiang$"] = "image=image/animate/SE_Shuangqiang.png",
["SE_Xinlai$"] = "image=image/animate/SE_Xinlai.png",
["SE_Xinlai_Not"] = "不发动",
["SE_Shuangqiang"] = "双枪「双枪双剑」",
["$SE_Shuangqiang1"] = "你逃不掉的！从来没有犯人能逃出我的手心！",
["$SE_Shuangqiang2"] = "不可饶恕...就算你跪下来哭着向我道歉...我也饶不了你！",
[":SE_Shuangqiang"] = " 每当你造成一次普通伤害时，若你的装备区内有至少两张牌，你可以将牌堆顶部的四张牌置入弃牌堆，然后令此伤害+X-1（X为其中最多的花色的数量）。",
["SE_Xinlai"] = "信赖「武侦第一条·相信同伴」",
["$SE_Xinlai1"] = "我很期待你能够拿出你的实力！",
["$SE_Xinlai2"] = "万一遇到危机，我会保护你的！",
["$SE_Xinlai3"] = "武侦第一条·相信同伴，拯救同伴！",
[":SE_Xinlai"] = "<font color=\"Sky Blue\"><b>萌战技，3，武侦，</b></font>每当一名武侦角色造成伤害后，若其参战，你可以令任意数量的武侦角色各摸X张牌（X为此伤害的数值）。",
["#SE_Xinlai_Draw"] = "令该角色摸牌",
["Give Card to:Aria"] = "令亚里亚摸牌",
["Give Card to:Reki"] = "令雷姬摸牌",
["Give Card to:Riko"] = "令理子摸牌",
["Give Card to:Shirayuki"] = "令白雪摸牌",
["Aria"] = "亚里亚",
["&Aria"] = "亚里亚",
["@Aria"] = "绯弹的亚里亚",
["#Aria"] = "双枪双剑",
["~Aria"] = "我都这样说了！为什么...为什么你还不肯相信我！",
["designer:Aria"] = "Sword Elucidator",
["cv:Aria"] = "钉宫理惠",
["illustrator:Aria"] = "NorthAbyssor",
}

--巴斯克维尔-雷姬
SE_Juji_Reki = sgs.CreateTriggerSkill{
	name = "SE_Juji_Reki",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.TargetConfirmed, sgs.SlashProceed, sgs.GameStart, sgs.EventAcquireSkill},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.GameStart or (event == sgs.EventAcquireSkill and data:toString() == self:objectName()) then
			local list = room:getAlivePlayers()
			for _,p in sgs.qlist(list) do
				room:setFixedDistance(player, p, 1)
			end
		elseif event == sgs.TargetConfirmed then
			local use = data:toCardUse()
			local card = use.card
			local source = use.from
			local room = player:getRoom()
			if card:isKindOf("Slash") then
				if source:objectName() == player:objectName() then
					local phase = player:getPhase()
					if phase == sgs.Player_Play then
						local range = player:getAttackRange()
						local targets = use.to
						for _,target in sgs.qlist(targets) do
							if not target:inMyAttackRange(player) then
								if card:getNumber() ~= 0 then
									room:broadcastSkillInvoke("SE_Juji_Reki")
								end
								local msg = sgs.LogMessage()
								msg.type = "#SE_Juji_XD"
								room:sendLog(msg)
								room:setPlayerFlag(target, "SE_JujiTarget_Reki")
							end
						end
					end
				end
			end
		elseif event == sgs.SlashProceed then
			local effect = data:toSlashEffect()
			local dest = effect.to
			if dest:hasFlag("SE_JujiTarget_Reki") then
				room:setPlayerFlag(dest, "-SE_JujiTarget_Reki")
				room:setEmotion(dest, "snipe")
				room:slashResult(effect, nil)
				return true
			end
		end
		return false
	end
}

SE_Juji_RekiClear = sgs.CreateDetachEffectSkill{
	name = "SE_Juji_Reki",
	on_skill_detached = function(self, room, player)
		for _,p in sgs.qlist(room:getAlivePlayers()) do
			room:removeFixedDistance(player, p, 1)
		end
	end,
}

SE_Zhiyuan = sgs.CreateTriggerSkill{
	name = "SE_Zhiyuan",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Damage},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.Damage then
			local slash = damage.card
			if not slash then return end
			if not slash:isKindOf("Slash") then return end
			local list = room:getAlivePlayers()
			for _,p in sgs.qlist(list) do
				if p:hasSkill("SE_Zhiyuan") and p:objectName() == damage.from:objectName() then
					if p:askForSkillInvoke(self:objectName(), data) then
						room:broadcastSkillInvoke(self:objectName())
						room:doLightbox("SE_Zhiyuan$", 800)
						local num = 0
						local done = 0
						local partner = getBaskervillesNum(room)
						for _,guy in sgs.qlist(room:getAlivePlayers()) do
							if isBaskervilles(guy) then
								local newdata = sgs.QVariant()
								newdata:setValue(guy)
								local prompt = string.format("Make Judge on:"..guy:getGeneralName())
								local choice = room:askForChoice(p,"SE_Zhiyuan",prompt.."+".."SE_Zhiyuan_Not", newdata)
								if choice == prompt then
									local judge = sgs.JudgeStruct()
									judge.pattern = ".|spade"
									if p:objectName() == guy:objectName() then
										judge.pattern = "."
									end
									judge.good = true
									judge.negative = false
									judge.reason = self:objectName()
									judge.who = guy
									judge.play_animation = true
									judge.time_consuming = true
									room:judge(judge)
									local suit = judge.card:getSuit()
									if suit == sgs.Card_Spade or (p:objectName() == guy:objectName() and suit == sgs.Card_Club and partner == 1) then
										room:doLightbox("SE_Zhiyuan$", 1200)
										guy:gainAnExtraTurn()
										done = done + 1
									end
									num = num + 1
								end
							end
						end
						if done == 0 then
							local wore = damage.to
							if not wore:isNude() then
								local id = room:askForCardChosen(p, wore, "hej", "SE_Zhiyuan")
								room:throwCard(id, wore, p)
							end
						end
					end
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}

Reki:addSkill(SE_Juji_Reki)
Reki:addSkill(SE_Juji_RekiClear)
extension:insertRelatedSkills("SE_Juji_Reki", "#SE_Juji_Reki-clear")
Reki:addSkill(SE_Zhiyuan)
Reki:addSkill("#SE_Baskervilles_make")

sgs.LoadTranslationTable{
["SE_Zhiyuan$"] = "image=image/animate/SE_Zhiyuan.png",
["SE_Zhiyuan_Not"] = "不支援",
["SE_Juji_Reki"] = "狙击「SVD」",
["$SE_Juji_Reki1"] = "我是...一发子弹。",
["$SE_Juji_Reki2"] = "子弹没有感情。因此，没有迷惘。",
[":SE_Juji_Reki"] = "锁定技。当你与其他角色计算距离时，始终为1；出牌阶段，你使用的【杀】不能被攻击范围内没有你的角色的【闪】响应。",
["SE_Zhiyuan"] = "支援「援护射击」",
["$SE_Zhiyuan1"] = "亚里亚是我的委托人。",
["$SE_Zhiyuan2"] = "我是雷姬。我听说委托人白雪失踪了。",
["$SE_Zhiyuan3"] = "请冷静。失去冷静的人只能发挥其五成的能力。",
[":SE_Zhiyuan"] = "<font color=\"Sky Blue\"><b>萌战技，武侦，3，</b></font>每当你使用【杀】造成一次伤害后，你可以选择一项：1.令任意数量的参战角色（目标角色必须包括其他角色）各进行一次判定：若结果为♠，该角色获得一个额外的回合，然后若没有角色判定为♠，你弃置受到伤害角色的一张牌。2.令为参战角色的你进行一次判定：若结果为黑色，你获得一个额外的回合，然后若没有角色判定为黑色，你弃置受到伤害角色的一张牌。",
["#SE_Zhiyuan_Judge"] = "支援",
["Make Judge on:Aria"] = "令亚里亚判定",
["Make Judge on:Reki"] = "令雷姬判定",
["Make Judge on:Riko"] = "令理子判定",
["Make Judge on:Shirayuki"] = "令白雪判定",
["Reki"] = "雷姬",
["&Reki"] = "雷姬",
["@Reki"] = "绯弹的亚里亚",
["#Reki"] = "风の狙击手",
["~Reki"] = "...",
["designer:Reki"] = "Sword Elucidator",
["cv:Reki"] = "石原夏織",
["illustrator:Reki"] = "暴力にゃ長",
}

--右代宮縁寿
SE_QizhuangCompulsory = sgs.CreateTriggerSkill{
	name = "#SE_QizhuangCompulsory",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart, sgs.EventPhaseStart,sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		if event == sgs.GameStart then
			local room = player:getRoom()
			for _,p in sgs.qlist(room:getPlayers()) do
				p:loseAllMarks("@Lucifer")
				p:loseAllMarks("@Leviathan")
				p:loseAllMarks("@Satan")
				p:loseAllMarks("@Belphegor")
				p:loseAllMarks("@Mammon")
				p:loseAllMarks("@Beelzebub")
				p:loseAllMarks("@Asmodeus")
			end
			player:gainMark("@Lucifer")
			player:gainMark("@Leviathan")
			player:gainMark("@Satan")
			player:gainMark("@Belphegor")
			player:gainMark("@Mammon")
			player:gainMark("@Beelzebub")
			player:gainMark("@Asmodeus")
		end
		if player:isAlive() and player:hasSkill(self:objectName()) then
			if event == sgs.EventPhaseStart and player:getPhase() == sgs.Player_RoundStart then
				if not player:isSkipped(sgs.Player_Play) then
					player:skip(sgs.Player_Play)
				end
			elseif event == sgs.EventPhaseEnd and player:getPhase() == sgs.Player_Discard then
				local card_num = player:getHandcardNum()
				local room = player:getRoom()
				local x = room:getOtherPlayers(player):length() - 1
				if card_num < x then
					player:drawCards(x - card_num)
				end
			end
		end
	end
}

--[[
local function  QizhuangTarget(room, player)
	local targets  = sgs.SPlayerList()
	for _,p in sgs.qlist(room:getOtherPlayers(player)) do
		if p:getMark("@Lucifer") == 0 and p:getMark("@Leviathan") == 0 and p:getMark("@Satan") == 0 and p:getMark("@Belphegor") == 0 and p:getMark("@Mammon") == 0 and p:getMark("@Beelzebub") == 0 and p:getMark("@Asmodeus") == 0 then
			targets:append(p)
		end
	end
	return targets
end
]]
SE_Qizhuang = sgs.CreateTriggerSkill{
	name = "SE_Qizhuang",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseEnd,sgs.DamageInflicted, sgs.Death},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local ange = room:findPlayerBySkillName("SE_Qizhuang")
		if not ange then return end
		if event == sgs.EventPhaseEnd then
			if player:isAlive() and player:hasSkill(self:objectName()) then
				if player:getPhase() == sgs.Player_Finish then
					if ange:askForSkillInvoke(self:objectName(),data) then
						room:broadcastSkillInvoke("SE_Qizhuang")
						if ange:getMark("@Lucifer") == 1 then
							local targets  = room:getOtherPlayers(ange)
							local target = room:askForPlayerChosen(ange, targets, "Lucifer")
							if target then
								ange:loseAllMarks("@Lucifer")
								target:gainMark("@Lucifer")
							end
						end
						if ange:getMark("@Leviathan") == 1 then
							local targets  = room:getOtherPlayers(ange)
							local target = room:askForPlayerChosen(ange, targets, "Leviathan")
							if target then
								ange:loseAllMarks("@Leviathan")
								target:gainMark("@Leviathan")
							end
						end
						if ange:getMark("@Satan") == 1 then
							local targets  = room:getOtherPlayers(ange)
							local target = room:askForPlayerChosen(ange, targets, "Satan")
							if target then
								ange:loseAllMarks("@Satan")
								target:gainMark("@Satan")
							end
						end
						if ange:getMark("@Belphegor") == 1 then
							local targets  = room:getOtherPlayers(ange)
							local target = room:askForPlayerChosen(ange, targets, "Belphegor")
							if target then
								ange:loseAllMarks("@Belphegor")
								target:gainMark("@Belphegor")
							end
						end
						if ange:getMark("@Beelzebub") == 1 then
							local targets  = room:getAlivePlayers()
							local target = room:askForPlayerChosen(ange, targets, "Beelzebub")
							if target then
								ange:loseAllMarks("@Beelzebub")
								target:gainMark("@Beelzebub")
							end
						end
						if ange:getMark("@Asmodeus") == 1 then
							local targets  = room:getAlivePlayers()
							local target = room:askForPlayerChosen(ange, targets, "Asmodeus")
							if target then
								ange:loseAllMarks("@Asmodeus")
								target:gainMark("@Asmodeus")
							end
						end
					end
				end
			end
		elseif event == sgs.DamageInflicted then
			local damage = data:toDamage()
			local source = damage.from
			if source then
				if source:isAlive() then
					if source:getMark("@Lucifer") == 1 then
						if source:objectName() ~= ange:objectName() then
							if ange:askForSkillInvoke("Lucifer",data) then
								room:broadcastSkillInvoke("Lucifer")
								room:doLightbox("Lucifer$", 800)
								source:loseAllMarks("@Lucifer")
								local da1 = sgs.DamageStruct()
								da1.from = source
								da1.to = source
								da1.damage = damage.damage
								room:damage(da1)
								ange:gainMark("@Lucifer")
							end
						end
					end
					if source:getMark("@Leviathan") == 1 then
						if source:objectName() ~= ange:objectName() then
							if ange:askForSkillInvoke("Leviathan",data) then
								local wore = math.random(1,2)
								if wore == 1 then
									room:broadcastSkillInvoke("Leviathan")
									room:doLightbox("Leviathan$", 800)
									if source:getEquips():length() > 0 then
										local id = room:askForCardChosen(ange, source, "e", "Leviathan")
										room:throwCard(id, source, ange)
										if source:getEquips():length() > 0 then
											local id = room:askForCardChosen(ange, source, "e", "Leviathan")
											room:throwCard(id, source, ange)
										end
									end
								end
								source:loseAllMarks("@Leviathan")
								ange:gainMark("@Leviathan")
							end
						end
					end
					if source:getMark("@Satan") == 1 then
						if source:objectName() ~= ange:objectName() then
							if ange:askForSkillInvoke("Satan",data) then
								source:loseAllMarks("@Satan")
								local wore = math.random(1,2)
								if wore == 1 then
									room:broadcastSkillInvoke("Satan")
									room:doLightbox("Satan$", 800)
									local da2 = sgs.DamageStruct()
									da2.from = ange
									da2.to = source
									da2.damage = 1
									room:damage(da2)
								end
								ange:gainMark("@Satan")
							end
						end
					end
					if source:getMark("@Belphegor") == 1 then
						if source:objectName() ~= ange:objectName() then
							if ange:askForSkillInvoke("Belphegor",data) then
								local wore = math.random(1,2)
								if wore == 1 then
									room:broadcastSkillInvoke("Belphegor")
									room:doLightbox("Belphegor$", 800)
									damage.damage = 0
									data:setValue(damage)
								end
								source:loseAllMarks("@Belphegor")
								ange:gainMark("@Belphegor")
							end
						end
					end
					if source:getMark("@Beelzebub") == 1 then
						if ange:askForSkillInvoke("Beelzebub",data) then
							local wore = math.random(1,2)
							if wore == 1 then
								room:broadcastSkillInvoke("Beelzebub")
								room:doLightbox("Beelzebub$", 800)
								source:drawCards(2)
							end
							source:loseAllMarks("@Beelzebub")
							ange:gainMark("@Beelzebub")
						end
					end
					if source:getMark("@Asmodeus") == 1 then
						if ange:askForSkillInvoke("Asmodeus",data) then
							local wore = math.random(1,2)
							if source:objectName() ~= ange:objectName() then
								if wore == 1 then
									room:broadcastSkillInvoke("Asmodeus")
									room:doLightbox("Asmodeus$", 800)
									local re = sgs.RecoverStruct()
									re.who = ange
									room:recover(ange, re, true)
									local re2 = sgs.RecoverStruct()
									re.who = source
									room:recover(source, re, true)
								end
							else
								local wore2 = math.random(1,2)
								if wore == 1 and wore2 == 1 then
									room:broadcastSkillInvoke("Asmodeus")
									room:doLightbox("Asmodeus$", 800)
									local re3 = sgs.RecoverStruct()
									re3.who = ange
									room:recover(ange, re3, true)
									local re4 = sgs.RecoverStruct()
									re4.who = source
									room:recover(source, re4, true)
								end
							end
							source:loseAllMarks("@Asmodeus")
							ange:gainMark("@Asmodeus")
						end
					end
					if source:getMark("@Mammon") == 1 then
						if ange:askForSkillInvoke("Mammon",data) then
							room:broadcastSkillInvoke("Mammon")
							room:doLightbox("Mammon$", 800)
							source:gainMark("@Mahou_ai")
							source:loseAllMarks("@Mammon")
							ange:gainMark("@Mammon")
						end
					end
				end
			end
		elseif event == sgs.Death then
			local death = data:toDeath()
			local deadGuy = death.who
			if deadGuy:objectName() ~= ange:objectName() then
				if deadGuy:getMark("@Lucifer") == 1 then
					deadGuy:loseAllMarks("@Lucifer")
					ange:gainMark("@Lucifer")
				end
				if deadGuy:getMark("@Leviathan") == 1 then
					deadGuy:loseAllMarks("@Leviathan")
					ange:gainMark("@Leviathan")
				end
				if deadGuy:getMark("@Satan") == 1 then
					deadGuy:loseAllMarks("@Satan")
					ange:gainMark("@Satan")
				end
				if deadGuy:getMark("@Belphegor") == 1 then
					deadGuy:loseAllMarks("@Belphegor")
					ange:gainMark("@Belphegor")
				end
				if deadGuy:getMark("@Beelzebub") == 1 then
					deadGuy:loseAllMarks("@Beelzebub")
					ange:gainMark("@Beelzebub")
				end
				if deadGuy:getMark("@Asmodeus") == 1 then
					deadGuy:loseAllMarks("@Asmodeus")
					ange:gainMark("@Asmodeus")
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}

SE_Fanhun = sgs.CreateTriggerSkill{
	name = "SE_Fanhun",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		if player:isAlive() and player:hasSkill(self:objectName()) then
			local room = player:getRoom()
			if event == sgs.EventPhaseStart then
				if player:getPhase() == sgs.Player_RoundStart then
					for _,p in sgs.qlist(room:getPlayers()) do
						if p:getMark("@SE_Fanhun_ed") > 0 then
							local deathdamage = sgs.DamageStruct()
							deathdamage.from = p
							room:killPlayer(p,deathdamage)
						end
					end
					local deathplayer = {}
					for _,p in sgs.qlist(room:getPlayers()) do
						if p:isDead() and p:getMaxHp() >= 1 then
							table.insert(deathplayer,p:getGeneralName())
						end
					end
					if #deathplayer>0 then
						if player:askForSkillInvoke(self:objectName(), data) then
							local ap = room:askForChoice(player,"SE_Fanhun_choose",table.concat(deathplayer,"+"))
							local revivee
							for _,p in sgs.qlist(room:getPlayers()) do
								if p:getGeneralName() == ap and p:isDead() then
									revivee=p
								end
							end
							room:broadcastSkillInvoke("SE_Fanhun")
							room:doLightbox("SE_Fanhun$", 1200)
							room:revivePlayer(revivee)
							room:setPlayerProperty(revivee, "hp", sgs.QVariant(2))
							revivee:gainMark("@SE_Fanhun_ed")
							revivee:gainAnExtraTurn()
						end
					end
				elseif player:getPhase() == sgs.Player_Finish then
					for _,p in sgs.qlist(room:getAlivePlayers()) do
						if p:getMark("@SE_Fanhun_ed") > 0 then
							if player:getMark("@Mahou_ai") > 0 then
								local choice = room:askForChoice(player,"Use_Mahou+Use_Mahou_Not", data)
								if choice == "Use_Mahou" then
									player:loseMark("@Mahou_ai")
								else
									local deathdamage2 = sgs.DamageStruct()
									deathdamage2.from = p
									room:killPlayer(p,deathdamage2)
								end
							else
								local deathdamage3 = sgs.DamageStruct()
								deathdamage3.from = p
								room:killPlayer(p,deathdamage3)
							end
						end
					end
				end
			end
		end
	end,
}

Lucifer = sgs.CreateTriggerSkill{
	name = "Lucifer",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
	end
}

Leviathan = sgs.CreateTriggerSkill{
	name = "Leviathan",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
	end
}

Satan = sgs.CreateTriggerSkill{
	name = "Satan",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
	end
}

Belphegor = sgs.CreateTriggerSkill{
	name = "Belphegor",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
	end
}

Mammon = sgs.CreateTriggerSkill{
	name = "Mammon",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
	end
}

Beelzebub = sgs.CreateTriggerSkill{
	name = "Beelzebub",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
	end
}

Asmodeus = sgs.CreateTriggerSkill{
	name = "Asmodeus",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
	end
}

Ange:addSkill(SE_Qizhuang)
Ange:addSkill(SE_QizhuangCompulsory)
extension:insertRelatedSkills("SE_Qizhuang", "#SE_QizhuangCompulsory")
Ange:addSkill(SE_Fanhun)

extension:addToSkills(Lucifer)
extension:addToSkills(Leviathan)
extension:addToSkills(Satan)
extension:addToSkills(Belphegor)
extension:addToSkills(Mammon)
extension:addToSkills(Beelzebub)
extension:addToSkills(Asmodeus)




sgs.LoadTranslationTable{
["Lucifer"] = "路西法 - 令该角色受到相同伤害。",
["Leviathan"] = "雷维阿坦 - 1/2概率弃掉该角色的两件装备。",
["Satan"] = "撒旦 - 1/2概率令你对该角色造成一点伤害。",
["Belphegor"] = "贝露菲格露 - 1/2概率令该角色造成的伤害失效。",
["Mammon"] = "玛蒙 - 令你获得一个【爱の魔法】标记。",
["Beelzebub"] = "贝露赛布布 - 1/2概率令该角色摸2张牌。",
["Asmodeus"] = "阿丝磨德乌丝 - 1/2概率令你和该角色各回复一点体力。（在自己身上时为1/4）",
["@Lucifer"] = "路西法",
["@Leviathan"] = "雷维阿坦",
["@Satan"] = "撒旦",
["@Belphegor"] = "贝露菲格露",
["@Mammon"] = "玛蒙",
["@Beelzebub"] = "贝露赛布布",
["@Asmodeus"] = "阿丝磨德乌丝",
["@Mahou_ai"] = "爱の魔法",
["@SE_Fanhun_ed"] = "返魂状态",
["Lucifer$"] = "image=image/animate/Lucifer.png",
["Leviathan$"] = "image=image/animate/Leviathan.png",
["Satan$"] = "image=image/animate/Satan.png",
["Belphegor$"] = "image=image/animate/Belphegor.png",
["Mammon$"] = "image=image/animate/Mammon.png",
["Beelzebub$"] = "image=image/animate/Beelzebub.png",
["Asmodeus$"] = "image=image/animate/Asmodeus.png",
["SE_Fanhun$"] = "image=image/animate/SE_Fanhun.png",
["$Lucifer1"] = "...",
["$Lucifer2"] = "...",
["$Lucifer3"] = "...",
["$Lucifer4"] = "...",
["$Leviathan1"] = "...",
["$Leviathan2"] = "...",
["$Leviathan3"] = "...",
["$Satan1"] = "...",
["$Satan2"] = "...",
["$Satan3"] = "...",
["$Belphegor1"] = "...",
["$Belphegor2"] = "...",
["$Belphegor3"] = "...",
["$Mammon1"] = "...",
["$Mammon2"] = "...",
["$Mammon3"] = "...",
["$Mammon4"] = "...",
["$Mammon5"] = "...",
["$Beelzebub1"] = "...",
["$Beelzebub2"] = "...",
["$Beelzebub3"] = "...",
["$Asmodeus1"] = "...",
["$Asmodeus2"] = "...",
["$Asmodeus3"] = "...",
["SE_Fanhun_choose"] = "请选择返魂的目标",
["Use_Mahou"] = "使用【爱の魔法】标记维持其存在",
["Use_Mahou_Not"] = "不维持其存在",
["SE_Qizhuang"] = "七桩【炼狱七桩】",
["$SE_Qizhuang1"] = "七姐妹！",
["$SE_Qizhuang2"] = "炼狱的七姐妹！",
["$SE_Qizhuang3"] = "那么，再见了。See you again.",
["$SE_Qizhuang4"] = "啊，不行啊，完全不行啊！",
["$SE_Qizhuang5"] = "以现在的魔力足够了！",
["$SE_Qizhuang6"] = "给我适可而止吧！",
["$SE_Qizhuang7"] = "Good night. Have a nice dream.",
[":SE_Qizhuang"] = "锁定技。游戏开始时，你获得7枚“炼狱桩”标记；你跳过你的出牌阶段；弃牌阶段结束时，若你的手牌小于X，你将手牌补至X-2（X为场上的存活角色）；每当拥有“炼狱桩”标记的角色死亡后，你获得其对应的“炼狱桩”标记。结束阶段结束时，你可以令其他角色获得你的标记。每当拥有“炼狱桩”标记的角色造成伤害时，你可以获得此标记并根据此标记执行以下效果：\n路西法 - 该角色受到等同于其造成的伤害。\n雷维阿坦 - 你有1/2的几率弃置该角色的两张装备区里的牌。\n撒旦 - 你有1/2几率对该角色造成1点伤害。\n贝露菲格露 -  你有1/2几率防止此伤害。\n贝露赛布布 - 你有1/2几率令该角色摸两张牌。\n阿丝磨德乌丝 - 你有1/2几率令你与该角色各回复1点体力。\n玛蒙 - 你获得1枚“爱の魔法”标记。 \n◆7枚“炼狱桩”标记分别为“路西法”“雷维阿坦”“撒旦”“贝露菲格露”“贝露赛布布”“阿丝磨德乌丝”“玛蒙”标记。",
["SE_Fanhun"] = "返魂【爱の魔法】",
["$SE_Fanhun1"] = "把憎恨强加给别人的根本就不是魔法。",
["$SE_Fanhun2"] = "真羡慕大家...",
["$SE_Fanhun3"] = "这是非常美妙的奇迹。",
["$SE_Fanhun4"] = "魔法、魔女，在此刻展示奇迹吧！",
["$SE_Fanhun5"] = "我也想成为真里亚姐姐那样。",
["$SE_Fanhun6"] = "我是安琪·贝阿朵莉切！",
["$SE_Fanhun7"] = "（樱太郎）呜溜~做到了呐！",
[":SE_Fanhun"] = "回合开始时，你可以令一名已死亡的角色复活并将其体力自然回复至2点，然后令其获得一个额外的回合。结束阶段开始时，你可以弃置1枚“爱の魔法”标记并令该角色存活至你的下一回合初，否则该角色死亡。",
["Ange"] = "右代宮縁寿",
["&Ange"] = "右代宮縁寿",
["@Ange"] = "海猫鸣泣之时",
["#Ange"] = "反魂の魔女",
["~Ange"] = "对不起，哥哥...",
["designer:Ange"] = "Sword Elucidator",
["cv:Ange"] = "佐藤利奈",
["illustrator:Ange"] = "時火",
}
--利维尔


SE_Jiepi = sgs.CreateTriggerSkill{
    name = "SE_Jiepi",
    frequency = sgs.Skill_NotFrequent,
    events = {sgs.TargetConfirming},
    on_trigger = function(self, event, player, data)
			local room = player:getRoom()
			if event == sgs.TargetConfirming then
				local use = data:toCardUse()
				if not use.card or not use.to:contains(player) or not player:hasSkill(self:objectName()) or not use.from then return false end
				if use.card:isNDTrick() then
					if use.from:getHandcardNum() > player:getHandcardNum() and room:askForSkillInvoke(player, self:objectName(), data) then
						room:broadcastSkillInvoke(self:objectName())
						use.to:removeOne(player)
						data:setValue(use)
					end
				end
				if use.card:isKindOf("DelayedTrick") and use.from:getHandcardNum() < player:getHandcardNum() and room:askForSkillInvoke(player, self:objectName(), data) then
					room:broadcastSkillInvoke(self:objectName())
					room:throwCard(use.card, player, player)
				end
			end

			return false
    end,
  	can_trigger = function(self, target)
			return target
  	end
}

se_zhanjing=sgs.CreateViewAsSkill{
	name="se_zhanjing",
	n = 0,
	view_as = function(self, cards)
		return se_zhanjingcard:clone()
	end,
	enabled_at_play = function(self, player)
		return not player:hasFlag("se_zhanjing_used")
	end,
}

se_zhanjingcard = sgs.CreateSkillCard{
	name = "se_zhanjingcard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		return #targets == 0
	end,
	on_use = function(self, room, source, targets)
		if #targets > 1 then return end
		room:setPlayerFlag(source, "se_zhanjing_used")
		local target = targets[1]
		--if math.random(1,2) == 1 then
			--room:broadcastSkillInvoke("se_zhanjing",1)
		--else
			--room:broadcastSkillInvoke("se_zhanjing",2)
		--end
		room:doLightbox("se_zhanjing1$", 400)
		while target:objectName() ~= source:getNextAlive():objectName() do
			room:getThread():delay(300)
			room:swapSeat(source, source:getNextAlive())
		end
		room:broadcastSkillInvoke("se_zhanjing",3)
		room:doLightbox("se_zhanjing2$", 1200)
		room:swapSeat(source, target)
		local cardNum = target:getHandcardNum()/2
		for i = 1, cardNum do
			local id = room:askForCardChosen(source, target, "h", "se_zhanjing")
			room:throwCard(id, target, source)
		end
		local hp = target:getHp()
		local maxhp = target:getMaxHp()
		if hp > source:getHp() then
			room:loseHp(target)
		end
		--KOF
		if maxhp > source:getMaxHp() and room:getAllPlayers(true):length() > 2 then
			room:loseMaxHp(target)
		end
		if hp <= source:getHp() and maxhp <= source:getMaxHp() then
			local da = sgs.DamageStruct()
			da.from = source
			da.to = target
			da.damage = 1
			room:damage(da)
		end
	end
}

Rivaille:addSkill(SE_Jiepi)
Rivaille:addSkill(se_zhanjing)

sgs.LoadTranslationTable{
["se_zhanjing1$"] = "image=image/animate/se_zhanjing1.png",
["se_zhanjing2$"] = "image=image/animate/se_zhanjing2.png",
["SE_Jiepi"] = "洁癖",
["$SE_Jiepi1"] = "切...脏死了...",
["$SE_Jiepi2"] = "...跟没打扫一样...全部重做！...",
[":SE_Jiepi"] = "你成为手牌多于你的角色的非延时锦囊牌的目标时，你可以取消之。手牌少于你的角色对你使用延时锦囊牌时，你可以弃置之。",
["se_zhanjing"] = "斩颈「身高杀手」",
["$se_zhanjing1"] = "...都长着一张滑稽的脸啊。",
["$se_zhanjing2"] = "给我放老实点。不然我就没办法...漂亮地切下你的肉了好嘛。",
["$se_zhanjing3"] = "（斩颈声）",
[":se_zhanjing"] = "出牌阶段限一次，你可以向右依次交换位置至一名角色右侧，然后弃掉该角色一半（向下取整）数量的手牌。若该角色的体力值大于你的体力值，你令其失去一点体力；若该角色体力上限大于你的体力上限，你令其失去一点体力上限。若该角色体力值和体力上限均不大于你，你对其造成一点伤害。",
["Rivaille"] = "利维尔",
["&Rivaille"] = "利维尔",
["@Rivaille"] = "进击的巨人",
["#Rivaille"] = "兵长",
["~Rivaille"] = "...我不可能知道答案，一直以来都是如此。不管你是相信自己的力量，还是相信那些值得信赖的伙伴所作出的选择，其对应的结果，任何人都不可能预见到。",
["designer:Rivaille"] = "御坂20623",
["cv:Rivaille"] = "神谷浩史",
["illustrator:Rivaille"] = "NA2-A5",
}
--蓝羽浅葱


se_poyi=sgs.CreateViewAsSkill{
	name="se_poyi",
	n = 0,
	view_as = function(self, cards)
		return se_poyicard:clone()
	end,
	enabled_at_play = function(self, player)
		return not player:hasFlag("se_poyi_used")
	end,
}



se_poyicard = sgs.CreateSkillCard{
	name = "se_poyicard",
	target_fixed = true,
	will_throw = true,
	on_use = function(self, room, source, targets)
		if source:hasFlag("se_poyi_used")  then return end
		local AIList = sgs.SPlayerList()
		for _,p in sgs.qlist(room:getOtherPlayers(source)) do
			if p:getAI() ~= nil then
				AIList:append(p)
			end
		end
		if AIList:length() == 0 then
			local log1 =  sgs.LogMessage()
			log1.type = "#se_poyi_NOAI"
			room:sendLog(log1)
			return
		end
		local target1 = room:askForPlayerChosen(source, AIList, "se_poyi1")
		room:resetAI(target1)
		sgs.SE_se_poyi1 = target1
		if not target1 then return end
		local target2 = room:askForPlayerChosen(source, room:getOtherPlayers(target1), "se_poyi2")
		sgs.SE_se_poyi1 = target2
		if not target2 then return end
		room:setPlayerFlag(source, "se_poyi_used")
		--room:broadcastSkillInvoke("se_poyi")
		room:doLightbox("se_poyi$", 800)
		local log3 =  sgs.LogMessage()
		log3.from = source
		log3.arg = target1:getGeneralName()
		log3.type = "#se_poyi_Reset"
		room:sendLog(log3)
		local use = sgs.CardUseStruct()
		local card = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
		use.from = target1
		use.to:append(target2)
		use.card = card
		room:useCard(use, false)
	end
}

SE_Guanli=sgs.CreateTriggerSkill{
	name = "SE_Guanli",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseChanging},
	on_trigger = function(self,event,player,data)
		local room = player:getRoom()
		local Asagi = room:findPlayerBySkillName(self:objectName())
		local change = data:toPhaseChange()
		if change.to == sgs.Player_Start and change.from ~= sgs.Player_Play and not player:hasFlag("SE_Guanli_on") then
			if not Asagi or Asagi:getCardCount(true) == 0 then return end
			local newdata = sgs.QVariant()
			newdata:setValue(player)
			local prompt = string.format("@SE_Guanli:%s", player:objectName())
			if not Asagi:askForSkillInvoke("SE_Guanli", newdata) then return end
			if not room:askForCard(Asagi,"..",prompt,newdata,self:objectName()) then return end
			room:broadcastSkillInvoke("SE_Guanli")
			player:setFlags("SE_Guanli_on")
			local choice = room:askForChoice(Asagi, self:objectName(), "Gl_draw+Gl_play+Gl_discard")
			if choice == "Gl_draw" then
				change.to = sgs.Player_Draw
				data:setValue(change)
				player:insertPhase(sgs.Player_Draw)
			elseif choice == "Gl_play" then
				change.to = sgs.Player_Play
				data:setValue(change)
				player:insertPhase(sgs.Player_Play)
			elseif choice == "Gl_discard" then
				change.to = sgs.Player_Discard
				data:setValue(change)
				player:insertPhase(sgs.Player_Discard)
				--KOF
				if room:getAllPlayers(true):length() == 2 then
					room:loseHp(player)
				end
			end
		elseif change.to == sgs.Player_Finish and player:hasFlag("SE_Guanli_on") then
			player:setFlags("-SE_Guanli_on")
		end
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
}

Asagi:addSkill(se_poyi)
Asagi:addSkill(SE_Guanli)


sgs.LoadTranslationTable{
["se_poyi$"] = "image=image/animate/se_poyi.png",
["#se_poyi_Reset"] = "%from 清除了 %arg 的AI的意识形态",
["#se_poyi_NOAI"] = "场上没有AI角色。",
["se_poyi"] = "破译",
["$se_poyi1"] = "那又怎么了，光是启动而不能控制的话...",
["$se_poyi2"] = "摩古歪，这家伙的形态要素解析已经可以了。",
["$se_poyi3"] = "（摩古歪）还真是一如既往的爱滥用AI的大小姐呢。",
[":se_poyi"] = "出牌阶段限一次，你可以指定一名AI角色X和另一名角色Y，令X的AI重置，然后令X视为对Y使用一张【杀】。 ",
["SE_Guanli"] = "管理",
["$SE_Guanli1"] = "好吧，我稍微有点兴趣，就陪你查一下吧。",
["$SE_Guanli2"] = "缓冲器都用上也无所谓，给我撑住！",
["$SE_Guanli3"] = "...就是这么回事。",
[":SE_Guanli"] = "任意角色回合开始时，你可以弃置一张牌，令该角色立刻执行一个你指定的一个额外阶段。",
["@SE_Guanli"] = "弃掉一张牌令%src获得一个额外的阶段。",
["Gl_draw"] = "摸牌阶段",
["Gl_play"] = "出牌阶段",
["Gl_discard"] = "弃牌阶段",
["Asagi"] = "藍羽浅葱",
["&Asagi"] = "藍羽浅葱",
["@Asagi"] = "噬血狂袭",
["#Asagi"] = "电子の女帝",
["~Asagi"] = "（古城）别过来，浅葱！...",
["designer:Asagi"] = "Sword Elucidator",
["cv:Asagi"] = "瀬戸麻沙美",
["illustrator:Asagi"] = "",
}

--峰理子


function askForChooseSkill(riko)
	local room = riko:getRoom()
	local old_skill = riko:getTag("SE_YirongSkill"):toString()
	if old_skill and riko:hasSkill(old_skill) then
		room:detachSkillFromPlayer(riko, old_skill)
	end
	riko:setTag("SE_YirongSkill", sgs.QVariant())
	local sks = {}
	local all_generals = sgs.Sanguosha:getLimitedGeneralNames()
	for i=1, #all_generals do
		if all_generals[i]=="Ushio" or all_generals[i]=="Nico" or all_generals[i]=="rika2" or all_generals[i]=="mianma" or all_generals[i]=="Chiyo" or all_generals[i]=="Eugen" or all_generals[i]=="Tukasa" or  all_generals[i]=="Sayaka" or all_generals[i]=="Koishi" or all_generals[i]=="Mikoto" or all_generals[i]=="Natsume_Rin" or all_generals[i]=="Kazehaya" or all_generals[i]=="AiAstin" or all_generals[i]=="Reimu" or all_generals[i]=="Louise" or all_generals[i]=="eugeo" then
			table.remove(all_generals, i)
			i = i - 1
		end
	end

	for _,general_name in ipairs(all_generals) do
		local general = sgs.Sanguosha:getGeneral(general_name)
		for _,sk in sgs.qlist(general:getVisibleSkillList()) do
			if not sk:isLordSkill() then
				if sk:getFrequency() == sgs.Skill_Compulsory then
					if sk:getFrequency() ~= sgs.Skill_Wake then
						table.insert(sks, sk:objectName())
					end
				end
			end
		end
	end

	local toAsk = {}
	local i
	while #sks > 0 do
		toAsk = {}
		for i = 1, 10 do
			if #sks > 0 then
				table.insert(toAsk, sks[1])
				table.remove(sks, 1)
			end
		end
		if #sks > 0 then
			table.insert(toAsk, "Buyaozhexie")
		else
			table.insert(toAsk, "Meile")
		end
		if #toAsk > 0 then
			local choice = room:askForChoice(riko, "SE_Yirong%", table.concat(toAsk, "+"))
			if choice ~= "Buyaozhexie" then
				riko:setTag("SE_YirongSkill", sgs.QVariant(choice))
				room:acquireSkill(riko, choice)
				return
			end
		end
	end
end

SE_Yirong = sgs.CreateTriggerSkill{
    name = "SE_Yirong",
	frequency = sgs.Skill_Frequent,
	events = {sgs.GameStart,sgs.EventPhaseStart,sgs.EventLoseSkill},
	priority = -1,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.GameStart then
			player:setTag("SE_YirongSkill", sgs.QVariant())
		elseif event == sgs.EventPhaseStart then
			local phase = player:getPhase()
			if phase == sgs.Player_RoundStart or phase == sgs.Player_Play or phase == sgs.Player_Discard  then
				if room:askForSkillInvoke(player, self:objectName()) then
					room:broadcastSkillInvoke("SE_Yirong")
					askForChooseSkill(player)
				end
			end
		elseif event == sgs.EventLoseSkill then
			local old_skill = player:getTag("SE_YirongSkill"):toString()
			if old_skill and player:hasSkill(old_skill) then
				room:detachSkillFromPlayer(player, old_skill)
			end
			player:setTag("SE_YirongSkill", sgs.QVariant())
		end
	end
}

SE_YirongClear = sgs.CreateDetachEffectSkill{
	name = "SE_Yirong",
	on_skill_detached = function(self, room, player)
		local old_skill = player:getTag("SE_YirongSkill"):toString()
		if old_skill and player:hasSkill(old_skill) then
			room:detachSkillFromPlayer(player, old_skill)
		end
	end,
}


se_youhuo = sgs.CreateViewAsSkill{
	name = "se_youhuo",
	n = 1,
	view_filter = function(self, selected, to_select)
		return #selected < 1 and not to_select:isEquipped()
	end,
	view_as = function(self,cards)
		if #cards == 1 then
			local card = se_youhuocard:clone()
			card:setSkillName(self:objectName())
			card:addSubcard(cards[1])
			return card
		end
	end,
	enabled_at_play = function(self, player)
		return not player:hasFlag("se_youhuo_used") and not player:isKongcheng()
	end,
}

se_youhuocard = sgs.CreateSkillCard{
	name="se_youhuocard",
	will_throw = true,
	filter = function(self, selected, to_select)
		return #selected < 1 and to_select:objectName() ~= sgs.Self:objectName()
	end,
	on_use = function(self,room,source,targets)
		local target = targets[1]
		local choice = room:askForChoice(target, "Youhuo", "se_youhuo_Obtain+se_youhuo_Recovery")
		room:broadcastSkillInvoke("se_youhuo")
		room:doLightbox("se_youhuo$", 1000)
		if choice == "se_youhuo_Obtain" then
			local times = 0
			for _,guy in sgs.qlist(room:getAlivePlayers()) do
				if isBaskervilles(guy) and times < 3 then
					if not target:isNude() then
						local newdata = sgs.QVariant()
						newdata:setValue(guy)
						local prompt = string.format("Allow to obtain card:"..guy:getGeneralName())
						local choice2 = room:askForChoice(source,"Youhuo_Obtain",prompt.."+".."Youhuo_Obtain_Not", newdata)
						if choice2 == prompt then
							local card = room:askForCardChosen(guy,target,"he",self:objectName())
							room:obtainCard(guy, card)
							times = times + 1
						end
					end
				end
			end
		else
			room:loseHp(target, 1)
			local re = sgs.RecoverStruct()
			re.who = source
			room:recover(source, re, true)
		end
		room:setPlayerFlag(source,"se_youhuo_used")
	end
}


Riko:addSkill(SE_Yirong)
Riko:addSkill(SE_YirongClear)
extension:insertRelatedSkills("SE_Yirong", "#SE_Yirong-clear")
Riko:addSkill(se_youhuo)
Riko:addSkill("#SE_Baskervilles_make")

sgs.LoadTranslationTable{
["se_youhuo$"] = "image=image/animate/se_youhuo.png",
["SE_Yirong"] = "易容",
["#SE_Yirong"] = "理子大人要变身成什么呢？",
["Buyaozhexie"] = "不要这些！",
["Meile"] = "再不选没了！",
["$SE_Yirong1"] = "理子明白了！我知道了！原来这么快就就插上FLAG了！",
["$SE_Yirong2"] = "理子·峰·罗宾4世，这是理子的真名。",
["$SE_Yirong3"] = "你猜的没错~正是理子的说~",
[":SE_Yirong"] = "回合开始时，出牌阶段开始时，弃牌阶段开始时，你可以声明当前游戏支持的武将包中的一个锁定技，你获得此锁定技直到下一次声明前。特别地，你不可以声明【灵体】【忍耐】等技能。",
["se_youhuo"] = "诱惑",
["$se_youhuo1"] = "你要是肯「啊~」一下下的话，我会告诉你很多消息哦~",
["$se_youhuo2"] = "这里？还是说...比较喜欢这里？...",
["$se_youhuo3"] = "好棒...好棒哦，金次。金次的这种眼神，让理子兴奋了。",
["$se_youhuo4"] = "呐，你知道嘛，金次？这可是福利场景哦。",
["$se_youhuo5"] = "（舔）谁都不会知道这房间发生什么了哦。",
[":se_youhuo"] = "<font color=\"Sky Blue\"><b>萌战技，3，武侦，</b></font>出牌阶段限一次，你可以弃置一张手牌并指定一名角色，令其选择一项：1、令你允许的参战角色各获得其一张牌。2、失去一点体力并令你回复一点体力。",
["Youhuo_Obtain"] = "令该角色获得目标的牌",
["Youhuo_Obtain_Not"] = "不令其获得牌。",
["se_youhuo_Obtain"] = "令武侦角色获得你的牌",
["se_youhuo_Recovery"] = "失去一点体力，并令理子恢复体力。",
["Allow to obtain card:Aria"] = "令亚里亚获得目标的牌",
["Allow to obtain card:Reki"] = "令雷姬获得目标的牌",
["Allow to obtain card:Riko"] = "令理子获得目标的牌",
["Allow to obtain card:Shirayuki"] = "令白雪获得目标的牌",
["Riko"] = "理子",
["&Riko"] = "理子",
["@Riko"] = "绯弹的亚里亚",
["#Riko"] = "侦探科宅女",
["~Riko"] = "我不会再轻视你们，将视你们为同等的对手。所以，承诺过的约定一定会遵守。要是被我以外的人干掉了我课不会轻饶你们。au revoir！",
["designer:Riko"] = "幻胧之月",
["cv:Riko"] = "伊瀬茉莉也",
["illustrator:Riko"] = "North Abyssor",
}



--时崎狂三


SE_Qidan = sgs.CreateTriggerSkill{
	name = "SE_Qidan",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.GameStart, sgs.EventPhaseStart, sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.GameStart then
			if player:hasSkill(self:objectName()) then
				player:loseAllMarks("@Seven")
				player:loseAllMarks("@Ten")
				player:gainMark("@Seven")
			end
		elseif event == sgs.EventPhaseStart then
			if player:getPhase()==sgs.Player_Start and player:getMark("@Seven") > 0 then
				room:setPlayerFlag(player,"SE_Qidan_Seven")
				if room:askForSkillInvoke(player, self:objectName(), data) then
					local targets = room:getAlivePlayers()
					local target = room:askForPlayerChosen(player,targets,self:objectName())
					room:broadcastSkillInvoke("SE_Qidan")
					room:setPlayerFlag(player,"SE_Qidan_used")
					target:turnOver()
					target:gainMark("@Qidan_attacked", 1)
					if not player:isSkipped(sgs.Player_Play) then
						player:skip(sgs.Player_Play)
					end
					if not player:isSkipped(sgs.Player_Discard) then
						player:skip(sgs.Player_Discard)
					end
				end
			end
		elseif event == sgs.EventPhaseEnd then
			if player:getPhase()==sgs.Player_Finish and player:getMark("@Seven") > 0 and player:hasFlag("SE_Qidan_Seven") then
				if player:hasFlag("SE_Qidan_used") then
					player:drawCards(1)
				end
				player:loseAllMarks("@Seven")
				player:gainMark("@Ten")
			end
		end
	end
}

SE_Shidan = sgs.CreateTriggerSkill{
	name = "SE_Shidan",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart, sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.EventPhaseStart then
			if player:getPhase()==sgs.Player_Start and player:getMark("@Ten") > 0 then
				room:setPlayerFlag(player,"SE_Shidan_Ten")
				if room:askForSkillInvoke(player, self:objectName(), data) then
					local targets = room:getAlivePlayers()
					local target = room:askForPlayerChosen(player,targets,self:objectName())
					room:doLightbox("SE_Shidan$", 800)
					--KOF
					if target:getMark("@Qidan_attacked") > 0 and room:getAllPlayers(true):length() > 2 then
						local damage = sgs.DamageStruct()
						damage.nature = sgs.DamageStruct_Fire
						damage.from = player
						damage.damage = 2
						damage.to = target
						room:broadcastSkillInvoke("SE_Shidan")
						room:damage(damage)
					else
						local use = sgs.CardUseStruct()
						local card = sgs.Sanguosha:cloneCard("fire_slash", sgs.Card_NoSuit, 0)
						card:setSkillName(self:objectName())
						use.from = player
						use.to:append(target)
						use.card = card
						room:useCard(use, false)
					end
					if not player:isSkipped(sgs.Player_Play) then
						player:skip(sgs.Player_Judge)
					end
					if not player:isSkipped(sgs.Player_Discard) then
						player:skip(sgs.Player_Draw)
					end
				end
			end
		elseif event == sgs.EventPhaseEnd then
			if player:getPhase()==sgs.Player_Finish and player:getMark("@Ten") > 0 and player:hasFlag("SE_Shidan_Ten") then
				player:loseAllMarks("@Ten")
				player:gainMark("@Seven")
				for _,p in sgs.qlist(room:getAlivePlayers()) do
					if p:getMark("@Qidan_attacked") > 0 then
						p:loseAllMarks("@Qidan_attacked")
					end
				end
			end
		end
	end
}

SE_Badan = sgs.CreateTriggerSkill{
	name = "SE_Badan",
	frequency = sgs.Skill_Limited,
	limit_mark = "@Eight",
	events = {sgs.EventPhaseChanging},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.EventPhaseChanging then
			local change = data:toPhaseChange()
			if player:hasSkill(self:objectName()) and change.to == sgs.Player_Start and player:getMark("@Eight") > 0 then
				if room:askForSkillInvoke(player, self:objectName(), data) then
					room:broadcastSkillInvoke("SE_Badan")
					room:doLightbox("SE_Badan$", 3000)
					player:loseAllMarks("@Eight")
					room:setPlayerProperty(player, "hp", sgs.QVariant(3))
					local choice = room:askForChoice(player,self:objectName(),"SE_Badan_Odd+SE_Badan_Oven")
					if choice == "SE_Badan_Odd" then
						player:loseAllMarks("@Seven")
						player:loseAllMarks("@Ten")
						player:gainMark("@Seven")
					elseif choice == "SE_Badan_Oven" then
						player:loseAllMarks("@Seven")
						player:loseAllMarks("@Ten")
						player:gainMark("@Ten")
					end
				end
			end
		end
	end
}

Kurumi:addSkill(SE_Qidan)
Kurumi:addSkill(SE_Shidan)
Kurumi:addSkill(SE_Badan)

sgs.LoadTranslationTable{
["SE_Shidan$"] = "image=image/animate/SE_Shidan.png",
["SE_Badan$"] = "image=image/animate/SE_Badan.png",
["@Seven"] = "奇数回合",
["@Ten"] = "偶数回合",
["@Eight"] = "八弹",
["@Qidan_attacked"] = "七弹目标",
["SE_Qidan"] = "七弹",
["$SE_Qidan1"] = "要想杀死某样东西，自己却没有被杀的觉悟。你不认为奇怪吗？",
["$SE_Qidan2"] = "啊，啊，失算了，失算了。虽然还想享受一会儿和士道的约会...",
["$SE_Qidan"] = "",
["$SE_Qidan"] = "",
[":SE_Qidan"] = "奇数回合的准备阶段开始时，你可以跳过你的出牌阶段和弃牌阶段并指定一名其他角色，令其武将牌翻面。若如此做，此回合结束阶段开始时，你摸一张牌。",
["SE_Shidan"] = "十弹",
["$SE_Shidan1"] = "把枪口对准生命，就是...这样一回事哦。",
["$SE_Shidan2"] = "但是，没办法呢。",
["$SE_Shidan"] = "",
[":SE_Shidan"] = "偶数回合的准备阶段开始时，你可以跳过你的判定阶段和摸牌阶段并指定一名其他角色，视为对其使用一张火【杀】。若该角色为上回合使用“七弹”的目标，改为你对其直接造成2点火属性伤害。",
["SE_Badan"] = "八弹",
["$SE_Badan"] = "不是哦。我还是让时间倒流了而已。来吧来吧，开始吧~",
[":SE_Badan"] = "限定技。回合开始时，你可以将体力值回复至3，并重置你当前的回合为奇数或偶数。",
["SE_Badan_Odd"] = "设定为奇数回合",
["SE_Badan_Oven"] = "设定为偶数回合",
["Kurumi"] = "时崎狂三",
["&Kurumi"] = "时崎狂三",
["@Kurumi"] = "Date A Live",
["#Kurumi"] = "NightMare",
["~Kurumi"] = "（士道）琴里，这样下去她真的会死的！用不杀精灵的方法解决问题，这才是拉塔托斯克吧！",
["designer:Kurumi"] = "御坂20623",
["cv:Kurumi"] = "真田麻美",
["illustrator:Kurumi"] = "入绘由君（君君々）",
}



--木之本樱


local function searchBaibianForSkill(card)
	local suit = card:getSuit()
	local number = card:getNumber()
	if suit == sgs.Card_Spade then

		if number == 1 then return "zhuren"
		elseif number == 2 then return "haixing"
		elseif number == 3 then return "SE_Zhixing"
		elseif number == 4 then return "huanxing"
		elseif number == 5 then return "kuisi"
		elseif number == 6 then return "paoji"
		elseif number == 7 then return "kongdi"
		elseif number == 8 then return "nuequ"
		elseif number == 9 then return "fanqian"
		elseif number == 10 then return "fanghuo"
		elseif number == 11 then return "taxian"
		elseif number == 12 then return "goutong"
		elseif number == 13 then return "kangfen" end

	elseif suit == sgs.Card_Club then

		if number == 1 then return "nangua"
		elseif number == 2 then return "jixian"
		elseif number == 3 then return "ningju"
		elseif number == 4 then return "tianzi"
		elseif number == 5 then return "se_nitian"
		elseif number == 6 then return "se_guwu"
		elseif number == 7 then return "se_qiangjing"
		elseif number == 8 then return "se_zhifu"
		elseif number == 9 then return "se_nike"
		elseif number == 10 then return "se_kuangquan"
		elseif number == 11 then return "se_qianlei"
		elseif number == 12 then return "se_shuacun"
		elseif number == 13 then return "jinghua" end

	elseif suit == sgs.Card_Heart then

		if number == 1 then return "Huansha"
		elseif number == 2 then return "SE_Shanguang"
		elseif number == 3 then return "SE_Dixian"
		elseif number == 4 then return "shouren"
		elseif number == 5 then return "se_shengjian"
		elseif number == 6 then return "se_qidian"
		elseif number == 7 then return "SE_Zhuzhen"
		elseif number == 8 then return "SE_Huifu"
		elseif number == 9 then return "SE_Mengfeng"
		elseif number == 10 then return "SE_Nagong"
		elseif number == 11 then return "se_dushe"
		elseif number == 12 then return "SE_Qifen"
		elseif number == 13 then return "SE_Feiti" end

	elseif suit == sgs.Card_Diamond then

		if number == 1 then return "SE_Zishang"
		elseif number == 2 then return "SE_Shouzang"
		elseif number == 3 then return "SE_Shuangqiang"
		elseif number == 4 then return "se_poyi"
		elseif number == 5 then return "SE_Guanli"
		elseif number == 6 then return "SE_Zhandan"
		elseif number == 7 then return "LuaShenzhi"
		elseif number == 8 then return "LuaZhuan"
		elseif number == 9 then return "LuaBuwu"
		elseif number == 10 then return "LuaWangxiang"
		elseif number == 11 then return "LLJ_reality"
		elseif number == 12 then return "LuaJingming"
		elseif number == 13 then return "luasaoshe" end

	end
end

SE_Baibian = sgs.CreateTriggerSkill{
	name = "SE_Baibian", --必须
	frequency = sgs.Skill_Frequent,
	events = {sgs.TurnStart, sgs.GameStart}, --必须
	on_trigger = function(self, event, player, data) --必须
		if player:isAlive() and player:hasSkill(self:objectName()) then
			local room = player:getRoom()
			if event == sgs.TurnStart then
				for _,askill in sgs.qlist(player:getVisibleSkillList()) do
					if askill:objectName() ~= "SE_Baibian" and askill:objectName() ~= "SE_Kuluo" then
						room:detachSkillFromPlayer(player,askill:objectName())
					end
				end
				if player:getMaxHp() > 6 then room:setPlayerProperty(player, "maxhp", sgs.QVariant(6)) end
				if player:getMaxHp() < 3 then room:setPlayerProperty(player, "maxhp", sgs.QVariant(3)) end
				if player:getHp() < player:getMaxHp() and room:askForSkillInvoke(player, self:objectName()) then
					local num = player:getMaxHp() - player:getHp()
					if room:getDrawPile():length()< num then room:swapPile() end
					local cards = room:getDrawPile()
					room:broadcastSkillInvoke("SE_Baibian")
					room:doLightbox("SE_Baibian$", 1200)
					for i = 1, num , 1 do
						local cardsid1=cards:at(i-1)
						room:showCard(player,cardsid1)
						local card=sgs.Sanguosha:getCard(cardsid1)
						local skillName = searchBaibianForSkill(card)
						room:acquireSkill(player,skillName)
						room:obtainCard(player, card)
					end
				end
			elseif event == sgs.GameStart then
				if room:getAllPlayers(true):length() == 2 then
					room:detachSkillFromPlayer(player, "SE_Kuluo")
				end
			end
		end
	end,
}

SE_Kuluo = sgs.CreateMaxCardsSkill{
	name = "SE_Kuluo",
	extra_func = function(self, player)
		if player:hasSkill(self:objectName()) then
			return 52 - player:getHp()
		end
	end
}

Sakura:addSkill(SE_Baibian)
Sakura:addSkill(SE_Kuluo)

sgs.LoadTranslationTable{
["SE_Baibian$"] = "image=image/animate/SE_Baibian.png",
["SE_Baibian"] = "百变",
["$SE_Baibian1"] = "【盾】",
["$SE_Baibian2"] = "【风】",
["$SE_Baibian3"] = "【浮】",
["$SE_Baibian4"] = "【歌】",
["$SE_Baibian5"] = "【幻】",
["$SE_Baibian6"] = "【剑】",
["$SE_Baibian7"] = "【力】",
["$SE_Baibian8"] = "【水】",
["$SE_Baibian9"] = "【雨】",
[":SE_Baibian"] = "准备阶段开始时，你需失去所有“百变”和“库洛”以外的技能；若你的体力上限大于6，将你的体力上限设定为6；若你的体力上限小于3，将你的体力上限设定为3。你可以翻开牌堆顶X张牌（X为你失去的你的体力值），根据翻开的牌获得技能，然后获得这些手牌。",--\n<font color=\"red\"><b>♠</b></font>：A，无双，2，烈弓，3，再起，4，奸雄，5，急智，6，奇袭，7，铁骑，8，遗计，9，咆哮，10，死战，J，青囊，Q，绝境，K，八阵\n♥：A，火计，2，空城，3，天香，4，流离，5，节命，6，放逐，7，天义，8，英魂，9，帷幕，10，挑衅，J，享乐，Q，激昂，K，悲歌\n♣：A，龙魂，2，连破，3，枭姬，4，离间，5，据守，6，断粮，7，智迟，8，甘露，9，疠火，10，弓骑，J，当先，Q，智愚，K，称象\n♦：A，求援，2，御策，3，缓释，4，血祭，5，离魂，6，漫卷，7，昭烈，8，扶乱，9，倾城，10，裸衣，J，绝汲，Q，争功，K，固守。",
["SE_Kuluo"] = "库洛",
["$SE_Kuluo"] = "",
[":SE_Kuluo"] = "锁定技。你的手牌上限为52。",
["Sakura"] = "木之本樱",
["&Sakura"] = "木之本樱",
["@Sakura"] = "魔卡少女樱",
["#Sakura"] = "初代萌王",
["~Sakura"] = "【影】",
["designer:Sakura"] = "幽灵;御坂;萝莉姬",
["cv:Sakura"] = "丹下桜",
["illustrator:Sakura"] = "",
}

--优吉欧

--忍耐
SE_Rennai = sgs.CreateTriggerSkill{
	name = "SE_Rennai",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DamageInflicted, sgs.PreHpLost, sgs.EventPhaseStart, sgs.Death},
	priority = 2,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.DamageInflicted then
			if player:hasSkill(self:objectName()) and player:getMark("@Patience") == 0 then
				room:loseHp(player)
				room:doLightbox("SE_Rennai$", 800)
				player:gainMark("@Patience")
				room:acquireSkill(player, "se_qingqiangwei", true)
				return true
			elseif player:hasSkill(self:objectName()) and player:getMark("@Patience") > 0 then
				return true
			end
		elseif event == sgs.PreHpLost then
			if player:hasSkill(self:objectName()) and player:getMark("@Patience") > 0 then
				return true
			end
		elseif event == sgs.EventPhaseStart then
			if player:getPhase() == sgs.Player_RoundStart then
				if player:getMark("@Patience") > 0 then
					player:loseAllMarks("@Patience")
				end
				for _,p in sgs.qlist(room:getAlivePlayers()) do
					if p:getMark("@Frozen_Eu") then p:loseMark("@Frozen_Eu") end
				end
				if player:hasSkill("SE_Zhanfang") then
					room:detachSkillFromPlayer(player, "SE_Zhanfang")
				end
			end
		elseif event == sgs.Death then
			local death = data:toDeath()
			if death.who:hasSkill(self:objectName()) then
				for _,p in sgs.qlist(room:getAlivePlayers()) do
					if p:getMark("@Frozen_Eu") then p:loseMark("@Frozen_Eu") end
				end
			end
		end
		return false
	end
}
--青蔷薇
se_qingqiangwei = sgs.CreateViewAsSkill{
	name = "se_qingqiangwei",
	n = 0,
	view_as = function(self, cards)
		local card = se_qingqiangweicard:clone()
		card:setSkillName(self:objectName())
		return card
	end,
	enabled_at_play = function(self, player)
		return not player:hasUsed("#se_qingqiangweicard")
	end
}
se_qingqiangweicard = sgs.CreateSkillCard{
	name = "se_qingqiangweicard",
	target_fixed = true,
	will_throw = true,
	on_use = function(self, room, source, targets)
		--room:broadcastSkillInvoke("se_qingqiangwei")
		room:doLightbox("se_qingqiangwei$", 1500)
		local wore = 0
		for _,p in sgs.qlist(room:getAlivePlayers()) do
			if p:getMark("@Yuzorano") > 0 then
				if room:askForSkillInvoke(p, "Yuzora_Qingqiangwei") then
					wore = 1
				end
			end
		end
		for _,p in sgs.qlist(room:getAlivePlayers()) do
			local dist = source:distanceTo(p)
			if dist <= source:getMaxHp() - source:getHp() + 1 + wore then
				p:gainMark("@Frozen_Eu")
				room:setPlayerProperty(p, "chained", sgs.QVariant(true))
			end
		end
		room:acquireSkill(source, "SE_Zhanfang", true)
		room:detachSkillFromPlayer(source, "se_qingqiangwei")
	end
}

SE_Zhanfang = sgs.CreateTriggerSkill{
	name = "SE_Zhanfang",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DamageCaused},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.DamageCaused then
			local damage = data:toDamage()
			if damage.from and damage.from:getMark("@Frozen_Eu") > 0 and damage.nature == sgs.DamageStruct_Normal then
				local mygod= room:findPlayerBySkillName("SE_Zhanfang")
				if mygod then
					if mygod:isAlive() then
						local damage1 = sgs.DamageStruct()
						for _,p in sgs.qlist(room:getAlivePlayers()) do
							if p:getMark("@Frozen_Eu") > 0 then
								damage1.from = nil
								damage1.to = p
								room:setEmotion(p, "skills/ice")
								room:damage(damage1)
							end
						end
					end
				end
			end
			if damage.from and damage.from:getMark("@Frozen_Eu") > 0 and damage.nature == sgs.DamageStruct_Fire then
				local mygod = room:findPlayerBySkillName("SE_Zhanfang")
				if mygod then
					damage.from:loseMark("@Frozen_Eu")
				 	return true
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}


-- Eugeo:addSkill(SE_Rennai)
-- Eugeo:addSkill(SE_Huajian)
-- extension:addToSkills(se_qingqiangwei)
-- extension:addToSkills(SE_Zhanfang)
-- extension:addToSkills(SE_Huajian_ed)

--古手梨花

SE_Shenghua = sgs.CreateTriggerSkill{
	name = "SE_Shenghua",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if player:isAlive() then
			if event == sgs.EventPhaseStart then
				if player:getPhase() == sgs.Player_RoundStart then
					if player:hasSkill("suipian") then
						room:detachSkillFromPlayer(player, "suipian")
					end
					if player:hasSkill("qiji") then
						room:detachSkillFromPlayer(player, "qiji")
					end
					if player:askForSkillInvoke(self:objectName(),data) then
						room:broadcastSkillInvoke("SE_Shenghua")
						local choice = room:askForChoice(player,"SE_Shenghua","Shenghua_suipian+Shenghua_qiji")
						if choice == "Shenghua_suipian" then
							room:acquireSkill(player, "suipian")
						else
							room:acquireSkill(player, "qiji")
						end
					end
				end
			end
		end
	end
}

SE_Wumai = sgs.CreateTriggerSkill{
	name = "SE_Wumai",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Damaged, sgs.DamageInflicted},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.Damaged then
			if player:isAlive() and player:hasSkill(self:objectName()) then
				local da = data:toDamage()
				if not da.from or da.from:isNude() then return end
				if not player:askForSkillInvoke(self:objectName(),data) then return end
				room:broadcastSkillInvoke("SE_Wumai")
				local card
				for i = 1, da.damage do
					card = room:askForCardChosen(player, da.from, "he", self:objectName())
					if not card then return end
					player:addToPile("Fragments", card)
				end
			end
		elseif event == sgs.DamageInflicted then
			if player:isAlive() and player:hasSkill(self:objectName()) then
				if player:getPile("Fragments"):length() == 0 then return end
				if not player:askForSkillInvoke(self:objectName(),data) then return end
				local da = data:toDamage()
				if da.card == nil then return end
				local Suit = da.card:getSuitString()
				local judge = sgs.JudgeStruct()
				judge.pattern = ".|"..Suit
				judge.good = true
				judge.reason = self:objectName()
				judge.who = player
				judge.play_animation = true
				judge.time_consuming = true
				room:judge(judge)
				if judge.card:getSuit() == da.card:getSuit() then
					player:addToPile("Fragments", judge.card)
				else
					player:drawCards(1)
				end
			end
		end
		return false
	end
}

SE_WumaiClear = sgs.CreateDetachEffectSkill{
	name = "SE_Wumai",
	pilename = "Fragments",
}

SE_Poxiao = sgs.CreateTriggerSkill{
	name = "SE_Poxiao",
	frequency = sgs.Skill_Wake,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if player:isAlive() then
			if event == sgs.EventPhaseStart then
				if player:getPhase() == sgs.Player_RoundStart then
					if player:getPile("Fragments"):length() > player:getHandcardNum() and not player:hasSkill("se_mipa") then
						room:setPlayerProperty(player, "maxhp", sgs.QVariant(player:getMaxHp()+1))
						room:broadcastSkillInvoke("SE_Poxiao")
						room:doLightbox("SE_Poxiao$", 3000)
						if player:hasSkill("suipian") then
							room:detachSkillFromPlayer(player, "suipian")
						end
						if player:hasSkill("qiji") then
							room:detachSkillFromPlayer(player, "qiji")
						end
						if player:hasSkill("SE_Shenghua") then
							room:detachSkillFromPlayer(player, "SE_Shenghua")
						end
						room:acquireSkill(player, "se_mipa")
					end
				end
			end
		end
	end
}

se_mipaVS = sgs.CreateViewAsSkill{
	name = "se_mipa",
	n = 0,
	view_as = function(self, cards)
		return se_mipacard:clone()
	end,
	enabled_at_play = function(self, player)
		return player:getPile("Fragments"):length() >0
	end,
}

se_mipacard = sgs.CreateSkillCard{
	name = "se_mipacard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		return #targets == 0 and (to_select:getMark("@mipa_basic") == 0 or to_select:getMark("@mipa_notbasic") == 0)
	end,
	on_use = function(self, room, source, targets)
		local target = targets[1]
		local Fragments = source:getPile("Fragments")
		room:fillAG(Fragments, source)
		id = room:askForAG(source, Fragments, false, self:objectName())
		room:clearAG(source)
		if id == -1 then
			return
		end
		--room:broadcastSkillInvoke("se_mipa")
		room:doLightbox("se_mipa$", 800)
		local card = sgs.Sanguosha:getCard(id)
		room:throwCard(card, nil, nil)
		local choice
		if target:getMark("@mipa_basic") > 0 then choice = "Mipa_NotBasic"
		elseif target:getMark("@mipa_notbasic") > 0 then choice = "Mipa_Basic"
		else choice = room:askForChoice(source,"se_mipa","Mipa_Basic+Mipa_NotBasic") end
		if choice == nil then return end
		if choice == "Mipa_Basic" then
			target:gainMark("@mipa_basic")
			room:setPlayerCardLimitation(target, "use,response", "BasicCard", false)
		else
			target:gainMark("@mipa_notbasic")
			room:setPlayerCardLimitation(target, "use,response", "^BasicCard", false)
		end
	end,
}

se_mipa = sgs.CreateTriggerSkill{
	name = "se_mipa",
	view_as_skill = se_mipaVS,
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart, sgs.Death},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if player:isAlive() then
			if event == sgs.EventPhaseStart then
				if player:getPhase() == sgs.Player_RoundStart then
					for _,p in sgs.qlist(room:getAlivePlayers()) do
						if p:getMark("@mipa_basic") > 0 then
							p:loseMark("@mipa_basic")
							room:removePlayerCardLimitation(p, "use,response", "BasicCard")
						end
						if p:getMark("@mipa_notbasic") > 0 then
							p:loseMark("@mipa_notbasic")
							room:removePlayerCardLimitation(p, "use,response", "^BasicCard")
						end
					end
				end
			elseif event == sgs.Death then
				local death = data:toDeath()
				if death.who:hasSkill("se_mipa") then
					for _,p in sgs.qlist(room:getAlivePlayers()) do
						if p:getMark("@mipa_basic") > 0 then
							p:loseMark("@mipa_basic")
							room:removePlayerCardLimitation(p, "use,response", "BasicCard")
						end
						if p:getMark("@mipa_notbasic") > 0 then
							p:loseMark("@mipa_notbasic")
							room:removePlayerCardLimitation(p, "use,response", "^BasicCard")
						end
					end
				end
			end
		end
	end
}

se_mipaClear = sgs.CreateDetachEffectSkill{
	name = "se_mipa",
	on_skill_detached = function(self, room, player)
		for _,p in sgs.qlist(room:getAlivePlayers()) do
			if p:getMark("@mipa_basic") > 0 then
				p:loseMark("@mipa_basic")
				room:removePlayerCardLimitation(p, "use,response", "BasicCard")
			end
			if p:getMark("@mipa_notbasic") > 0 then
				p:loseMark("@mipa_notbasic")
				room:removePlayerCardLimitation(p, "use,response", "^BasicCard")
			end
		end
	end,
}


Rika:addSkill(SE_Shenghua)
Rika:addSkill(SE_Wumai)
Rika:addSkill(SE_WumaiClear)
extension:insertRelatedSkills("SE_Wumai", "#SE_Wumai-clear")
Rika:addSkill(SE_Poxiao)
extension:addToSkills(se_mipa)
extension:addToSkills(se_mipaClear)
extension:insertRelatedSkills("se_mipa", "#se_mipa-clear")
Rika:addWakeTypeSkillForAudio("se_mipa")

sgs.LoadTranslationTable{
["SE_Poxiao$"] = "image=image/animate/SE_Poxiao.png",
["se_mipa$"] = "image=image/animate/se_mipa.png",
["SE_Shenghua"] = "升华",
["$SE_Shenghua1"] = "要不要来上一拳让她吐出来？",
["$SE_Shenghua2"] = "不知为何感觉十分不爽呢！",
["$SE_Shenghua3"] = "别管那么多，照我说的做！（背景音：发抖中的羽入）",
["$SE_Shenghua4"] = "我就不告诉你，谁让我是坏人呢~",
[":SE_Shenghua"] = "回合开始时，你可以选择“碎片筛选”或“奇迹宣言”，若如此做，直到你的下个回合开始，你视为拥有该技能。",
["Shenghua_suipian"] = "碎片筛选",
["Shenghua_qiji"] = "奇迹宣言",
["Mipa_Basic"] = "该角色在你的下一回合前无法使用基本牌。",
["Mipa_NotBasic"] = "该角色在你的下一回合前无法使用非基本牌。",
["SE_Wumai"] = "雾霾",
["$SE_Wumai1"] = "话说...这不完全没有了结吗OTL",
["$SE_Wumai2"] = "虽然我有过许多痛苦的回忆，但多亏了这些回忆，我才能像这样和大家在一起。",
["$SE_Wumai3"] = "这样也好，就算你们不主动涉足，惩罚依旧会来临...因为，绵流祭即将开始...",
["$SE_Wumai4"] = "这个世界不需要败者，这就是古手梨花在追寻奇迹的千百年之旅的尽头中找到的答案。",
["$SE_Wumai5"] = "你选择的是生，还是死。",
["$SE_Wumai6"] = "我到底该怎么办...该怎么办...",
[":SE_Wumai"] = "每当你受到1点伤害后，你可以将伤害来源的一张牌置于你的武将牌上，称为“碎片”。每当你受到一次伤害时，若你有“碎片”时，你可以进行一次判定：若结果与造成伤害的牌花色相同，你将其加入“碎片”；若不同，你摸一张牌。",
["SE_Poxiao"] = "破晓",
["$SE_Poxiao1"] = "我要回到属于我的雏见泽，我有着非常重要的工作，而且...如果不回去的话，我就再也见不到羽入了。我最最最喜欢羽入了~咪啪~（背景音：羽入哽咽中）",
["$SE_Poxiao2"] = "看来我不得不放弃成为魔女了，现在的我必须舍弃身为贝伦卡斯特尔的魔女身份，回到古手梨花的位置上来了。",
[":SE_Poxiao"] = "觉醒技。回合开始时，若你的“碎片”大于你的手牌数，你须增加1点体力上限，然后你失去“升华”并获得“咪啪”。",
["se_mipa"] = "咪啪",
["@mipa_basic"] = "咪啪-基本牌",
["@mipa_notbasic"] = "咪啪-非基本牌",
["$se_mipa1"] = "（大梨花）咪啪~（小梨花）咪啪~（大梨花）咪啪~（小梨花）咪啪~（梨花合奏）咪啪~~~",
[":se_mipa"] = "出牌阶段，你可以弃置1枚“碎片”并指定一名角色，直到你的下个回合开始前，你选择一项：令该角色不能使用或打出基本牌，或令该角色不能使用非锦囊牌。",
["Rika"] = "古手梨花",
["&Rika"] = "古手梨花",
["@Rika"] = "寒蝉鸣泣之时",
["#Rika"] = "御社神の巫女",
["~Rika"] = "（背景音：蝉鸣）今天，是举行绵流祭的日子...",
["designer:Rika"] = "黑猫roy",
["cv:Rika"] = "田村ゆかり",
["illustrator:Rika"] = "ナナムラ",
}

--死灵法师


luaqicetrick={
	--"slash",
	--"fire_slash",
	--"thunder_slash",
	--"jink",
	--"analeptic",
	--"nullification",
	"snatch",
	"dismantlement",
	"collateral",
	"ex_nihilo",
	"duel",
	"fire_attack",
	--"peach",
	"amazing_grace",
	"savage_assault",
	"archery_attack",
	"god_salvation",
	"iron_chain"
}
qicepattern=""
qicechoice=""

luaqice_card=sgs.CreateSkillCard{
	name="luaqice_card",
	target_fixed=true,
	will_throw=false,
	on_use=function(self,room,source,targets)
		local cardlist=""
		for _,cd in ipairs(luaqicetrick) do
			cardlist=cardlist..cd.."+"
		end
		can_slash = false
		for _,p in sgs.qlist(room:getAlivePlayers()) do
			local slash = sgs.Sanguosha:cloneCard("Slash")
			if source:canSlash(p) and not p:isCardLimited(slash, sgs.Card_MethodUse) and not p:isProhibited(source, slash, source:getSiblings()) and  source:canSlashWithoutCrossbow()  then can_slash = true end
		end
		if can_slash then cardlist=cardlist.."slash+fire_slash+thunder_slash+" end
		if source:getHp() < source:getMaxHp() then cardlist=cardlist.."peach+" end
		local analeptic = sgs.Sanguosha:cloneCard("Analeptic")
		if not source:isCardLimited(analeptic, sgs.Card_MethodUse) then cardlist=cardlist.."analeptic+" end
		cardlist=cardlist.."cancel"
		qicepattern=room:askForChoice(source,"luaqice",cardlist)
		if qicepattern=="" or qicepattern=="cancel" then return end
		if qicepattern=="ex_nihilo" or qicepattern=="peach" or qicepattern=="amazing_grace" or qicepattern=="savage_assault" or qicepattern=="archery_attack" or qicepattern=="god_salvation" then
			if source:getHandcardNum() + source:getEquips():length() >= 2 then
				--[[qicechoice = room:askForChoice(source, "luaqice_single", "qice_zero+qice_two")
			else
				qicechoice = "qice_zero"]]
				qicechoice = "qice_two"
			end
		end
		room:setPlayerFlag(source,"luaqicechosen")
		room:broadcastSkillInvoke("luaqice")
		room:askForUseCard(source,"@@luaqice","#luaqice:"..qicepattern)
		room:setPlayerFlag(source,"-luaqicechosen")
	end,
}

sgs.chenyanPattern = {"pattern"}
se_chenyan = sgs.CreateViewAsSkill{
	name = "se_chenyan",
	n=999,
	view_filter=function(self,selected,to_select)
		return true
	end,
	view_as = function(self, cards)
		local pattern = sgs.chenyanPattern[1]
		if #cards==0 then
			if pattern == "slash" then
				local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit,0)
				local slash_e = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit,0)
				slash:addSubcard(slash_e)
				slash:setSkillName("luaqice1")
				return slash
			elseif pattern == "jink" then
				local jink = sgs.Sanguosha:cloneCard("jink", sgs.Card_NoSuit,0)
				local jink_e = sgs.Sanguosha:cloneCard("jink", sgs.Card_NoSuit,0)
				jink:addSubcard(jink_e)
				jink:setSkillName("luaqice1")
				return jink
			elseif pattern == "peach" then
				local peach = sgs.Sanguosha:cloneCard("peach", sgs.Card_NoSuit,0)
				local peach_e = sgs.Sanguosha:cloneCard("peach", sgs.Card_NoSuit,0)
				peach:addSubcard(peach_e)
				peach:setSkillName("luaqice1")
				return peach
			elseif pattern == "nullification" then
				local nullification = sgs.Sanguosha:cloneCard("nullification", sgs.Card_NoSuit,0)
				local nullification_e = sgs.Sanguosha:cloneCard("nullification", sgs.Card_NoSuit,0)
				nullification:addSubcard(nullification_e)
				nullification:setSkillName("luaqice1")
				return nullification
			end
		elseif #cards==2 then
			if pattern == "slash" then
				local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit,0)
				slash:addSubcard(cards[1])
				slash:addSubcard(cards[2])
				slash:setSkillName("luaqice")
				return slash
			elseif pattern == "jink" then
				local jink = sgs.Sanguosha:cloneCard("jink", sgs.Card_NoSuit,0)
				local jink_e = sgs.Sanguosha:cloneCard("jink", sgs.Card_NoSuit,0)
				jink:addSubcard(cards[1])
				jink:addSubcard(cards[2])
				jink:setSkillName("luaqice")
				return jink
			elseif pattern == "peach" then
				local peach = sgs.Sanguosha:cloneCard("peach", sgs.Card_NoSuit,0)
				local peach_e = sgs.Sanguosha:cloneCard("peach", sgs.Card_NoSuit,0)
				peach:addSubcard(cards[1])
				peach:addSubcard(cards[2])
				peach:setSkillName("luaqice")
				return peach
			elseif pattern == "nullification" then
				local nullification = sgs.Sanguosha:cloneCard("nullification", sgs.Card_NoSuit,0)
				local nullification_e = sgs.Sanguosha:cloneCard("nullification", sgs.Card_NoSuit,0)
				nullification:addSubcard(cards[1])
				nullification:addSubcard(cards[2])
				nullification:setSkillName("luaqice")
				return nullification
			end
		end
	end,
	enabled_at_play=function()
		return false
	end,
	enabled_at_response = function(self, player, pattern)
		if (pattern == "jink" and not sgs.Self:hasFlag("qiceused") ) or (pattern == "slash" and not sgs.Self:hasFlag("qiceused")) or (pattern == "nullification" and not sgs.Self:hasFlag("qiceused")) or (pattern == "peach" and not sgs.Self:hasFlag("qiceused") ) then
			sgs.chenyanPattern = {pattern}
			return true
		end
		return false
	end,
	enabled_at_nullification = function(self, player)
		if not player:hasFlag("qiceused") then
			sgs.chenyanPattern = {"nullification"}
			return true
		end
		return false
	end
}
--[[
luaqice=sgs.CreateViewAsSkill{
	name="luaqice",
	n=999,
	view_filter=function(self,selected,to_select)
		return sgs.Self:hasFlag("luaqicechosen")
	end,
	view_as=function(self,cards)
		if #cards==0 and not sgs.Self:hasFlag("luaqicechosen") then
			return luaqice_card:clone()
		end
		if qicechoice ~= "" then
			if qicechoice == "qice_zero" then
				if #cards==0 then
					local acard=sgs.Sanguosha:cloneCard(qicepattern,sgs.Card_NoSuit,0)
					acard:setSkillName("luaqice1")
					qicechoice = ""
					return acard
				end
			if qicechoice == "qice_two" then
				if #cards==2 then
					local suittable={}
					for i=1,#cards,1 do
						table.insert(suittable,cards[i]:getSuit())
					end
					local suit
					if #suittable==1 then suit=suittable[1] else suit=sgs.Card_NoSuit end
					local acard=sgs.Sanguosha:cloneCard(qicepattern,suit,0)
					for i=1,#cards,1 do acard:addSubcard(cards[i]:getId()) end
					acard:setSkillName("luaqice")
					qicechoice = ""
					return acard
				end
			end
		else
			if #cards==0 then
				local acard=sgs.Sanguosha:cloneCard(qicepattern,sgs.Card_NoSuit,0)
				acard:setSkillName("luaqice1")
				return acard
			elseif #cards==2 then
				local suittable={}
				for i=1,#cards,1 do
					table.insert(suittable,cards[i]:getSuit())
				end
				local suit
				if #suittable==1 then suit=suittable[1] else suit=sgs.Card_NoSuit end
				local acard=sgs.Sanguosha:cloneCard(qicepattern,suit,0)
				for i=1,#cards,1 do acard:addSubcard(cards[i]:getId()) end
				acard:setSkillName("luaqice")
				return acard
			end
		end
	end,
	enabled_at_play=function()
		return not sgs.Self:hasFlag("qiceused")
	end,
	enabled_at_response=function(self,player,pattern)
		return pattern=="@@luaqice"
	end,
}
]]
luaqice_tr=sgs.CreateTriggerSkill{
	name="#luaqice_tr",
	events={sgs.EventPhaseEnd,sgs.CardUsed},
	on_trigger=function(self,event,player,data)
		local room=player:getRoom()
		if event==sgs.EventPhaseEnd then
			local Eu = room:findPlayerBySkillName(self:objectName())
			if not Eu then return end
			room:setPlayerFlag(Eu,"-qiceused")
		end
		if event==sgs.CardUsed then
			local use=data:toCardUse()
			if use.card:getSkillName()=="luaqice" then
				room:setPlayerFlag(player,"qiceused")
			elseif use.card:getSkillName()=="luaqice1" then
				room:loseHp(use.from)
				room:setPlayerFlag(player,"qiceused")
			end
		end
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
}

--Eucliwood:addSkill(luaqice)
Eucliwood:addSkill(luaqice_tr)
Eucliwood:addSkill(se_chenyan)

se_tongling = sgs.CreateViewAsSkill{
	name="se_tongling",
	limit_mark = "@se_tongling",
	n=0,
	view_as=function(self,cards)
		return se_tonglingcard:clone()
	end,
	enabled_at_play=function(self,player)
		return player:getMark("@se_tongling") > 0
	end
}

se_tonglingcard = sgs.CreateSkillCard{
	name = "se_tonglingcard",
	target_fixed = true,
	will_throw = true,
	on_use = function(self, room, source, targets)
		if source:getMark("@se_tongling") == 0 then return end
		local choice = room:askForChoice(source, "se_tongling_kd", "se_tongling_kill+se_tongling_death")
		if choice == "se_tongling_death" then
			local deathplayer = {}
			for _,p in sgs.qlist(room:getPlayers()) do
				if p:isDead() and p:getMaxHp() >= 1 then
					table.insert(deathplayer,p:getGeneralName())
				end
			end
			if #deathplayer==0 then
				local log =  sgs.LogMessage()
				log.type = "#se_qiyuan_noDeath"
				room:sendLog(log)
				return
			end
			local ap = room:askForChoice(source,"se_tongling_d",table.concat(deathplayer,"+"))
			local player
			for _,p in sgs.qlist(room:getPlayers()) do
				if p:getGeneralName() == ap and p:isDead() then
					player=p
				end
			end
			source:loseMark("@se_tongling")
			--room:broadcastSkillInvoke("se_tongling")
			room:doLightbox("se_tongling$", 3000)
			room:revivePlayer(player)
			room:changeHero(player, "Eu_Zombie",true, true, false, true)
		elseif choice == "se_tongling_kill" then
			local list = sgs.SPlayerList()
			for _,p in sgs.qlist(room:getAlivePlayers()) do
				if not p:isLord() and p:getHp() < 2 then
					list:append(p)
				end
			end
			if list:length() == 0 then return end
			local player = room:askForPlayerChosen(source,list,"se_tongling_k")
			if not player then return end
			source:loseMark("@se_tongling")
			local deathdamage = sgs.DamageStruct()
			deathdamage.from = source
			room:killPlayer(player,deathdamage)
			room:broadcastSkillInvoke("se_tongling")
			room:doLightbox("se_tongling$", 3000)
			room:revivePlayer(player)
			room:changeHero(player, "Eu_Zombie",true, true, false, true)
		end
	end,
}

Eucliwood:addSkill(se_tongling)

sgs.LoadTranslationTable{
["se_tongling$"] = "image=image/animate/se_tongling.png",
["qice_zero"] = "使用0张牌。",
["qice_two"] = "使用两张牌",
["luaqice"] = "谶言",
["$luaqice1"] = "（脑补）：欧尼酱，人家饿了嘛~快给优准备饭菜哦~还有~洗~澡~水~",
["$luaqice2"] = "（脑补）欧尼酱，便利店的饭团好好吃哦~",
["$luaqice3"] = "（脑补）只要和哥哥在一起，什么都很美味呢~喵~",
["$luaqice4"] = "（脑补）只要和哥哥在一起，什么都很美味呢~喵~",
["$luaqice5"] = "（脑补）优呢，因为哥哥不在很寂寞啊，于是就过来了~",
[":luaqice"] = "出牌阶段限一次，每当你需使用一张牌时，你可以弃置两张牌或失去1点体力并声明你需使用的牌，你视为使用此牌。",
["se_chenyan"] = "谶言",
["$se_chenyan1"] = "我明白的。",
["$se_chenyan2"] = "不管再发生什么事情，我都会待在步的身边的。",
["$se_chenyan3"] = "步能想办法帮我改变我和我的命运吗？",
["$se_chenyan4"] = "我想我一定一直都在等待着这种[任性]吧。",
["$se_chenyan5"] = "步，今天不对我进行妄想吗？",
[":se_chenyan"] = "每当你需使用或打出一张牌时，你可以弃置两张牌或失去1点体力并声明你需使用的牌，你视为使用此牌，每阶段限一次。",
["se_tongling"] = "通灵",
["@se_tongling"] = "通灵",
["$se_tongling1"] = "步，你给那个女孩戒指了啊...（背景音：步惊吓ING）",
["$se_tongling2"] = "太温吞，酸死了，真差劲。",
[":se_tongling"] = "限定技。出牌阶段，你可以选择一项：1、指定一名主公以外的体力值不大于1的其他角色，你杀死该角色，然后令其复活并变身为僵尸。2、指定一名已死亡角色，令其变身为僵尸。",
["Eucliwood"] = "优克莉伍德",
["&Eucliwood"] = "优克莉伍德",
["@Eucliwood"] = "这就是僵尸吗",
["#Eucliwood"] = "沉默の死灵师",
["~Eucliwood"] = "好痛啊，步。",
["designer:Eucliwood"] = "御坂20623；黑猫roy-音频",
["cv:Eucliwood"] = "月宫みどり",
["illustrator:Eucliwood"] = "Windforcelan",
}


SE_Juyang = sgs.CreateTriggerSkill{
	name = "SE_Juyang",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DamageInflicted},
	priority = -1,
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local room = player:getRoom()
			if event == sgs.DamageInflicted then
				if damage.nature == sgs.DamageStruct_Fire then
					if player:hasSkill(self:objectName()) then
						damage.damage = damage.damage + 1
						data:setValue(damage)
						room:broadcastSkillInvoke("SE_Juyang")
						return false
					end
				elseif damage.nature == sgs.DamageStruct_Normal then
					if player:hasSkill(self:objectName()) then
						player:drawCards(1)
						player:turnOver()
						room:broadcastSkillInvoke("SE_Juyang")
						return true
					end
				end
			end
		return false
	end,
}

Eu_Zombie:addSkill(SE_Juyang)

sgs.LoadTranslationTable{
--["SE_Wumai$"] = "image=image/animate/SE_Wumai.png",
["SE_Juyang"] = "惧阳",
["$SE_Juyang"] = "",
[":SE_Juyang"] = "锁定技。每当你受到普通伤害时，你防止此伤害，你须摸一张牌并将你的武将牌翻面。每当你受到火焰伤害时，此伤害+1。",
["Eu_Zombie"] = "僵尸",
["&Eu_Zombie"] = "僵尸",
["@Eu_Zombie"] = "这就是僵尸吗",
["#Eu_Zombie"] = "",
["~Eu_Zombie"] = "...",
["designer:Eu_Zombie"] = "御坂20623",
["cv:Eu_Zombie"] = "",
["illustrator:Eu_Zombie"] = "",
}

--枣恭介
--音无结弦

--远山金次



--五河士道

--仲村由理


zuozhan = sgs.CreateTriggerSkill{
	name = "zuozhan",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart, sgs.EventPhaseChanging},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if player:isAlive() then
			if event == sgs.EventPhaseStart then
				if player:getPhase() == sgs.Player_Start then
					local Yuri = room:findPlayerBySkillName(self:objectName())
					if not Yuri then return end
					if Yuri:getHp() > player:getHp() then return end
					if not Yuri or not room:askForSkillInvoke(Yuri,self:objectName(),data) then return end
					room:broadcastSkillInvoke("zuozhan")
					if Yuri:objectName() == player:objectName() then
						room:doLightbox("zuozhan$", 800)
					end
					local choices = {"1_Zuozhan", "2_Zuozhan", "3_Zuozhan", "4_Zuozhan"}
					local choice1 = room:askForChoice(Yuri,"zuozhan1%from:"..player:objectName(), table.concat(choices,"+"))
					if not choice1 then return end
					for i = 1, #choices do
						if choices[i] == choice1 then
						table.remove(choices, i)
						i = i-1
						end
					end
					local choice2 = room:askForChoice(Yuri,"zuozhan2%from:"..player:objectName(), table.concat(choices,"+"))
					if not choice2 then return end
					for j = 1, #choices do
						if choices[j] == choice2 then
						table.remove(choices, j)
						j = j-1
						end
					end
					local choice3 = room:askForChoice(Yuri,"zuozhan3%from:"..player:objectName(), table.concat(choices,"+"))
					if not choice3 then return end
					for k = 1, #choices do
						if choices[k] == choice3 then
						table.remove(choices, k)
						k = k-1
						end
					end
					local choice4 = choices[1]
					if not choice4 then return end
					--player:setFlags(choice1..choice2..choice3..choice4)
					local ap = sgs.QVariant()
					local Tag = string.sub(choice1,1,1)..string.sub(choice2,1,1)..string.sub(choice3,1,1)..string.sub(choice4,1,1)
					Tag = tonumber(Tag)
					ap:setValue(Tag)
					room:setTag("zuozhan_Tag"..player:objectName(),ap)
					--[[
					if not player:isSkipped(sgs.Player_Judge) then
						player:skip(sgs.Player_Judge)
					end
					if not player:isSkipped(sgs.Player_Draw) then
						player:skip(sgs.Player_Draw)
					end
					if not player:isSkipped(sgs.Player_Play) then
						player:skip(sgs.Player_Play)
					end
					if not player:isSkipped(sgs.Player_Discard) then
						player:skip(sgs.Player_Discard)
					end
					]]
					player:gainMark("@SSS")
				elseif player:getPhase() == sgs.Player_Finish then
					if player:getMark("@SSS") > 0 then
						player:loseMark("@SSS")
					end
				end
			elseif event == sgs.EventPhaseChanging then
				if player:getMark("@SSS") == 0 then return end
				local change = data:toPhaseChange()
				local Tag = room:getTag("zuozhan_Tag"..player:objectName()):toInt()
				Tag = string.format("%u", Tag)
				if Tag ~= "0" and string.len(Tag) > 0 then
					if string.sub(Tag, 1, 1) == "1" then
						--player:insertPhase(sgs.Player_Judge)
						change.to = sgs.Player_Judge
						data:setValue(change)
					elseif string.sub(Tag, 1, 1) == "2" then
						--player:insertPhase(sgs.Player_Draw)
						change.to = sgs.Player_Draw
						data:setValue(change)
					elseif string.sub(Tag, 1, 1) == "3" then
						--player:insertPhase(sgs.Player_Play)
						change.to = sgs.Player_Play
						data:setValue(change)
					elseif string.sub(Tag, 1, 1) == "4" then
						--player:insertPhase(sgs.Player_Discard)
						change.to = sgs.Player_Discard
						data:setValue(change)
					end
					if string.len(Tag) > 1 then
						Tag = string.sub(Tag, 2, -1)
					else
						Tag = "0"
					end
					local ap = sgs.QVariant()
					Tag = tonumber(Tag)
					ap:setValue(Tag)
					room:setTag("zuozhan_Tag"..player:objectName(),ap)
				else
					change.to = sgs.Player_Finish
					data:setValue(change)
					room:removeTag("zuozhan_Tag"..player:objectName())
				end
			end
		end
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
}

-- Yuri:addSkill(zuozhan)



--小木曽雪菜


sgs.GaolingPattern = {"pattern"}

SE_Gaoling = sgs.CreateViewAsSkill{
	name = "SE_Gaoling",
	n = 0,
	view_as = function(self, cards)
		local pattern = sgs.GaolingPattern[1]
		if pattern == "jink" then
			local card = sgs.Sanguosha:cloneCard("jink", sgs.Card_NoSuit,0)
			local jink = sgs.Sanguosha:cloneCard("jink", sgs.Card_NoSuit,0)
			jink:addSubcard(card)
			jink:setSkillName("SE_Gaoling")
			return jink
		elseif pattern == "nullification" then
			local card = sgs.Sanguosha:cloneCard("nullification", sgs.Card_NoSuit,0)
			local nu_card = sgs.Sanguosha:cloneCard("nullification", sgs.Card_NoSuit,0)
			nu_card:addSubcard(card)
			nu_card:setSkillName("SE_Gaoling")
			return nu_card
		end
	end,
	enabled_at_play = function(self, player)
		return false
	end,
	enabled_at_response = function(self, player, pattern)
		if math.ceil(player:getHandcardNum()/2) * 2 == player:getHandcardNum() and (pattern == "nullification" or pattern == "jink") then
			sgs.GaolingPattern = {pattern}
			return true
		end
	end,
	enabled_at_nullification = function(self, player)
		if math.ceil(player:getHandcardNum()/2) * 2 == player:getHandcardNum() then
			sgs.GaolingPattern = {"nullification"}
			return true
		end
	end
}

SE_Gaoling_tr=sgs.CreateTriggerSkill{
	name="#SE_Gaoling_tr",
	events={sgs.CardUsed, sgs.CardResponded},
	on_trigger=function(self,event,player,data)
		local room=player:getRoom()
		if event==sgs.CardUsed then
			local use=data:toCardUse()
			if use.card:getSkillName()=="SE_Gaoling" then
				player:drawCards(1)
			end
		elseif event==sgs.CardResponded then
			local use=data:toCardResponse()
			if use.m_card:getSkillName()=="SE_Gaoling" then
				player:drawCards(1)
			end
		end
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
}

SE_Shengmu = sgs.CreateTriggerSkill{
	name = "SE_Shengmu",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Damaged},
	priority = -1,
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local room = player:getRoom()
		local victim = damage.to
		local Setsuna = room:findPlayerBySkillName(self:objectName())
		if not Setsuna then return end
		if math.ceil(Setsuna:getHandcardNum()/2) * 2 ~= Setsuna:getHandcardNum() then
			if not victim:isAlive() then return end
			if not room:askForSkillInvoke(Setsuna,self:objectName(),data) then return end
			local prompt = string.format("@SE_Shengmu:%s:%s", Setsuna:getGeneralName(),victim:getGeneralName())
			local card = room:askForCard(Setsuna, ".|.|.", prompt, data, sgs.CardDiscarded)
			if card then
				room:broadcastSkillInvoke("SE_Shengmu")
				local re = sgs.RecoverStruct()
				re.who = victim
				room:recover(victim,re,true)
				if card:isRed() then
					room:doLightbox("SE_Shengmu$", 1000)
					victim:drawCards(1)
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return not target:hasSkill("SE_Shengmu")
	end
}

Setsuna:addSkill(SE_Gaoling)
Setsuna:addSkill(SE_Gaoling_tr)
extension:insertRelatedSkills("SE_Gaoling", "#SE_Gaoling_tr")
Setsuna:addSkill(SE_Shengmu)

sgs.LoadTranslationTable{
["SE_Shengmu$"] = "image=image/animate/SE_Shengmu.png",
["SE_Gaoling"] = "高岭",
["$SE_Gaoling1"] = "十分感谢您的聆听！~",
["$SE_Gaoling2"] = "听了这个以后，小木曽雪菜的秘密就一个不剩了。全部都被你知道了。",
["$SE_Gaoling3"] = "（春希）抱歉，我要更正一点，小木曽雪菜，毫无疑问，是一位完美无缺的偶像。",
[":SE_Gaoling"] = "每当你需要使用一张【金色宣言】或【闪】时，若你的手牌数为双数，你可以视为使用一张【金色宣言】或【闪】，然后摸一张牌。",
["@SE_Shengmu"]="%src 技能【圣母】生效，你须弃置一张牌才能令其恢复1点体力。",
["SE_Shengmu"] = "圣母",
["$SE_Shengmu1"] = "直接叫我、雪菜就可以了。",
["$SE_Shengmu2"] = "明明昨天说过绝对不会过来，冬马同学已经没事了嘛？",
["$SE_Shengmu3"] = "太好了，冬马同学~真的对不起，没帮上忙。",
["$SE_Shengmu4"] = "今天我想一直沉睡在梦境里，打从心底唱着自己最喜欢的曲子，被最喜欢人的夸奖...",
[":SE_Shengmu"] = "若你手牌数为单数，其他角色受到伤害后，你可以弃置一张牌，令其恢复1点体力，若你弃牌为红牌，该角色摸一张牌。",
["Setsuna"] = "小木曽雪菜",
["&Setsuna"] = "小木曽雪菜",
["@Setsuna"] = "白色相簿2",
["#Setsuna"] = "峰城附の高岭之花",
["~Setsuna"] = "要是和纱，要是和纱是男生的话，该多好啊...",
["designer:Setsuna"] = "昂翼天使",
["cv:Setsuna"] = "米澤円",
["illustrator:Setsuna"] = "なかむらたけし",
}


--姫柊雪菜


Schneewalzer = sgs.CreateTriggerSkill{
	name = "Schneewalzer",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DamageCaused},
	priority = 1,
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local room = player:getRoom()
			if damage.nature == sgs.DamageStruct_Thunder then
				if event == sgs.DamageCaused then
					local source = damage.from
					if source and source:isAlive() then
						if source:hasSkill(self:objectName()) then
							room:broadcastSkillInvoke("Schneewalzer")
							room:doLightbox("Schneewalzer$", 800)
							local bask = false
							local zess = false
							if damage.to:getMark("@Baskervilles") > 0 then
								bask = true
							end
							if damage.to:getMark("@zessho") > 0 then
								zess = true
							end
							damage.to:throwAllMarks(true)
							damage.to:clearPrivatePiles()
							if bask then
								damage.to:gainMark("@Baskervilles", 1)
							end
							if zess then
								damage.to:gainMark("@zessho", 1)
							end
							return false
						end
					end
				end
			end
		return false
	end
}

SE_JianshiTr = sgs.CreateTriggerSkill{
	name = "#SE_JianshiTr",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Damaged, sgs.Death},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.Damaged then
			local damage = data:toDamage()
			if damage.to:hasSkill(self:objectName()) then
				damage.to:gainMark("@surveillance")
			end
		elseif event==sgs.Death then
			local death = data:toDeath()
			local Ou = death.who
			if Ou:getMark("@surveillance") > 0 then
				room:broadcastSkillInvoke("se_jianshi", 3)
				local yukina = room:findPlayerBySkillName("se_jianshi")
				if not yukina then return end
				for _,p in sgs.qlist(room:getOtherPlayers(yukina)) do
					if p:getMark("@surveillance") > 0 then p:loseMark("@surveillance", 1) end
				end
			end
		end
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
}

SE_JianshiTrAll = sgs.CreateTriggerSkill{
	name = "#SE_JianshiTrAll",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.CardUsed, sgs.CardResponded},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event==sgs.CardUsed then
			local use=data:toCardUse()
			if use.from:getMark("@surveillance") > 0 then
				if math.random(1, 100) < 18 then--
					local Yukina = room:findPlayerBySkillName("se_jianshi")
					if not Yukina then return end
					if not room:askForSkillInvoke(Yukina,"se_jianshi",data) then return end
					local dest = room:askForPlayerChosen(Yukina,room:getAlivePlayers(),"SE_JianshiTr")
					if dest then
						local da = sgs.DamageStruct()
						da.from = Yukina
						da.to = dest
						da.nature = sgs.DamageStruct_Thunder
						room:damage(da)
					end
				end
			end
		elseif event==sgs.CardResponded then
			local use=data:toCardResponse()
			if not use.to then return end
			if use.to:getMark("@surveillance") > 0 then
				if math.random(1, 100) < 18 then--
					local Yukina = room:findPlayerBySkillName("se_jianshi")
					if not Yukina then return end
					if not room:askForSkillInvoke(Yukina,"se_jianshi",data) then return end
					local dest = room:askForPlayerChosen(Yukina,room:getAlivePlayers(),"SE_JianshiTr")
					if dest then
						local da = sgs.DamageStruct()
						da.from = Yukina
						da.to = dest
						da.nature = sgs.DamageStruct_Thunder
						room:damage(da)
					end
				end
			end
		end
	end,
}

SE_JianshiTri = sgs.CreateTriggerSkill{
	name = "#SE_JianshiTri",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.GameStart then
			if player:hasSkill(self:objectName()) then
				player:gainMark("@surveillance")
			end
		end
	end,
}

se_jianshi=sgs.CreateViewAsSkill{
	name="se_jianshi",
	n = 0,
	view_as = function(self, cards)
		return se_jianshicard:clone()
	end,
	enabled_at_play = function(self, player)
		return player:getMark("@surveillance") > 0
	end,
}

se_jianshicard = sgs.CreateSkillCard{
	name = "se_jianshicard",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		return #targets == 0 and to_select:getMark("@surveillance") == 0
	end,
	on_use = function(self, room, source, targets)
		local dest = targets[1]
		if dest:objectName() == source:objectName() then return end
		local count = source:getMark("@surveillance")
		if count == 0 then
			return
		else
			source:loseMark("@surveillance", 1)
		end
		if dest:isAlive() then
			dest:gainMark("@surveillance")
			if math.random(1,2) == 1 then
				room:broadcastSkillInvoke("se_jianshi", 1)
			else
				room:broadcastSkillInvoke("se_jianshi", 2)
			end
			if not dest:hasSkill("#SE_JianshiTrAll") then
				room:acquireSkill(dest, "#SE_JianshiTrAll", false)
			end
		end
	end
}

Yukina:addSkill(Schneewalzer)
Yukina:addSkill(SE_JianshiTr)
Yukina:addSkill(SE_JianshiTri)
Yukina:addSkill(SE_JianshiTrAll)
Yukina:addSkill(se_jianshi)
extension:insertRelatedSkills("se_jianshi", "#SE_JianshiTrAll")
extension:insertRelatedSkills("se_jianshi", "#SE_JianshiTri")
extension:insertRelatedSkills("se_jianshi", "#SE_JianshiTr")

sgs.LoadTranslationTable{
["Schneewalzer$"] = "image=image/animate/Schneewalzer.png",
["Schneewalzer"] = "雪霞狼",
["$Schneewalzer1"] = "不，前辈，是我们的战斗。",
["$Schneewalzer2"] = "狮子神子 高神剑巫 诚心祷祝",
["$Schneewalzer3"] = "破魔曙光 雪霞神狼 以钢之神威 助我讨尽恶神百鬼",
[":Schneewalzer"] = "锁定技。每当你对一名角色造成雷属性伤害时，你须将该角色的武将牌上的所有牌置入弃牌堆，然后弃置其所有标记。",
["se_jianshi"] = "监视",
["@surveillance"] = "监视",
["$se_jianshi1"] = "我作为剑巫接受了监视学长的任务才来到弦神岛。——等等，监视？",
["$se_jianshi2"] = "难道今后一直跟着？当然啦，我可是监视者啊。",
["$se_jianshi3"] = "前...前辈......",
[":se_jianshi"] = "游戏开始时，你获得1枚“监视”标记；每当你受到1点伤害后，你获得1枚“监视”标记。\n出牌阶段，你可以指定一名没有“监视”标记的角色，若如此做，你令其获得你的1枚“监视”标记。\n每当拥有“监视”标记的角色使用一张牌后或成为一张牌的目标后，你有17%的概率可以指定一名角色，你对其造成1点雷电伤害。每当拥有“监视”标记的角色死亡时，所有其他角色各失去“监视”标记。",
["Yukina"] = "姫柊雪菜",
["&Yukina"] = "姫柊雪菜",
["@Yukina"] = "噬血狂袭",
["#Yukina"] = "狮子王机关の剑巫",
["~Yukina"] = "啊...",
["designer:Yukina"] = "Sword Elucidator",
["cv:Yukina"] = "種田梨沙",
["illustrator:Yukina"] = "緋華",
}


--前原圭一


SE_Guiyin = sgs.CreateTriggerSkill{
	name = "SE_Guiyin",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Damaged, sgs.EventPhaseStart, sgs.EventPhaseEnd,sgs.TargetConfirmed},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.Damaged then
			local damage = data:toDamage()
			if damage.to:hasSkill(self:objectName()) then
				if damage.from:objectName() ~= player:objectName() then
					if not player:hasFlag("guiyin2_used") then
						room:broadcastSkillInvoke("SE_Guiyin", 2)
						player:setFlags("guiyin2_used")
					end
				end
				damage.from:gainMark("@Oni")
				damage.to:gainMark("OniLv")
			end
			return false
		elseif event == sgs.EventPhaseStart then
			if player:hasSkill(self:objectName()) and player:getPhase()==sgs.Player_Finish then
				if player:getMark("OniLv") > 2 then
					room:broadcastSkillInvoke("SE_Guiyin", 3)
					for _,p in sgs.qlist(room:getAlivePlayers()) do
						if p:inMyAttackRange(player) then
						p:gainMark("@Oni")
						player:gainMark("OniLv")
						end
					end
				end
			end
		elseif event == sgs.EventPhaseEnd then
			if player:hasSkill(self:objectName()) and player:getPhase()==sgs.Player_Play then
				if player:getMark("OniLv") > 4 then
					room:broadcastSkillInvoke("SE_Guiyin", 4)
					room:doLightbox("SE_Guiyin$", 2000)
					local da = sgs.DamageStruct()
					for _,p in sgs.qlist(room:getAlivePlayers()) do
						if p:getMark("@Oni") > 0 then
							--da = sgs.DamageStruct()
							da.from = player
							da.to = p
							if p:getMark("@Oni") > 2 then
								da.damage = 2
							else
								da.damage = p:getMark("@Oni")
							end
							if p:objectName() == player:objectName() then
								if p:getMark("@Oni") >= 2 then da.damage = 1 end
							end
							room:damage(da)
							p:loseAllMarks("@Oni")
						end
					end
					--if not room:askForSkillInvoke(player, self:objectName(), data) then return end
					--local t = room:askForPlayerChosen(player, targets, self:objectName())
					--targets:removeOne(t)
					player:loseAllMarks("OniLv")
				end
			end
		elseif event == sgs.TargetConfirmed then
			local use = data:toCardUse()
			 if use.to:contains(player) then
				--if use.from:objectName() ~= player:objectName() then
				if not use.from then return end
				use.from:gainMark("@Oni")
				player:gainMark("OniLv")
				--end
				if use.from:objectName() ~= player:objectName() then
					if not player:hasFlag("guiyin1_used") then
						room:broadcastSkillInvoke("SE_Guiyin", 1)
						player:setFlags("guiyin1_used")
					end
				end
			end
		--[[elseif event == sgs.GameStart then
			for _,p in sgs.qlist(room:getAlivePlayers()) do
				if not p:hasSkill("#SE_GuiyinEx") then
					room:acquireSkill(p, "#SE_GuiyinEx", false)
				end
			end]]
		end
		return false
	end
}
--[[
SE_GuiyinEx = sgs.CreateTriggerSkill{
	name = "#SE_GuiyinEx",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.CardUsed},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.CardUsed then
			local use = data:toCardUse()
			local K = room:findPlayerBySkillName("SE_Guiyin")
			if use.to and use.to:contains(K) then
				player:gainMark("@Oni")
				sgs.AllOni = sgs.AllOni + 1
			end
		end
		return false
	end,
}
]]

SE_GuiyinDis = sgs.CreateDistanceSkill{
	name = "#SE_GuiyinDis",
	correct_func = function(self, from, to)
		if from:hasSkill("#SE_GuiyinDis") then
			if from:getMark("OniLv") > 0 then
				return -2
			end
		end
	end
}

-- K1:addSkill(SE_Guiyin)
-- K1:addSkill(SE_GuiyinDis)
-- extension:insertRelatedSkills("SE_Guiyin", "#SE_GuiyinDis")


--江之岛盾子


SE_Heimu = sgs.CreateTriggerSkill{
	name = "SE_Heimu",
	frequency = sgs.Skill_Limited,
	events = {sgs.AskForPeachesDone, sgs.GameStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.AskForPeachesDone then
			--judge
			local dying = data:toDying()
			local de = dying.who
			if de:getHp() > 0 then return end
			local trig = true
			if de:getRole() == "rebel" then
				for _,p in sgs.qlist(room:getOtherPlayers(de)) do
					if p:getRole() == "rebel" then trig = false end
					if p:getRole() == "renegade" then trig = false end
				end
			elseif de:getRole() == "loyalist" then
				trig = false
			elseif de:getRole() == "renegade" then
				if room:getAlivePlayers():length() > 2 then
					trig = false
				end
			end
			if not trig then return end
			local junko
			for _,p in sgs.qlist(room:getAllPlayers(true)) do
				if p:getGeneralName()=="Junko" then
					junko = p
				end
			end
			if not junko then return false end

			if junko:getMark("SE_Heimu_done") == 1 then return false end
			if room:askForSkillInvoke(junko, self:objectName()) then
				if junko:isDead() then
					room:revivePlayer(junko)
				end
				room:setPlayerProperty(junko, "hp", sgs.QVariant(junko:getMaxHp()))
				local derole = de:getRole()
				local junkorole = junko:getRole()
				room:setPlayerProperty(junko, "role", sgs.QVariant("lord"))--设置盾子为主公
				room:setPlayerProperty(de, "role", sgs.QVariant("loyalist"))--设置死掉的de为忠臣
				if derole == "lord" then--死者为主公，则胜利者为内奸或反贼
					local winner
					for _,p in sgs.qlist(room:getOtherPlayers(junko)) do
						if p:getRole() == "rebel" then
							winner = "rebel"
						end
					end
					if not winner then winner = "renegade" end
					for _,p in sgs.qlist(room:getOtherPlayers(junko)) do
						if p:getRole() == winner then
							room:setPlayerProperty(p, "role", sgs.QVariant("rebel"))--设置所有胜利者为反贼
						else
							room:killPlayer(p)
						end
					end
				elseif  derole == "rebel" or derole == "renegade" then--死者为反贼或内奸，则胜利者为主公和忠臣
					for _,p in sgs.qlist(room:getOtherPlayers(junko)) do
						if p:getRole() == "lord" or p:getRole() == "loyalist" then
							room:setPlayerProperty(p, "role", sgs.QVariant("rebel"))--设置所有胜利者为反贼
						else
							room:killPlayer(p)
						end
					end
				end
				local da = sgs.DamageStruct()
				for _,p in sgs.qlist(room:getOtherPlayers(junko)) do
					da.from = junko
					da.to = p
					da.nature = sgs.DamageStruct_Thunder
					room:damage(da)
				end
			end
			junko:gainMark("SE_Heimu_done")
			return false
		end
	end,
}

--Junko:addSkill(SE_Heimu)

--右代宫战人


SE_Xianzhuo = sgs.CreateTriggerSkill{
	name = "SE_Xianzhuo",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Death},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local death = data:toDeath()
		if death.who:objectName() == player:objectName() then
			if not room:askForSkillInvoke(player, self:objectName(), data) then return end
			local choices = "+lord+loyalist+rebel+renegade"
			for _,p in sgs.qlist(room:getOtherPlayers(player)) do
				local choice = room:askForChoice(player, self:objectName(), string.format(p:getGeneralName()..choices))
				if choice ~= p:getRole() then return end
			end
			if player:isDead() then
				room:revivePlayer(player)
			end
			room:setPlayerProperty(player,"hp",sgs.QVariant(player:getMaxHp()))
			for _,p in sgs.qlist(room:getAlivePlayers()) do
				p:throwAllMarks()
				p:throwAllCards()
				if p:objectName() ~= player:objectName() then
					room:changeHero(p, "sujiang",false, false, false, true)
				end
				p:clearPrivatePiles()
			end
			local ld = true
			local newChoices = "+lord+loyalist+rebel+renegade"
			local newChoices2 = "+loyalist+rebel+renegade"
			local last = room:getAllPlayers():length()
			local i = 0
			for _,p in sgs.qlist(room:getAllPlayers()) do
				if p:isDead() then
					room:revivePlayer(p)
				end
			end
			local all_generals = sgs.Sanguosha:getLimitedGeneralNames()
			for _,p in sgs.qlist(room:getOtherPlayers(player)) do
				room:changeHero(p, all_generals[math.random(1, #all_generals)], false, false, false, true)
			end
			for _,p in sgs.qlist(room:getAllPlayers()) do
				if i == last - 1 and ld then
					room:setPlayerProperty(p,"role",sgs.QVariant("lord"))
				else
					if ld then
						local c = room:askForChoice(player, self:objectName(), string.format(p:getGeneralName()..newChoices))
						while c == p:getGeneralName() do
							c = room:askForChoice(player, self:objectName(), string.format(p:getGeneralName()..newChoices))
						end
						room:setPlayerProperty(p,"role",sgs.QVariant(c))
						if c == "lord" then
							ld = false
						end
					else
						local c = room:askForChoice(player, self:objectName(), string.format(p:getGeneralName()..newChoices2))
						while c == p:getGeneralName() do
							c = room:askForChoice(player, self:objectName(), string.format(p:getGeneralName()..newChoices2))
						end
						room:setPlayerProperty(p,"role",sgs.QVariant(c))
					end
				end
				i = i + 1
			end
		end
		return false
	end,
	can_trigger = function(self, target)
        return target and target:hasSkill(self:objectName())
    end
}

Batora:addSkill(SE_Xianzhuo)



sgs.LoadTranslationTable{

["SE_Xianzhuo"] = "掀桌",
["$SE_Xianzhuo"] = "",
[":SE_Xianzhuo"] = "你死亡时，你可以依次指出每个角色的身份，若正确，你复活并回复至体力上限，令场上所有角色的牌、标记、武将牌、各牌堆均置入弃牌堆，复活各角色，所有角色均摸取一张武将牌，然后你重新分配各角色的身份（主公只能有一个）。",

["Batora"] = "右代宮戦人",
["&Batora"] = "右代宮戦人",
["@Batora"] = "海猫鸣泣之时",
["#Batora"] = "翻盘狂魔",
["~Batora"] = "",
["designer:Batora"] = "Sword Elucidator",
["cv:Batora"] = "小野大輔",
["illustrator:Batora"] = "",

}


--白雪


sgs.SE_Jiawu_broad = true
SE_Jiawu = sgs.CreateTriggerSkill{
	name = "SE_Jiawu",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.CardsMoveOneTime},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local move = data:toMoveOneTime()
		local source = move.from
		if source then
			if isBaskervilles(source) then
				if move.to_place == sgs.Player_DiscardPile then
					local reason = move.reason.m_reason
					local flag = false
					if bit32.band(reason, sgs.CardMoveReason_S_MASK_BASIC_REASON) == sgs.CardMoveReason_S_REASON_DISCARD then
						flag = true
					end
					if reason == 0x3A then
						flag = true
					end
					if flag then
						local numList = sgs.IntList()
						for _,cardid in sgs.qlist(move.card_ids) do
							if cardid ~= -1 and not numList:contains(sgs.Sanguosha:getCard(cardid):getNumber()) then
								numList:append(sgs.Sanguosha:getCard(cardid):getNumber())
							end
						end
						if numList:length() == 0 then return end
						local dispile = room:getDiscardPile()
						local newList = sgs.IntList()
						for _,id in sgs.qlist(dispile) do
							if cardid ~= -1 and numList:contains(sgs.Sanguosha:getCard(id):getNumber()) and not move.card_ids:contains(id) then
								newList:append(id)
							end
						end
						if newList:length() == 0 then return end
						if not room:askForSkillInvoke(player, self:objectName()) then return end
						room:fillAG(newList, player)
						local cid = room:askForAG(player, newList, false, self:objectName())
						room:clearAG(player)
						if cid == -1 then
							return
						end
						local giveList = sgs.IntList()
						room:obtainCard(player,cid)
						giveList:append(cid)
						if (player:isWounded() and sgs.Sanguosha:getCard(cid):isKindOf("Peach")) or sgs.Sanguosha:getCard(cid):isKindOf("Weapon") then
							if sgs.Sanguosha:getCard(cid):isKindOf("EquipCard") then player:setFlags("SE_Jiawu_EquipCard") end
							local will_use = room:askForChoice(player,self:objectName(),"SE_Jiawu_use+SE_Jiawu_give")
	                        if will_use == "SE_Jiawu_use" then
	                        	local newuse = sgs.CardUseStruct()
								newuse.from = player
								newuse.to:append(player)
								newuse.card = sgs.Sanguosha:getCard(cid)
	                            room:useCard(newuse)
	                            if sgs.Sanguosha:getCard(cid):isKindOf("EquipCard") then player:setFlags("-SE_Jiawu_EquipCard") end
	                            return
	                        end
	                    end
						local toGiveList = sgs.SPlayerList()
						if player:getPhase() == sgs.Player_Discard then
							if sgs.SE_Jiawu_broad then
								room:broadcastSkillInvoke(self:objectName())
							end
							sgs.SE_Jiawu_broad = false
							room:askForYiji(player, giveList, self:objectName(), true, true, true, -1, room:getOtherPlayers(player))
						else
							sgs.SE_Jiawu_broad = true
							room:broadcastSkillInvoke(self:objectName())
							room:askForYiji(player, giveList, self:objectName(), true, true, true, -1, room:getAlivePlayers())
						end
					end
				end
			end
		end
		return false
	end,
}

SE_Zhandan = sgs.CreateTriggerSkill{
	name = "SE_Zhandan",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageCaused},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.DamageCaused then
			local damage = data:toDamage()
			if damage.damage <= 1 then return end
			local source = damage.from
			local mygod = room:findPlayerBySkillName(self:objectName())
			if not mygod then return end
			if not source then
				if room:askForSkillInvoke(mygod, self:objectName(), data) then return true end
				return
			end
			if not mygod:inMyAttackRange(source) and not mygod:inMyAttackRange(damage.to) then return end
			if not room:askForSkillInvoke(mygod, self:objectName(), data) then return end
			local card
			if source:getHandcardNum() == 0 then
				local log = sgs.LogMessage()
				log.type = "#TriggerSkill"
				log.from = mygod
				log.arg = self:objectName()
				room:doLightbox("SE_Zhandan$", 1000)
				room:broadcastSkillInvoke(self:objectName())
				return true
			else
				card = room:askForCardShow(source, mygod, self:objectName())
				room:showCard(source,card:getEffectiveId())
				local suit = card:getSuitString()
				local pattern = string.format(".|%s|.|.",suit)
				if room:askForCard(mygod, pattern, string.format("@SE_Zhandan"..suit), data, sgs.CardDiscarded) then
					local log = sgs.LogMessage()
					log.type = "#TriggerSkill"
					log.from = mygod
					log.arg = self:objectName()
					room:doLightbox("SE_Zhandan$", 1000)
					room:broadcastSkillInvoke(self:objectName())
					sgs.SE_Jiawu_broad = true
					return true
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
	priority = -2
}



Shirayuki:addSkill(SE_Zhandan)
Shirayuki:addSkill(SE_Jiawu)
Shirayuki:addSkill("#SE_Baskervilles_make")

sgs.LoadTranslationTable{
["SE_Zhandan$"] = "image=image/animate/SE_Zhandan.png",
["SE_Jiawu"] = "家务",
["SE_Jiawu_use"] = "使用这张牌",
["SE_Jiawu_give"] = "不使用这张牌",
["$SE_Jiawu1"] = "那我趁这时间去打扫一下，或者洗一下衣服。",
["$SE_Jiawu2"] = "我也要和小金一起住~",
["@SE_Zhandanspade"] = "请弃置一张黑桃花色的手牌并取消该伤害。",
["@SE_Zhandandiamond"] = "请弃置一张方片花色的手牌并取消该伤害。",
["@SE_Zhandanclub"] = "请弃置一张草花花色的手牌并取消该伤害。",
["@SE_Zhandanheart"] = "请弃置一张红桃花色的手牌并取消该伤害。",
[":SE_Jiawu"]="<font color=\"Sky Blue\"><b>萌战技，1，武侦，</b></font>每当武侦角色的牌因判定或弃置而进入弃牌堆时，你可以从弃牌堆中获得一张与其中任意弃牌点数相同的牌，若该牌为桃或武器牌，你可以立即使用之，否则你可以将其交给任意角色。",

["SE_Zhandan"] = "斩弹",
["$SE_Zhandan1"] = "小金没有错！小金只是被骗了！",
["$SE_Zhandan2"] = "（挡子弹声） （亚里亚）啊...你是 超侦！？",
["$SE_Zhandan3"] = "魔剑,我不会再让你伤害我的伙伴了！",
["$SE_Zhandan4"] = "我的讳名，真正的名字是「绯色的巫女」，也就是「绯巫女」！",
[":SE_Zhandan"] = "每当一名角色受到伤害时，若该伤害大于1，1.且若没有伤害来源，你可以防止之。2.且其或伤害来源在你的攻击范围内时，你可以令伤害来源展示一张手牌，若其无法展示或你弃置一张与其展示手牌花色相同的牌，你令该伤害无效。",

["Shirayuki"] = "星伽白雪",
["&Shirayuki"] = "星伽白雪",
["@Shirayuki"] = "绯弹的亚里亚",
["#Shirayuki"] = "星伽的绯巫女",
["~Shirayuki"] = "亚里亚，对不起。我明明总是对你做那么过分的事。",
["designer:Shirayuki"] = "Sword Elucidator",
["cv:Shirayuki"] = "高橋美佳子",
["illustrator:Shirayuki"] = "",

}

--宮永咲


sgs.kansuu = 0

SE_Lingshang = sgs.CreateTriggerSkill{
	name = "SE_Lingshang",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.CardsMoveOneTime, sgs.DrawNCards},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.CardsMoveOneTime then
			local move = data:toMoveOneTime()
			if move.to_place == sgs.Player_DiscardPile then
				local reason = move.reason.m_reason
				if bit32.band(reason, sgs.CardMoveReason_S_MASK_BASIC_REASON) == sgs.CardMoveReason_S_REASON_DISCARD then return end
				if reason == 0x03 then return end
				for _,id in sgs.qlist(move.card_ids) do

					if id ~= -1 then
						local tp
						if sgs.Sanguosha:getCard(id):isKindOf("BasicCard") then
							tp = "BasicCard"
						elseif sgs.Sanguosha:getCard(id):isKindOf("TrickCard") then
							tp = "TrickCard"
						elseif sgs.Sanguosha:getCard(id):isKindOf("EquipCard") then
							tp = "EquipCard"
						end
						if not tp then return end
						local cards = sgs.IntList()
						for _,card in sgs.qlist(player:getCards("he")) do
							if card:isKindOf(tp) then
								cards:append(card:getEffectiveId())
							end
						end
						if cards:length() < 2 then return end
						if room:getDrawPile():length() == 0 then return end

						if not room:askForSkillInvoke(player, self:objectName(), sgs.QVariant(tp)) then return end
						if sgs.kansuu == 0 then
							room:broadcastSkillInvoke(self:objectName(), 3)
						else
							if math.random(1, 3) == 1 then
								room:broadcastSkillInvoke(self:objectName(), 3)
							else
								room:broadcastSkillInvoke(self:objectName(), 4)
							end
						end

						room:fillAG(cards, player)
						local card1 = room:askForAG(player, cards, true, self:objectName())
						room:clearAG(player)
						if not card1 then return end
						cards:removeOne(card1)
						room:fillAG(cards, player)
						local card2 = room:askForAG(player, cards, true, self:objectName())
						room:clearAG(player)
						if not card2 then return end
						room:throwCard(card1,player, player)
						room:throwCard(card2,player, player)

						local firstchoice = room:askForChoice(player,"SE_Lingshang_type","BasicCard+TrickCard+EquipCard")

						local choices
						local choicesDone = {}
						for _,id in sgs.qlist(room:getDrawPile()) do
							if not choices and sgs.Sanguosha:getCard(id):isKindOf(firstchoice) then
								choices = sgs.Sanguosha:getCard(id):objectName()
								table.insert(choicesDone, sgs.Sanguosha:getCard(id):objectName())
							else
								if not table.contains(choicesDone, sgs.Sanguosha:getCard(id):objectName()) and sgs.Sanguosha:getCard(id):isKindOf(firstchoice) then
									choices = string.format(choices.."+"..sgs.Sanguosha:getCard(id):objectName())
									table.insert(choicesDone, sgs.Sanguosha:getCard(id):objectName())
								end
							end
						end
						if not choices then return end
						local choice = room:askForChoice(player,self:objectName(),choices)
						if not choice then return end
						for _,id in sgs.qlist(room:getDrawPile()) do
							if sgs.Sanguosha:getCard(id):objectName() == choice then
								if math.random(1, 2) == 1 then
									room:broadcastSkillInvoke(self:objectName(), 1)
								else
									room:broadcastSkillInvoke(self:objectName(), 2)
								end
								room:doLightbox("SE_Lingshang$", 500)
								room:obtainCard(player,id,false)
								sgs.kansuu = 1
								break
							end
						end
						player:gainMark("@Saki")
					end
				end
			end
		elseif event == sgs.DrawNCards then
			if player:hasSkill("SE_Guiling") then
				data:setValue(data:toInt() + player:getMark("@Saki") * 2)
			else
				data:setValue(data:toInt() + math.min(player:getMark("@Saki"), 4))
			end
		end
		return false
	end,
}

SE_Lingshang_end = sgs.CreateMaxCardsSkill{
	name = "#SE_Lingshang_end",
	extra_func = function(self, player)
		if player:hasSkill(self:objectName()) then
			if player:hasSkill("SE_Guiling") then
				return player:getMark("@Saki")
			else
				return math.min(player:getMark("@Saki"), 4)
			end
		end
	end
}


SE_Guiling = sgs.CreateTriggerSkill{
	name = "SE_Guiling",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.EventPhaseEnd and player:getPhase() == sgs.Player_Draw then
			room:broadcastSkillInvoke(self:objectName())
			player:loseAllMarks("@Saki")
			sgs.kansuu = 0
		end
		return false
	end,
}

Saki:addSkill(SE_Lingshang)
Saki:addSkill(SE_Lingshang_end)
extension:insertRelatedSkills("SE_Lingshang", "#SE_Lingshang_end")
Saki:addSkill(SE_Guiling)

sgs.LoadTranslationTable{
["SE_Lingshang$"] = "image=image/animate/SE_Lingshang.png",
["SE_Lingshang"] = "岭上",
["SE_Lingshang"] = "岭上",
["$SE_Lingshang1"] = "自摸，清一色 碰碰和 三暗刻 三杠子 赤宝牌1 岭上开花。",
["$SE_Lingshang2"] = "自摸，岭上开花。",
["$SE_Lingshang3"] = "杠",
["$SE_Lingshang4"] = "再来一个，杠",
[":SE_Lingshang"]="每当一张牌非因弃置而进入弃牌堆时，你可以弃置两张与之相同类别的牌，然后指定一种牌堆中存在的牌名，你从牌堆中获得一张这种牌，然后你获得一个“咲”标记。摸牌阶段，你可以额外摸2X张牌。你的手牌上限始终+X。X为你“咲”标记的数量。若你没有“归零”，X至多为4，且摸牌数变为X。",
["@Saki"] = "咲",

["SE_Guiling"] = "归零",
["$SE_Guiling1"] = "我每次打麻将，都会变成这个样子..",
["$SE_Guiling2"] = "（和）只是这样？（咲）只是这样。",
[":SE_Guiling"] = "锁定技。摸牌阶段结束时，你失去“咲”标记。",

["Saki"] = "宮永咲",
["&Saki"] = "宮永咲",
["@Saki"] = "天才麻将少女",
["#Saki"] = "裱人大魔王",
["~Saki"] = "嗯...没办法杠...",
["designer:Saki"] = "Sword Elucidator",
["cv:Saki"] = "植田佳奈",
["illustrator:Saki"] = "",

}

--沙耶香


SE_Wuwei = sgs.CreateTriggerSkill{
	name = "SE_Wuwei",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Damaged, sgs.EventPhaseStart, sgs.CardUsed, sgs.DamageCaused, sgs.TargetConfirmed, sgs.CardFinished, sgs.SlashProceed},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.Damaged then
			if player:isAlive() and player:hasSkill(self:objectName()) then
				room:broadcastSkillInvoke(self:objectName(),math.random(2,3)) --回复 = 3
				local re = sgs.RecoverStruct()
				re.who = player
				room:recover(player,re,true)
				player:gainMark("@Wuwei")
				if player:getMark("@Wuwei") > room:getAlivePlayers():length() / 2 and player:getMark("@Wuwei") > 2 then
					room:setPlayerFlag(player,"InfinityAttackRange")
				end
			end
		elseif event == sgs.EventPhaseStart then
			if player:hasSkill(self:objectName()) and player:getPhase() == sgs.Player_RoundStart then
				if player:getMark("@Wuwei") > room:getAlivePlayers():length() / 2 and player:getMark("@Wuwei") > 2 then
					room:setPlayerFlag(player,"InfinityAttackRange")
				end
			end
			if player:hasSkill(self:objectName()) and player:getPhase() == sgs.Player_Finish then
				if player:getMark("@Wuwei") > room:getAlivePlayers():length() and player:getMark("@Wuwei") > 4 then
					room:broadcastSkillInvoke(self:objectName(), 4)
					room:doLightbox("SE_Wuwei_change$", 3000)
					if player:getGeneralName() == "Sayaka" then
						room:changeHero(player,"Majyo",true, false, false, true)
					else
						room:changeHero(player,"Majyo",true, false, true, true)
					end
					if not player:isLord() then
						room:setPlayerProperty(player, "role", sgs.QVariant("renegade"))
					end
				else
					room:broadcastSkillInvoke(self:objectName(),math.random(2,3)) --回复 = 2，3
					local re = sgs.RecoverStruct()
					re.who = player
					room:recover(player,re,true)
					player:drawCards(1)
				end
			end
		elseif event == sgs.CardUsed then
			local use = data:toCardUse()
			local card = use.card
			local source = use.from
			local room = player:getRoom()
			if card:isKindOf("Slash") then
				if source:objectName() == player:objectName() then
					if not source:askForSkillInvoke(self:objectName(), data) then return end
					room:broadcastSkillInvoke(self:objectName(),math.random(1,2)) --杀人 = 1 or 2
					room:doLightbox("SE_Wuwei$", 800)
					source:gainMark("@Wuwei")
					if source:getMark("@Wuwei") > room:getAlivePlayers():length() / 2 and source:getMark("@Wuwei") > 2 then
						room:setPlayerFlag(source,"InfinityAttackRange")
					end
					card:setFlags("wuwei_used")
				end
			end
		elseif event == sgs.DamageCaused then
			local damage = data:toDamage()
			if not damage.card then return end
			if damage.card:isKindOf("Slash") and damage.from:hasSkill(self:objectName()) and damage.from:getMark("@Wuwei") > room:getAlivePlayers():length() and damage.from:getMark("@Wuwei") > 4 then
				damage.from:drawCards(1)
			end
			if damage.card:hasFlag("wuwei_used") then
				damage.damage = damage.damage + 1
				data:setValue(damage)
				damage.from:loseMark("@Wuwei", 1)
				if damage.from:getMark("@Wuwei") <= room:getAlivePlayers():length() / 2 or damage.from:getMark("@Wuwei") <= 2 and damage.from:hasFlag("InfinityAttackRange") then
					room:setPlayerFlag(damage.from,"-InfinityAttackRange")
				end
				easyTalk(room, "#SE_Wuwei_plusOne")
				return
			end
		elseif event == sgs.TargetConfirmed then
			local use = data:toCardUse()
			if use.from and use.from:hasSkill(self:objectName()) and use.from:getMark("@Wuwei") > 2 then
				if use.card:isKindOf("Slash") then
					if use.from:objectName() == player:objectName() then
					room:setPlayerFlag(use.from, "WuweiArmor")
					easyTalk(room, "#SE_Wuwei_Armor")
						for _,p in sgs.qlist(use.to) do
							room:setPlayerMark(p, "Armor_Nullified", 1)
						end
					end
				end
			end
			return false
		elseif event == sgs.CardFinished then
			local use = data:toCardUse()
			if use.card:isKindOf("Slash") and use.from:hasFlag("WuweiArmor") then
				for _,p in sgs.qlist(use.to) do
					room:setPlayerMark(p, "Armor_Nullified", 0)
				end
			end
		elseif event == sgs.SlashProceed then
			local effect = data:toSlashEffect()
			local source = effect.from
			if source:hasSkill(self:objectName()) and source:getMark("@Wuwei") > room:getAlivePlayers():length() and source:getMark("@Wuwei") > 4 then
				easyTalk(room, "#SE_Wuwei_noJink")
				room:slashResult(effect, nil)
				return true
			end
		end
	end
}

SE_Wuwei_tmod = sgs.CreateTargetModSkill{
    name = "#SE_Wuwei_tmod",
    pattern = "Slash",
    residue_func = function(self, player)
        if player:hasSkill(self:objectName()) and player:getMark("@Wuwei") > 1 then
            return 1000
        end
    end,
}

Sayaka:addSkill(SE_Wuwei)
Sayaka:addSkill(SE_Wuwei_tmod)
extension:insertRelatedSkills("SE_Wuwei", "#SE_Wuwei_tmod")


sgs.LoadTranslationTable{
["SE_Wuwei$"] = "image=image/animate/SE_Wuwei.png",
["SE_Wuwei_change$"] = "image=image/animate/SE_Wuwei_change.png",
["SE_Wuwei"] = "无畏",
["$SE_Wuwei1"] = "...不要妨碍我，我一个人能解决..",
["$SE_Wuwei2"] = "只要我有此意，痛觉什么的，呵呵...呵呵...啊哈哈哈哈！",
["$SE_Wuwei3"] = "这个名为梦之事物啊，并不是什么悲伤的事情哦。",
["$SE_Wuwei4"] = "我真是个笨蛋...",
[":SE_Wuwei"]="锁定技。你每受到一次伤害后，你回复一点体力然后你获得一个“无畏”标记。\n\n回合结束阶段开始时，若你的“无畏”标记大于场上存活角色数（至少为4），你变身为魔女并将你的身份变为内奸（主公时不变），否则你回复一点体力并摸一张牌。\n\n当你使用【杀】时，你可以获得一个“无畏”标记，此【杀】造成伤害时，该伤害+1，你失去一个“无畏”标记。\n\n若你的“无畏”标记大于1，你使用【杀】无次数限制；\n\n若你的“无畏”标记大于2，你使用【杀】无视防具；\n\n若你的“无畏”标记大于场上存活角色数（至少为4）/2，你回合内使用【杀】无视距离；\n\n若你的“无畏”标记大于场上存活角色数（至少为4），你的【杀】不可闪避且你使用【杀】造成伤害时摸一张牌。",
["@Wuwei"] = "无畏",
["#SE_Wuwei_Armor"] = "沙耶香发动了「无畏」无视了目标的防具。",
["#SE_Wuwei_plusOne"] = "沙耶香发动了「无畏」令该伤害+1",
["#SE_Wuwei_noJink"] = "沙耶香发动了「无畏」令目标不能闪避。",
["#SE_Wuwei_noLimit"] = "沙耶香发动了「无畏」出【杀】没有次数限制。",

["Sayaka"] = "美樹沙耶香",
["&Sayaka"] = "美樹沙耶香",
["@Sayaka"] = "魔法少女小圆",
["#Sayaka"] = "迷茫的魔法少女",
["~Sayaka"] = "我真是个笨蛋...",
["designer:Sayaka"] = "OmnisReen; Sword Elucidator",
["cv:Sayaka"] = "喜多村英梨",
["illustrator:Sayaka"] = "momonote",

["Majyo"] = "魔女",
["&Majyo"] = "魔女",
["#Majyo"] = "崩溃的魔法少女",
["~Majyo"] = "",
["designer:Majyo"] = "Sword Elucidator",
["cv:Majyo"] = "",
["illustrator:Majyo"] = "",
}

se_gatecard = sgs.CreateSkillCard{
	name = "se_gatecard",
	target_fixed = true,
	will_throw = false,
	on_use = function(self, room, source, targets)
		local ids = self:getSubcards()
		if ids:length() == 0 then
			if source:getPile("pika_gob"):length() == 0 then return end
			local pile = source:getPile("pika_gob")
			room:fillAG(pile, source)
			local agid = room:askForAG(source, pile, false, self:objectName())
			room:clearAG(source)
			if agid == -1 then return end
			local target = room:askForPlayerChosen(source,room:getOtherPlayers(source),"se_gate")
			if not target then return end
			local choice = "gateNormal"
			local data = sgs.QVariant()
			data:setValue(target)
			choice = room:askForChoice(source,"se_gate","gateNormal+gateThunder+gateFire", data)
			local card
			if choice == "gateNormal" then
				card = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
			elseif choice == "gateThunder" then
				card = sgs.Sanguosha:cloneCard("thunder_slash", sgs.Card_NoSuit, 0)
			else
				card = sgs.Sanguosha:cloneCard("fire_slash", sgs.Card_NoSuit, 0)
			end
			card:addSubcard(agid)
			card:setSkillName(self:objectName())
			--room:broadcastSkillInvoke(self:objectName(), math.random(4, 6))
			room:doLightbox("se_gate$", 800)
			local use = sgs.CardUseStruct()
			use.from = source
			use.to:append(target)
			use.card = card
			room:useCard(use, false)
		else
			--room:broadcastSkillInvoke(self:objectName(), math.random(1, 3))
			for _,id in sgs.qlist(ids) do
				source:addToPile("pika_gob", id)
			end
		end
	end
}



se_gatevs = sgs.CreateViewAsSkill{
	name = "se_gate",
	n = 999,
	view_filter = function(self, selected, to_select)
		return to_select:isKindOf("Weapon") and #selected < 999
	end,
	view_as = function(self, cards)
		if #cards == 0 then
			return se_gatecard:clone()
		else
			local se_jcard = se_gatecard:clone()
			for i=1, #cards, 1 do
				se_jcard:addSubcard(cards[i]:getId())
			end
			return se_jcard
		end
	end,
	enabled_at_play = function(self, player)
		if player:getPile("pika_gob"):length() > 0 then return true end
		local hasWea = false
		if player:getWeapon() then hasWea = true end
		if not hasWea then
			for _,card in sgs.qlist(player:getHandcards()) do
				if card:isKindOf("Weapon") then
					hasWea = true
					break
				end
			end
		end
		return  hasWea
	end
}

se_gate=sgs.CreateTriggerSkill{
	name="se_gate",
	frequency=sgs.Skill_NotFrequent,
	events={sgs.EventPhaseStart},
	view_as_skill = se_gatevs,
	on_trigger=function(self,event,player,data)
		local room = player:getRoom()
		if event == sgs.EventPhaseStart and player:getPhase() == sgs.Player_RoundStart and player:hasSkill(self:objectName()) then
			local weapon_id = -1
			for _,id in sgs.qlist(room:getDrawPile()) do
				if sgs.Sanguosha:getCard(id):isKindOf("Weapon") then
					weapon_id = id
					break
				end
			end
			if weapon_id == -1 then
				for _,id in sgs.qlist(room:getDiscardPile()) do
					if sgs.Sanguosha:getCard(id):isKindOf("Weapon") then
						weapon_id = id
						break
					end
				end
			end
			if weapon_id == -1 then
				for _,p in sgs.qlist(room:getOtherPlayers(player)) do
					if p:getWeapon() then
						weapon_id = p:getWeapon():getEffectiveId()
						break
					end
				end
			end
			if weapon_id == -1 then return end
			if not player:askForSkillInvoke("se_gate", data) then return false end
			room:broadcastSkillInvoke("se_gate", math.random(1, 3))
			player:addToPile("pika_gob", weapon_id)
		end
	end
}

se_gateClear = sgs.CreateDetachEffectSkill{
	name = "se_gate",
	pilename = "pika_gob",
}

SE_Tiansuo = sgs.CreateTriggerSkill{
	name = "SE_Tiansuo",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.SlashProceed, sgs.TargetConfirmed},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.TargetConfirmed then
			local use = data:toCardUse()
			if use.to:length() == 1 and use.from and use.from:hasSkill(self:objectName()) and not use.to:at(0):isChained() and use.to:at(0):objectName() ~= use.from:objectName() then
				if not use.from:askForSkillInvoke(self:objectName(), data) then return end
				room:broadcastSkillInvoke(self:objectName())
				room:setPlayerProperty(use.to:at(0), "chained", sgs.QVariant(true))
			end
			if use.from:hasSkill(self:objectName()) and use.card:isKindOf("Slash") then
				for _,p in sgs.qlist(use.to) do
					if p:isChained() then
						if not room:askForCard(p,".Basic","@SE_Tiansuo-discard",data) then
							p:addMark("SE_Tiansuo")
						end
					end
				end
			end
		elseif event == sgs.SlashProceed then
			local effect = data:toSlashEffect()
			local source = effect.from
			if source:hasSkill(self:objectName()) and effect.to:getMark("SE_Tiansuo") > 0 then
				easyTalk(room, "#SE_Tiansuo_noJink")
				room:slashResult(effect, nil)
				effect.to:removeMark("SE_Tiansuo")
				return true
			end
		end
	end
}




Kinpika:addSkill(se_gate)
Kinpika:addSkill(se_gateClear)
extension:insertRelatedSkills("se_gate", "#se_gate-clear")
Kinpika:addSkill(SE_Tiansuo)


sgs.LoadTranslationTable{
["se_gate$"] = "image=image/animate/se_gate.png",
["se_gate"] = "财宝「Gate of Babylon」",
["$se_gate1"] = "假货，让你看看真伪之间的区别吧。",
["$se_gate2"] = "让你看看人类最早的真货吧！",
["$se_gate3"] = "Gate of Babylon",
["$se_gate4"] = "Gate of Babylon!!!",
["$se_gate5"] = "哼，哈哈哈哈，哈哈哈哈哈哈哈哈！",
["$se_gate6"] = "哈哈哈哈哈哈哈哈哈哈——",
["gateNormal"] = "将武器牌当做一张普通【杀】",
["gateThunder"] = "将武器牌当做一张雷属性【杀】",
["gateFire"] = "将武器牌当做一张火属性【杀】",
[":se_gate"]="回合开始时，你可以搜寻一张武器牌并放在你的武将牌上，称为“王之财宝”。出牌阶段，你可以将任意张武器牌置入“王之财宝”。你可选择一张“王之财宝”，将其视为你对一名其他角色使用了一张任意属性的【杀】。以此法使用的【杀】无视距离且不计入回合次数限制。",
["pika_gob"] = "王之财宝",

["SE_Tiansuo"] = "天锁「天之锁」",
["$SE_Tiansuo1"] = "天之锁！",
["$SE_Tiansuo2"] = "消失吧，蠢货。",
["$SE_Tiansuo3"] = "杂种一样的东西，也敢朝着王吠么。",
["$SE_Tiansuo4"] = "那么，这是你最后的舞台了",
["$SE_Tiansuo5"] = "送你归西吧。",
[":SE_Tiansuo"]="你指定一名其他角色为唯一目标时，可以令其横置。你指定横置的角色为目标使用【杀】时，其需弃置一张基本牌，否则该【杀】不能闪避。",
["#SE_Tiansuo_noJink"] = "吉尔伽美什的「天之锁」令该【杀】不可被闪避。",
["@SE_Tiansuo-discard"] = "吉尔伽美什的「天之锁」效果，你需要弃置一张基本牌，否则该【杀】不能闪避。",

["Kinpika"] = "吉尔伽美什",
["&Kinpika"] = "吉尔伽美什",
["@Kinpika"] = "Fate Zero/Fate Stay Night",
["#Kinpika"] = "金闪闪",
["~Kinpika"] = "明明是个杂种！#￥%…",
["designer:Kinpika"] = "Sword Elucidator",
["cv:Kinpika"] = "関智一",
["illustrator:Kinpika"] = "null",
}

se_origincard = sgs.CreateSkillCard{
	name = "se_origincard",
	target_fixed = true,
	will_throw = true,
	mute = true,
	on_use = function(self, room, source, targets)
		--room:broadcastSkillInvoke("se_origin")
		room:loseMaxHp(source)
		source:gainMark("@origin_bullet")
	end,
}

se_origin = sgs.CreateViewAsSkill{
	name = "se_origin",
	n = 0,
	view_as = function(self, cards)
		return se_origincard:clone()
	end,
	enabled_at_play = function(self, player)
		return player:getMaxHp() > 1
	end,
}


se_origin_trigger = sgs.CreateTriggerSkill{
	name = "se_origin",
	frequency = sgs.Skill_NotFrequent,
	view_as_skill = se_origin,
	events = {sgs.TargetConfirmed, sgs.DrawNCards, sgs.DamageCaused, sgs.CardFinished},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.TargetConfirmed then
			local use = data:toCardUse()
			local card = use.card
			local source = use.from
			if card:isKindOf("Slash") then
				if use.to:length() == 1 and source:objectName() == player:objectName() and source:getMark("@origin_bullet") > 0 and use.to:at(0):getMark("@Biling_target") == 0 then
					local choice = room:askForChoice(source,"se_origin","use_normal+use_origin", data)
					source:setFlags("slash_one")
					if choice == "use_origin" then
						card:setFlags("origin_bullet")
					end
				end
			end
		elseif event == sgs.DrawNCards then
			if player:hasSkill("se_origin") and player:getMark("@origin_bullet") > 0 then
				data:setValue(data:toInt() + player:getMark("@origin_bullet"))
			end
		elseif event == sgs.DamageCaused then
			local damage = data:toDamage()
			if damage.card and damage.card:isKindOf("Slash") and damage.card:hasFlag("origin_bullet") then
				local sb = damage.to
				local skill_list
				if sb:getGeneral2() then
					skill_list = sgs.Sanguosha:getGeneral(sb:getGeneral2Name()):getSkillList()
				end
				room:broadcastSkillInvoke("se_origin", 4)
				room:doLightbox("se_origin$", 3000)
				room:setEmotion(sb, "skills/origin")
				if skill_list then
	                for _,skill in sgs.qlist(sb:getSkillList(false, false)) do
	                	if sb:hasSkill(skill:objectName()) and not skill_list:contains(skill) then
	                    	room:detachSkillFromPlayer(sb, skill:objectName())
	                    end
	                end
	            else
	            	for _,skill in sgs.qlist(sb:getSkillList(false, false)) do
	                	if sb:hasSkill(skill:objectName()) then
	                    	room:detachSkillFromPlayer(sb, skill:objectName())
	                    end
	                end
	            end
                doLog("#se_origin_ko",sb)
			end
		elseif event == sgs.CardFinished then
			local use = data:toCardUse()
			local card = use.card
			local source = use.from
			if card:isKindOf("Slash") and card:hasFlag("origin_bullet") then
				source:loseMark("@origin_bullet")
				card:setFlags("-origin_bullet")
			end
		end
	end,
}

se_origin_tmod = sgs.CreateTargetModSkill{
    name = "#se_origin_tmod",
    pattern = "Slash",
    residue_func = function(self, player)
        if player:hasSkill("se_origin") and player:getMark("@origin_bullet") > 0 then
            return player:getMark("@origin_bullet")
        end
    end,
}

se_bilingcard = sgs.CreateSkillCard{
	name = "se_bilingcard",
	skill_name = "se_biling",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		return #targets == 0
	end,
	on_use = function(self, room, source, targets)
		room:broadcastSkillInvoke("se_biling", math.random(1, 3))
		source:loseMark("@Biling_kiri")
		local target = targets[1]
		target:gainMark("@Biling_target")
		room:doLightbox("se_biling$", 3000)
		if target:getGeneral2() then
			room:getThread():delay(2000)
			room:broadcastSkillInvoke("se_biling", 4)
			room:changeHero(target,"sujiang",false, false, true, true)
		else
			local targets = room:getOtherPlayers(source)
			targets:removeOne(target)
			if targets:length() == 0 then return end
			local from = room:askForPlayerChosen(source, targets,"se_biling")
			if not from then return end
			room:broadcastSkillInvoke("se_biling", 5)
			room:getThread():delay(5000)
			for i = 1, 2,1 do
				if not from:isAlive() then return end
				local card = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
				card:setSkillName("se_bilingcard")
				local use = sgs.CardUseStruct()
				use.from = from
				use.to:append(target)
				use.card = card
				room:useCard(use, false)
			end
		end
	end,
}


se_bilingvs = sgs.CreateViewAsSkill{
	name = "se_biling",
	n = 0,
	view_as = function(self, cards)
		card = se_bilingcard:clone()
		return card
	end,
	enabled_at_play = function(self, player)
		return player:getMark("@Biling_kiri") > 0
	end,
}

se_biling = sgs.CreateTriggerSkill{
	name = "se_biling",
	frequency = sgs.Skill_Limited,
	limit_mark = "@Biling_kiri",
	events = {sgs.DamageCaused},
	view_as_skill = se_bilingvs,
	on_trigger = function(self, event, player, data)
		if event == sgs.DamageCaused then
			local damage = data:toDamage()
			if damage.from:hasSkill("se_biling") and damage.to:getMark("@Biling_target") > 0 then
				doLog("#se_biling_nodamage",damage.to)
				damage.to:getRoom():broadcastSkillInvoke("se_biling", 6)
				return true
			end
		end
	end
}

se_jianqiao = sgs.CreateTriggerSkill{
	name = "se_jianqiao",
	frequency = sgs.Skill_Limited,
	limit_mark = "@kiri_jianqiao",
	events = {sgs.DamageInflicted},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.DamageInflicted then
			local damage = data:toDamage()
			if damage.to:getHp() - damage.damage <= 0 then
				local kiri = room:findPlayerBySkillName(self:objectName())
				if not kiri or kiri:getMark("@kiri_jianqiao") == 0 then return end
				if not kiri:askForSkillInvoke(self:objectName(), data) then return end
				kiri:loseMark("@kiri_jianqiao")
				room:broadcastSkillInvoke("se_jianqiao")
				room:doLightbox("se_jianqiao$", 3000)
				local re = sgs.RecoverStruct()
				re.who = damage.to
				room:recover(damage.to,re,true)
				return true
			end
		end
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
}

Kiritsugu:addSkill(se_origin_trigger)
Kiritsugu:addSkill(se_origin_tmod)
extension:insertRelatedSkills("se_origin", "#se_origin_tmod")
Kiritsugu:addSkill(se_biling)
Kiritsugu:addSkill(se_jianqiao)

--卫宫切嗣
sgs.LoadTranslationTable{
["se_origin$"] = "image=image/animate/se_origin.png",
["@origin_bullet"] = "起源弹",
["use_normal"] = "作为普通的【杀】使用",
["use_origin"] = "使用起源弹",
["#se_origin_ko"] = "%from 受到起源弹的影响，失去了所有的技能。",
["se_origin"] = "起源「起源弹」",

["$se_origin1"] = "小少爷的起源是“切断”和“结合”，切断之后再连结。",
["$se_origin2"] = "这颗子弹放进了小少爷肋骨磨成的粉末，小少爷的起源会在被它击中的人身上具体化。",
["$se_origin3"] = "这就是小少爷的礼装，起源弹",
["$se_origin4"] = "（砰——）",
[":se_origin"]="出牌阶段，你可以失去一点体力上限，获得一发“起源弹”。\n若你拥有起源弹，你额外摸“起源弹”数目张牌，你回合使用【杀】次数+“起源弹”数目。\n你使用【杀】指定一名角色时，需选择是否为“起源弹”（目标不知道选项），当你的【杀】造成的伤害时，若为“起源弹”，目标失去副将外的所有的技能。",

["se_biling"] = "逼令「自我强制证文」",
["se_biling$"] = "image=image/animate/se_biling.png",
["@Biling_kiri"] = "自我强制证文",
["@Biling_target"] = "逼令目标",
["se_bilingcard"] = "逼令",
["#se_biling_nodamage"] = "受到自我强制证文的影响，卫宫切嗣不能对 %from 造成伤害。",
["$se_biling1"] = "卫宫的刻印下令，以下列条件成立为前提，誓约如同戒律，毫无例外的束缚对象",
["$se_biling2"] = "...永远禁止做出杀害，伤害意图以及行为，条件......（呃......）",
["$se_biling3"] = "的确只要达成了条件，他就杀不了我了，可是......",
["$se_biling4"] = "用掉所有剩下的令咒，让Servant自尽。",
["$se_biling5"] = "嗯，成立了，我已经无法再伤害你们了。（打火机声，枪声）仅限我。",
["$se_biling6"] = "不好意思，契约让我做不到。",
[":se_biling"]="限定技。你指定一名角色，令其获得效果：你对其造成伤害时，取消之，且其不能成为起源弹的目标。若该角色有副将，令该角色移除自己的副将；若该角色没有副将，其受到你指定的你和其以外的来源的两张【杀】（若无来源则无效）。",

["@kiri_jianqiao"] = "剑鞘",
["se_jianqiao"] = "剑鞘「亚瑟王的治愈之力」",
["se_jianqiao$"] = "image=image/animate/se_jianqiao.png",
["$se_jianqiao"] = "还活着...还活着...还活着......",
[":se_jianqiao"]="限定技。当一名角色受到造成濒死的伤害时，你可以取消之并令其回复一点体力。",

["Kiritsugu"] = "衛宮切嗣",
["&Kiritsugu"] = "衛宮切嗣",
["@Kiritsugu"] = "Fate Zero",
["#Kiritsugu"] = "正义天平的衡量者",
["~Kiritsugu"] = "（士郎）就交给我吧，老爹的梦想。 ————啊，那就安心了。",
["designer:Kiritsugu"] = "Sword Elucidator",
["cv:Kiritsugu"] = "小山力也",
["illustrator:Kiritsugu"] = "砂雲",
}

--八云社长


se_banyun = sgs.CreateViewAsSkill{
	name = "se_banyun",
	n = 0,
	view_as = function(self, cards)
		local card = se_banyuncard:clone()
		card:setSkillName(self:objectName())
		return card
	end,
	enabled_at_play = function(self, player)
		return not player:hasUsed("#se_banyuncard")
	end
}
se_banyuncard = sgs.CreateSkillCard{
	name = "se_banyuncard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		if #targets < 1 then
			return to_select:objectName() ~= sgs.Self:objectName() and sgs.Self:distanceTo(to_select) == 1
		end
	end,
	on_use = function(self, room, source, targets)
		local peopleA = targets[1]
		local peopleB
		local all = room:getOtherPlayers(peopleA)
		all:removeOne(source)
		peopleB = room:askForPlayerChosen(source, all,"se_banyun")
		if not peopleA or not peopleB then return end
		room:doLightbox("se_banyun$", 1000)
		local maxMove = room:getAlivePlayers():length() - 1
		for i = 1, 5 do
			local step = math.random(1, maxMove)
			for j = 1, step do
				room:swapSeat(source, source:getNextAlive())
			end
			for j = 1, step do
				room:swapSeat(peopleA, peopleA:getNextAlive())
			end
			room:getThread():delay(500)
		end
		for k = 1, maxMove do
			if source:getNextAlive():objectName() == peopleB:objectName() then
				for m = 1, k - 1 do
					room:swapSeat(peopleA, peopleA:getNextAlive())
				end
				break
			else
				room:swapSeat(source, source:getNextAlive())
			end
		end
		local da = sgs.DamageStruct()
		da.from = source
		da.to = peopleA
		room:damage(da)
	end
}

se_jianxi = sgs.CreateViewAsSkill{
	name = "se_jianxi",
	n = 0,
	view_as = function(self, cards)
		local card = se_jianxicard:clone()
		card:setSkillName(self:objectName())
		return card
	end,
	enabled_at_play = function(self, player)
		return not player:hasUsed("#se_jianxicard")
	end
}
se_jianxicard = sgs.CreateSkillCard{
	name = "se_jianxicard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		return #targets < 2
	end,
	on_use = function(self, room, source, targets)
		local peopleA = targets[1]
		local peopleB = targets[2]
		if not peopleA or not peopleB then return end
		room:doLightbox("se_jianxi$", 1000)
		room:swapSeat(peopleA, peopleB)
	end
}

se_shenglong = sgs.CreateTriggerSkill{
	name = "se_shenglong",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DamageInflicted},
	priority = 10,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.DamageInflicted then
			if not damage.from then return end
			if damage.from:objectName() == player:objectName() then return end
			local num = damage.from:getHandcardNum()
			room:broadcastSkillInvoke(self:objectName())
			room:doLightbox("se_shenglong$", 1000)
			if num == 0 then return true end
			if num < 4 then
				local da = sgs.DamageStruct()
				da.from = player
				da.to = damage.from
				room:damage(da)
			elseif num < 7 then
				local da = sgs.DamageStruct()
				da.from = player
				da.to = damage.from
				da.damage = 2
				room:damage(da)
			else
				local da = sgs.DamageStruct()
				da.from = player
				da.to = damage.from
				da.damage = 3
				room:damage(da)
			end
		end
		return false
	end,
}

Yakumo:addSkill(se_banyun)
Yakumo:addSkill(se_jianxi)
Yakumo:addSkill(se_shenglong)
sgs.LoadTranslationTable{
["se_banyun"] = "搬运",
["$se_banyun1"] = "（音效）",
["se_banyun$"] = "image=image/animate/se_banyun.png",
[":se_banyun"]="出牌阶段限一次，指定一名距离为1的其他角色A和任意一名你和A以外的角色B。你带着A随机位移5次，然后你和A以原次序移动到B的左侧。若如此做，你对A造成一点伤害。",

["se_jianxi"] = "间隙",
["$se_jianxi1"] = "（音效）",
["$se_jianxi2"] = "（音效）",
["se_jianxi$"] = "image=image/animate/se_jianxi.png",
[":se_jianxi"]="出牌阶段限一次，你可以指定两名角色交换位置。",

["se_shenglong"] = "升龙",
["$se_shenglong1"] = "（音效）",
["se_shenglong$"] = "image=image/animate/se_shenglong.png",
[":se_shenglong"]="锁定技。你受到其他角色的伤害时，若伤害来源的手牌数为0，取消之；为1-3，伤害来源受到一点你造成的伤害；为4-6，伤害来源受到两点你造成的伤害；大于6，伤害来源受到三点你造成的伤害。",

["Yakumo"] = "社长八云",
["&Yakumo"] = "社长八云",
["@Yakumo"] = "拳皇/TH",
["#Yakumo"] = "搬运社",
["~Yakumo"] = "啊————KO",
["designer:Yakumo"] = "军师可以打酱油",
["cv:Yakumo"] = "",
["illustrator:Yakumo"] = "",
}

--雪之下雪乃

se_shifeng = sgs.CreateTriggerSkill{
	name = "se_shifeng",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageCaused},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.DamageCaused then
			local damage = data:toDamage()
			if damage.damage < 1 then return end
			local source = damage.from
			if not source then return end
			local mygod = room:findPlayerBySkillName(self:objectName())
			if not mygod then return end
			if mygod:getMark("@Yukino_shifeng") > 1 then return end
			if not mygod:askForSkillInvoke(self:objectName(), data) then return end
			room:broadcastSkillInvoke(self:objectName())
			room:doLightbox("se_shifeng$", 800)
			damage.damage = damage.damage - 1
			data:setValue(damage)
			mygod:gainMark("@Yukino_shifeng")
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
	priority = -10
}


se_zhiyanVS = sgs.CreateZeroCardViewAsSkill{
	name = "se_zhiyan",
	response_pattern = "nullification",
	view_as = function(self)
		local ncard = sgs.Sanguosha:cloneCard("nullification", sgs.Card_NoSuit, 0)
		ncard:setSkillName(self:objectName())
		return ncard
	end,
	enabled_at_nullification = function(self, player)
		return player:getMark("@yukino_zhiyan") > 0
	end
}

se_zhiyan = sgs.CreateTriggerSkill{
	name = "se_zhiyan",
	view_as_skill = se_zhiyanVS,
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DrawNCards, sgs.CardUsed},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.DrawNCards then
			if player:hasSkill(self:objectName()) then
				player:loseAllMarks("@yukino_zhiyan")
				local counts = player:getMark("@Yukino_shifeng")
				player:loseAllMarks("@Yukino_shifeng")
				if counts == 0 then return end
				data:setValue(0)
				if counts >= 2 then
					player:gainMark("@yukino_zhiyan")
				end
			end
		elseif event == sgs.CardUsed then
			local use = data:toCardUse()
			local card = use.card
			local source = use.from
			if card:isKindOf("Nullification") then
				if source:objectName() == player:objectName() and card:getSkillName() == "se_zhiyan" and card:getSuit() == sgs.Card_NoSuit and card:getNumber() == 0 then
					player:gainMark("@Yukino_shifeng")
				end
			end
		end
	end
}

se_zhiyanClear = sgs.CreateDetachEffectSkill{
	name = "se_zhiyan",
	on_skill_detached = function(self, room, player)
		player:loseAllMarks("@Yukino_shifeng")
		player:loseAllMarks("@yukino_zhiyan")
	end,
}

--結衣

se_wenchang = sgs.CreateTriggerSkill{
	name = "se_wenchang",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Damaged},
	priority = 2,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.Damaged then
			if not damage.to:isAlive() or not damage.from or damage.from:isNude() then return end
			local Yyui = room:findPlayerBySkillName(self:objectName())
			if not Yyui then return end
			if Yyui:isNude() then return end
			if not Yyui:askForSkillInvoke(self:objectName(), data) then return end
			if not room:askForDiscard(Yyui,self:objectName(),1,1,false,true) then return end
			local cardid = room:askForCardChosen(damage.to, damage.from, "he", self:objectName())
			if cardid == -1 then return end
			room:broadcastSkillInvoke(self:objectName())
			room:obtainCard(damage.to, cardid)
			local card = sgs.Sanguosha:getCard(cardid)
			if not card then return end
			if card:isRed() then
				local re = sgs.RecoverStruct()
				re.who = damage.to
				room:recover(damage.to,re,true)
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
}

se_yuanxin = sgs.CreateTriggerSkill{
	name = "se_yuanxin",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageInflicted},
	priority = 10,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.DamageInflicted then
			if damage.damage < 2 then return end
			local Yyui = room:findPlayerBySkillName(self:objectName())
			if not Yyui then return end
			if not Yyui:askForSkillInvoke(self:objectName(), data) then return end
			room:broadcastSkillInvoke(self:objectName())
			room:doLightbox("se_yuanxin$", 1500)
			local da = sgs.DamageStruct()
			da.from = damage.from
			da.to = Yyui
			room:damage(da)
			damage.damage = damage.damage - 1
			data:setValue(damage)
			room:showAllCards(Yyui, damage.to)
			room:showAllCards(damage.to,Yyui)
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
}

Yukino:addSkill(se_shifeng)
Yukino:addSkill(se_zhiyan)
Yukino:addSkill(se_zhiyanClear)
extension:insertRelatedSkills("se_zhiyan", "#se_zhiyan-clear")

Yyui:addSkill(se_wenchang)
Yyui:addSkill(se_yuanxin)

sgs.LoadTranslationTable{
["se_shifeng"] = "侍奉",
["@Yukino_shifeng"] = "侍奉",
["$se_shifeng1"] = "你来了呢",
["$se_shifeng2"] = "本来我们就无法知道别人的想法，就算相识也不一定理解对方。",
["$se_shifeng3"] = "平常...呢...是么，这就是对你来说的平常么。",
["$se_shifeng4"] = "你是在说...不想改变呢",
["$se_shifeng5"] = "（静）打扰了，有些事情要拜托你们一下。",
["$se_shifeng6"] = "不是的...我总是以为自己做的很好，却是自作聪明而已。",
[":se_shifeng"]="一名角色受到伤害时，若你的“侍奉”标记不超过2，你可以令该伤害值-1。若如此做，你获得一个“侍奉”标记。",

["se_shifeng$"] = "image=image/animate/se_shifeng.png",
["@yukino_zhiyan"] = "直言",
["se_zhiyan"] = "直言",
["$se_zhiyan1"] = "你的这种做法，我很厌烦。",
["$se_zhiyan2"] = "虽然不知道怎么形容，但我对此感到十分焦躁",
["$se_zhiyan3"] = "那你也不用特意去撒那种谎的。",
["$se_zhiyan4"] = "也没什么关系，我不可能去干涉你私人的行动，而且也没那种资格。",
[":se_zhiyan"]="摸牌阶段，若你有“侍奉”标记，你的摸牌数为0;若你的“侍奉”标记数至少为2，直到你的下一个摸牌阶段你获得效果 「当你需要使用【金色宣言】时，你可以视为使用一张【金色宣言】，并获得一个“侍奉”标记。」结算后，将“侍奉”标记全部弃置。",

["se_wenchang"] = "稳场",
["$se_wenchang1"] = "就是嘛。啊哈哈...哈哈......",
["$se_wenchang2"] = "说起来大家都和平常一样啊，那个，嗯，大家都......",
["$se_wenchang3"] = "等等...怎么会变成这样的呢...很奇怪啊......",
[":se_wenchang"]="一次伤害造成后，你可以弃置一张牌，令受到伤害的角色获得伤害来源的一张牌并展示。若获得的牌为红色，受伤角色回复一点体力。",

["se_yuanxin$"] = "image=image/animate/se_yuanxin.png",
["se_yuanxin"] = "援心",
["$se_yuanxin1"] = "但是...但是呢...以后可不能再做这种事了。",
["$se_yuanxin2"] = "但是.....你也要考虑下别人的感受啊......为什么你知道那么多东西，却偏偏不明白这个啊！......",
["$se_yuanxin3"] = "那样的......我不想看到。",
["$se_yuanxin4"] = "我喜欢这个社团......喜欢...的",
[":se_yuanxin"]="一名角色受到伤害时，若伤害值不小于2，你可以受到伤害来源的一点伤害，然后令该伤害-1。若如此做，你和受到伤害的角色互相观看手牌。",

["Yukino"] = "雪之下雪乃",
["&Yukino"] = "雪之下雪乃",
["@Yukino"] = "果然我的青春恋爱喜剧搞错了",
["#Yukino"] = "侍奉部长",
["~Yukino"] = "为什么...你要哭呢...果然你...卑怯呢...",
["designer:Yukino"] = "Sword Elucidator",
["cv:Yukino"] = "早见沙织",
["illustrator:Yukino"] = "刃天",

["Yyui"] = "由比滨结衣",
["&Yyui"] = "由比滨结衣",
["@Yyui"] = "果然我的青春恋爱喜剧搞错了",
["#Yyui"] = "决意的团子",
["~Yyui"] = "但是呢...我...不想要现在这个样子啊...",
["designer:Yyui"] = "Sword Elucidator",
["cv:Yyui"] = "东山奈央",
["illustrator:Yyui"] = "コ゛りぼて",
}

--佐仓千代

se_linmoVS = sgs.CreateOneCardViewAsSkill{
    name = "se_linmo",
    view_filter = function(self, card)
    	if sgs.Self:getPile("drawing"):length() == 0 then return false end
    	local tp
			local copy_id = sgs.Self:getPile("copying"):at(0)
			if copy_id == -1 then return false end

    	if sgs.Sanguosha:getCard(sgs.Self:getPile("copying"):at(0)):isKindOf("BasicCard") then tp = "BasicCard" end
    	if sgs.Sanguosha:getCard(sgs.Self:getPile("copying"):at(0)):isKindOf("TrickCard") then tp = "TrickCard" end
    	if sgs.Sanguosha:getCard(sgs.Self:getPile("copying"):at(0)):isKindOf("EquipCard") then tp = "EquipCard" end
    	if not tp then return false end
        if not card:isKindOf(tp) then return false end
        if sgs.Sanguosha:getCard(sgs.Self:getPile("copying"):at(0)):isKindOf("Slash") then
	        if sgs.Sanguosha:getCurrentCardUseReason() == sgs.CardUseStruct_CARD_USE_REASON_PLAY then
	            local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_SuitToBeDecided, -1)
	            slash:addSubcard(card:getEffectiveId())
	            slash:deleteLater()
	            return slash:isAvailable(sgs.Self)
	        end
	    end
	    return true
    end,
    view_as = function(self, originalCard)
    	local name = sgs.Sanguosha:getCard(sgs.Self:getPile("drawing"):at(0)):objectName()
        local slash = sgs.Sanguosha:cloneCard(name, originalCard:getSuit(), originalCard:getNumber())
        slash:addSubcard(originalCard:getId())
        slash:setSkillName(self:objectName())
        return slash
    end,
    enabled_at_play = function(self, player)
        return sgs.Slash_IsAvailable(player)
    end,
    enabled_at_response = function(self, player, pattern)
        return (pattern == "slash" and sgs.Sanguosha:getCard(sgs.Self:getPile("copying"):at(0)):isKindOf("Slash")) or (pattern == "jink" and sgs.Sanguosha:getCard(sgs.Self:getPile("copying"):at(0)):isKindOf("Jink")) or (pattern == "nullification" and sgs.Sanguosha:getCard(sgs.Self:getPile("copying"):at(0)):isKindOf("Nullification"))
    end
}

se_linmo = sgs.CreateTriggerSkill{
	name = "se_linmo",
	view_as_skill = se_linmoVS,
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.CardUsed, sgs.EventPhaseChanging},
	priority = -100,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event==sgs.CardUsed then
			local use=data:toCardUse()
			if not use.card then return end
			if use.card:getSkillName() == "se_linmo" then
				use.from:drawCards(1)
				return false
			end
			if use.from:getPhase() ~= sgs.Player_Play then return end
			if not use.card:isKindOf("BasicCard") and not use.card:isKindOf("TrickCard") then return end
			if use.card:getNumber() == 0 or use.card:getSuit() == sgs.Card_NoSuit then return end
			local chi = room:findPlayerBySkillName("se_linmo")
			if not chi then return end
			if chi:isNude() then return end
			if chi:objectName() == use.from:objectName() then return end
			if chi:getPile("drawing"):length() > 0 then return end
			if not room:askForSkillInvoke(chi, "se_linmo", data) then return end
			room:broadcastSkillInvoke("se_linmo")
			room:doLightbox("se_linmo$", 800)
			chi:addToPile("drawing", use.card:getEffectiveId())
			local new_card = room:askForCardChosen(chi, chi, "he", self:objectName())
			chi:addToPile("copying", new_card)
		elseif event==sgs.EventPhaseChanging then
			local change = data:toPhaseChange()
			if change.to == sgs.Player_NotActive and player:hasSkill("se_linmo") then
				player:removePileByName("drawing")
				player:removePileByName("copying")
			end
		end
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
}

se_linmoClear = sgs.CreateDetachEffectSkill{
	name = "se_linmo",
	on_skill_detached = function(self, room, player)
		player:removePileByName("drawing")
		player:removePileByName("copying")
	end,
}

se_zhenfen = sgs.CreateTriggerSkill{
	name = "se_zhenfen",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.CardUsed, sgs.EventPhaseStart, sgs.EventLoseSkill},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if player:isAlive() then
			if event == sgs.CardUsed then
				if player:getPhase() == sgs.Player_Play then
					local use = data:toCardUse()
					local card = use.card
					if card and use.from:hasSkill(self:objectName()) then
						if use.from:getMark("@zhenfen_carduse") == use.from:getHp() then
							room:broadcastSkillInvoke("se_zhenfen")
							room:doLightbox("se_zhenfen$", 800)
							if use.from:getGeneralName() == "Chiyo" then
								room:changeHero(use.from,"Eugen",false, false, false, true)
							else
								room:changeHero(use.from,"Eugen",false, false, true, true)
							end
							use.from:loseAllMarks("@zhenfen_carduse")
							use.from:removePileByName("drawing")
							use.from:removePileByName("copying")
						else
							use.from:gainMark("@zhenfen_carduse")
						end
					end
				end
			elseif event == sgs.EventPhaseStart then
				if player:getPhase() == sgs.Player_Play and player:hasSkill(self:objectName()) then
					player:loseAllMarks("@zhenfen_carduse")
				end
			end
		end
	end,
}

se_zhenfenClear = sgs.CreateDetachEffectSkill{
	name = "se_zhenfen",
	on_skill_detached = function(self, room, player)
		player:loseAllMarks("@zhenfen_carduse")
	end,
}

se_fupao = sgs.CreateTriggerSkill{
	name = "se_fupao",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.CardUsed, sgs.Damage},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.CardUsed then
			local use = data:toCardUse()
			local card = use.card
			if not card:isKindOf("Slash") then return end
			local eu = room:findPlayerBySkillName(self:objectName())
			if not eu then return end
			if not use.from or use.from:objectName()  == eu:objectName() then return end
			if use.to:length() == 0 then return end
			if not eu:askForSkillInvoke(self:objectName(), data) then return end
			room:broadcastSkillInvoke("se_fupao")
			room:doLightbox("se_fupao$", 800)
			local ap = sgs.QVariant()
			ap:setValue(use.from)
			room:setTag("se_fupao_tag",ap)
			local ncard = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
			ncard:setSkillName("se_fupao")
			local nuse = sgs.CardUseStruct()
			nuse.from = eu
			nuse.to = use.to
			nuse.card = ncard
			room:useCard(nuse, false)
		elseif event == sgs.Damage then
			local damage = data:toDamage()
			if not damage.card then return end
			if not damage.card:isKindOf("Slash") or damage.card:getSkillName() ~= "se_fupao" then return end
			if damage.card:getSuit() ~= sgs.Card_NoSuit or damage.card:getNumber() ~= 0 then return end
			local  eu = room:findPlayerBySkillName(self:objectName())
			if not eu then return end
			eu:drawCards(1)
			if eu:getGeneralName() == "Eugen" then
				room:changeHero(eu,"Chiyo",false, false, false, true)
			else
				room:changeHero(eu,"Chiyo",false, false, true, true)
			end
			if not damage.to:getWeapon() then return end
			local to = room:getTag("se_fupao_tag"):toPlayer()
			local reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_TRANSFER, eu:objectName(), self:objectName(), "")
			room:moveCardTo(damage.to:getWeapon(), damage.to, to, Player_PlaceEquip, reason)
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
}

se_tuodui = sgs.CreateTriggerSkill{
	name = "se_tuodui",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.TargetConfirming, sgs.DamageInflicted},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.TargetConfirming then
			local use = data:toCardUse()
			local card = use.card
			if card:isKindOf("AOE") then
				local eu = room:findPlayerBySkillName(self:objectName())
				if not eu then return end
				if use.to:contains(eu) then
					use.to:removeOne(eu)
					data:setValue(use)
					room:broadcastSkillInvoke("se_tuodui", 1)
				end
			end
		elseif event == sgs.DamageInflicted then
			local damage = data:toDamage()
			if damage.to:hasSkill(self:objectName()) then
				room:broadcastSkillInvoke("se_tuodui", 2)
				room:doLightbox("se_tuodui$", 1200)
				if damage.to:getGeneralName() == "Eugen" then
					room:changeHero(damage.to,"Chiyo",false, false, false, true)
				else
					room:changeHero(damage.to,"Chiyo",false, false, true, true)
				end
				return true
			end
		end
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
}

Chiyo:addSkill(se_linmo)
Chiyo:addSkill(se_linmoClear)
extension:insertRelatedSkills("se_linmo", "#se_linmo-clear")
Chiyo:addSkill(se_zhenfen)
Chiyo:addSkill(se_zhenfenClear)
extension:insertRelatedSkills("se_zhenfen", "#se_zhenfen-clear")

Eugen:addSkill(se_fupao)
Eugen:addSkill(se_tuodui)

sgs.LoadTranslationTable{
["se_linmo"] = "临摹",
["drawing"] = "原稿",
["copying"] = "临摹",
["$se_linmo1"] = "哎————野崎君是漫画家？（野崎）哎？不知道就涂了四个小时？",
["$se_linmo2"] = "（野崎）我在想，能画出边界那么干净的海报的人，一定能帮上忙吧。（千代）原来是看重我的技术么！",
["$se_linmo3"] = "（野崎）那边，拜托涂黑了。（千代）嗯？......",
[":se_linmo"]="一名其他角色于出牌阶段使用基本牌或锦囊牌时，若你的武将牌上没有“原稿”，你可以将其置于你的武将牌上，称为“原稿”。若如此做，你可以将一张牌置于你的武将牌上，称为“临摹”。若你拥有该技能，你所有的与“临摹”牌类相同的牌均可以视为“原稿”，你每以此方式使用一张这种牌，你摸一张牌。“原稿”与“临摹”于你回合结束时进入弃牌堆。",

["se_linmo$"] = "image=image/animate/se_linmo.png",
["se_zhenfen$"] = "image=image/animate/se_zhenfen.png",
["se_zhenfen"] = "振奋",
["$se_zhenfen1"] = "好，佐仓千代，要上了！",
["$se_zhenfen2"] = "野，野野野野崎君，一直都......是你的粉丝！",
["$se_zhenfen3"] = "佐仓千代，16岁，和喜欢的人告白，获得了签名......",
["$se_zhenfen4"] = "稍等......不我好像确实说了是粉丝......",
["$se_zhenfen5"] = "被当成缠人的女生的话怎么办啊！",
[":se_zhenfen"]="锁定技。若你于出牌阶段使用了第x张牌，你变身为“欧根亲王”。 x为你的体力值+1",
["@zhenfen_carduse"] = "振奋",

["se_fupao"] = "辅炮「援护火力」",
["$se_fupao1"] = "开火！开火！",
["$se_fupao2"] = "仔细瞄准…开火！",
["$se_fupao3"] = "主炮，仔细瞄准…炮击，开始！",
[":se_fupao"]="每当一名其他角色使用【杀】时，你可以视为对相同目标使用一张【杀】。若该【杀】造成伤害后，你需摸一张牌并变身为佐仓千代，然后将受到这张【杀】的伤害的角色的武器移动到这名角色的武器区。",

["se_tuodui$"] = "image=image/animate/se_tuodui.png",
["se_fupao$"] = "image=image/animate/se_fupao.png",
["se_tuodui"] = "脱队「全身而退」",
["$se_tuodui1"] = "诶，你说我是幸运女孩？完全没这回事哦！浅海什么的都不在行啦…",
["$se_tuodui2"] = "就这点伤我才不会沉呢！反击了哦！",
[":se_tuodui"]="锁定技。你成为AOE目标时，将你从目标中排除。当你受到伤害时，你取消之，然后变身为佐仓千代。",

["Chiyo"] = "佐仓千代",
["&Chiyo"] = "佐仓千代",
["@Chiyo"] = "月刊少女野崎君",
["#Chiyo"] = "月刊派拉斯",
["~Chiyo"] = "哇————嘿嘿...哈哈...真高兴呢...第二张签名呢......嘿嘿...万岁————......",
["designer:Chiyo"] = "Sword Elucidator",
["cv:Chiyo"] = "小澤亞李",
["illustrator:Chiyo"] = "Straw@お仕事募集中",

["Eugen"] = "欧根亲王",
["&Eugen"] = "欧根亲王",
["@Eugen"] = "艦隊collection",
["#Eugen"] = "月刊重巡",
["~Eugen"] = "这样的话，要被俾斯麦姐姐取笑了啦…",
["designer:Eugen"] = "Sword Elucidator",
["cv:Eugen"] = "小澤亞李",
["illustrator:Eugen"] = "Hiten◆三日目A08a",
}
