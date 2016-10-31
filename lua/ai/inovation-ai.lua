
function getMostWeakEnemyToDamage(self, targets, nature)
	local min = 100
	local target
	if not nature then nature = sgs.DamageStruct_Normal end
	for _,p in sgs.qlist(targets) do
		if self:isEnemy(p) and self:damageIsEffective(p, nature) and p:getHp() * 2 + p:getHandcardNum() < min then
			target = p
			min =  p:getHp() * 2 + p:getHandcardNum()
		end
	end
	return target
end

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
		if not self.player:isCardLimited(card, sgs.Card_MethodUse) then
			local card_str = ("key_trick:guangyu[%s:%s]=%d"):format(card:getSuitString(), card:getNumberString(), id)
			local ss = sgs.Card_Parse(card_str)
			local dummy_use = { isDummy = true , to = sgs.SPlayerList() }
			self:useCardKeyTrick(ss, dummy_use)
			if dummy_use.card and not dummy_use.to:isEmpty() then
				return card_str .. "->" .. dummy_use.to:first():objectName()
			end
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
	for _,p in sgs.qlist(self.room:getPlayers()) do
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
	return self.enemies[1]
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
	if self:isWeak() then return true end
	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
		if #p:getPileNames() > 0 and self:isFriend(p) then
			table.insert(targets, p)
		end
	end
	if #targets > 0 then return true end
	if self.player:getHandcardNum() > self.player:getHp() - 1 then return true end
	if #self.enemies > self.player:getPile("Kansaiki"):length() then return true end
	return false
end

sgs.ai_skill_playerchosen.weishi = function(self, targets)
	if #self.enemies > self.player:getPile("Kansaiki"):length() then return self.player end
	-- todo, now return random fuck
end

hongzha_skill={}
hongzha_skill.name="hongzha"
table.insert(sgs.ai_skills,hongzha_skill)
hongzha_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasUsed("HongzhaCard") then return end
	if #self.enemies == 0 then return end
	if self.player:getPile("Kansaiki"):length() == 0 then return end
	
	--是否发动？
	if self.player:isKongcheng() then return end
	if self.player:getHandcardNum() == 1 then
		if self:getCardsNum("Jink") == 1 or self:getCardsNum("Peach") == 1 then return end
	end

	for _,target in ipairs(self.enemies) do
		if self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), target)  then
			return sgs.Card_Parse("@HongzhaCard=.")
		end
	end
end

sgs.ai_skill_use_func.HongzhaCard = function(card,use,self)
	local targets = sgs.SPlayerList()
	for _,enemy in ipairs(self.enemies) do
		if targets:length() < self.player:getPile("Kansaiki"):length() and not enemy:hasArmorEffect("vine") and self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), enemy) then
			targets:append(enemy)
		end
	end
	local cards = sgs.QList2Table(self.player:getCards("he"))
	self:sortByKeepValue(cards)

	if targets:length() > 0 and #cards > 0 then
		use.card = sgs.Card_Parse("@HongzhaCard="..cards[1]:getEffectiveId())
		 use.to = targets
		return
	end
end

sgs.ai_use_value["HongzhaCard"] = 4
sgs.ai_use_priority["HongzhaCard"]  = 0
sgs.ai_card_intention["HongzhaCard"] = 100

--早季
sgs.ai_skill_invoke.kuisi = function(self, data)
	local death = data:toDeath()
	if self:isEnemy(death.damage.from) then return true end
	return false
end

sgs.ai_skill_invoke.youer = function(self, data)
	local dying = data:toDying()
	if self:isEnemy(dying.damage.from) then
		if self:getCardsNum("Peach") > 0 or self:getCardsNum("Analeptic") > 0 then
			return false
		end
		return true
	end
	return false
end

--大傻
nuequ_skill={}
nuequ_skill.name="nuequ"
table.insert(sgs.ai_skills,nuequ_skill)
nuequ_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasUsed("NuequCard") then return end
	local targets = {}
	local min = 100
	for _,p in sgs.qlist(self.room:getAlivePlayers()) do
		if p:getHp() < min then
			targets = {}
			min = p:getHp()
		end
		if p:getHp() <= min then table.insert(targets, p) end
	end
	if min == 0 then
		if #targets == 1 and targets[1]:hasSkill("lingti") then return end
	end
	return sgs.Card_Parse("@NuequCard=.")
end

