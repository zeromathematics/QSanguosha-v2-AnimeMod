module("extensions.math",package.seeall)
extension=sgs.Package("math")

Seniorious=sgs.General(extension,"Seniorious","magic",4,false)
oumashu=sgs.General(extension,"oumashu","science",4)
Inori=sgs.General(extension,"Inori","science",3,false)
oumamana=sgs.General(extension,"oumamana","science",2,false,true)
MiyanagaTeru=sgs.General(extension,"MiyanagaTeru","real",4,false)
OohoshiAwai=sgs.General(extension,"OohoshiAwai","real",4,false)

xingfu=sgs.CreateTriggerSkill{
name="xingfu",
frequency=sgs.Skill_Notfrequent,
events={sgs.CardUsed},
on_trigger=function(self,event,player,data)
local use=data:toCardUse()
local card=use.card
local room=player:getRoom()
if card:getSuit()==sgs.Card_Heart then
if room:askForSkillInvoke(player,"xingfu",data) then
local choice=room:askForChoice(player,"xingfu","draw_a_card+recover_one_hp")
if choice=="draw_a_card" then
room:broadcastSkillInvoke(self:objectName())
room:drawCards(player,1)
end
if choice=="recover_one_hp" then
room:broadcastSkillInvoke(self:objectName())
local theRecover=sgs.RecoverStruct()
theRecover.recover=1
theRecover.who=player
room:recover(player,theRecover)
end
end
end
end
}

mshengjian=sgs.CreateFilterSkill{
name="mshengjian",
view_filter = function(self, to_select)
local room=sgs.Sanguosha:currentRoom()
local player=room:findPlayerBySkillName(self:objectName())
if player:getWeapon()~=nil then
return to_select:isRed()
end
end,
view_as = function(self, card)
local id = card:getEffectiveId()
local new_card = sgs.Sanguosha:getWrappedCard(id)
new_card:setSkillName(self:objectName())
new_card:setSuit(sgs.Card_Heart)
new_card:setModified(true)
return new_card
end
}

mshengjian_tri=sgs.CreateTriggerSkill{
name="#mshengjian_tri",
frequency=sgs.Skill_Notfrequent,
events={sgs.CardsMoveOneTime},
on_trigger=function(self,event,player,data)
local room = player:getRoom()
local move = data:toMoveOneTime()
if move.from then
places = sgs.QList2Table(move.from_places)
local can_invoke=false
for i=1,#places,1 do
if places[i]==sgs.Player_PlaceEquip then
can_invoke=true
end
end
if not can_invoke then
return false
end
card_ids = sgs.QList2Table(move.card_ids)
for i=1,#places,1 do
if places[i]==sgs.Player_PlaceEquip then
card=sgs.Sanguosha:getCard(card_ids[i])
if (card:isRed() and move.from:objectName() == player:objectName()) then
if room:askForSkillInvoke(player,"mshengjian",data) then
local x=player:getMaxHp()-player:getHp()
room:drawCards(player,1+x)
room:broadcastSkillInvoke(self:objectName())
end
end
end
end
end
end
}

m_qinshi=sgs.CreateTriggerSkill{
name="m_qinshi",
frequency=sgs.Skill_Notfrequent,
events={sgs.CardUsed,sgs.DamageCaused},
on_trigger=function(self,event,player,data)
if event==sgs.CardUsed then
local use=data:toCardUse()
local card=use.card
local room=player:getRoom()
if card:isBlack() and (card:isKindOf("Slash") or card:isKindOf("TrickCard")) then
room:broadcastSkillInvoke(self:objectName())
room:doLightbox("image=image/animate/qinshi.png",2000)
room:loseHp(player)
player:gainMark("@m_qinshi")
end
end
if event==sgs.DamageCaused then
local damage=data:toDamage()
local room=player:getRoom()
if player:getMark("@m_qinshi")>0 then
if room:askForSkillInvoke(player,"m_qinshi",data) then
room:broadcastSkillInvoke(self:objectName())
room:doLightbox("image=image/animate/qinshi.png",2000)
player:loseMark("@m_qinshi")
damage.damage = damage.damage + 1
data:setValue(damage)
end
end
end
end
}

