
module("extensions.lolihime",package.seeall)
extension = sgs.Package("lolihime")

jdd = sgs.General(extension, "jdd", "real", 3, false)
acc = sgs.General(extension, "acc", "science", 3)
--------------------------------------------------------------------------------------
tuhao = sgs.CreateTriggerSkill{
	name = "tuhao",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.CardUsed},
	on_trigger = function(self, event, player, data)
		local room=player:getRoom()
		local count = 0
		local use = data:toCardUse()
		if use.from:objectName() == player:objectName() and player:hasSkill(self:objectName()) and player:getPhase() == sgs.Player_Play and not player:getCards("hej"):isEmpty() then
			if use.card:getSuit() == sgs.Card_Heart or use.card:getSuit() == sgs.Card_Diamond then
				if not player:hasFlag("tuhao_used") then
					room:broadcastSkillInvoke(self:objectName())
					player:setFlags("tuhao_used")
				end
				player:drawCards(1) 
				end
			if use.card:getSuit() == sgs.Card_Club or use.card:getSuit() == sgs.Card_Spade then
				if not player:hasFlag("tuhao_black_used") then
					room:broadcastSkillInvoke(self:objectName())
				else
					room:setPlayerFlag(player, "tuhao_black_used")
				end
				local id = room:askForCardChosen(player, player, "hej", "tuhao")
				room:throwCard(id,player, player)
			end
		end
	end
}

---------------------------------------------------------------------------------------
yehuo = sgs.CreateTriggerSkill{
	name="yehuo",
	events = {sgs.TurnStart},
	frequency = sgs.Skill_Compulsory,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local phase = player:getPhase()
		if phase == sgs.Player_Start and player:faceUp() then return end
		if phase == sgs.Player_Start then
			player:turnOver()
		end
	end
}

-----------------------------------------------
vector = sgs.CreateTriggerSkill
{
	name = "vector",
	frequency = sgs.Skill_NotFrequent,
    events = {sgs.CardEffect},
	
	on_trigger = function(self, event, player, data)
        local room = player:getRoom()
		if player:isKongcheng()then return end
		local effect = data:toCardEffect()
		if effect.to:objectName() ~= player:objectName() then return end
		if player:getCards("he"):length() == 0 then return end
		if room:askForSkillInvoke(player,self:objectName(),data) and room:askForCard(player, ".|.|.", "vector_Discard", sgs.QVariant(), self:objectName()) then
			local list = room:getAlivePlayers()
			for _,q in sgs.qlist(list) do
				if sgs.Sanguosha:isProhibited(player, q, effect.card) then 
					list:removeOne(q)
				end
			end
			local dest = room:askForPlayerChosen(player, list, "vector")
			room:broadcastSkillInvoke(self:objectName())
			room:doLightbox("vector$", 800)
			effect.to = dest
			data:setValue(effect)
		end
		return false
	end,
}

------------------------------------------------------------------------------------------------
shouji = sgs.CreateViewAsSkill{
	name = "shouji",
	n=99,
	view_filter = function(self, selected, to_select)
		return #selected<sgs.Self:getHp() + 1 and not sgs.Self:isJilei(to_select)
	end,
	view_as = function(self, cards)
		if #cards == sgs.Self:getHp() + 1 then
			local card = shoujicard:clone()
			for _,c in ipairs(cards) do
				card:addSubcard(c:getId())
			end
			card:setSkillName(self:objectName())
			return card 
		end
	end,
	enabled_at_play = function(self, player)
		return not player:hasUsed("#shoujicard")
	end
}

shoujicard = sgs.CreateSkillCard{
    name = "shoujicard",
    target_fixed = true,
    will_throw = true,
	on_use = function(self, room, source, targets)
		--room:broadcastSkillInvoke("shouji")
		room:doLightbox("shouji$", 1000)
		for _,p in sgs.qlist(room:getOtherPlayers(source)) do
			if not p:getCards("h"):isEmpty() then
				local list = p:handCards()
				room:fillAG(list,source)
				local card_id = room:askForAG(source,list,true,self:objectName())
				local card = sgs.Sanguosha:getCard(card_id)
				room:obtainCard(source,card,false)
				room:clearAG(source)
			end
		end
	end
}

--------------------------------------------------------

kuro = sgs.General(extension, "kuro", "magic", 4, false, false, false)


spreadillness = sgs.CreateTriggerSkill{
	name = "spreadillness", 
	frequency = sgs.Skill_Compulsory, 
	events = {sgs.EventPhaseEnd},  
	on_trigger = function(self, event, player, data) 
		local room = player:getRoom()
		local phase = player:getPhase()
		if phase == sgs.Player_Finish then
			if player:getMark("@spreadillness") > 0 or player:hasSkill("spring") then
				for _,p in sgs.qlist(room:getOtherPlayers(player)) do
					if player:distanceTo(p) == 1 then
						local x = math.random(1,5)
						if p:getMark("@spreadillness") == 0 and p:getMark("@immune") == 0 and x > 1 then
							--room:acquireSkill(p,"spreadillness",true)
							p:gainMark("@spreadillness")
							room:broadcastSkillInvoke("spreadillness")
						end
					end
					if player:distanceTo(p) == 2 then
						local y = math.random(1,2)
						if p:getMark("@spreadillness") == 0 and p:getMark("@immune") == 0 and y == 1 then
							--room:acquireSkill(p,"spreadillness",true)
							p:gainMark("@spreadillness", 1)
							room:broadcastSkillInvoke("spreadillness")
						end
					end
				end
				local z = math.random(1,2)
				if z == 1 then 
					--room:detachSkillFromPlayer(player,"spreadillness",true)
					player:loseMark("@spreadillness")
					if not player:hasSkill("spring") then
						player:gainMark("@immune")
					end
				end
				
				if not player:hasSkill("spring") then
					room:loseHp(player)
				end
			elseif player:getMark("@immune") > 0 then
				local z = math.random(1,2)
				if z == 1 then 
					player:loseMark("@immune")
				end
			end
		end
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}



