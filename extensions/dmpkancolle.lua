module("extensions.dmpkancolle",package.seeall)--游戏包
extension=sgs.Package("dmpkancolle")--增加拓展包

--势力
--[[
do
    require  "lua.config" 
	local config = config
	local kingdoms = config.kingdoms
            table.insert(kingdoms,"kancolle")
	config.color_de = "#9AC0CD"
end
]]

Akagi = sgs.General(extension, "Akagi", "kancolle", 4, false,false,false)
Kitagami = sgs.General(extension, "Kitagami", "kancolle", 3, false,false,false)
Yuudachi = sgs.General(extension, "Yuudachi", "kancolle", 4, false,false,false)
poi_kai2 = sgs.General(extension, "poi_kai2", "kancolle", 3, false,true,true)
Shimakaze = sgs.General(extension, "Shimakaze", "kancolle", 3, false,false,false)
Fubuki = sgs.General(extension, "Fubuki", "kancolle", 3, false,false,false)

--吃撑
se_chichengcard = sgs.CreateSkillCard{
	name = "se_chichengcard",
	target_fixed = true, 
	will_throw = false, 
	on_use = function(self, room, source, targets)
		--room:broadcastSkillInvoke("se_chicheng")
		for _,id in sgs.qlist(self:getSubcards()) do
			source:addToPile("akagi_lv", id)
		end
		if self:getSubcards():length() > 1 then
			local re = sgs.RecoverStruct()
			re.who = source
			room:recover(source,re,true)
		end
	end
}
se_chicheng = sgs.CreateViewAsSkill{
	name = "se_chicheng", 
	n = 999, 
	view_filter = function(self, selected, to_select)
		return true
	end, 
	view_as = function(self, cards)
		if #cards > 0 then
			local card = se_chichengcard:clone()
			for _,cd in pairs(cards) do
				card:addSubcard(cd)
			end
			return card
		end
	end, 
	enabled_at_play = function(self, player)
		return player:getHandcardNum() > 0 and not player:hasUsed("#se_chichengcard")
	end
}



--制空
se_zhikong=sgs.CreateTriggerSkill{
	name = "se_zhikong",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseChanging, sgs.DamageCaused},
	on_trigger = function(self,event,player,data)
		local room = player:getRoom()
		local Akagi = room:findPlayerBySkillName(self:objectName())
		if event == sgs.EventPhaseChanging then
			local change = data:toPhaseChange()
			if change.to == sgs.Player_Start and not player:hasFlag("se_zhikong_on") then
				if Akagi and Akagi:isAlive() and Akagi:getHp() > 1 and Akagi:getPile("akagi_lv"):length() > 0 and Akagi:getMark("@FireCaused") == 0 then
					local newdata = sgs.QVariant()
					newdata:setValue(player)
					if not Akagi:askForSkillInvoke(self:objectName(), newdata) then return end
					local lvs = Akagi:getPile("akagi_lv")
					room:fillAG(lvs, Akagi)
					local id = room:askForAG(Akagi, lvs, false, self:objectName())
					room:clearAG(Akagi)
					if id == -1 then return end
					local card = sgs.Sanguosha:getCard(id)
					room:throwCard(card, nil, nil)
					room:broadcastSkillInvoke(self:objectName())
					room:doLightbox("se_zhikong$", 800)
					if player:getKingdom() == "kancolle" then
						Akagi:drawCards(1)
					end
					player:setFlags("se_zhikong_on")
					for _,p in sgs.qlist(room:getOtherPlayers(player)) do
						if p:getMark("Armor_Nullified") == 0 then
							room:setPlayerMark(p, "Armor_Nullified", 1) 
						else
							room:setPlayerMark(p, "has_been_Armor_Nullified", 1) 
						end
					end
				end
			elseif change.to == sgs.Player_Finish and player:hasFlag("se_zhikong_on") then
				player:setFlags("-se_zhikong_on")
				for _,p in sgs.qlist(room:getOtherPlayers(player)) do
					if p:getMark("has_been_Armor_Nullified") == 0 then
						room:setPlayerMark(p, "Armor_Nullified", 0) 
					else
						room:setPlayerMark(p, "has_been_Armor_Nullified", 0) 
					end
				end
			end
		elseif event == sgs.DamageCaused then
			local damage = data:toDamage()
			if damage.to and damage.to:isAlive() and damage.from:hasFlag("se_zhikong_on") and damage.card and damage.card:isKindOf("Slash") then
				if math.random(1, 100) < 63 then
					damage.damage = damage.damage + 1
				end
				data:setValue(damage)
			end
		end
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end,
}