voidcard=sgs.CreateSkillCard{
name="voidcard",
filter=function(self,targets,to_select)
return #targets==0
end,
on_effect=function(self,effect)
local room = effect.from:getRoom()
   if effect.to:getGeneralName()=="Inori" and effect.from:getGeneralName()=="oumashu" and not (room:hasAura() and room:getAura()==self:objectName()) then
   room:doAura(effect.from,self:objectName())
   end
   for i=1,2,1 do
      if not effect.to:isKongcheng() then
      local disabled_ids=sgs.IntList()
          for _,id in sgs.qlist(effect.to:handCards()) do
          local tryCard=sgs.Sanguosha:getEngineCard(id)
          local toTry=sgs.Sanguosha:cloneCard(tryCard)
               if toTry~=nil then
               toTry:setCanRecast(false)
               toTry:setSkillName("void")
                     if not toTry:isAvailable(effect.from) or (tryCard:isKindOf("Slash") and effect.from:usedTimes("Slash")>=1 + sgs.Sanguosha:correctCardTarget(sgs.TargetModSkill_ExtraTarget, sgs.Self, self))then
                     disabled_ids:append(id)
                     end
               toTry=nil
               end
          end
      room:fillAG(effect.to:handCards(), effect.from,disabled_ids)
      local choice=room:askForChoice(effect.from,"void","use+not_use")
	       if choice=="use" then
           if disabled_ids:length()<effect.to:handCards():length() then
           local id=room:askForAG(effect.from,effect.to:handCards(),true,"void")
           room:clearAG(effect.from)
           local card=sgs.Sanguosha:getCard(id)
           local use=sgs.CardUseStruct()
           use.card=card
           use.from=effect.from
           local targets=sgs.SPlayerList()
                for _,p in sgs.qlist(room:getAlivePlayers()) do
                     if not effect.from:isProhibited(p,card) then
                     targets:append(p)
                     end
                end
                if targets:length()>0 then
                    if card:isKindOf("AmazingGrace") or card:isKindOf("GodSalvation") then
                         for _,dest in sgs.qlist(targets) do
                         use.to:append(dest)
                         end
                    end
					if card:isKindOf("IronChain") then
                    local dest1=room:askForPlayerChosen(effect.from,targets,"void")
                    use.to:append(dest1)
                    local dest2=room:askForPlayerChosen(effect.from,targets,"void")
                    local same=false
					for _,p in sgs.qlist(use.to) do
					if p:objectName()==dest2:objectName() then
					same=true
					end
					end
					if same==false then
					use.to:append(dest2)
					end
                    end
					if card:isKindOf("SavageAssault") or card:isKindOf("ArcheryAttack") then
					     for _,dest in sgs.qlist(targets) do
                            if dest:objectName()~=effect.from:objectName() then
						    use.to:append(dest)
                            end
						end
					end
					if card:isKindOf("EquipCard") or card:isKindOf("Peach") or card:isKindOf("Analeptic") then
					use.to:append(effect.from)
					end
					if card:isKindOf("Collateral") or card:getClassName()=="reijyuu"  then
					local dest1=room:askForPlayerChosen(effect.from,targets,"void")
                    use.to:append(dest1)
					local dest2=room:askForPlayerChosen(effect.from,room:getAlivePlayers(),"void")
                    use.to:append(dest2)
					end
					if not card:isKindOf("IronChain") and not card:isKindOf("SavageAssault") and not card:isKindOf("ArcheryAttack") and not card:isKindOf("AmazingGrace") and not card:isKindOf("GodSalvation") and not card:isKindOf("EquipCard") and not card:isKindOf("Collateral") and not card:isKindOf("Peach") and not card:isKindOf("Analeptic") and card:getClassName()~="reijyuu" then
                    local dest=room:askForPlayerChosen(effect.from,targets,"void")
                    use.to:append(dest)
                    end
                room:useCard(use)
				effect.to:gainMark("void")
				if card:isKindOf("Slash") then
				room:addPlayerHistory(effect.from,"Slash",1)
				end
                end
			end
			room:clearAG(effect.from)
			room:setPlayerFlag(effect.from,"void_used")
            end
			if choice=="not_use" then
			room:clearAG(effect.from)
			end
        end
    end
	room:setPlayerFlag(effect.from,"void_used")
end
}

void = sgs.CreateZeroCardViewAsSkill{
    name = "void" ,
    view_as = function()
	local vs_card=voidcard:clone()
	vs_card:setSkillName("void")
        return vs_card
    end ,
    enabled_at_play = function(self, player)
        return not player:hasFlag("void_used")
    end
}

voideffect=sgs.CreateTriggerSkill{
name="#voideffect",
frequency=sgs.Skill_Compulsory,
events={sgs.EventPhaseStart},
on_trigger=function(self,event,player,data)
local room=player:getRoom()
if player:getPhase()==sgs.Player_Finish then
for _,p in sgs.qlist(room:getAlivePlayers()) do
room:drawCards(p,p:getMark("void"))
p:loseAllMarks("void")
end
end
end
}

confession=sgs.CreateTriggerSkill{
name="confession",
frequency=sgs.Skill_limited,
events={sgs.Dying},
on_trigger=function(self,event,player,data)
local room=player:getRoom()
local target_list=sgs.SPlayerList()
local list=room:getAlivePlayers()
local dying=data:toDying()
local splayer=room:findPlayerBySkillName(self:objectName())
local hp=splayer:getHp()
for _,p in sgs.qlist(list) do
if p:getGender()==sgs.General_Female then
target_list:append(p)
end
end
if splayer:getMark("confession")==0 and target_list:length()>0 and dying.who:objectName()==splayer:objectName() then
if room:askForSkillInvoke(splayer,"confession",data) then
room:broadcastSkillInvoke("confession",1)
local dest=room:askForPlayerChosen(splayer,target_list,"confession")
if room:askForSkillInvoke(dest,"confession",data) then
room:broadcastSkillInvoke("confession",2)
room:doLightbox("image=image/animate/confession.png",6000)
local theRecover=sgs.RecoverStruct()
theRecover.recover=2-hp
theRecover.who=splayer
room:recover(splayer,theRecover)
room:loseHp(dest,2-hp)
room:drawCards(dest,2-hp)
splayer:gainMark("@hare",2-hp)
if not splayer:hasSkill("loneliness") then
room:acquireSkill(splayer,"loneliness")
end
end
splayer:gainMark("confession")
end
end
end,
can_trigger = function(self, player)
return true
end
}