spring = sgs.CreateTriggerSkill{
	name = "spring", 
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageInflicted,sgs.EventPhaseStart},  
	on_trigger = function(self, event, player, data) 
		local room = player:getRoom()
		if event == sgs.DamageInflicted then
			local damage = data:toDamage()
			if (damage.from and not damage.from:hasSkill("spring")) and (damage.to and not damage.to:hasSkill("spring")) then return false end
			if damage.from and damage.from:getMark("@spreadillness") == 0 or damage.to:getMark("@immune") > 0 then return false end
			local sp = room:findPlayerBySkillName("spring")
			if not sp then return false end
			if not room:askForSkillInvoke(sp, self:objectName(), data) then return false end
			--room:detachSkillFromPlayer(damage.from,"spreadillness",true)
			damage.from:loseMark("@spreadillness")
			--room:acquireSkill(damage.to,spreadillness)
			if damage.to:getMark("@spreadillness") == 0 then
				damage.to:gainMark("@spreadillness")
			end
			damage.damage = 0
			data:setValue(damage)
			room:broadcastSkillInvoke("spring")
			return true
		elseif event == sgs.EventPhaseStart then
			if player:getPhase() ~= sgs.Player_Start then return false end
			if player:hasSkill("spring") then
				local get = true
				for _,p in sgs.qlist(room:getAlivePlayers()) do
					if p:getMark("@spreadillness") > 0 then
						get = false
						break
					end
				end
				if get then
					card1 = room:askForCard(player, ".|club|.|hand|.", "@spreadDiscard",sgs.QVariant(),self:objectName()) 
					if card1 then
						player:gainMark("@spreadillness")
					end
				end
			end
		end
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}
---------------------------
--qb = sgs.General(extension, "qb", "Erciyuan", 3, false, false, false)

youpian= sgs.CreateViewAsSkill{
	name="youpian",
	n=0,
	view_as = function(self, cards)
		local Ncard=youpianCARD:clone()
		Ncard:setSkillName(self:objectName())
		return Ncard
	end,
	enabled_at_play = function(self, player)
		return not player:hasFlag("youpian_used")
	end
}

youpianCARD=sgs.CreateSkillCard{
	name="youpianCARD",
	filter = function(self, targets, to_select)
		return #targets==0 and to_select:getCardCount(true)>0 and to_select:objectName() ~= sgs.Self:objectName() 
    end,
	on_use = function(self, room, source, targets)
		room:setPlayerFlag(source,"youpian_used")
		local target = targets[1]
		if target == nil  then return false end	
		room:setPlayerMark(target,"youpian_target",1)
		
		local y = math.random(1,2)
		if y==1 then
			local choice = room:askForChoice(target,self:objectName(),"youpianyes+youpianno")
			if choice == "youpianyes" then
				room:loseHp(target)
				return
			elseif choice == "youpianno" then
				return 
			end
		elseif y==2 then
			local choice = room:askForChoice(target,self:objectName(),"youpianno+youpianyes")
			if choice == "youpianyes" then
				room:loseHp(target)
				return
			elseif choice == "youpianno" then
				room:acquireSkill(target,spreadillness)
				return 
			end
		end
	end
}

----------------------------------

mianma = sgs.General(extension, "mianma", "real", 10, false, false, false)


lingti = sgs.CreateTriggerSkill
{
	name = "lingti",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DamageDone,sgs.PreHpLost},
	on_trigger = function(self,event,player,data)
		local room = player:getRoom()
		if player:hasSkill(self:objectName()) then
			room:broadcastSkillInvoke("lingti")
			player:drawCards(1)
			return true
		end
	end,
	priority = 8
}


xiaoshi = sgs.CreateTriggerSkill
{
	name = "xiaoshi",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart, sgs.EventPhaseStart},
	on_trigger = function(self,event,player,data)
		local room = player:getRoom()
		if event == sgs.GameStart then
			room:setPlayerProperty(player, "maxhp", sgs.QVariant(0))
			room:broadcastSkillInvoke("xiaoshi")
			player:gainMark("@Menma_turn", room:getAlivePlayers():length() + 5)
		elseif event == sgs.EventPhaseStart and player:getPhase() == sgs.Player_Start then
			player:loseMark("@Menma_turn")
			if player:getMark("@Menma_turn") == 0 then
				room:doLightbox("xiaoshi$", 3000)
				room:killPlayer(player, killer)
			end
		end
	end,
	priority = 7
}
------------------------------------
cr = sgs.General(extension, "cr", "real", 4, false, false, false)