--雷幕
se_leimu = sgs.CreateTriggerSkill{
	name = "se_leimu", 
	frequency = sgs.Skill_NotFrequent, 
	events = {sgs.CardsMoveOneTime,sgs.GameStart},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.CardsMoveOneTime then
			local move = data:toMoveOneTime()
			local places = move.from_places
			if places:contains(sgs.Player_DrawPile) then
				local num = room:getDrawPile():length()
				if num - move.card_ids:length() < 1 then
					local kita = room:findPlayerBySkillName(self:objectName())
					if not kita or not kita:askForSkillInvoke(self:objectName(), data) then return end
					local target = room:askForPlayerChosen(kita, room:getOtherPlayers(player), "se_leimu")
					if target then
						room:broadcastSkillInvoke(self:objectName())
						room:doLightbox("se_leimu$", 1200)
						local da = sgs.DamageStruct()
						da.from = kita
						da.to = target
						da.nature = sgs.DamageStruct_Thunder
						room:damage(da)
					end
				end
			end
		elseif event == sgs.GameStart then
			if player:hasSkill(self:objectName()) then
				if not player:askForSkillInvoke(self:objectName(), data) then return end
				local target = room:askForPlayerChosen(player, room:getOtherPlayers(player), "se_leimu")
				if target then
					room:broadcastSkillInvoke(self:objectName())
					room:doLightbox("se_leimu$", 1200)
					local da = sgs.DamageStruct()
					da.from = player
					da.to = target
					da.nature = sgs.DamageStruct_Thunder
					room:damage(da)
				end
			end
		end
	end
}

se_yezhan = sgs.CreateTriggerSkill{
	name = "se_yezhan",  
	frequency = sgs.Skill_Compulsory, 
	events = {sgs.DamageCaused, sgs.EventPhaseStart}, 
	priority = -1,
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local room = player:getRoom()
		if event == sgs.DamageCaused then
			if damage.from:hasSkill(self:objectName()) and damage.nature ~= sgs.DamageStruct_Normal and damage.from:getMark("@turn_of_kita") > 0 and math.floor(damage.from:getMark("@turn_of_kita") / 2) * 2 == damage.from:getMark("@turn_of_kita") then
				damage.damage = damage.damage + 1
				data:setValue(damage)
				room:broadcastSkillInvoke(self:objectName())
			end
			if damage.from:hasSkill(self:objectName()) and damage.to:getHp() <= damage.damage then
				damage.damage = damage.damage + 1
				data:setValue(damage)
				room:doLightbox("se_yezhan$", 2000)
			end
		elseif event == sgs.EventPhaseStart and player:hasSkill(self:objectName()) then
			if player:getPhase()==sgs.Player_RoundStart then 
				player:gainMark("@turn_of_kita")
			end
		end
		
	end, 
	can_trigger = function(self, target)
		return target
	end
}

se_mowang = sgs.CreateTriggerSkill{
	name = "se_mowang", 
	frequency = sgs.Skill_NotFrequent, 
	events = {sgs.Dying},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local dying_data = data:toDying()
		local source = dying_data.who
		if source:hasSkill(self:objectName()) and source:getMark("@mowang") == 0 then
			if not source:askForSkillInvoke(self:objectName(), data) then return end
			room:loseMaxHp(source, 2)
			room:broadcastSkillInvoke(self:objectName())
			room:doLightbox("se_mowang$", 3000)
			room:setPlayerProperty(source, "hp", sgs.QVariant(1))
			source:drawCards(3)
			room:acquireSkill(source, "SE_Lingshang")
			room:acquireSkill(source, "#SE_Lingshang_end")
			source:gainMark("@mowang")
		end
		
	end
}