loneliness=sgs.CreateTriggerSkill{
name="loneliness",
frequency=sgs.Skill_Notfrequent,
events={sgs.CardUsed,sgs.EventLoseSkill,sgs.EventAcquireSkill},
on_trigger=function(self,event,player,data)
local room=player:getRoom()
if event==sgs.CardUsed then
if player:getMark("@hare")>0 then
if room:askForSkillInvoke(player,"loneliness",data) then
player:loseMark("@hare")
local dest=room:askForPlayerChosen(player,room:getAlivePlayers(),"loneliness")
local choice=room:askForChoice(player,"loneliness","throw_all_handcards+lose_one_maxhp")
if choice=="throw_all_handcards" then
room:broadcastSkillInvoke("loneliness",1)
if not dest:isKongcheng() then
for _,id in sgs.qlist(dest:handCards()) do
room:throwCard(id,dest,dest)
end
end
end
if choice=="lose_one_maxhp" then
room:broadcastSkillInvoke("loneliness",1)
room:loseMaxHp(dest)
end
if player:getMark("@hare")==0 then
room:loseMaxHp(player)
local target=room:askForPlayerChosen(player,room:getAlivePlayers(),"loneliness")
room:broadcastSkillInvoke("loneliness",2)
room:drawCards(target,3)
if target:getGeneralName()=="Inori" then
room:loseMaxHp(target)
room:changeHero(target,"oumamana",false,true,false,true)
room:detachSkillFromPlayer(player,"Ozhiai")
if room:hasAura() and room:getAura()=="voidcard" then
room:clearAura()
end
end
local LuaChanyuan_skills = player:getTag("LuaChanyuanSkills"):toString():split("+")
local skills = player:getVisibleSkillList()
for _, skill in sgs.qlist(skills) do
if skill:objectName() ~= self:objectName() and not skill:inherits("SPConvertSkill") and not skill:isAttachedLordSkill() and not table.contains(LuaChanyuan_skills, skill:objectName()) then
room:addPlayerMark(player, "Loneliness"..skill:objectName())
table.insert(LuaChanyuan_skills, skill:objectName())
local jsonValue = {
  9
}
room:doBroadcastNotify(sgs.CommandType.S_COMMAND_LOG_EVENT, json.encode(jsonValue))
player:setTag("LuaChanyuanSkills", sgs.QVariant(table.concat(LuaChanyuan_skills, "+")))
end
end
end
end
end
end
if event==sgs.EventLoseSkill then
if data:toString() == self:objectName() then
local LuaChanyuan_skills = player:getTag("LuaChanyuanSkills"):toString():split("+")
for _, skill_name in ipairs(LuaChanyuan_skills) do
room:removePlayerMark(player, "Loneliness"..skill_name)
local jsonValue = {
  9
}
room:doBroadcastNotify(sgs.CommandType.S_COMMAND_LOG_EVENT, json.encode(jsonValue))
end

player:setTag("LuaChanyuanSkills", sgs.QVariant())
end
end
if event==sgs.EventAcquireSkill then
if data:toString() ~= self:objectName() and player:getMark("@hare")==0 then
local LuaChanyuan_skills = player:getTag("LuaChanyuanSkills"):toString():split("+")
room:addPlayerMark(player, "Loneliness"..data:toString())
table.insert(LuaChanyuan_skills, data:toString())
local jsonValue = {
  9
}
room:doBroadcastNotify(sgs.CommandType.S_COMMAND_LOG_EVENT, json.encode(jsonValue))
player:setTag("LuaChanyuanSkills", sgs.QVariant(table.concat(LuaChanyuan_skills, "+")))
end
end
end
}

Ozhiaicard=sgs.CreateSkillCard{
name="Ozhiaicard",
target_fixed=false,
will_throw=true,
filter=function(self,targets,to_select)
if #targets==0 then
return to_select:getGeneralName()=="Inori"
end
end,
on_effect=function(self,effect)
local room=effect.from:getRoom()
room:drawCards(effect.to,1)
local victim=room:askForPlayerChosen(effect.from,room:getAlivePlayers(),"Ozhiai")
local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
slash:setSkillName("Ozhiai")
slash:deleteLater()
room:useCard(sgs.CardUseStruct(slash, effect.from, victim))
room:setPlayerFlag(effect.from,"Ozhiai_used")
end
}

Ozhiai=sgs.CreateViewAsSkill{
name="Ozhiai",
n=1,
view_filter=function(self,selected,to_select)
if #selected==0 then
return true
end
end,
view_as=function(self,cards)
if #cards==0 then
return nil
end
local vs_card = Ozhiaicard:clone()
vs_card:addSubcard(cards[1])
vs_card:setSkillName(self:objectName())
return vs_card
end,
enabled_at_play = function(self, player)
        return not player:hasFlag("Ozhiai_used")
    end
}

Ozhiai_tri=sgs.CreateTriggerSkill{
name="#Ozhiai_tri",
frequency=sgs.Skill_Compulsory,
events={sgs.Death},
on_trigger=function(self,event,player,data)
local room=player:getRoom()
local death=data:toDeath()
local splayer=room:findPlayerBySkillName(self:objectName())
if death.who:getGeneralName()=="Inori" then
room:broadcastSkillInvoke(self:objectName())
if splayer:hasSkill("Ozhiai") then
room:detachSkillFromPlayer(splayer,"Ozhiai")
room:acquireSkill(splayer,"shiming")
end
if splayer:hasSkill("void") then
room:detachSkillFromPlayer(splayer,"void")
end
if room:hasAura() and room:getAura()=="voidcard" then
room:clearAura()
end
end
if death.who:getGeneralName()=="oumashu" then
if room:hasAura() and room:getAura()=="voidcard" then
room:clearAura()
end
end
end,
can_trigger = function(self, player)
return player:hasSkill("Ozhiai")
end
}