sgs.ai_skill_use_func.NuequCard = function(card,use,self)
	local target
	
	local targets = {}
	local min = 100
	for _,p in sgs.qlist(self.room:getAlivePlayers()) do
		if p:getHp() < min then
			targets = {}
			min = p:getHp()
		end
		if p:getHp() <= min then table.insert(targets, p) end
	end

	for _, t in ipairs(targets) do
		if self:isEnemy(t) and t:getHandcardNum() == 0 then
			target = t
		end
	end

	if not target then
		for _, t in ipairs(targets) do
			if self:isFriend(t) and t:getHp() <= 1 then
				target = t
			end
		end
	end

	if not target then
		for _, t in ipairs(targets) do
			if self:isEnemy(t) and t:getHandcardNum() <= 1 then
				target = t
			end
		end
	end

	if not target then target = targets[1] end

	local cards = sgs.QList2Table(self.player:getCards("he"))
	self:sortByKeepValue(cards)

	if target and #cards > 0 then
		use.card = sgs.Card_Parse("@NuequCard="..cards[1]:getEffectiveId())
		 if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["NuequCard"] = 5
sgs.ai_use_priority["NuequCard"]  = 0
sgs.ai_card_intention.NuequCard = function(self, card, from, tos)
	for _, to in ipairs(tos) do
		if self:isFriend(to) then return -80 end
	end
	return 100
end

sgs.ai_skill_choice["BurningLove"] = function(self, choices, data)
	local damage = data:toDamage()
	if self:isFriend(damage.to) then return "BLRecover" end
	return "BLDamage"
end


--瑞鹤
eryu_skill={}
eryu_skill.name="eryu"
table.insert(sgs.ai_skills,eryu_skill)
eryu_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasUsed("EryuCard") then return end
	if self.player:getMark("@EryuMark") == 1 then return end
	local targets = {}
	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
		if self:isFriend(p) and not p:isMale() then return sgs.Card_Parse("@EryuCard=.") end
	end
end

sgs.ai_skill_use_func.EryuCard = function(card,use,self)
	local target
	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
		if self:isFriend(p) and not p:isMale() then
			if not target then
				target = p
			else
				if target:getHp() < p:getHp() then
					target = p
				end
			end
			if p:hasSkills(sgs.cardneed_skill) and p:getHp() > 2 then
				target = p
				break
			end
		end
	end


	if target then
		use.card = sgs.Card_Parse("@EryuCard=.")
		 if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["EryuCard"] = 10
sgs.ai_use_priority["EryuCard"]  = 10
sgs.ai_card_intention["EryuCard"] = -100



sgs.ai_skill_invoke.youdiz = function(self, data)
	if #self.friends_noself == 0 then return false end
	for _,p in ipairs(self.enemies) do
		if p:inMyAttackRange(self.player) then return true end
	end
	return false
end

sgs.ai_skill_playerchosen.youdiz = function(self, targets)
	for _,p in sgs.qlist(targets) do
		if self:isEnemy(p) then return p end
	end
	return targets:at(0)
end

sgs.ai_skill_playerchosen.youdi_draw = function(self, targets)
	return self:findPlayerToDraw(false, 1)
end

--静雄
sgs.ai_skill_invoke.baonu = function(self, data)
	if #self.enemies == 0 then return false end
	if self.player:getHp() == 1 and self:getCardsNum("Peach") == 0 and self:getCardsNum("Analeptic") == 0 then return false end
	if self.player:getLostHp() == 0 and self.player:getHandcardNum() > 4 then return false end
	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
		if self.player:inMyAttackRange(p) and not p:isNude() then return true end
	end
	return false
end


--has bug TODO
jizhanshiz_skill={}
jizhanshiz_skill.name="jizhanshiz"
table.insert(sgs.ai_skills,jizhanshiz_skill)
jizhanshiz_skill.getTurnUseCard=function(self, inclusive)
	if self.player:hasUsed("JizhanCard") then return end
	if self.player:getMark("@Baonu") == 0 then return end
	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
		if self.player:inMyAttackRange(p) and not p:isNude() then
		 	return sgs.Card_Parse("@JizhanCard=.") 
		end
	end
end