--噩梦
se_emeng = sgs.CreateTriggerSkill{
	name = "se_emeng", 
	frequency = sgs.Skill_Wake, 
	events = {sgs.EventPhaseStart}, 
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		room:loseMaxHp(player)
		room:broadcastSkillInvoke(self:objectName())
		room:doLightbox("se_suo$", 500)
		room:doLightbox("se_luo$", 500)
		room:doLightbox("se_men$", 1000)
		room:doLightbox("se_wo$", 300)
		room:doLightbox("se_you$", 300)
		room:doLightbox("se_hui$", 300)
		room:doLightbox("se_lai$", 300)
		room:doLightbox("se_le$", 300)
		room:doLightbox("se_a$", 1000)
		room:doLightbox("se_emeng$", 2000)
		if player:getGeneralName() == "Yuudachi" then
			room:changeHero(player, "poi_kai2",false, false, false, false)
		else
			room:changeHero(player, "poi_kai2",false, false, true, false)
		end
		player:gainMark("@waked")
		local list = room:getAlivePlayers()
		for _,p in sgs.qlist(list) do
			room:setFixedDistance(player, p, 1)
			room:setFixedDistance(p, player, 1)
		end
		return false
	end, 
	can_trigger = function(self, target)
		if target then
			if target:isAlive() and target:hasSkill(self:objectName()) then
				if target:getPhase() == sgs.Player_Start then
					if target:getMark("@waked") == 0 then
						return target:getHp() == 1
					end
				end
			end
		end
		return false
	end
}
--狂犬
se_kuangquan = sgs.CreateTriggerSkill{
	name = "se_kuangquan",  
	frequency = sgs.Skill_NotFrequent, 
	events = {sgs.DamageCaused}, 
	priority = -3,
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local room = player:getRoom()
		if damage.from:hasSkill(self:objectName()) and damage.card and damage.card:isKindOf("Slash") and damage.from:distanceTo(damage.to) <= 1 then
			if not damage.from:askForSkillInvoke(self:objectName(), data) then return end
			room:broadcastSkillInvoke(self:objectName())
			room:doLightbox("se_kuangquan$", 1000)
			room:loseMaxHp(damage.to, 1)
		end
	end, 
	can_trigger = function(self, target)
		return target
	end
}

--冲撞
se_chongzhuang = sgs.CreateTriggerSkill{
	name = "se_chongzhuang", 
	frequency = sgs.Skill_NotFrequent, 
	events = {sgs.Dying},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local dying_data = data:toDying()
		local source = dying_data.who
		if source:hasSkill(self:objectName()) then
			if not source:askForSkillInvoke(self:objectName(), data) then return end
			local target = room:askForPlayerChosen(source, room:getOtherPlayers(source), "se_chongzhuang")
			if not target then return end
			while target:objectName() ~= source:getNextAlive():objectName() do
				room:getThread():delay(100)
				room:swapSeat(source, source:getNextAlive())
			end
			room:doLightbox("se_chongzhuang$", 1500)
			local card = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
			card:setSkillName(self:objectName())		
			local use = sgs.CardUseStruct()
			use.from = source
			use.to:append(target)
			use.card = card
			room:useCard(use, false)
		end
	end
}