LLJ_reality= sgs.CreateTriggerSkill
{
	name = "LLJ_reality",
	frequency = sgs.Skill_Frequent, 
	events = {sgs.EventPhaseStart, sgs.FinishJudge}, 
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.EventPhaseStart then
			if player:getPhase() == sgs.Player_Draw then
				local broadcasted = false
				while player:askForSkillInvoke(self:objectName()) do
					if not broadcasted then
						room:broadcastSkillInvoke("LLJ_reality", 1)
						room:doLightbox("LLJ_reality$", 500)
						broadcasted = true
					end
					local choice = room:askForChoice(player,self:objectName(),"jiben12+jinang12+zhuangbei12")
					if choice == "zhuangbei12" then
						local id = room:askForCardChosen(player, player, "h", "LLJ_reality")
						room:throwCard(id,player, player)
						player:gainMark("@force", 1)
					end
					
					local judge = sgs.JudgeStruct()
					judge.who = player
					judge.negative = false
					judge.play_animation = false
					judge.time_consuming = true
					judge.reason = self:objectName()
					room:judge(judge)
					if judge.card:isKindOf("BasicCard") and choice == "jiben12" then
						break
					elseif judge.card:isKindOf("TrickCard") and choice == "jinang12" then
						break
					elseif judge.card:isKindOf("EquipCard") and choice == "zhuangbei12" then
						break
					end
					if judge.card:isKindOf("BasicCard") then
						room:broadcastSkillInvoke("LLJ_reality", 2)
					elseif judge.card:isKindOf("TrickCard") then
						room:broadcastSkillInvoke("LLJ_reality", 3)
					else
						room:broadcastSkillInvoke("LLJ_reality", 4)
					end
				end
			end
		elseif event == sgs.FinishJudge then
			local judge = data:toJudge()
			if judge.reason == self:objectName() then
				local card = judge.card
					player:obtainCard(card)
					return true
			end
		end
		return false
	end
}

LLJ_force= sgs.CreateTriggerSkill
{
	name = "LLJ_force",
	frequency = sgs.Skill_Frequent, 
	events = {sgs.EventPhaseStart, sgs.FinishJudge}, 
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.EventPhaseStart then
			if player:getPhase() == sgs.Player_Start then
				while player:askForSkillInvoke(self:objectName()) do
					local choice = room:askForChoice(player,self:objectName(),"jiben12+jinang12+zhuangbei12")
					if choice == "zhuangbei12" then
						local id = room:askForCardChosen(player, player, "h", "LLJ_reality")
						room:throwCard(id,player, player)
					end
					
					local judge = sgs.JudgeStruct()
					judge.who = player
					judge.negative = false
					judge.play_animation = false
					judge.time_consuming = true
					judge.reason = self:objectName()
					room:judge(judge)
					room:broadcastSkillInvoke("LuaLuoshen")
					if judge.card:isKindOf("BasicCard") and choice == "jiben12" then
						break
					elseif judge.card:isKindOf("TrickCard") and choice == "jinang12" then
						break
					elseif judge.card:isKindOf("EquipCard") and choice == "zhuangbei12" then
						break
					end
				end
			end
		elseif event == sgs.FinishJudge then
			local judge = data:toJudge()
			if judge.reason == self:objectName() then
				local card = judge.card
					player:obtainCard(card)
					return true
			end
		end
		return false
	end
}


------------------------------------------

LLJ_chihun = sgs.CreateTriggerSkill{
	name = "LLJ_chihun",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.CardUsed},
	on_trigger = function(self, event, player, data)
		local room=player:getRoom()
		local use = data:toCardUse()
		if use.from:objectName() == player:objectName() and player:hasSkill(self:objectName()) and player:getPhase() == sgs.Player_Play and not player:getCards("hej"):isEmpty() then
			if use.card:getSuit() == sgs.Card_NoSuit then
			player:drawCards(2) 
			end
		end
	end
}

------------------------------------------------------------


LLJ_guilty = sgs.CreateTriggerSkill{-----罪
	name = "LLJ_guilty",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Damaged},
	can_trigger=function()
		return true
	end,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local da = data:toDamage()
		if da.from == nil then return false end
		if event== sgs.Damaged then
			if da.from:hasSkill(self:objectName()) then return end
			if da.from:getMark("@LLJ_guilty") == 0 then
				da.from:gainMark("@LLJ_guilty")
			end
			da.to:loseMark("@LLJ_guilty")
		end
	end
}

LLJ_DN = sgs.CreateTriggerSkill{-----罪
	name = "LLJ_DN",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Damaged},
	can_trigger=function()
		return true
	end,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local da = data:toDamage()
		if da.from == nil then return false end
		if event== sgs.Damaged then
			if da.from:getMark("@LLJ_guilty") > 0 then
			local hp = da.from:getHp()
			room:loseHp(da.from,hp)
			end
		end
	end
}

--killer = sgs.General(extension, "killer", "Erciyuan", 3, true, false, false)

---------------------------------------------

rika2 = sgs.General(extension, "rika2", "magic", 3, false, false, false)