sgs.ai_skill_use_func.JizhanCard = function(card,use,self)
	local target
	if #self.enemies > 1 then
		for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
			if self.player:inMyAttackRange(p) and not p:isNude() and self:isEnemy(p) then
				target = p
				if p:getEquips():length() > 0 then break end
			end
		end
		if not target then
			for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
				if self.player:inMyAttackRange(p) and not p:isNude()  then
					target = p
					break
				end
			end
		end
	else
		for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
			if self.player:inMyAttackRange(p) and not p:isNude() and not self:isEnemy(p) then
				target = p
				if p:getEquips():length() > 0 then break end
			end
		end
	end
	if target then
		use.card = card
		self.room:writeToConsole("here???")
		if use.to then
			self.room:writeToConsole("target???? "..target:getGeneralName())
			use.to:append(target)
		end
		return
	end
end



sgs.ai_skill_playerchosen.jizhanshiz = function(self, targets)
	return getMostWeakEnemyToDamage(self, targets)
end

sgs.ai_use_value["JizhanCard"] = 5
sgs.ai_use_priority["JizhanCard"]  = 5
sgs.ai_card_intention["JizhanCard"] = 0


--3000
sgs.ai_skill_invoke.yuzhai = true
sgs.ai_skill_playerchosen.yuzhai = function(self, targets)
	return self:findPlayerToDiscard("he", false, true)
end

--无名
sgs.ai_skill_invoke.kangfen = function(self, data)
	if #self.enemies == 0 then return false end
	if self.player:getHp() == 1 and self:getCardsNum("Peach") == 0 and self:getCardsNum("Analeptic") == 0 then return false end
	if self.player:getEquips():length() == 0 and self.player:getHp() <= 3 then return false end
	return true
end

xiedou_skill={}
xiedou_skill.name="xiedou"
table.insert(sgs.ai_skills,xiedou_skill)
xiedou_skill.getTurnUseCard=function(self,inclusive)
	if #self.enemies < 1 then return end
	if self.player:getEquips():length() == 0 then return end
	if self.player:hasFlag("XiedouUsed") then return end

	local needNum = self.player:getHandcardNum() - self.player:getEquips():length()

	if needNum <= 0 then return end

	local cards = sgs.QList2Table(self.player:getHandcards())
	self:sortByUseValue(cards)
	local cardToUses = {table.unpack (cards , 1 , needNum)}
	
	local suit = cardToUses[1]:getSuitString()
	local number = cardToUses[1]:getNumberString()
	local card_str = ("duel:xiedou[%s:%s]="):format(suit, number)
	for _, card in ipairs(cardToUses) do
		card_str = card_str..card:getEffectiveId().."+"
	end
	card_str = string.sub(card_str, 1, -2)
	return sgs.Card_Parse(card_str)
end

--凌波
taxian_skill={}
taxian_skill.name="taxian"
table.insert(sgs.ai_skills,taxian_skill)
taxian_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasUsed("TaxianCard") then return end
	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
		if self:isEnemy(p) and self.player:inMyAttackRange(p) and not p:inMyAttackRange(self.player) then return sgs.Card_Parse("@TaxianCard=.") end
	end
	if self.player:getHp() <= 1 and self:getCardsNum("Peach") == 0 and self:getCardsNum("Analeptic") == 0 then return end
	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
		if self:isEnemy(p) and self.player:inMyAttackRange(p) then return sgs.Card_Parse("@TaxianCard=.") end
	end
end

sgs.ai_skill_use_func.TaxianCard = function(card,use,self)
	local targets = sgs.SPlayerList()
	for _,p in ipairs(self.enemies) do
		if self.player:inMyAttackRange(p) then
			--TODO if friend need maixie
			if not p:inMyAttackRange(self.player) then
				targets:append(p)
			elseif p:getHandcardNum() < 2 then
				targets:append(p)
			elseif self.player:getHp() > 1 or self:getCardsNum("Peach") > 0 or self:getCardsNum("Analeptic") > 0 then
				targets:append(p)
			elseif #targets == 2 then
				targets:append(p)
			end
		end
	end

	if targets:length() > 0 then
		use.card = sgs.Card_Parse("@TaxianCard=.")
		use.to = targets
		return
	end
end

sgs.ai_use_value["TaxianCard"] = 8
sgs.ai_use_priority["TaxianCard"]  = 1
sgs.ai_card_intention["TaxianCard"] = 100

--最上（ceshi)
sgs.ai_skill_invoke.fanghuo = function(self, data)
	local damage = data:toDamage()
	if not self:isFriend(damage.to) then return true end
	return false
end