shiming=sgs.CreateTriggerSkill{
name="shiming",
frequency=sgs.Skill_Compulsory,
events={sgs.CardEffected},
on_trigger=function(self,event,player,data)
local effect=data:toCardEffect()
local room=player:getRoom()
if effect.card:isKindOf("TrickCard") and effect.card:isBlack() and effect.to:hasSkill("shiming") then
return true
end
end,
can_trigger = function(self, player)
return true
end
}


qigecard=sgs.CreateSkillCard{
name="qigecard",
target_fixed=false,
will_throw=true,
filter=function(self,targets,to_select)
return true
end,
on_use=function(self,room,source,targets)
for i=1,#targets,1 do
local theRecover=sgs.RecoverStruct()
theRecover.recover=1
theRecover.who=targets[i]
room:recover(targets[i],theRecover)
end
room:setPlayerFlag(source,"qige_used")
for i=1,16,1 do
room:clearAura()
room:getThread():delay(500)
end
end
}

qige=sgs.CreateViewAsSkill{
name="qige",
n=2,
view_filter=function(self,selected,to_select)
if #selected<2 then
return to_select:isRed()
end
end,
view_as=function(self,cards)
if #cards<2 then
return nil
end
local vs_card = qigecard:clone()
for var = 1, #cards, 1 do
vs_card:addSubcard(cards[var])
end
vs_card:setSkillName(self:objectName())
return vs_card
end,
enabled_at_play = function(self, player)
        return not player:hasFlag("qige_used")
    end
}

Izhiaicard=sgs.CreateSkillCard{
name="Izhiaicard",
target_fixed=false,
will_throw=false,
filter=function(self,targets,to_select)
if #targets==0 then
return to_select:getGeneralName()=="oumashu"
end
end,
on_effect=function(self,effect)
local card=effect.card
local room=effect.from:getRoom()
room:obtainCard(effect.to,card,false)
end
}

Izhiaivs=sgs.CreateViewAsSkill{
name="#Izhiaivs",
n=1,
view_filter=function(self,selected,to_select)
return to_select:isRed() and not to_select:isEquipped()
end,
view_as=function(self,cards)
if #cards==0 then
return nil
end
local vs_card = Izhiaicard:clone()
vs_card:addSubcard(cards[1])
vs_card:setSkillName(self:objectName())
return vs_card
end,
enabled_at_play = function(self, player)
return false
end,
enabled_at_response = function(self, player, pattern)
return pattern == "@@Izhiai"
end
}

Izhiai=sgs.CreateTriggerSkill{
name="Izhiai",
frequency=sgs.Skill_Notfrequent,
events={sgs.TargetConfirming,sgs.CardFinished},
view_as_skill = Izhiaivs,
on_trigger=function(self,event,player,data)
local room=player:getRoom()
local splayer=room:findPlayerBySkillName(self:objectName())
if event==sgs.TargetConfirming then
local use=data:toCardUse()
if splayer:isAlive() and player:getGeneralName()=="oumashu" and use.card:isKindOf("Slash") then
if room:askForSkillInvoke(splayer,"Izhiai",data) then
if room:askForUseCard(splayer, "@@Izhiai", "@Izhiai") then
local jink=sgs.Sanguosha:cloneCard("jink",sgs.Card_NoSuit,0)
jink:setSkillName("Izhiai")
room:provide(jink)
end
end
end
end
if event==sgs.CardFinished then
local use=data:toCardUse()
local card=use.card
if card:getSkillName() =="void" and use.from:getGeneralName()=="oumashu" then
local can=false
for _,p in sgs.qlist(use.to) do
if p:objectName()==splayer:objectName() then
can=true
end
end
if can==true then
room:drawCards(splayer,1)
end
end
end
end,
can_trigger = function(self, player)
return true
end
}

shengmingxian=sgs.CreateTriggerSkill{
name="shengmingxian",
frequency=sgs.Skill_limited,
events={sgs.AskForPeaches},
on_trigger=function(self,event,player,data)
local room=player:getRoom()
local dying=data:toDying()
if dying.who:objectName()~=player:objectName() and player:getMark("shengmingxian")==0 then
if room:askForSkillInvoke(player,"shengmingxian",data) then
for _, card in sgs.qlist(player:getHandcards()) do
room:obtainCard(dying.who,card,false)
end
for _, card in sgs.qlist(player:getEquips()) do
room:obtainCard(dying.who,card,false)
end
room:loseHp(player,player:getHp())
local theRecover=sgs.RecoverStruct()
theRecover.recover=dying.who:getMaxHp()-dying.who:getHp()
theRecover.who=dying.who
room:recover(dying.who,theRecover)
player:gainMark("shengmingxian")
end
end
end
}

tianqi=sgs.CreateViewAsSkill{
name="tianqi",
n=2,
view_filter=function(self,selected,to_select)
if #selected<2 then
return to_select:isBlack()
end
end,
view_as=function(self,cards)
if #cards<2 then
return nil
end
local suit,number

	for _,card in ipairs(cards) do
		if suit and (suit~=card:getSuit()) then suit=sgs.Card_NoSuitBlack else suit=card:getSuit() end
		if number and (number~=card:getNumber()) then number=-1 else number=card:getNumber() end
	end
local vs_card = sgs.Sanguosha:cloneCard("savage_assault",suit,number)
for var = 1, #cards, 1 do
vs_card:addSubcard(cards[var])
end
vs_card:setSkillName(self:objectName())
return vs_card
end,
enabled_at_play = function(self, player)
return not player:hasFlag("tianqi_used")
end
}

