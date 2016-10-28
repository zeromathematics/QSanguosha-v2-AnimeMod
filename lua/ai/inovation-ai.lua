sgs.ai_skill_invoke.huanxing = function(self, data)
	local use = data:toCardUse()
	if not use or not use.from then return false end
	if self:isEnemy(use.from) then return true end
	return false
end

sgs.ai_skill_invoke.fushang = function(self, data)
	local damage = data:toDamage()
	if not damage or not damage.to then return false end
	if self:isFriend(damage.to) then
		local num = damage.to:getMark("@fushang")
		local last = damage.to:getMark("@fushang_time")
		if last == 1 then
			if self:isWeak(damage.to) and self:getCardsNum("Peach") == 0 then return false end
			if num >= damage.to:getLostHp() - 1 then return false end
			return true
		else
			return true
		end
	end
	return false
end

--skill guangyu
sgs.ai_skill_use["@@guangyu"] = function(self)
	local ids = self.player:property("guangyu"):toString():split("+")
	for _, id in ipairs(ids) do
		local card = sgs.Sanguosha:getCard(id)
		if self.player:isCardLimited(card, sgs.Card_MethodUse) then continue end
		local card_str = ("key_trick:guangyu[%s:%s]=%d"):format(card:getSuitString(), card:getNumberString(), id)
		local ss = sgs.Card_Parse(card_str)
		local dummy_use = { isDummy = true , to = sgs.SPlayerList() }
		self:useCardKeyTrick(ss, dummy_use)
		if dummy_use.card and not dummy_use.to:isEmpty() then
			return card_str .. "->" .. dummy_use.to:first():objectName()
		end
	end
	return "."
end
sgs.ai_skill_invoke.guangyu = function(self, data)
	if self:isFriend(self.room:getCurrent()) then return true end
	return false
end

--skill xiyuan
sgs.ai_skill_invoke.xiyuan = function(self, data)
	if #self.friends_noself == 0 then return false end
	return true
end

sgs.ai_skill_playerchosen.xiyuan = function(self, targets)
	for _,p in ipairs(self.friends_noself) do
		if not p:getGeneral2() and self:isWeak(p) then return p end
		if p:hasSkill("se_diangong") then return p end
	end
	return self.friends_noself[1]
end

--skill dingxin
sgs.ai_skill_choice["dingxin"] = function(self, choices, data)
	if self:getCardsNum("Peach") == 0 then return "dingxin_recover" end
	for _,p in sgs.qlist(room:getPlayers()) do
		if (p:getGeneralName() == "Nagisa" or p:getGeneral2Name() == "Nagisa") and (self.player:getRole() == p:getRole() or (self.player:getRole() == "lord" and p:getRole() == "loyalist")) then return "dingxin_revive" end
	end
	return "dingxin_recover"
end



--麻婆豆腐
function SmartAI:useCardMapoTofu(card, use) --need help 这个锦囊太复杂了。。。。。
	local targets = {}
	for _,p in sgs.qlist(self.room:getAlivePlayers()) do
		if self.player:distanceTo(p) <= 1 then table.insert(targets, p) end
	end
	if #targets == 0 then return end
	local f_target
	for _,target in ipairs(targets) do
		if self:isFriend(target) then
			if target:hasSkills(sgs.masochism_by_self_skill) then f_target = target end
			if target:hasSkills("Tianhuo") and target:getLostHp() > 0 then return target end
			local touma = self.room:findPlayerBySkillName("Huansha")
			local shirayuki = self.room:findPlayerBySkillName("SE_Zhandan")
			if ((touma and self:isFriend(touma)) or (shirayuki and self:isFriend(shirayuki))) and target:getLostHp() > 0 then return target end
		else
			if self.player:hasSkills(sgs.weak_killer_skill) and target:getLostHp() == 0 then f_target = target end
		end
	end
	if not f_target then
		for _,target in ipairs(targets) do
			if self:isFriend(target) and target:getLostHp() > 0 then
				f_target = target
			end
		end
	end
	if self.player:hasSkill("se_shouren") then
		for _,target in ipairs(targets) do
			if self:isEnemy(target) then
				f_target = target
			end
		end
	end
	if f_target then
		for _,v in ipairs(self.enemies) do
			if v:objectName() ~= f_target:objectName() then
				use.card = card
				if use.to and not (self.room:isProhibited(self.player, v, card) or self.room:isAkarin(self.player, v)) then use.to:append(v) end
				return
			end
		end
	end
end
sgs.ai_use_priority.MapoTofu = 10
sgs.ai_use_value.MapoTofu = 8
sgs.ai_keep_value.MapoTofu = 1.0
sgs.ai_card_intention.MapoTofu = 0