jianhun_skill={}
jianhun_skill.name="jianhun"
table.insert(sgs.ai_skills,jianhun_skill)
jianhun_skill.getTurnUseCard=function(self,inclusive)
	if #self.enemies < 1 then return end
	local num = 0
	for _,p in sgs.qlist(self.player:getSiblings()) do
		if p:getGeneralName() == "Mogami" or p:getGeneral2Name() == "Mogami" or p:getGeneralName() == "Shigure" or p:getGeneral2Name() == "Shigure" then num = num + p:getLostHp() end
	end

	if num < 2 then return end
	
	local cards = sgs.QList2Table(self.player:getHandcards())
	self:sortByKeepValue(cards)
	if #cards == 0 then return end
	local cardToUse = cards[1]
	if not cardToUse then
		return
	end
	if cardToUse:isKindOf("Peach") then return end
	
	local suit = cardToUse:getSuitString()
	local number = cardToUse:getNumberString()
	local card_id = cardToUse:getEffectiveId()
	local card_str = ("slash:jianhun[%s:%s]=%d"):format(suit, number, card_id)
	return sgs.Card_Parse(card_str)
end

--一色彩羽
sgs.ai_skill_invoke.jianjin = function(self, data)
	local damage = data:toDamage()

	if not self:isFriend(damage.from) and not self:isFriend(damage.to) then return false end
	local current = self.room:getCurrent()
	if current:objectName() == self.player:objectName() or current:getNextAlive():objectName() == self.player:objectName() then
		if self.player:getMark("@Jianjin_damage_recovery") > 2 then return true end
		if self.player:getLostHp() > 0 and self:getCardsNum("Peach") > 0 then return false end
		if self.player:hasWeapon("crossbow") and self:getCardsNum("Slash") > 0 then return false end
		return true
	else
		if self.player:getMark("@Jianjin_damage_recovery") > 2 then return true end
		if self.player:getMark("@Jianjin_damage_recovery") == 2 then
			if self:isFriend(damage.from) and self:isWeak(damage.from) then return true end
			if self:isFriend(damage.to) and self:isWeak(damage.to) then return true end
		end
	end
end

sgs.ai_skill_playerchosen.jianjin = function(self, targets)

	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) then return p end
	end
	return targets:first()
end

sgs.ai_skill_invoke.faka = function(self, data)
	local move = data:toMoveOneTime()
	local value = move.card_ids:length()
	if move.from then
		if not self:isEnemy(self.room:getCurrent()) and not self:isEnemy(move.from) then return false end
	else
		if not self:isEnemy(self.room:getCurrent()) then return false end
	end


	for _,id in sgs.qlist(move.card_ids) do
		if sgs.Sanguosha:getCard(id):isKindOf("Peach") then
			value = value - 2
		end
		if sgs.Sanguosha:getCard(id):isKindOf("Analeptic") then
			value = value - 1.5
		end
	end
	if value >= 1 then return true end
	return false
end

sgs.ai_skill_playerchosen.faka = function(self, targets)

	for _,p in sgs.qlist(targets) do
		if self:isEnemy(p) then return p end
	end
	for _,p in sgs.qlist(targets) do
		if not self:isFriend(p) then return p end
	end
	return targets:first()
end


--七海千秋
ningju_skill={}
ningju_skill.name="ningju"
table.insert(sgs.ai_skills,ningju_skill)
ningju_skill.getTurnUseCard=function(self,inclusive)
	if self.player:usedTimes("NingjuCard") >= 3 then return end
	if #self.enemies == 0 then return end
	local card = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
	for _,p in ipairs(self.enemies) do
		if not self:slashProhibit(card, p) and self:slashIsEffective(card, p) and self:damageIsEffective(p, sgs.DamageStruct_Normal, self.player) then return sgs.Card_Parse("@NingjuCard=.") end
	end
	return sgs.Card_Parse("@NingjuCard=.")
end