tianqi_tri=sgs.CreateTriggerSkill{
name="#tianqi_tri",
frequency=sgs.Skill_Compulsory,
events={sgs.CardUsed},
on_trigger=function(self,event,player,data)
local use=data:toCardUse()
local card=use.card
local room=player:getRoom()
if card:getSkillName()=="tianqi" then
room:setPlayerFlag(player,"tianqi_used")
end
end
}

oqiyuan=sgs.CreateTriggerSkill{
name="oqiyuan",
frequency=sgs.Skill_Compulsory,
events={sgs.CardsMoveOneTime,sgs.EventPhaseEnd},
on_trigger=function(self,event,player,data)
local room=player:getRoom()
local current=room:getCurrent()
local splayer=room:findPlayerBySkillName(self:objectName())
if event==sgs.CardsMoveOneTime then
if current:objectName()~=splayer:objectName() then
if splayer:getHandcardNum()<2 then
room:drawCards(splayer,2-splayer:getHandcardNum())
end
if splayer:getHandcardNum()>2 then
local id=room:askForCardChosen(splayer,splayer,"h","oqiyuan")
room:throwCard(id,player,player)
end
end
end
if event==sgs.EventPhaseEnd and splayer:getPhase()==sgs.Player_Finish then
if splayer:getHandcardNum()<2 then
room:drawCards(splayer,2-splayer:getHandcardNum())
end
if splayer:getHandcardNum()>2 then
local id=room:askForCardChosen(splayer,splayer,"h","oqiyuan")
room:throwCard(id,player,player)
end
end
end
}

shiluocard=sgs.CreateSkillCard{
name="shiluocard",
target_fixed=false,
will_throw=true,
filter=function(self,targets,to_select)
return to_select:objectName()==sgs.Self:objectName()
end,
on_effect=function(self,effect)
local room=effect.from:getRoom()
room:loseHp(effect.from)
for _,p in sgs.qlist(room:getAlivePlayers()) do
local redlist=sgs.IntList()
for _,id in sgs.qlist(p:handCards()) do
local card=sgs.Sanguosha:getCard(id)
if card:isRed() then
redlist:append(id)
end
end
if redlist:length()>0 or p:getEquips():length()>0 then
   local n=p:getEquips():length()
   for _, card in sgs.qlist(redlist) do
   room:throwCard(card,p,p)
   end
   for _, card in sgs.qlist(p:getEquips()) do
   room:throwCard(card,p,p)
   end
end
if redlist:length()==0 and n==0 then
room:loseMaxHp(p)
end
end
effect.from:gainMark("shiluo")
end
}

shiluo=sgs.CreateViewAsSkill{
name="shiluo",
n=2,
view_filter=function(self,selected,to_select)
if #selected<2 then
return not to_select:isEquipped()
end
end,
view_as=function(self,cards)
if #cards<2 then
return nil
end
local vs_card = shiluocard:clone()
for var = 1, #cards, 1 do
vs_card:addSubcard(cards[var])
end
vs_card:setSkillName(self:objectName())
return vs_card
end,
enabled_at_play = function(self, player)
return player:getMark("shiluo")==0
end,
}


lianzhuang=sgs.CreateTriggerSkill{
name="lianzhuang",
frequency=sgs.Skill_Compulsory,
events={sgs.EventPhaseEnd,sgs.DrawNCards,sgs.Death,sgs.EventPhaseChanging},
on_trigger=function(self,event,player,data)
local room=player:getRoom()
if event==sgs.EventPhaseEnd then
if player:getPhase()==sgs.Player_Draw then
local n=room:getAllPlayers(true):length()
if player:getMark("@zhuang")<n then
player:gainMark("@zhuang")
if player:getMark("@zhuang")==1 then
room:broadcastSkillInvoke("lianzhuang",1)
end
if player:getMark("@zhuang")==2 then
room:broadcastSkillInvoke("lianzhuang",2)
end
if player:getMark("@zhuang")==3 then
room:broadcastSkillInvoke("lianzhuang",3)
end
if player:getMark("@zhuang")==4 then
room:broadcastSkillInvoke("lianzhuang",4)
end
if player:getMark("@zhuang")==5 then
room:broadcastSkillInvoke("lianzhuang",5)
end
if player:getMark("@zhuang")==6 then
room:broadcastSkillInvoke("lianzhuang",6)
end
end
end
end
if event==sgs.DrawNCards then
local count = data:toInt() + player:getMark("@zhuang")
data:setValue(count)
end
if event==sgs.Death then
local death=data:toDeath()
if death.damage.from and death.damage.from:objectName()==player:objectName() then
local n=room:getAllPlayers(true):length()
if player:getMark("@zhuang")<n then
player:gainMark("@zhuang")
if player:getMark("@zhuang")==1 then
room:broadcastSkillInvoke("lianzhuang",1)
end
if player:getMark("@zhuang")==2 then
room:broadcastSkillInvoke("lianzhuang",2)
end
if player:getMark("@zhuang")==3 then
room:broadcastSkillInvoke("lianzhuang",3)
end
if player:getMark("@zhuang")==4 then
room:broadcastSkillInvoke("lianzhuang",4)
end
if player:getMark("@zhuang")==5 then
room:broadcastSkillInvoke("lianzhuang",5)
end
if player:getMark("@zhuang")==6 then
room:broadcastSkillInvoke("lianzhuang",6)
end
end
else player:loseAllMarks("@zhuang")
room:broadcastSkillInvoke("lianzhuang",7)
end
end
if event==sgs.EventPhaseChanging then
local change=data:toPhaseChange()
local phase=change.to
if phase==sgs.Player_Judge then
if not player:isSkipped(sgs.Player_Judge) and player:getMark("@zhuang")<2 then
player:skip(phase)
end
end
end
end
}