LLJ_recycle = sgs.CreateTriggerSkill{
	name = "LLJ_recycle",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.CardsMoveOneTime,sgs.EventPhaseStart, sgs.DrawNCards},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.EventPhaseStart then
			if player:getPhase() == sgs.Player_RoundStart or player:getPhase() == sgs.Player_Finish then
				local lunhui = player:getPile("lunhui")
				if lunhui:length() > 0 then
					local move2 = sgs.CardsMoveStruct()
					move2.card_ids =lunhui
					move2.to = player
					move2.to_place = sgs.Player_PlaceHand
					room:moveCardsAtomic(move2,false)	
					room:broadcastSkillInvoke("LLJ_recycle")	
				end
			end
		elseif event == sgs.CardsMoveOneTime then
			local move = data:toMoveOneTime()
			local source = move.from
			if not source then return end
			if source:objectName() == player:objectName() then
				if move.to_place == sgs.Player_DiscardPile then
					local reason = move.reason.m_reason
					local flag = false
					if bit32.band(reason, sgs.CardMoveReason_S_MASK_BASIC_REASON) == sgs.CardMoveReason_S_REASON_DISCARD then
						flag = true
					end
					if reason == 0x01 then
						flag = true
					end
					if flag then
						local ids = sgs.QList2Table(move.card_ids)
						local places = move.from_places
						for i = 1, #ids, 1 do
							local id = ids[i]
							local place = places[i]
							local suit = sgs.Sanguosha:getCard(id):getSuit()
							if suit ~= sgs.Card_NoSuit then
								if place ~= sgs.Player_PlaceSpecial then
									if room:getCardPlace(id) == sgs.Player_DiscardPile then
										player:addToPile("lunhui", id)
									end
								end
							end
						end
					end
				end
			end
		elseif event == sgs.DrawNCards then
			if data:toInt() - 1 > 0 then
				data:setValue(data:toInt() - 1)
			else
				data:setValue(0)
			end
		end
		return false
	end,
}



-------芽衣子 补充
SE_Xinyuan = sgs.CreateTriggerSkill{
        name = "SE_Xinyuan",
        frequency = sgs.Skill_NotFrequent,
        events = {sgs.BeforeCardsMove},
        on_trigger = function(self, event, player, data)
            local move = data:toMoveOneTime()
            local source = move.from
            if source and source:objectName() == player:objectName() and player:getPhase() == sgs.Player_Discard then
                if move.to_place == sgs.Player_DiscardPile then
                    local reason = move.reason
                    local basic = bit32.band(reason.m_reason, sgs.CardMoveReason_S_MASK_BASIC_REASON)
                    if basic == sgs.CardMoveReason_S_REASON_DISCARD then
                        local room = player:getRoom()
                        local i = 0
                        local lirang_card = sgs.IntList()
                        for _,card_id in sgs.qlist(move.card_ids) do
                            if room:getCardOwner(card_id):objectName() == move.from:objectName() then
                                local place = move.from_places:at(i)
                                if place == sgs.Player_PlaceHand or place == sgs.Player_PlaceEquip then
                                    lirang_card:append(card_id)
                                end
                            end
                            i = i + 1
                        end
                        if not lirang_card:isEmpty() then
                            if player:askForSkillInvoke(self:objectName(), data) then
                            	player:setMark("xinyuan_dis", lirang_card:length())
                                local dest = room:askForPlayerChosen(player,room:getOtherPlayers(player),self:objectName())
                                room:broadcastSkillInvoke("SE_Xinyuan")
                                if dest then dest:drawCards(lirang_card:length()) end
                            end
                        end
                    end
                end
            end
            return false
        end
    }


local function tabcontain(a,b)
	flag=false
	for _, c in ipairs(a) do
		if b==c then
			flag=true
		end
	end
	return flag
end


ku = sgs.General(extension, "ku", "real", 4, false)

