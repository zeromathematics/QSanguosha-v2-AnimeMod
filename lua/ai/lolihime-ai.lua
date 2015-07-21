sgs.ai_skill_invoke.vector = function(self, data)
	local effect = data:toCardEffect()
	local card = effect.card
	local power = self.player:getHp() * 2 + self.player:getHandcardNum()
	local cardN = self.player:getCards("he"):length()
	local hp = self.player:getHp()
	if card:isKindOf("AOE") then
		if power > 9 or cardN > hp or power < 4 or hp == 1 then
			return true
		end
		return false
	elseif card:isKindOf("Snatch") or card:isKindOf("Dismantlement") or card:isKindOf("Collateral") or card:isKindOf("Duel") then return true
	elseif card:isKindOf("ex_nihilo") then
		self.room:setPlayerFlag(self.player,"vecter_friend")
		if power > 10 then return true end
		return false
	elseif card:isKindOf("Slash") then
		if self:isFriend(effect.from) then return false end
		if #self.enemies == 0 then return false end
		self.room:setPlayerFlag(self.player,"vecter_slash")
		return true
	end
	return false
end

local function doVector(who, self)
	if who:objectName() == self.player:objectName() then return false end
	if not self:isFriend(who) and who:hasSkill("leiji") and (self:hasSuit("spade", true, who) or who:getHandcardNum() >= 3) and (getKnownCard(who, "Jink", true) >= 1 or self:hasEightDiagramEffect(who)) then
		return false
	end

	local cards = self.player:getCards("h")
	cards = sgs.QList2Table(cards)
	self:sortByKeepValue(cards)
	for _, card in ipairs(cards) do
		if not self.player:isCardLimited(card, method) then
			if self:isFriend(who) then
				return false
			else
				return true
			end
		end
	end

	local cards = self.player:getCards("e")
	cards=sgs.QList2Table(cards)
	self:sortByKeepValue(cards)
	for _, card in ipairs(cards) do
		if not self.player:isCardLimited(card, method) then
			return true
		end
	end
	return false
end

sgs.ai_skill_playerchosen.vector = function(self, targets)
	if self.player:hasFlag("vecter_friend") then
		return self:findPlayerToDraw(false, 2)
	elseif self.player:hasFlag("vecter_slash") then
		for _,ememy in ipairs(self.enemies) do
			if doVector(enemy, self) then return enemy end
		end
		for _,ememy in ipairs(self.enemies) do
			return enemy
		end
	else
		return self:findPlayerToDiscard()
	end
end

shouji_skill={}
shouji_skill.name="shouji"
table.insert(sgs.ai_skills,shouji_skill)
shouji_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasUsed("#shoujicard") then return end
	if self.player:getHandcardNum() < self.player:getHp() + 1 then return end
	local cards = self.player:getHandcards()
	local black = 0
	for _,acard in sgs.qlist(cards) do
		if acard:isBlack() then black = black + 1 end
	end
	if black * 3 < self.player:getHandcardNum() and #self.enemies < self.player:getHp() + 1 then return end
	return sgs.Card_Parse("#shoujicard:.:")
end

sgs.ai_skill_use_func["#shoujicard"] = function(card,use,self)
	local needed = {}
	local cards = sgs.QList2Table(self.player:getHandcards())
	for _,acard in ipairs(cards) do
		if acard:isBlack() then
			table.insert(needed, acard:getEffectiveId())
			if #needed > self.player:getHp() then
				break
			end
		end
	end
	if #needed < self.player:getHp() + 1 then
		for _,acard in ipairs(cards) do
			if acard:isRed() then
				table.insert(needed, acard:getEffectiveId())
				if #needed > self.player:getHp() then
					break
				end
			end
		end
	end
	use.card = sgs.Card_Parse("#shoujicard:"..table.concat(needed,"+")..":")
	return
end

sgs.ai_use_value["shoujicard"] = 8
sgs.ai_use_priority["shoujicard"]  = 5

sgs.ai_skill_choice["LLJ_reality"] = function(self, choices, data)
	if self.player:getHandcardNum() > self.player:getHp() + 3 then return "zhuangbei12" end
	return "jinang12"