--英姿
 poi_yingzi = sgs.CreateTriggerSkill{
    name = "poi_yingzi",
    frequency = sgs.Skill_Frequent,
    events = {sgs.DrawNCards},
    on_trigger = function(self, event, player, data)
        local room = player:getRoom()
        if room:askForSkillInvoke(player, "poi_yingzi", data) then
        	room:broadcastSkillInvoke("se_emeng")
        	local num = math.random(1, 100)
            local count = data:toInt()  + 1
            if num > 70 then
            	count = count + 1
            elseif num > 92 then
            	count = count + 1
            elseif num > 98 then
            	count = count + 2
            end
            data:setValue(count)
        end
    end
}

--咆哮
poi_paoxiao = sgs.CreateTargetModSkill{
    name = "poi_paoxiao",
    pattern = "Slash",
    residue_func = function(self, player)
        if player:hasSkill(self:objectName()) then
            return 1000
        end
    end,
}

--疾风
se_jifeng = sgs.CreateTriggerSkill{
	name = "se_jifeng", --必须 
	frequency = sgs.Skill_NotFrequent, 
	events = {sgs.EventPhaseChanging}, --必须 
	on_trigger = function(self, event, player, data) --必须
		local change = data:toPhaseChange()
		local phase = change.to
		if phase == sgs.Player_NotActive then
			local room = player:getRoom()
			local shima = room:findPlayerBySkillName(self:objectName())
			if not shima then return end
			if not shima:askForSkillInvoke(self:objectName(), data) then return end
			room:broadcastSkillInvoke(self:objectName())
			room:doLightbox("se_jifeng$", 400)
			room:swapSeat(shima, player:getNextAlive())
		end	
	end, 
	can_trigger = function(self, target)
		return target:getNextAlive():getNextAlive():hasSkill("se_jifeng")
	end
}

--回避
se_huibi = sgs.CreateTriggerSkill{
	name = "se_huibi", 
	frequency = sgs.Skill_NotFrequent, 
	events = {sgs.CardResponded, sgs.CardAsked}, 
	on_trigger = function(self, event, player, data) 
		local room = player:getRoom()
		if event == sgs.CardResponded then
			local card = data:toCardResponse().m_card
			if card:isKindOf("Jink") and player:hasSkill(self:objectName())then
				if room:askForSkillInvoke(player, self:objectName(), data) then
					room:broadcastSkillInvoke("se_huibi")
					room:doLightbox("se_jifeng$", 800)
					for _,p in sgs.qlist(room:getAlivePlayers()) do
						if p:getNextAlive():objectName() == player:objectName() then
							room:swapSeat(p, player)
							break
						end
					end
					player:gainMark("@shimakaze_speed")
				end
			end 
		elseif event == sgs.CardAsked then
			local pattern = sgs.Sanguosha:getCurrentCardUsePattern()
			if pattern == "jink" then
				if math.random(1, 5) > player:getMark("@shimakaze_speed") then return end
				if not player:hasSkill("se_huibi") then return end
				room:broadcastSkillInvoke(self:objectName())
				local jinkcard = sgs.Sanguosha:cloneCard("jink",sgs.Card_NoSuit,0)
				jinkcard:setSkillName("se_huibi")
				room:provide(jinkcard)
				return true
			end
		end
		return false
	end, 
}


--欠雷
se_qianlei = sgs.CreateTriggerSkill{
	name = "se_qianlei", 
	frequency = sgs.Skill_NotFrequent, 
	events = {sgs.Dying},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local dying_data = data:toDying()
		local der = dying_data.who
		if not der then return end
		local buki = room:findPlayerBySkillName(self:objectName())
		if not buki then return end
		local damage = dying_data.damage
		if not damage then return end
		if not damage.from then return end
		if not buki:askForSkillInvoke(self:objectName(), data) then return end
		local choice = room:askForChoice(buki, self:objectName(), "se_qianlei_first+se_qianlei_second")
		if choice == "se_qianlei_first" then
			if buki:isNude() then return end
			local cardid = room:askForCardChosen(buki, buki, "he", self:objectName())
			if cardid == -1 then return end
			room:broadcastSkillInvoke("se_qianlei", math.random(1, 3))
			room:doLightbox("se_qianlei1$", 1200)
			room:obtainCard(der, cardid)
			local card = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
			card:setSkillName(self:objectName())		
			local use = sgs.CardUseStruct()
			use.from = buki
			use.to:append(damage.from)
			use.card = card
			room:useCard(use, false)
		else
			if der:getHandcardNum() == 0 then return end
			room:broadcastSkillInvoke("se_qianlei", math.random(4, 5))
			room:doLightbox("se_qianlei2$", 1200)
			room:showAllCards(der,buki)
			for _,c in sgs.qlist(der:getHandcards()) do
				if c:isRed() then
					room:throwCard(c, der, buki)
				end
			end
		end
	end
}