dandiao = sgs.CreateTriggerSkill{
    name = "dandiao",
    frequency = sgs.Skill_NotFrequent,
    events = {sgs.EventPhaseStart},
    on_trigger = function(self, event, player, data)
        local room = player:getRoom()
        local phase = player:getPhase()
        if phase == sgs.Player_Draw then
            if room:askForSkillInvoke(player, self:objectName(), data) then
				local spade=0
				local heart=0
				local club=0
				local diamond=0
				for _, card in sgs.qlist(player:getHandcards()) do
					if card:getSuit()==sgs.Card_Spade then  spade=spade+1 end
					if card:getSuit()==sgs.Card_Heart then  heart=heart+1 end
					if card:getSuit()==sgs.Card_Club then  club=club+1 end
					if card:getSuit()==sgs.Card_Diamond then  diamond=diamond+1 end
				end
				local onecount=0
				local whichflu="none"
				if spade == 1 then onecount=onecount+1 
				whichflu="spade" end
				if heart == 1 then onecount=onecount+1 
				whichflu="heart" end
				if club == 1 then onecount=onecount+1 
				whichflu="club" end
				if diamond == 1 then onecount=onecount+1 
				whichflu="diamond" end
				if onecount~=1 then whichflu="none" end
				
				
				--local condition = {}
				--local conditionrank = {}
				----储存弃牌堆的花色
				local spade=0
				local heart=0
				local club=0
				local diamond=0
				for i=0,200 do
					if room:getDiscardPile():at(i)>0 then
						if sgs.Sanguosha:getCard(room:getDiscardPile():at(i)):getSuit()==sgs.Card_Spade then  spade=spade+1 end
						if sgs.Sanguosha:getCard(room:getDiscardPile():at(i)):getSuit()==sgs.Card_Heart then  heart=heart+1 end
						if sgs.Sanguosha:getCard(room:getDiscardPile():at(i)):getSuit()==sgs.Card_Club then  club=club+1 end
						if sgs.Sanguosha:getCard(room:getDiscardPile():at(i)):getSuit()==sgs.Card_Diamond then  diamond=diamond+1 end
					end
				end
				local rank={}
				table.insert(rank,spade)
				table.insert(rank,heart)
				table.insert(rank,club)
				table.insert(rank,diamond)
				table.sort(rank)
				local aimflu=0
				local damagewillbedone=0
				if whichflu=="spade" then aimflu=spade end
				if whichflu=="heart" then aimflu=heart end
				if whichflu=="club" then aimflu=club end
				if whichflu=="diamond" then aimflu=diamond end
				--if whichflu==0 then return end
				for i=1,4 do
					if rank[i]==aimflu then
						damagewillbedone=i
					end
				end
				
				
				--[[
				i=1
				while math.max(spade,heart,club,diamond)>0 do
					local Ah = math.max(spade,heart,club,diamond)
					if spade==Ah then 
						table.insert(condition,"spade")
						table.insert(conditionrank,i)
						spade=-1
					end
					if heart==Ah then 
						table.insert(condition,"heart")
						table.insert(conditionrank,i)
						heart=-1
					end
					if club==Ah then 
						table.insert(condition,"club") 
						table.insert(conditionrank,i)
						club=-1
					end
					if diamond==Ah then 
						table.insert(condition,"diamond") 
						table.insert(conditionrank,i)
						diamond=-1
					end
					i=i+1
				end	
				]]
				
				

				
				--[[if spade>Ah and tabcontain(condition, "spade") then table.remove(condition,1)end
				if heart>Ah and tabcontain(condition, "heart") then table.remove(condition,1) end
				if club>Ah and tabcontain(condition, "club") then table.remove(condition,1) end
				if diamond>Ah and tabcontain(condition, "diamond") then table.remove(condition,1) end]]
					
	            local card1 = room:drawCard()
				local move = sgs.CardsMoveStruct()
				move.card_ids:append(card1)
				move.reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_TURNOVER, player:objectName(), self:objectName(), nil)
				move.to_place = sgs.Player_PlaceTable
				room:moveCardsAtomic(move, true)
				
				local card2 = sgs.Sanguosha:getCard(card1)
				local suit = card2:getSuitString()
				
				if whichflu==suit then 
					if math.random(1, 2) == 1 then
						room:broadcastSkillInvoke("dandiao", 1)
					else
						room:broadcastSkillInvoke("dandiao", 2)
					end
					room:doLightbox("dandiao$", 3000)
					room:showAllCards(player)
					local to = room:askForPlayerChosen(player, room:getAlivePlayers(), self:objectName(), "solo", true, true)
					room:damage(sgs.DamageStruct(self:objectName(), player, to, damagewillbedone, sgs.DamageStruct_Thunder))
					room:loseMaxHp(to, math.floor(damagewillbedone/2))
				else
					if math.random(1, 2) == 1 then
						room:broadcastSkillInvoke("dandiao", 3)
					else
						room:broadcastSkillInvoke("dandiao", 4)
					end
				end
				
				local move2 = move
	            move2.to_place = sgs.Player_PlaceHand
	            move2.to = player
	            move2.reason.m_reason = sgs.CardMoveReason_S_REASON_DRAW
	            room:moveCardsAtomic(move2, true)
				return true
            end
        end
    end
}
ku:addSkill(dandiao)

sgs.LoadTranslationTable{
["ku"] = "竹井久",
["&ku"] = "竹井久",
["@ku"] = "天才麻将少女",
["~ku"] = "那个呢...我平时也是选择更加合理的打法的...",
["#ku"] = "地狱单骑",
["$dandiao1"] = "（まこ）在这里的我们，就是你选择概率低打法的结果呢，部长。",
["$dandiao2"] = "这可不安全哟。点和，立直，一发，宝牌4，12000点。",
["$dandiao3"] = "那么，你打算...把仅此一次的人生，也用理论和计算度过吗？",
["$dandiao4"] = "和看见了又该生气了吧。",
["dandiao"] = "单吊『将』",
["solo"] = "選擇一個角色受到傷害和上限失去！",
[':dandiao'] = "摸牌阶段开始时，你可以放弃摸牌改为从牌堆顶亮出一张牌。若此牌的花色是手牌中唯一的仅一张的花色，则可以展示所有手牌，并选择一名角色，对其造成X点雷电伤害之后失去[X/2]点体力上限，然后获得此牌。 （X为此牌的花色在弃牌堆中花色的从少到多的顺位）。",
["designer:ku"] = "帕秋莉·萝莉姬",
["cv:ku"] = "伊藤静",
["illustrator:ku"] = "",
}

pyuki = sgs.General(extension, "pyuki", "real", 4, false)
eastfast = sgs.CreateTriggerSkill{
        name = "eastfast",
        frequency = sgs.Skill_Frequent,
        events = {sgs.EventPhaseStart},
        on_trigger = function(self, event, player, data)
                if player:getPhase() == sgs.Player_Start then
                        local room = player:getRoom()
                        local broadcasted = false
						::label1::
                        if room:askForSkillInvoke(player, self:objectName(), data) then
                                local condition=room:getDrawPile():length()-(3*room:getDiscardPile():length())
								local x=2+player:getCards("j"):length()
								if condition>0 then
										if not broadcasted then
											room:doLightbox("eastfast$", 500)
											room:broadcastSkillInvoke("eastfast", 1)
											broadcasted = true
										end
										local card = sgs.IntList()
										card:append(room:getDrawPile():at(0))
										local id = room:getDrawPile():at(0)
										local acard=sgs.Sanguosha:getCard(id)
										room:fillAG(card, player)
										player:setMark("eastfast_card", id)
										local choice = room:askForChoice(player,"eastfast","save+drop")
										if choice =="drop" then
											room:throwCard(acard, nil, nil)
										end
										if choice =="save" then
											if acard:isKindOf("tacos") then
												room:broadcastSkillInvoke("eastfast", 2)
											end
											player:addToPile("save", acard, false)
										end
										room:clearAG(player)
										if player:getPile("save"):length()<x then
											goto label1
										end
										--goto labels
								end
								if condition<=0 then
										local card = room:askForUseCard(player, 'tacos', "@eastfast-tacos")
										if card then
											if not broadcasted then
												room:broadcastSkillInvoke("eastfast", 2)
												broadcasted = true
											end
											goto label1
										end
										--goto labels
								end
						end		
						--::labels::
						local saves=player:getPile("save")
						if saves:length()>0 then
							local move = sgs.CardsMoveStruct()
							move.card_ids=saves
							move.to_place = sgs.Player_DrawPile
							move.reason.m_reason=sgs.CardMoveReason_S_REASON_PUT
							room:moveCardsAtomic(move,false)
							--room:askForGuanxing(player,saves,sgs.Room_GuanxingUpOnly)
						end
						room:clearAG(player)
                end
        end
}