end

sgs.ai_skill_invoke.SE_Xinyuan = function(self, data)
	if #self.friends <= 1 then return false end
	return true
end

sgs.ai_skill_playerchosen.SE_Xinyuan = function(self, targets)
	return self:findPlayerToDraw(false, self.player:getMark("xinyuan_dis"))
end

local function tabcontain(a,b)
	flag=false
	for _, c in ipairs(a) do
		if b==c then
			flag=true
		end
	end
	return flag
end

sgs.ai_skill_invoke.dandiao = function(self, data)
	local room = self.room
	local player = self.player
	local condition = {}
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
	local Ah = math.max(spade,heart,club,diamond)
	if spade==Ah then table.insert(condition,"spade")end
	if heart==Ah then table.insert(condition,"heart") end
	if club==Ah then table.insert(condition,"club") end
	if diamond==Ah then table.insert(condition,"diamond") end
	
	spade=0
	heart=0
	club=0
	diamond=0
	for _, card in sgs.qlist(player:getHandcards()) do
		if card:getSuit()==sgs.Card_Spade then  spade=spade+1 end
		if card:getSuit()==sgs.Card_Heart then  heart=heart+1 end
		if card:getSuit()==sgs.Card_Club then  club=club+1 end
		if card:getSuit()==sgs.Card_Diamond then  diamond=diamond+1 end
	end
	if spade == 0 then spade = 1000 end
	if heart == 0 then heart = 1000 end
	if club == 0 then club = 1000 end
	if diamond == 0 then diamond = 1000 end
	local Ah = math.min(spade,heart,club,diamond)
	if Ah ~= 1 then return end
	if spade>Ah and tabcontain(condition, "spade") then table.remove(condition,1)end
	if heart>Ah and tabcontain(condition, "heart") then table.remove(condition,1) end
	if club>Ah and tabcontain(condition, "club") then table.remove(condition,1) end
	if diamond>Ah and tabcontain(condition, "diamond") then table.remove(condition,1) end
	if #condition > 0 then return true end
	return false
end

sgs.ai_skill_playerchosen.dandiao = function(self, targets)
	local target
	if #self.enemies > 0 then
		for _,enemy in ipairs(self.enemies) do
			if enemy:isAlive() and sgs.isGoodTarget(enemy) and self:isWeak(enemy) and self:damageIsEffective(enemy, sgs.DamageStruct_Thunder, self.player) and not enemy:hasArmorEffect("SilverLion") then
				return enemy
			end
		end
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy:isAlive() then
			return enemy
		end
	end
	for _,p in sgs.qlist(self.room:getAlivePlayers()) do
		if not self:isFriend(p) then
			return p
		end
	end
end

sgs.ai_skill_choice["eastfast"] = function(self, choices, data)
	local card = sgs.Sanguosha:getCard(self.player:getMark("eastfast_card"))
	local room = self.room
	local num = room:getDrawPile():length()-(3*room:getDiscardPile():length())
	num = num/6

	if self.player:getCards("j"):length() > 0 then
		local i = 1
		for _,c in sgs.qlist(self.player:getCards("j")) do
			if self.player:getPile("save"):length() == 2 + self.player:getCards("j"):length() - i then
				if c:isKindOf("Indulgence") then
					if card:getSuit() == sgs.Card_Heart then return "save" end
					return "drop"
				elseif c:isKindOf("SupplyShortage") then
					if card:getSuit() == sgs.Card_Club then return "save" end
					return "drop"
				elseif c:isKindOf("Lightning") then
					if card:getSuit() == sgs.Card_Spade then return "drop" end
				end
			end
			i = i + 1
		end
	end

	if card:isKindOf("tacos") then return "save" end
	if self:getUseValue(card) > 5 then return "save" end
	if num > room:getAlivePlayers():length() * 3 and self:getUseValue(card) > 4.5 then return "save" end
	if num > 2 and self:getUseValue(card) >= 5 then return "save" end
	return "drop"
end

function sgs.ai_cardneed.eastfast(to, card, self)
	return card:isKindOf("tacos")
end