se_shuacun = sgs.CreateTriggerSkill{
	name = "se_shuacun",  
	frequency = sgs.Skill_NotFrequent, 
	events = {sgs.TargetConfirmed, sgs.EventPhaseEnd},  
	on_trigger = function(self, event, player, data) 
		local room = player:getRoom()
		if event == sgs.TargetConfirmed then
			local use = data:toCardUse()
			if not use.from then return end
			if use.from:getPhase() ~= sgs.Player_Play then return end
			local buki = room:findPlayerBySkillName(self:objectName())
			if not buki then return end
			if not use.to:contains(buki) then return end
			if not buki:hasFlag("sonzaikan_aru") then
				buki:setFlags("sonzaikan_aru")
			end
		elseif event == sgs.EventPhaseEnd then
			if player:getPhase() == sgs.Player_Play then
				local buki = room:findPlayerBySkillName(self:objectName())
				if not buki then return end
				if not buki:hasFlag("sonzaikan_aru") then
					if buki:isKongcheng() then return end
					if not buki:askForSkillInvoke(self:objectName(), data) then return end
					room:broadcastSkillInvoke("se_shuacun")
					local num = math.floor(buki:getHandcardNum() / 2)
					local good
					if num ~= 0 then
						good = room:askForDiscard(buki,"se_shuacun",num,num,false,false)
					else
						good = true
					end
					if good then
						buki:drawCards(buki:getHandcardNum())
					end
				else
					buki:setFlags("-sonzaikan_aru")
				end
			end
		end
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}


Akagi:addSkill(se_chicheng)
Akagi:addSkill(se_zhikong)
Kitagami:addSkill(se_leimu)
Kitagami:addSkill(se_yezhan)
Kitagami:addSkill(se_mowang)
Yuudachi:addSkill(se_emeng)
Yuudachi:addSkill(se_kuangquan)
poi_kai2:addSkill(poi_yingzi)
poi_kai2:addSkill(poi_paoxiao)
poi_kai2:addSkill(se_chongzhuang)
poi_kai2:addSkill(se_kuangquan)
Yuudachi:addWakeTypeSkillForAudio("se_chongzhuang")

Shimakaze:addSkill(se_jifeng)
Shimakaze:addSkill(se_huibi)
Fubuki:addSkill(se_qianlei)
Fubuki:addSkill(se_shuacun)