pyuki:addSkill(eastfast)
sgs.LoadTranslationTable{
["pyuki"] = "片岡優希",
["&pyuki"] = "片岡優希",
["@pyuki"] = "天才麻将少女",
["#pyuki"] = "东风王",
["eastfast"] = "速攻『东风』",
["$eastfast1"] = "这样的话，先锋派最强的出战才是常理。就是说我最强！",
["$eastfast2"] = "这场比赛...不会再有东二局！",
["~pyuki"] = "墨西哥饼能量耗尽了...",
["@eastfast-tacos"] = "你可以弃置一张tacos，然后发动「速攻『东风』」",
["drop"] = "弃掉这张牌",
["save"] = "保留这张牌",
[':eastfast'] = '准备阶段开始时，若摸牌堆大于弃牌堆牌数的3倍时，你可以观看牌堆顶的1张牌，然后可以弃置这张牌或者选择将此牌置于保留区，若保留牌数小于于X，则可以继续发动该技能。若摸牌堆不大于弃牌堆牌数的3倍时，你可以使用手牌中的tacos，如此做可以继续发动该技能。技能结束时，将保留区的牌按栈的规则放回牌堆顶。（X为2+你的判定区的牌数。）',
["designer:pyuki"] = "帕秋莉·萝莉姬",
["cv:pyuki"] = "釘宮理恵",
["illustrator:pyuki"] = "",
}


rika2:addSkill(LLJ_recycle)
--killer:addSkill(LLJ_guilty)
--killer:addSkill(LLJ_DN)
cr:addSkill(LLJ_reality)
mianma:addSkill(xiaoshi)
mianma:addSkill(lingti)
mianma:addSkill(SE_Xinyuan)
--qb:addSkill(youpian)
kuro:addSkill(spring)
kuro:addSkill(spreadillness)
--qb:addSkill(LLJ_chihun)
jdd:addSkill(tuhao)
jdd:addSkill(shouji)
acc:addSkill(vector)