--KEY

function SmartAI:useCardKeyTrick(card, use)
	for _,v in ipairs(self.friends) do
		if v:getLostHp() > 0 and not v:containsTrick("key_trick") and not (self.room:isProhibited(self.player, v, card) or self.room:isAkarin(self.player, v)) then
			use.card = card
			if use.to then use.to:append(v) end
			return
		end
	end
	for _,v in ipairs(self.friends) do
		if not v:containsTrick("key_trick") and not (self.room:isProhibited(self.player, v, card) or self.room:isAkarin(self.player, v)) then
			use.card = card
			if use.to then use.to:append(v) end
			return
		end
	end
end
sgs.ai_use_priority.KeyTrick = 3
sgs.ai_use_value.KeyTrick = 2
sgs.ai_keep_value.KeyTrick = 2
sgs.ai_card_intention.KeyTrick = -50

--shengjian_black
sgs.ai_skill_playerchosen.shengjian_black = function(self, targets)
	local source = self.player
	local power = 0
	for _,enemy in ipairs(self.enemies) do
		local force = math.abs(source:getEquips():length() - enemy:getEquips():length()) + (enemy:getEquips():length())/2
		if force > power then
			target = enemy
			power = force
		end
	end
	return target
end
	

--冈崎朋也
se_zhuren_skill={}
se_zhuren_skill.name="zhuren"
table.insert(sgs.ai_skills,se_zhuren_skill)
se_zhuren_skill.getTurnUseCard=function(self,inclusive)
	if #self.friends <= 1 then return end
	local source = self.player
	if source:isKongcheng() then return end
	if source:hasUsed("ZhurenCard") then return end
	return sgs.Card_Parse("@ZhurenCard=.")
end

sgs.ai_skill_use_func.ZhurenCard = function(card,use,self)
	local target
	local source = self.player
	local max_num = source:getMaxHp() - source:getHp() + 1
	local max_x = 0
	for _,friend in ipairs(self.friends) do
		local x = 5 - friend:getHandcardNum()

		if x > max_x and friend:objectName() ~= source:objectName() then
			max_x = x
			target = friend
		end
	end
	local cards=sgs.QList2Table(self.player:getHandcards())
	local needed = {}
	for _,acard in ipairs(cards) do
		if #needed < max_num then
			table.insert(needed, acard:getEffectiveId())
		end
	end
	if target and needed then
		use.card = sgs.Card_Parse("@ZhurenCard="..table.concat(needed,"+"))
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value.ZhurenCard = 4
sgs.ai_use_priority.ZhurenCard  = 2.4
sgs.ai_card_intention.ZhurenCard  = -60

sgs.ai_skill_invoke.zhuren = function(self, data)
	return true
end

sgs.ai_skill_choice.Daolu = function(self, data)
	local lord = self.room:getLord()
	if self.player:getRole() == "lord" then
		for _,friend in ipairs(self.friends) do
			if self:isWeak(friend) and friend:objectName() ~= self.player:objectName() then
				return "Fuko_summoner"
			end
		end
		return "Nagisa_Protector"
	elseif self.player:getRole() == "loyalist" then
		return "Tomoyo_Couple"
	elseif self.player:getRole() == "rebel" then
		for _,friend in ipairs(self.friends) do
			if self:isWeak(friend) and self.player:getHp() > 2 and friend:objectName() ~= self.player:objectName() then
				if #self.friends > #self.enemies then
					return "Fuko_summoner"
				end
			end
			--TODO
		end
		return "Nagisa_Protector"
	elseif self.player:getRole() == "renegade" then
		if lord:getHp() <= 2 then
			return "Fuko_summoner"
		end
		return "Nagisa_Protector"
	end
end

sgs.ai_skill_playerchosen.Daolu = function(self, targets)
	local lord = self.room:getLord()
	if self.player:getRole() == "loyalist" then return lord end
	if self.player:getRole() == "rebel" then
		for _,friend in ipairs(self.friends) do
			if not friend:objectName()~=self.player:objectName() and self:isWeak(friend) and self.player:getHp() > 2 then
				target = friend
			end
		end
	end
	if target then return target end
	for _,friend in ipairs(self.friends) do
		if not friend:objectName()~=self.player:objectName() then
			target = friend
		end
	end
	return target
end

sgs.ai_playerchosen_intention.Daolu = function(from, to)
	local intention = -100
	sgs.updateIntention(from, to, intention)
end