lianzhuangeffect=sgs.CreateMaxCardsSkill{
name="#lianzhuangeffect",
extra_func=function(self,target)
if target:hasSkill("lianzhuang") then
local n=target:getMark("@zhuang")
return math.min(4,n)
end
end
}

zhaojing=sgs.CreateTriggerSkill{
name="zhaojing",
frequency=sgs.Skill_Compulsory,
events={sgs.GameStart,sgs.CardUsed,sgs.EventPhaseEnd},
on_trigger=function(self,event,player,data)
if event==sgs.GameStart then
local room=player:getRoom()
local splayer=room:findPlayerBySkillName(self:objectName())
if player:objectName()==splayer:objectName() then
room:broadcastSkillInvoke(self:objectName())
splayer:turnOver()
end
end
if event==sgs.CardUsed then
local room=player:getRoom()
local splayer=room:findPlayerBySkillName(self:objectName())
local current=room:getCurrent()
local use=data:toCardUse()
local card=use.card
if current:objectName()==use.from:objectName() and use.from:objectName()~=splayer:objectName() then
if use.from:getMark("zhaojing_num")==0 then
use.from:gainMark("zhaojing_num",card:getNumber())
if card:getSuit()==sgs.Card_Club then
use.from:gainMark("C")
end
if card:getSuit()==sgs.Card_Diamond then
use.from:gainMark("D")
end
if card:getSuit()==sgs.Card_Heart then
use.from:gainMark("H")
end
if card:getSuit()==sgs.Card_Spade then
use.from:gainMark("S")
end
end
end
end
if event==sgs.EventPhaseEnd then
local room=player:getRoom()
local splayer = room:findPlayerBySkillName(self:objectName())
if splayer and player:getPhase() == sgs.Player_Finish then
player:loseAllMarks("zhaojing_num")
player:loseAllMarks("C")
player:loseAllMarks("D")
player:loseAllMarks("H")
player:loseAllMarks("S")
end
end
end,
can_trigger = function(self, player)
return true
end
}

zhaojing2=sgs.CreateProhibitSkill{
name="#zhaojing2",
is_prohibited=function(self,from,to,card)
if to:hasSkill("zhaojing") and from:getMark("C")>0 then
return card:getNumber()==from:getMark("zhaojing_num") or card:getSuit()==sgs.Card_Club
end
if to:hasSkill("zhaojing") and from:getMark("D")>0 then
return card:getNumber()==from:getMark("zhaojing_num") or card:getSuit()==sgs.Card_Diamond
end
if to:hasSkill("zhaojing") and from:getMark("H")>0 then
return card:getNumber()==from:getMark("zhaojing_num") or card:getSuit()==sgs.Card_Heart
end
if to:hasSkill("zhaojing") and from:getMark("S")>0 then
return card:getNumber()==from:getMark("zhaojing_num") or card:getSuit()==sgs.Card_Spade
end
end
}

wlizhi=sgs.CreateTriggerSkill{
name="wlizhi",
frequency=sgs.Skill_Compulsory,
events={sgs.TurnStart,sgs.CardsMoveOneTime,sgs.EventPhaseEnd},
on_trigger=function(self,event,player,data)
local room=player:getRoom()
if event==sgs.TurnStart then
local lizhi=player:getPile("lizhi")
if lizhi:length()==0 and not player:isKongcheng() then
local id=room:askForCardChosen(player,player,"h","wlizhi")
player:addToPile("lizhi",id)
if player:getPile("libao"):length()<4 then
if room:askForSkillInvoke(player,"wlizhi",data) then
local ids = room:getNCards(1, false)
local id1 = ids:at(1)
player:addToPile("libao",id1)
end
end
end
end
if event==sgs.CardsMoveOneTime then
local move = data:toMoveOneTime()
local wlizhicards = player:getTag("wlizhicards"):toString():split("+")
if move.to and move.to:objectName()==player:objectName() and player:getPhase()==sgs.Player_Draw and move.to_place == sgs.Player_PlaceHand and not move.from then
for _,id in sgs.qlist(move.card_ids) do
table.insert(wlizhicards, string.format("%d",id))
room:setCardFlag(id, "wlizhi_prohibit_exception", player)
end
end
player:setTag("wlizhicards", sgs.QVariant(table.concat(wlizhicards, "+")))
end
if event==sgs.EventPhaseEnd then
if player:getPhase()==sgs.Player_Finish then
  for _,id in ipairs(player:getTag("wlizhicards"):toString():split("+")) do
  room:clearCardFlag(id, player)
  end
player:setTag("wlizhicards", sgs.QVariant())
end
end
end
}

wlizhi1=sgs.CreateMaxCardsSkill{
name="#wlizhi1",
extra_func=function(self,target)
local n=0
if target:hasSkill("wlizhi") and target:getPile("lizhi"):length()>0 then
for _,id in sgs.qlist(target:getPile("lizhi")) do
local card=sgs.Sanguosha:getCard(id)
n=card:getNumber()
end
return n
end
end
}

wlizhi2=sgs.CreateProhibitSkill{
name="#wlizhi2",
is_prohibited=function(self,from,to,card)
if from:hasSkill("wlizhi") and from:getPile("lizhi"):length()>0 and from:getPhase()~=sgs.Player_NotActive then
return not card:hasFlag("wlizhi_prohibit_exception")
end
return false
end
}