sgs.LoadTranslationTable{
["shouji$"] = "image=image/animate/shouji.png",
["vector$"] = "image=image/animate/vector.png",
["xiaoshi$"] = "image=image/animate/xiaoshi.png",
["eastfast$"] = "image=image/animate/eastfast.png",
["dandiao$"] = "image=image/animate/dandiao.png",
["LLJ_reality$"] = "image=image/animate/LLJ_reality.png",

["rika2"] = "古手梨花",
["&rika2"] = "古手梨花", 
["@rika2"] = "寒蝉鸣泣之时",
["#rika2"] = "无尽轮回の巫女", 
["~rika2"] = "...", 
["cv:rika2"] = "田村ゆかり",
["designer:rika2"] = "帕秋莉·萝莉姬",

["lunhui"] = "轮回",
["LLJ_recycle"] = "轮回",
[":LLJ_recycle"] = "<font color=\"blue\"><b>锁定技,</b></font>摸牌阶段，你少摸一张牌（最少为0）。当你使用牌因弃牌、使用结算完毕将要进入弃牌堆时，你可以获得之并置于武将牌上方。回合开始时，回合结束阶段开始时，你获得武将牌上的所有牌。",
["$LLJ_recycle1"] = "这样也好，就算你们不主动涉足，惩罚依旧会来临...因为，绵流祭即将开始...",
["$LLJ_recycle2"] = "我到底该怎么办...该怎么办...",
["~rika2"] = "（背景音：蝉鸣）今天，是举行绵流祭的日子...", 

["killer"] = "夜神月",
["LLJ_guilty"] = "罪犯",
["LLJ_DN"] = "DN",
["LLJ_chihun"] = "炽魂",
[":LLJ_chihun"] = "出牌阶段，每当你使用一次指定性技能或使用无色的牌，你摸两张牌。",

["cr"] = "凉宫春日",
["&cr"] = "凉宫春日", 
["@cr"] = "凉宫春日的忧郁",
["#cr"] = "团长大人", 
["~cr"] = "你不也觉得那个世界很无聊么？你就不希望有什么更有趣的事情发生么？！", 
["cv:cr"] = "平野绫",
["designer:cr"] = "帕秋莉·萝莉姬",

["LLJ_reality"] = "梦现",
["$LLJ_reality1"] = "我对一般的人类没有兴趣，如果你们中谁是宇宙人，未来人，异世界人或者超能力者的话，就到我这里来！",
["$LLJ_reality2"] = "（长门神）通俗地说，我是相当于宇宙人的存在。",
["$LLJ_reality3"] = "（朝比奈学姐）我不是这个时代的人，是从更远的未来来的。",
["$LLJ_reality4"] = "（古泉）如您明察，我是超能力者。",
[":LLJ_reality"] = "摸牌阶段开始时，你可以声明一种牌的类别，然后进行判定并你获得判定牌。你重复该过程直到判定牌不为你所声明的类别。若你声明的是武器牌，你需要弃置一张手牌。",
["LLJ_force"] = "强制",
[":LLJ_force"] = "出牌阶段，你可以弃置8个标记，并获得场上一张装备牌",
["jiben12"] = "基本牌",
["jinang12"] = "锦囊牌",
["zhuangbei12"] = "装备牌",
["youpian"]="诱骗",
[":youpian"]="你可以指定一名角色，询问其是否愿意成为魔法少女。（如果选择同意，你失去一点体力；选择不同意，有50%几率什么都不发生，50%几率你获得“鼠疫”。）",
["youpianyes"]="你是否愿意成为魔法少女，按照圣经的教训与他同住，在神面前和她结为一体，爱她、安慰她、尊重她、保护他，像你爱自己一样。不论她生病或是健康、富有或贫穷，始终忠於她，直到离开世界?同意选此项",
["youpianno"]="你是否愿意成为魔法少女，按照圣经的教训与他同住，在神面前和她结为一体，爱她、安慰她、尊重她、保护他，像你爱自己一样。不论她生病或是健康、富有或贫穷，始终忠於她，直到离开世界?质疑选此项",

["shouji"]="收集",
["$shouji1"]="折木同学，有什么线索吗？",
["$shouji2"]="折木同学！一起来调查吧！我很好奇！",
[":shouji"]="<font color=\"green\"><b>出牌阶段限一次，</b></font>你可以弃置X张牌，依次观看场上所有角色的手牌并选择一张获得之。 X为你的体力值+1。",
["tuhao"] = "土豪",
["$tuhao1"] = "（里志）奉太郎没听说过【千反田家族】的名号吗！",
["$tuhao2"] = "（里志）怎么样！够气派吧！（奉太郎）走吧，千反田她们还等着呢。",
[":tuhao"] = "<font color=\"blue\"><b>锁定技,</b></font>出牌阶段，每当你使用一张红色的牌，你摸一张牌；每当你使用一张黑色的牌，你须弃置你的任意区域内的一张牌。",

["vector"]="矢量操纵",
["vector_Discard"]="你可以弃置一张手牌，令当前结算的效果转移为场上任意的角色。",
[":vector"]="每当结算你为目标的锦囊或杀的效果时，你可以弃置一张手牌，令该效果转移为场上任意的角色。",

["$vector1"] = "不好意思，这前面可是一方通行！",
["$vector2"] = "就算如此，我也决定在那小鬼面前，一直自称为最强。",
["$vector3"] = "（狂笑）演出辛苦了！",
["$vector4"] = "（狂笑）原来是木原君啊！",

["yehuo"] = "夜祸",
[":yehuo"] = "<font color=\"blue\"><b>锁定技,</b></font>你的回合开始阶段，如果处于背面朝上，你翻过来行动,并于回合结束阶段翻回背面。回合外，每次被翻回正面，你当收到一点无来源的无属性伤害。",
["spring"] = "源头",
[":spring"] = "游戏开始阶段，你获得“鼠疫”，“鼠疫”对你无效，你无法获得“抗体”。每当你受到“鼠疫”持有角色伤害或对其造成伤害时，可以获得其所拥有的“鼠疫”，或者给予其自己所拥有的“鼠疫”，并防止此次伤害。不能无视抗体",
["spreadillness"] = "鼠疫",
[":spreadillness"] = "回合结束的时候，失去1点体力，与你距离为1的角色将以80%获得“鼠疫”，距离为2的角色将以50%获得“鼠疫”，持有者将以50%的几率失去“鼠疫”获得免疫。获得免疫者以50%失去“抗体”",
["@spreadDiscard"] = "为新的病原体而弃置一张牌。",
["lingti"] = "灵体",
[":lingti"] = "<font color=\"blue\"><b>锁定技,</b></font>你防止你的任何体力减少，每防止一次摸一张牌。",	
["$lingti1"] = "大~丈~夫~",
["xiaoshi"] = "消逝",
[":xiaoshi"] = "游戏开始时，你的体力上限变为0，你获得X枚“灵体”标记。回合开始阶段开始时，你失去一个“灵体”标记；若你没有“灵体”标记，你立即死亡。X为游戏人数 + 5",
["$xiaoshi1"] = "面麻...对自己已经死了这件事，还是知道的...",
["SE_Xinyuan"] = "心愿",
["$SE_Xinyuan1"] = "这样子，真的好怀念，好开心。",
["$SE_Xinyuan2"] = "面麻的愿望...好像已经实现了...",
["$SE_Xinyuan3"] = "仁太，你又哭了吗？",
[":SE_Xinyuan"] = "弃牌阶段，当你的牌因弃置而置入弃牌堆时，你可以令任意其他角色摸等量的牌。",
["lolihime"] = "动漫包-萝莉姬",
["mianma"] = "本间芽衣子",
["#mianma"] = "面码",
["@mianma"] = "花名未闻",
["&mianma"] = "本间芽衣子",
["~mianma"] = "（仁太）一，二，（大家）找到面麻了！ （面麻）被大家找到...了...", 
["cv:mianma"] = "茅野爱衣",
["designer:mianma"] = "帕秋莉·萝莉姬 & Sword Elucidator",

["acc"] = "原·一方通行",
["&acc"] = "原·一方通行",
["@acc"] = "魔法禁书目录",
["~acc"] = "...", 
["#acc"] = "level 6",
["cv:acc"] = "冈本信彦",
["designer:acc"] = "帕秋莉·萝莉姬",

["qb"] = "QBキュゥべえ",
["&qb"] = "QB",
["~qb"] = "...", 
["#qb"] = "魔法少女诱拐犯",
["cv:qb"] = "加藤英美里",
["designer:qb"] = "帕秋莉·萝莉姬",


["kuro"] = "佩斯特",
["$kuro"] = "佩斯特",
["@kuro"] = "问题儿都来自新世界",
["#kuro"] = "黑死病魔王",
["~kuro"] = "...", 
["cv:kuro"] = "",
["designer:kuro"] = "帕秋莉·萝莉姬",


["jdd"] = "千反田爱瑠", 
["&jdd"] = "千反田爱瑠", 
["@jdd"] = "冰菓", 
["#jdd"] = "我很好奇", 
["~jdd"] = "太好了，让我想起来了...这样就能好好去送舅舅了...", 
["designer:jdd"] = "帕秋莉·萝莉姬",
["cv:jdd"] = "佐藤聡美",
["illustrator:jdd"] = "",
}


