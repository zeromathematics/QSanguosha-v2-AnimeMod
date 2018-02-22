--枪兵
sgs.ai_skill_invoke.bimie = function(self, data)
	local damage = data:toDamage()
	local target = damage.to
	if self:isEnemy(target) then
		return true
	end
	return false
end

--钢铁
sgs.ai_skill_invoke.gangqu = function(self, data)
	for _,card in sgs.qlist(self.player:getHandcards()) do
		if card:isKindOf("BasicCard") or card:isKindOf("TrickCard") then
			return true
		end
	end
	return false
end

sgs.ai_skill_invoke.gangquPrevent = function(self, data)
	local effect = data:toCardEffect()
	return not (effect.card:isKindOf("Peach") or effect.card:isKindOf("AmazingGrace") or effect.card:isKindOf("KeyTrick") or effect.card:isKindOf("GodSalvation") or (effect.card:isKindOf("MapoTofu") and effect.from and self:isFriend(effect.from)))
end

sgs.ai_skill_cardchosen.gangqu = function(self, who, flags)
	local cards = self.player:getCards("h")
	cards=sgs.QList2Table(cards)
	self:sortByUseValue(cards,true)
	for _,card in ipairs(cards) do
		if card:isKindOf("BasicCard") then
			return card
		end
		if card:isKindOf("TrickCard") then
			return card
		end
	end
	return cards[1]
end


tiaojiao_skill={}
tiaojiao_skill.name="tiaojiao"
table.insert(sgs.ai_skills,tiaojiao_skill)
tiaojiao_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasUsed("TiaojiaoCard") then return end
	for _,friend in ipairs(self.friends) do
		if friend:getJudgingArea():length() > 0 then
			return sgs.Card_Parse("@TiaojiaoCard=.")
		end
	end
	if #self.enemies < 1 then return end
	if #self.enemies == 1 and self.enemies[1]:isNude() then return end
	return sgs.Card_Parse("@TiaojiaoCard=.")
end

sgs.ai_skill_use_func.TiaojiaoCard = function(card,use,self)
	local target
	local source = self.player
	for _,enemy in ipairs(self.enemies) do
		if not enemy:isNude() then
			target = enemy
		end
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy:getHp() == 2 and not enemy:isNude() then
			target = enemy
		end
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy:getHp() == 1 and not enemy:isNude() then
			target = enemy
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:getJudgingArea():length() > 0 then
			target = friend
		end
	end
	if target then
		use.card = sgs.Card_Parse("@TiaojiaoCard=.")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value.TiaojiaoCard = 8
sgs.ai_use_priority.TiaojiaoCard  = 10
sgs.ai_card_intention.TiaojiaoCard = 30


sgs.ai_skill_playerchosen.tiaojiao = function(self, targets)
	local target
	if #self.enemies > 0 then
		local cards = 0
		for _,enemy in ipairs(self.enemies) do
			if enemy:isAlive() then
				target = enemy
			end
		end
		for _,enemy in ipairs(self.enemies) do
			if enemy:isAlive() and enemy:getHandcardNum() == 1 then
				target = enemy
			end
		end
		if target then return target end
	end
end

--女王
sgs.ai_view_as.yaojing = function(card, player, card_place)
	if not player:hasFlag("Yaojing_Active") then return end
	local suit = card:getSuitString()
	local number = card:getNumberString()
	local card_id =card:getEffectiveId()
	return ("god_salvation:yaojing[%s:%s]=%d"):format(suit, number, card_id)
end

sgs.ai_skill_invoke.yaojing = function(self, data)
	return true
end

sgs.ai_use_value.yaojing = 9
sgs.ai_use_priority.yaojing  = 6

sgs.ai_skill_choice.gongming = function(self, choices, data)
	local selfplayer=self.room:findPlayerBySkillName("gongming")
	if not selfplayer then return end
	if self:isFriend(selfplayer) and self.player:getHandcardNum() < 6 then return "hedraws" end
	return  "youdraw"
end