ganglibao=sgs.CreateTriggerSkill{
name="ganglibao",
frequency=sgs.Skill_Notfrequent,
events={sgs.EventPhaseEnd},
on_trigger=function(self,event,player,data)
local room=player:getRoom()
if player:getPhase()==sgs.Player_Finish and player:getPile("lizhi"):length()>0 and player:getPile("libao"):length()>0 then
if room:askForSkillInvoke(player,"ganglibao",data) then
for _,id in sgs.qlist(player:getPile("lizhi")) do
room:throwCard(id,player)
end
local x=1
for _,id in sgs.qlist(player:getPile("libao")) do
local card=sgs.Sanguosha:getCard(id)
local ok=false
if not player:isKongcheng() then
for _,p in sgs.qlist(player:handCards()) do
local c=sgs.Sanguosha:getCard(p)
if c:getSuit()==card:getSuit() then
ok=true
end
end
end
if ok==true then
x=x+1
end
room:throwCard(id,player)
end
local victim=room:askForPlayerChosen(player,room:getAlivePlayers(),"ganglibao")
local da = sgs.DamageStruct()
da.from = player
da.to = victim
da.damage = x
da.nature = sgs.DamageStruct_Thunder
room:damage(da)
end
end
end
}

Seniorious:addSkill(xingfu)
Seniorious:addSkill(mshengjian)
Seniorious:addSkill(m_qinshi)
Seniorious:addSkill(mshengjian_tri)
extension:insertRelatedSkills("mshengjian", "#mshengjian_tri")
oumashu:addSkill(void)
oumashu:addSkill(confession)
oumashu:addSkill(voideffect)
oumashu:addSkill(Ozhiai)
oumashu:addSkill(Ozhiai_tri)
oumashu:addSkill("#loneliness-inv")
oumashu:addWakeTypeSkillForAudio("loneliness")
oumashu:addWakeTypeSkillForAudio("shiming")
extension:insertRelatedSkills("void", "#voideffect")
extension:insertRelatedSkills("Ozhiai", "#Ozhiai_tri")
Inori:addSkill(qige)
Inori:addSkill(Izhiai)
Inori:addSkill(Izhiaivs)
Inori:addSkill(shengmingxian)
extension:insertRelatedSkills("Izhiai", "#Izhiaivs")
oumamana:addSkill(tianqi)
oumamana:addSkill(tianqi_tri)
oumamana:addSkill(oqiyuan)
oumamana:addSkill(shiluo)
extension:insertRelatedSkills("tianqi", "#tianqi_tri")
MiyanagaTeru:addSkill(lianzhuang)
MiyanagaTeru:addSkill(zhaojing)
MiyanagaTeru:addSkill(zhaojing2)
MiyanagaTeru:addSkill(lianzhuangeffect)
extension:insertRelatedSkills("zhaojing", "#zhaojing2")
extension:insertRelatedSkills("lianzhuang","#lianzhuangeffect")
OohoshiAwai:addSkill(wlizhi)
OohoshiAwai:addSkill(wlizhi1)
OohoshiAwai:addSkill(wlizhi2)
extension:insertRelatedSkills("wlizhi", "#wlizhi1")
extension:insertRelatedSkills("wlizhi", "#wlizhi2")
OohoshiAwai:addSkill(ganglibao)

local Skills = sgs.SkillList()
if not sgs.Sanguosha:getSkill("loneliness") then
Skills:append(loneliness)
end
sgs.Sanguosha:addSkills(Skills)

local Skills = sgs.SkillList()
if not sgs.Sanguosha:getSkill("shiming") then
Skills:append(shiming)
end
sgs.Sanguosha:addSkills(Skills)