--江之岛盾子

Junko = sgs.General(extension, "Junko", "real", 3, false,false,false)

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
			
			if junko:getMark("SE_Heimu_done") == 2 then return false end
			if junko:isAlive() then return false end
			if room:askForSkillInvoke(junko, self:objectName()) then
				room:revivePlayer(junko)
				room:broadcastSkillInvoke(self:objectName())
				room:setPlayerProperty(junko, "maxhp", sgs.QVariant(4))
				room:setPlayerProperty(junko, "hp", sgs.QVariant(4))
				junko:drawCards(4) 
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
			--以下忘了干啥用的了......
		--elseif event == sgs.GameStart then
		--	for _,p in sgs.qlist(room:getAlivePlayers()) do
		--		if not p:hasSkill("SE_Heimu") then
		--			room:acquireSkill(p, "SE_Heimu")
		--		end
		--	end
		end
	end,
}

Junko:addSkill(SE_Heimu)


ruler = sgs.CreateTriggerSkill{
	name = "ruler",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.HpChanged},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local junko = room:findPlayerBySkillName("ruler")
		if not junko then return false end
		if player:getHp()>junko:getHandcardNum() then
			room:broadcastSkillInvoke(self:objectName())
			room:setPlayerProperty(player, "hp", sgs.QVariant(junko:getHandcardNum()))
		end
		return false
	end,
	can_trigger = function(self, target)
		return target ~= nil
	end
}
extension:addToSkills(ruler)
Junko:addWakeTypeSkillForAudio("ruler")
sgs.LoadTranslationTable{
["SE_Heimu$"] = "image=image/animate/SE_Heimu.png", 

["SE_Heimu"] = "黑幕",
["$SE_Heimu1"] = "真是让我久等了，让本大爷久等了啊。我就等待着像你们这样的人出现。",
["$SE_Heimu2"] = "设定为拥有超强体力的姐姐就是战刃骸，设定为既可爱又聪明的妹妹...那就是我...江之岛盾子妹妹！哈哈哈哈哈哈哈！我们姐妹两个放在一起就是【超高校级的绝望】！绝望Sisters！！",
[":SE_Heimu"] = "<font color=\"red\"><b>限二技，</b></font>游戏结束前，若你已经阵亡，可以以4体力上限满血复活并摸4张牌并对场上所有角色造成1点雷击伤害，之后把你的身份变为主公，胜者为反贼，败者为内奸，并获得[规定『学级』]。\n\n<font weight=2><font color=\"brown\"><b>绝望学园 规定『学级』:</b></font><font color=\"blue\"><b>锁定技，</b></font>场上的所有角色在体力变动后，体力值调整为不多于你的手牌数。",

["ruler"] = "绝望学园 规定『学级』",
["$ruler1"] = "绝望  是会传染的。",
["$ruler2"] = "是个人都会绝望。",
["$ruler3"] = "嗯，就是这么回事，将作为希望象征的希望峰学园内发生的互相残杀向世界直播这件事....正是人类绝望计划的高潮啊！！",
["$ruler4"] = "我只是单纯的在追求绝望而已，这之中并没有任何其他理由了，正因为没有理由，所以也无法找到对策，而无法应对无法理解的这份蛮横，这正是【超高校级绝望】啦！",
[":ruler"] = "<font color=\"blue\"><b>锁定技，</b></font>场上的所有角色在体力变动后，体力值调整为不多于你的手牌数。",



["Junko"] = "江之岛盾子", 
["&Junko"] = "江之岛盾子", 
["@Junko"] = "弹丸论破", 
["#Junko"] = "幕后黑手", 
["~Junko"] = "噗噗~唔噗噗噗~啊~真是太棒了，这就是死亡的绝望呢，好想将整个世界都染上这份美妙的绝望~", 
["designer:Junko"] = "萝莉姬",
["cv:Junko"] = "豊口めぐみ",
["illustrator:Junko"] = "",
}