local se_diangong_skill={}
se_diangong_skill.name="diangong"
table.insert(sgs.ai_skills,se_diangong_skill)
se_diangong_skill.getTurnUseCard=function(self,inclusive)
	local cards = sgs.QList2Table(self.player:getHandcards()) 
	self:sortByUseValue(cards,true)  
	for _,enemy in ipairs(self.enemies) do
		if enemy:hasSkills("se_qidian|suipian|guangyu") then return end
	end
	for _,acard in ipairs(cards) do
		if self:getKeepValue(acard)<5 and acard:isBlack() then    
			local number = acard:getNumberString()
			local card_id = acard:getEffectiveId()
			local suit = acard:getSuitString()
			return sgs.Card_Parse("@DiangongCard=.")
		end
	end
end

sgs.ai_skill_use_func.DiangongCard = function(card,use,self)
	local target
	for _,enemy in sgs.qlist(self.room:getAlivePlayers()) do
		local pl = true
		for _,card in sgs.qlist(enemy:getJudgingArea()) do
			if card:isKindOf("Lightning") then
				pl = false
			end
		end
		if pl then
			target = enemy
		end
	end
	local needed
	local cards = sgs.QList2Table(self.player:getHandcards()) 
	for _,acard in ipairs(cards) do
		if self:getKeepValue(acard)<5 and acard:isBlack() then    
			needed = acard
		end
	end
	if target and needed then
		use.card = sgs.Card_Parse("@DiangongCard="..needed:getEffectiveId())
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_skill_invoke.huanxing = function(self, data)
	local use = data:toCardUse()
	if not use or not use.from then return false end
	if self:isEnemy(use.from) then return true end
	return false
end

sgs.ai_use_value.DiangongCard = 8
sgs.ai_use_priority.DiangongCard = 2.5


sgs.ai_skill_invoke.haixing = function(self, data)
	local dying_data = data:toDying()
	local source = dying_data.who
	if self:isFriend(source) then
		return true
	end
	return false
end

sgs.ai_skill_invoke.tanyan = function(self, data)
	return self:isFriend(self.room:getCurrent())
end

--枣铃
sgs.ai_need_damaged.SE_Maoqun = function (self, attacker)
	return self.player:getHp()>10
end

sgs.SE_Maoqun_keep_value = 
{
    Peach 		= 9,
    Analeptic 	= 8,
    Jink 		= 9,
}



se_zhiling_skill={}
se_zhiling_skill.name="zhiling"
table.insert(sgs.ai_skills,se_zhiling_skill)
se_zhiling_skill.getTurnUseCard=function(self,inclusive)
	if #self.enemies == 0 then return end
	if self.player:getPile("Neko"):length() == 0 then return end
	local can = false
	for _,enemy in ipairs(self.enemies) do
		if (enemy:getMark("@Neko_S") == 0 or enemy:getMark("@Neko_C") == 0 or (enemy:getMark("@Neko_D") == 0 and not enemy:hasSkill("Huansha")) or enemy:getMark("@Neko_H") == 0) and not enemy:hasFlag("Can_not") then
			can = true
		end
	end
	if self.player:getRole() =="renegade" then
		if #self.enemies - #self.friends <= 0 then
			can = false
		end
		if  self.player:getPile("Neko"):length() <=8 and #self.enemies - #self.friends <= 1 then
			can = false
		end
		if  self.player:getPile("Neko"):length() <=3 and #self.enemies - #self.friends <= 2 then
			can = false
		end
	end
	if not can then return end
	return sgs.Card_Parse("@ZhilingCard=.")
end

sgs.ai_skill_use_func.ZhilingCard = function(card,use,self)
	local target
	local lord = self.room:getLord()
	for _,enemy in ipairs(self.enemies) do
		if (enemy:getMark("@Neko_S") == 0 or enemy:getMark("@Neko_C") == 0 or (enemy:getMark("@Neko_D") == 0 and not enemy:hasSkill("Huansha")) or enemy:getMark("@Neko_H") == 0) and not enemy:hasFlag("Can_not") then
			target = enemy
		end
	end
	if self.player:getRole() =="rebel" then
		if (lord:getMark("@Neko_S") == 0 or lord:getMark("@Neko_C") == 0 or (lord:getMark("@Neko_D") == 0 and not lord:hasSkill("Huansha")) or lord:getMark("@Neko_H") == 0) and not lord:hasFlag("Can_not") then
			target = lord
		end
	end
	if target then
		use.card = sgs.Card_Parse("@ZhilingCard=.")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value.ZhilingCard = 9
sgs.ai_use_priority.ZhilingCard = 9.8
sgs.ai_card_intention.ZhilingCard  = 50

sgs.ai_skill_invoke.SE_Zhixing = function(self, data)
	local source = data:toPlayer()
	if self:isFriend(source) then return true end
	return false
end