sgs.LoadTranslationTable{
["math"]="长夜动漫包",
["Seniorious"]="珂朵莉·诺塔·瑟尼欧里斯",
["&Seniorious"]="珂朵莉",
["#Seniorious"]="黄金妖精",
["@Seniorious"]="末日时在做什么？有没有空？可以来拯救吗？",
["xingfu"]="幸福",
["mshengjian"]="圣剑",
["m_qinshi"]="侵蚀",
[":xingfu"]="当你使用一张红桃牌时，可以摸一张牌或回复一点体力。",
[":mshengjian"]="<font color=\"blue\"><b>锁定技，</b></font>当你装备武器时，你的红色牌皆视为红桃花色。当你失去一张红色装备时，可以摸1+x张牌（x为你损失体力值）。",
[":m_qinshi"]="<font color=\"blue\"><b>锁定技，</b></font>当你使用黑色的【杀】或锦囊时，你减少一点体力，获得1枚“侵蚀”标记；当你造成伤害时，可以弃置一枚“侵蚀”标记，令伤害+1。",
["draw_a_card"]="摸一张牌",
["recover_one_hp"]="回复一点体力",
["@m_qinshi"]="侵蚀",
["$xingfu1"]="不管别人怎么说，都一定是世界上最幸福的女孩。",
["$xingfu2"]="你在说什么呢！",
["$xingfu3"]="因为，喜欢上了嘛。",
["$mshengjian"]="我才不管呢！",
["$m_qinshi"]="再一次，让我回到那个地方。",
["~Seniorious"]="威廉，谢谢你。",
["designer:Seniorious"]="飞鸟&光临长夜",
["cv:Seniorious"]="音田所梓",
["illustrator:Seniorious"]="ue",
["oumashu"]="樱满集",
["&oumashu"]="樱满集",
["#oumashu"]="温柔的王",
["@oumashu"]="罪恶王冠",
["void"]="虚空",
[":void"]="</b></font><font color=\"green\"><b>出牌阶段限一次，</b></font>你可以观看一名角色的手牌并使用其中至多2张牌（以此法使用的锦囊牌，除“桃”，“酒”外的基本牌无目标限制）。回合结束时，该角色摸X张牌。（X为你以此法使用的牌数）",
["Ozhiai"]="挚爱",
[":Ozhiai"]="</b></font><font color=\"green\"><b>出牌阶段限一次，</b></font>当场上存在楪祈的时，你可以弃置一张牌，使其摸一张牌；视为你对一名角色使用一张无视距离的杀。当楪祈死亡时，该技能替换为失明。且你失去技能：虚空。",
["confession"]="告白",
[":confession"]="<font color=\"red\"><b>限定技，</b></font>当你进入濒死时，你可以令一名女性角色可选择让你体力值回复至2点，然后其失去X点体力，并摸X张牌（X为你以此法回复的体力值），然后你获得X枚“祭”标记，获得技能“孤独”。",
["loneliness"]="孤独",
[":loneliness"]="<font color=\"Yellow\"><b>唤醒技，</b></font>你每使用一张牌，可以弃置一枚“祭”，令一个角色弃置所有手牌或失去一点体力上限，当你失去所有“祭”时，你减1体力上限且你其他技能失效，然后令一名角色摸3张牌若你令楪祈摸牌，则楪祈扣除一点体力上限角色更改为真名，你失去技能：挚爱。",
["shiming"]="失明",
[":shiming"]="<font color=\"Yellow\"><b>唤醒技，<font color=\"blue\"><b>锁定技，</b></font>黑色的锦囊对你无效。",
["~oumashu"]="...唉，这样的我行么。",
["not_use"]="不使用",
["Inori"]="楪祈",
["&Inori"]="楪祈",
["#Inori"]="葬仪的歌姬",
["@Inori"]="罪恶王冠",
["qige"]="祈歌",
[":qige"]="</b></font><font color=\"green\"><b>出牌阶段限一次，</b></font>你可以弃置两张红色花色的牌令任意名角色回复一点体力。",
["Izhiai"]="挚爱",
["@Izhiai"]="挚爱",
["~Izhiai"]="选择一张红色手牌交给樱满集",
[":Izhiai"]="当樱满集在场上成为杀的目标时你可以给其一张红色手牌视为樱满集使用一张闪。樱满集对自身使用的虚空结束时摸一张牌。",
["shengmingxian"]="生命「生命线」",
[":shengmingxian"]="<font color=\"red\"><b>限定技，</b></font>当一名其他角色处于濒死状态时可以使用。失去自身所有体力，给予该角色自身手牌，装备区的牌，将该角色的体力回复至其体力上限。",
["oumamana"]="樱满真名",
["&oumamana"]="樱满真名",
["#oumamana"]="天启的夏娃",
["@oumamana"]="罪恶王冠",
["tianqi"]="天启",
[":tianqi"]="</b></font><font color=\"green\"><b>出牌阶段限一次，</b></font>你可以弃置2张黑色牌，当做南蛮入侵使用。",
["oqiyuan"]="起源",
[":oqiyuan"]="<font color=\"blue\"><b>锁定技，</b></font>在你的回合外，你的手牌数量始终为2。",
["shiluo"]="失落",
[":shiluo"]="<font color=\"red\"><b>限定技，</b></font>你弃置两张手牌，扣除一点体力发动。所有玩家依次弃置自己的装备牌和红色手牌，若其没有达成，其失去一点体力上限。",
["@hare"]="祭",
["throw_all_handcards"]="弃置所有手牌",
["lose_one_maxhp"]="失去一点体力上限",
["MiyanagaTeru"]="宫永照",
["&MiyanagaTeru"]="宫永照",
["#MiyanagaTeru"]="真·魔王",
["@MiyanagaTeru"]="天才麻将少女",
["@zhuang"]="庄",
["lianzhuang"]="连庄",
[":lianzhuang"]="<font color=\"blue\"><b>锁定技，</b></font>当你成功执行摸牌阶段后或者杀死一名武将后，获得一个”庄“标记（最多为本局总人数），你的摸牌阶段额外摸”庄“标记数的牌，你手牌上限+”庄“的数量（至多为4）。每当有其他角色不是因为你的击杀死亡，清空你的”庄“标记，若”庄“标记小于2，跳过你的判定阶段。",
["zhaojing"]="照镜",
[":zhaojing"]="<font color=\"blue\"><b>锁定技，</b></font>游戏开始时，你将武将牌翻面，其他角色在自己回合使用的与其此回合使用的第一张牌花色或点数相同的牌无法对你使用。",
["$lianzhuang1"]="点和...1000点。",
["$lianzhuang2"]="点和！1300点。",
["$lianzhuang3"]="自摸！闲家1000，庄家2000。",
["$lianzhuang4"]="宫永照）：点和！（花田煌）：好棒！（宫永照）：7700！",
["$lianzhuang5"]="自摸！每人4100点！",
["$lianzhuang6"]="（一段特技后...）自摸！每人6200点！",
["$lianzhuang7"]="新...新道寺的花田煌，给王者的连庄画上了休止符！",
["$zhaojing"]="（解说）不，根据跟他对战过的雀士所说，更像是能够看透你本质似的，宛如照魔镜一般的东西。",
}