sgs.ai_skill_use_func.NingjuCard = function(card,use,self)
	local target
	if self.player:getMark("@waked") == 1 then
		for _,p in ipairs(self.enemies) do
			if not self:slashProhibit(card, p) and self:slashIsEffective(card, p) and self:damageIsEffective(p, sgs.DamageStruct_Normal, self.player) then
				target = p
				if self:isWeak(p) then
					break
				end
			end
		end
	else
		
		local max_effect_num = -200
		for _,p in ipairs(self.enemies) do
			if not self:slashProhibit(card, p) and self:slashIsEffective(card, p) and self:damageIsEffective(p, sgs.DamageStruct_Normal, self.player) then
				local effective_num = 0
				local ava_num = 0
				for _, q in sgs.qlist(self.room:getAlivePlayers()) do
					if q:inMyAttackRange(p) then

						if self:isFriend(q) then effective_num = effective_num + 1 end
						if self:isEnemy(q) then effective_num = effective_num - 3 end
						-- more?
						ava_num = ava_num + 1
					end
				end
				if ava_num == 1 then effective_num = 2.8 end
				if max_effect_num < effective_num then
					max_effect_num = effective_num
					target = p
				end
			end
		end
	end

	if target then
		use.card = sgs.Card_Parse("@NingjuCard=.")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_skill_cardchosen.ningju = function(self, who, flags)
	local status = self.room:getTag("ningju_color"):toString()
	self.room:writeToConsole("current status is "..status)
	if not status then return nil end
	local need = "Red"
	if status == "None" or status == "Mix" then return nil end
	local chiaki = self.room:findPlayerBySkillName("ningju")
	if not chiaki then return nil end
	if (self:isEnemy(chiaki) and status == "Red") or (not self:isEnemy(chiaki) and status == "Black") then
		need = "Black"
	end
	local cards = self.player:getHandcards()
	for _,c in sgs.qlist(self.player:getEquips()) do
		cards:append(c)
	end
	cards = sgs.QList2Table(cards)
	self:sortByKeepValue(cards)

	if need == "Red" then
		self.room:writeToConsole(self.player:getGeneralName().." need to use red")
		for _, card in ipairs(cards) do
			if card:isRed() then return card:getEffectiveId() end
		end
	else
		self.room:writeToConsole(self.player:getGeneralName().." need to use black")
		for _, card in ipairs(cards) do
			if card:isBlack() then return card:getEffectiveId() end
		end
	end
	return nil
end

sgs.ai_use_value["NingjuCard"] = 8
sgs.ai_use_priority["NingjuCard"]  = 2
sgs.ai_card_intention["NingjuCard"] = 100


--朝潮
fanqian_skill={}
fanqian_skill.name="fanqian"
table.insert(sgs.ai_skills,fanqian_skill)
fanqian_skill.getTurnUseCard=function(self,inclusive)
	if self:getCardsNum("Peach") +  self:getCardsNum("Jink") + self:getCardsNum("Analeptic") +  self:getCardsNum("Nullification") >= self.player:getHandcardNum() then return end
	return sgs.Card_Parse("@FanqianCard=.")
end