sgs.LoadTranslationTable{
	["kancolle"] = "舰娘",
	["dmpkancolle"] = "动漫包-舰娘",

	["se_chichengcard"] = "吃撑「铝是用来吃的」",
	["se_chicheng"] = "吃撑「铝是用来吃的」",
	["akagi_lv"] = "铝",
	["$se_chicheng1"] = "梅雨的季节呢。还在下雨...这样的日子里到间宫那边小憩也是不错的呢，提督。...提督",
	["$se_chicheng2"] = "那个，提督，吃饭……啊不！作战还没有开始吗！",
	["$se_chicheng3"] = "烈风？不，不知道的孩子呢。",
	["$se_chicheng4"] = "流星？和九七（式）舰攻不一样？",
	[":se_chicheng"] = "<font color=\"green\"><b>出牌阶段限一次，</b></font>你可以将X张牌置于你的武将牌上，称为“铝”。若X不小于2，你回复一点体力。X为任意正整数。",

	["se_zhikong"] = "制空「铝是用来喷的」",
	["$se_zhikong1"] = "第一次攻击队，请发舰！",
	["$se_zhikong2"] = "舰载机的大家，准备好了吗？",
	[":se_zhikong"] = "若你的血量大于1，任意角色回合开始时，你可以弃置一张“铝”，该角色每在回合内使用【杀】造成的伤害有62%的概率+1，且在其回合内其他角色的防具失效。若该角色为舰娘，你摸一张牌。",
	["se_zhikong$"] = "image=image/animate/se_zhikong.png",


	["se_leimu"] = "雷幕 「开闭幕雷击」",
	["$se_leimu1"] = "单装炮，总感觉它有些寂寞呢。",
	["$se_leimu2"] = "嘛、和大井亲组合的话就最强了呢♪。",
	["$se_leimu3"] = "九三式氧推进鱼雷满载，真是重啊",
	[":se_leimu"] = "游戏开始时，你可以对一名其他角色造成一点雷属性伤害；每当牌堆中牌数为0时，若你的血量大于1，你可以对一名其他角色造成一点雷属性伤害。",
	["se_leimu$"] = "image=image/animate/se_leimu.png",

	["se_yezhan"] = "夜斩「夜战斩杀」",
	["$se_yezhan1"] = "给你“通通”的来几下吧！",
	["$se_yezhan2"] = "好——了，要追击了～。跟上我来！",
	["$se_yezhan3"] = "嘛……主炮呢……对……嗯……对啊……",
	[":se_yezhan"] = "<font color=\"blue\"><b>锁定技,</b></font>偶数轮（从你的偶数回合开始时到下个回合开始前），你造成属性伤害时，伤害+1；你的伤害若能造成濒死，伤害+1。",
	["se_yezhan$"] = "image=image/animate/se_yezhan.png",
	["@turn_of_kita"] = "北上的回合数",

	["@mowang"] = "北上大魔王",

	["se_mowang"] = "魔王「我不要裱船了」",
	["$se_mowang1"] = "来生，我还是当个重巡比较好吧……",
	["$se_mowang2"] = "来生的话，果然让我做战舰吧。",
	["$se_mowang3"] = "来生的话，果然让做空母吧…啊，怎么说也，工作舰什么的也，啊哈哈哈…",
	[":se_mowang"] = "当你进入濒死状态时，你可以失去两点体力上限，回复至一点体力，摸3张牌，然后获得技能“岭上”。",
	["se_mowang$"] = "image=image/animate/se_mowang.png",

	["se_emeng"] = "噩梦「所罗门的噩梦poi」",
	["$se_emeng1"] = "所罗门的噩梦，让你们见识一下！",
	["$se_emeng2"] = "那么，让我们举办一场华丽的派对吧！",
	["$se_emeng3"] = "夕立、突击poi。",
	[":se_emeng"] = "<font color=\"purple\"><b>觉醒技，</b></font>回合开始时，若你的体力值为1，你失去一点体力上限并获得技能【英姿】【咆哮】和【冲撞】（当你进入濒死时，移动到一名其他角色的左侧并视为对其使用一张【杀】。），你与所有角色计算距离时为1，其他角色与你计算距离时为1。",
	["se_emeng$"] = "image=image/animate/se_emeng.png",

	["se_suo$"] = "所    ",
	["se_luo$"] = "  罗  ",
	["se_men$"] = "    门",
	["se_wo$"] = "\n我          ",
	["se_you$"] = "\n  又        ",
	["se_hui$"] = "\n    回      ",
	["se_lai$"] = "\n      来    ",
	["se_le$"] = "\n        了  ",
	["se_a$"] = "\n          啊",

	["se_kuangquan"] = "狂犬「咬死你poi」",
	["$se_kuangquan1"] = "随便找一个打了poi？",
	["$se_kuangquan2"] = "首先从哪里开始打呢？",
	[":se_kuangquan"] = "你对距离为1的角色使用【杀】造成伤害时，可以令目标失去失去一点体力上限。",
	["se_kuangquan$"] = "image=image/animate/se_kuangquan.png",

	["se_chongzhuang"] = "冲撞「风帆突击」",
	["$se_chongzhuang"] = "即使是把打开船帆，也要继续战斗！",
	[":se_chongzhuang"] = "当你进入濒死时，移动到一名其他角色的左侧并视为对其使用一张【杀】。",
	["se_chongzhuang$"] = "image=image/animate/se_chongzhuang.png",

	["poi_yingzi"] = "英姿「孤舰突击」",
	[":poi_yingzi"] = "摸牌阶段，你可以额外摸一些牌。",
	["poi_paoxiao"] = "咆哮「噩梦般的雷击」",
	[":poi_paoxiao"] = "你在出牌阶段内使用【杀】时无次数限制。",

	["se_jifeng"] = "疾风「疾如岛风」",
	["$se_jifeng1"] = "疾如岛风，de-su！",
	["$se_jifeng2"] = "嘿嘿嘿，你很慢呢！",
	["$se_jifeng3"] = "任何人都追不上我的哦！",
	["$se_jifeng4"] = "太慢了！",
	[":se_jifeng"] = "你左侧第二名存活角色回合结束时，你可以向左移动一个位置。",
	["se_jifeng$"] = "image=image/animate/se_jifeng.png",

	["se_huibi"] = "回避「谁也追不上我哦」",
	["$se_huibi1"] = "想赛跑吗？我不会输的哦。",
	["$se_huibi2"] = "越来越快的话也可以吗？",
	["$se_huibi3"] = "这样下去的话有多快我可管不了了哦！",
	[":se_huibi"] = "每当你使用或打出【闪】时，你可以向左移动一个位置，并永久增加20%在你需要使用或打出【闪】时，你可以视为打出一张【闪】。",
	["@shimakaze_speed"] = "回避",

	["se_qianlei"] = "欠雷「逆天改命雷」",
	["se_qianlei_first"] = "将一张牌交给濒死角色，然后视为你对来源使用了一张【杀】。",
	["se_qianlei_second"] = "观看濒死角色的手牌，并弃置其中所有红色的牌。",
	["$se_qianlei1"] = "要、要由我来守护大家！",
	["$se_qianlei2"] = "拜托了！命中吧！",
	["$se_qianlei3"] = "诶？梦想吗？变得强大，能变得保护大家，和平到来的时候，想一直晒晒太阳呢",
	["$se_qianlei4"] = "就由我来解决掉！",
	["$se_qianlei5"] = "进行追击战。请跟紧我！",
	[":se_qianlei"] = "当一名角色受到伤害进入濒死时，你可以1.将一张牌交给濒死角色，然后视为你对来源使用了一张【杀】。2.观看濒死角色的手牌，并弃置其中所有红色的牌。",
	["se_qianlei1$"] = "image=image/animate/se_qianlei1.png",
	["se_qianlei2$"] = "image=image/animate/se_qianlei2.png",

	["se_shuacun"] = "刷存「怒刷存在感」",
	["$se_shuacun1"] = "您辛苦了，我叫吹雪。是，我会努力！",
	["$se_shuacun2"] = "是！已经准备好了！司令官！",
	[":se_shuacun"] = "其他角色出牌阶段若未指定你为目标，其出牌阶段结束时，你可以弃置一半的手牌（向下取整），然后摸取等同你手牌数目的手牌。",
	["se_shuacun$"] = "image=image/animate/se_qianlei.png",

	["Akagi"] = "赤城", 
	["&Akagi"] = "赤城", 
	["#Akagi"] = "一航战吃货", 
	["@Akagi"] = "艦隊collection", 
	["~Akagi"] = "一航战的荣耀，不能在这种地方丢掉……！", 
	["designer:Akagi"] = "Sword Elucidator",
	["cv:Akagi"] = "藤田咲",
	["illustrator:Akagi"] = "",

	["Kitagami"] = "北上", 
	["&Kitagami"] = "北上", 
	["#Kitagami"] = "超級北上大人", 
	["@Kitagami"] = "艦隊collection", 
	["~Kitagami"] = "嗯……该怎么说呢？这种事也有的嘛……想快点修理去。", 
	["designer:Kitagami"] = "Sword Elucidator",
	["cv:Kitagami"] = "大坪由佳",
	["illustrator:Kitagami"] = "custom",

	["Yuudachi"] = "夕立", 
	["&Yuudachi"] = "夕立", 
	["#Yuudachi"] = "所罗门的噩梦", 
	["@Yuudachi"] = "艦隊collection", 
	["~Yuudachi"] = "真、真是笨蛋！这样就没法战斗了poi！？", 
	["designer:Yuudachi"] = "Sword Elucidator",
	["cv:Yuudachi"] = "谷边由美",
	["illustrator:Yuudachi"] = "リン☆ユウ",

	["poi_kai2"] = "夕立改二", 
	["&poi_kai2"] = "夕立改二", 
	["#poi_kai2"] = "所罗门的噩梦", 
	["@poi_kai2"] = "艦隊collection", 
	["~poi_kai2"] = "真、真是笨蛋！这样就没法战斗了poi！？", 
	["designer:poi_kai2"] = "Sword Elucidator",
	["cv:poi_kai2"] = "谷边由美",
	["illustrator:poi_kai2"] = "",

	["Shimakaze"] = "島風", 
	["&Shimakaze"] = "島風", 
	["#Shimakaze"] = "海路最速传说", 
	["@Shimakaze"] = "艦隊collection", 
	["~Shimakaze"] = "哇啊啊！好痛的啦！", 
	["designer:Shimakaze"] = "Sword Elucidator",
	["cv:Shimakaze"] = "佐仓绫音",
	["illustrator:Shimakaze"] = "悠久ポン酢",

	["Fubuki"] = "吹雪", 
	["&Fubuki"] = "吹雪", 
	["#Fubuki"] = "伪·阿卡林2号机", 
	["@Fubuki"] = "艦隊collection", 
	["~Fubuki"] = "怎么会这样！不可以啊！", 
	["designer:Fubuki"] = "曦行;Sword Elucidator",
	["cv:Fubuki"] = "上坂すみれ",
	["illustrator:Fubuki"] = "",

	["Kongou"] = "金剛", 
	["&Kongou"] = "金剛", 
	["#Kongou"] = "Burning Love!", 
	["@Kongou"] = "艦隊collection", 
	["~Kongou"] = "", 
	["designer:Kongou"] = "Sword Elucidator",
	["cv:Kongou"] = "東山奈央",
	["illustrator:Kongou"] = "",

	["Naka"] = "那珂", 
	["&Naka"] = "那珂", 
	["#Naka"] = "舰队偶像", 
	["@Naka"] = "艦隊collection", 
	["~Naka"] = "", 
	["designer:Naka"] = "Sword Elucidator",
	["cv:Naka"] = "佐倉綾音",
	["illustrator:Naka"] = "",

	["Ikazuchi"] = "雷", 
	["&Ikazuchi"] = "雷", 
	["#Ikazuchi"] = "", 
	["@Ikazuchi"] = "艦隊collection", 
	["~Ikazuchi"] = "", 
	["designer:Ikazuchi"] = "Sword Elucidator",
	["cv:Ikazuchi"] = "洲崎綾",
	["illustrator:Ikazuchi"] = "",

	["Inazuma"] = "電", 
	["&Inazuma"] = "電", 
	["#Inazuma"] = "", 
	["@Inazuma"] = "艦隊collection", 
	["~Inazuma"] = "", 
	["designer:Inazuma"] = "Sword Elucidator",
	["cv:Inazuma"] = "洲崎綾",
	["illustrator:Inazuma"] = "",
}