sgs.ai_skill_playerchosen.SE_Zhixing = function(self, data)
for _,p in ipairs(self.friends) do
		if p:getJudgingArea():length() > 0 then
			return p
		end
	end
	for _,p in ipairs(self.enemies) do
		if p:getEquips():length() > 0 then
			return p
		end
	end
	for _,p in ipairs(self.enemies) do
		if not p:isNude() then
			return p
		end
	end
	return self.enemies[1]
end

--藤林杏
sgs.ai_view_as.touzhi = function(card, player, card_place)
	local suit = card:getSuitString()
	local number = card:getNumberString()
	local card_id = card:getEffectiveId()
	if card:isKindOf("TrickCard") and not card:isKindOf("AOE") and not card:isKindOf("GodSalvation") and not card:isKindOf("AmazingGrace")  and not card:isKindOf("Collateral") then
		return ("slash:touzhi[%s:%s]=%d"):format(suit, number, card_id)
	end
end

touzhi_skill={}
touzhi_skill.name="touzhi"
table.insert(sgs.ai_skills,touzhi_skill)
touzhi_skill.getTurnUseCard=function(self,inclusive)
	if #self.enemies < 1 then return end
	local cardToUse
	for _,card in sgs.qlist(self.player:getHandcards()) do 
		if card:isKindOf("TrickCard") and not card:isKindOf("AOE") and not card:isKindOf("GodSalvation") and not card:isKindOf("AmazingGrace")  and not card:isKindOf("Collateral") then
			cardToUse = card
		end
	end
	if not cardToUse then
		return
	end
	local suit = cardToUse:getSuitString()
	local number = cardToUse:getNumberString()
	local card_id = cardToUse:getEffectiveId()
	local card_str = ("slash:touzhi[%s:%s]=%d"):format(suit, number, card_id)
	return sgs.Card_Parse(card_str)
end

sgs.ai_use_priority_slash_remake["touzhi"] = 8

sgs.ai_skill_use["@@youjiao"] = function(self, prompt, method)
	local cardToUse
	for _,card in sgs.qlist(self.player:getHandcards()) do 
		if card:isKindOf("BasicCard") and not card:isKindOf("Peach") then
			cardToUse = card
		end
	end
	if cardToUse then
		local suit = cardToUse:getSuitString()
		local number = cardToUse:getNumberString()
		local card_id = cardToUse:getEffectiveId()
		local card_str = ("key_trick:youjiao[%s:%s]=%d"):format(suit, number, card_id)
		local ss = sgs.Card_Parse(card_str)
		local dummy_use = { isDummy = true , to = sgs.SPlayerList() }
		self:useCardKeyTrick(ss, dummy_use)
		if dummy_use.card and not dummy_use.to:isEmpty() then
			return card_str .. "->" .. dummy_use.to:first():objectName()
		end
	end
end

--间宫明里
sgs.ai_skill_invoke.Takamakuri = function(self, data)
	local damage = data:toDamage()
	if not damage or not damage.to then return false end
	if self:isEnemy(damage.to) and not damage.to:hasSkills(sgs.lose_equip_skill) then return true end
	return false
end

sgs.ai_skill_invoke.Tobiugachi = function(self, data)
	if self:isFriend(self.room:getCurrent()) then
		if self.player:getHandcardNum() - self.player:getHp() + 1 <= 3 and (self:isWeak() or self:getCardsNum("Jink") == 0) then return true end
		return false
	end
	if self.player:getHandcardNum() - self.player:getHp() + 1 <= 5 then return true end
	return false
end

sgs.ai_skill_playerchosen.Tobiugachi = function(self, targets)
	local target = self:findPlayerToDiscard()
	if target then return target end
	return self.enemies[0]
end


sgs.ai_skill_invoke.FukurouzaTobi = function(self, data)
	if self:isEnemy(self.room:getCurrent()) and not self.room:getCurrent():hasSkills(sgs.immune_skill) then return true end
	return false
end

sgs.ai_skill_invoke.FukurouzaTaka = true

--天江衣
sgs.ai_skill_invoke.kongdi = function(self, data)
	local move = data:toMoveOneTime()
	if move.to and not self:isFriend(move.to) then return true end
	return false
end

--加贺
sgs.ai_skill_invoke.weishi = function(self, data)
	local targets = {}
	if self:isWeak() and self.player:getHandcardNum() < self.player:getHp() then return false end
	for _,p in sgs.qlist(room:getOtherPlayers(self.player)) do
		if p:getPileNames():length() > 0 and self:isFriend(p) then
			table.insert(targets, p)
		end
	end
	if #targets > 0 then return true end
	if #self.enemies > self.player:getPile("Kansaiki"):length() then return true end
	return false
end