sgs.ai_skill_use_func.FanqianCard = function(card,use,self)
	local card

	local cards = sgs.QList2Table(self.player:getHandcards())
	self:sortByUsePriority(cards)


	--check equips first
	local equips = {}
	for _, card in sgs.qlist(self.player:getHandcards()) do
		if card:isKindOf("Armor") or card:isKindOf("Weapon") then
			if not self:getSameEquip(card) then
			elseif card:isKindOf("GudingBlade") and self:getCardsNum("Slash") > 0 then
				local HeavyDamage
				local slash = self:getCard("Slash")
				for _, enemy in ipairs(self.enemies) do
					if self.player:canSlash(enemy, slash, true) and not self:slashProhibit(slash, enemy) and
						self:slashIsEffective(slash, enemy) and not self.player:hasSkill("jueqing") and enemy:isKongcheng() then
							HeavyDamage = true
							break
					end
				end
				if not HeavyDamage then table.insert(equips, card) end
			else
				table.insert(equips, card)
			end
		elseif card:getTypeId() == sgs.Card_TypeEquip then
			table.insert(equips, card)
		end
	end

	if #equips > 0 then

		local select_equip, target
		for _, friend in ipairs(self.friends) do
			for _, equip in ipairs(equips) do
				if not self:getSameEquip(equip, friend) and self:hasSkills(sgs.need_equip_skill .. "|" .. sgs.lose_equip_skill, friend) then
					target = friend
					select_equip = equip
					break
				end
			end
			if target then break end
			for _, equip in ipairs(equips) do
				if not self:getSameEquip(equip, friend) then
					target = friend
					select_equip = equip
					break
				end
			end
			if target then break end
		end


		if target then
			use.card = sgs.Card_Parse("@FanqianCard="..select_equip:getEffectiveId())
			self.room:setTag("fanqian_target",sgs.QVariant(target:getGeneralName()))
			return
		end
	end












	for _, c in ipairs(cards) do
		if not c:isKindOf("Collateral") then 
			if c:isKindOf("Slash") or c:isKindOf("SingleTargetTrick") or c:isKindOf("Lightning") or c:isKindOf("AOE") then
				card = c
				break
			end
		end
	end

	if card then

		local target

		for _,p in sgs.qlist(self.room:getAlivePlayers()) do
			if p:getMark("@Buyu") then target = p end
		end
		if not target then target = self.enemies[1] end

		if target then
			use.card = sgs.Card_Parse("@FanqianCard="..card:getEffectiveId())
			self.room:setTag("fanqian_target",sgs.QVariant(target:getGeneralName()))
			return
		end
	else
		--peach
		for _, c in ipairs(cards) do
			if c:isKindOf("Peach") or c:isKindOf("GodSalvation") then
				card = c
				break
			end
		end

		if card then
			local target
			local minHp = 100
			for _,friend in ipairs(self.friends) do
				local hp = friend:getHp()
				if friend:getHp()==friend:getMaxHp() then
					hp = 1000
				end
				if self:hasSkills(sgs.masochism_skill, friend) then
					hp = hp - 1
				end
				if friend:isLord() then
					hp = hp - 1
				end
				if hp < minHp then
					minHp = hp
					target = friend
				end
			end
			for _,friend in ipairs(self.friends) do
				if friend:objectName() == "SE_Kirito" and friend:getHp() == 1 then
					target = friend
				end
			end
			if target then
				use.card = sgs.Card_Parse("@FanqianCard="..card:getEffectiveId())
				self.room:setTag("fanqian_target",sgs.QVariant(target:getGeneralName()))
				return
			end


		else
			for _, c in ipairs(cards) do
				if c:isKindOf("ExNihilo") or c:isKindOf("AmazingGrace") then
					card = c
					break
				end
			end

			if card then
				target = self:findPlayerToDraw(true, 2)
				if target then
					use.card = sgs.Card_Parse("@FanqianCard="..card:getEffectiveId())
					self.room:setTag("fanqian_target",sgs.QVariant(target:getGeneralName()))
					return
				end
			end
		end
	end
end
sgs.ai_skill_choice["fanqian"] = function(self, choices, data)
	return self.room:getTag("fanqian_target"):toString()
end


sgs.ai_use_value["FanqianCard"] = 8
sgs.ai_use_priority["FanqianCard"]  = 10
sgs.ai_card_intention["FanqianCard"] = 0

sgs.ai_skill_invoke.buyu = function(self, data)
	if #self.enemies == 0 then return false end
	local num = 0
	local other = 0
	for _, c in sgs.qlist(self.player:getHandcards()) do
		if (c:isKindOf("Slash") or c:isKindOf("SingleTargetTrick") or c:isKindOf("Lightning") or c:isKindOf("AOE")) and not c:isKindOf("Collateral") then
			num = num + 1
		elseif not c:isKindOf("Analeptic") and not c:isKindOf("Jink") then
			other = other + 1
		end
	end

	if num >= other then return true end
	return false
end

sgs.ai_skill_playerchosen.buyu = function(self, targets)
	return self:getPriorTarget()
end

--兰花
sgs.ai_skill_invoke.xingjian = true
sgs.ai_skill_choice["xingjian"] = function(self, choices, data)
	local ranka = self.room:findPlayerBySkillName("xingjian")
	if not self:isEnemy(ranka) then return "xingjian_skip" end
	if self.player:hasSkills(sgs.need_equip_skill) then return "xingjian_skip" end
	if self.player:hasSkills(sgs.lose_equip_skill) then return "xingjian_throw" end
	if self.player:hasSkills(sgs.cardneed_skill) then return "xingjian_throw" end
	if self:getCardsNum("Slash") == 0 then return "xingjian_throw" end
	return "xingjian_skip"
end

sgs.ai_skill_invoke.goutong =  function(self, data)
	move = data:toMoveOneTime()
	if self.player:objectName() == move.to:objectName() then
		if move.from and not self:isEnemy(move.from) then return true end
		if move.from then
			if self:isWeak(self.player) and not self:isWeak(move.from) and move.from:getLostHp() == 0 then return true end
		end
	else
		if move.to and not self:isEnemy(move.to) then return true end
		if move.to then
			if self:isWeak(self.player) and not self:isWeak(move.to) and move.to:getLostHp() == 0 then return true end
		end
	end
	return false
end