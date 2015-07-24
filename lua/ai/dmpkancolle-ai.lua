--获取场上最——角色
local function mostPlayer(self, isFriend, kind)
	local num = 0
	local target
	if kind == 1 then--手牌最少
		num = 100
		if isFriend then
			for _,p in ipairs(self.friends) do
				if p:getHandcardNum() < num then
					target = p
					num = p:getHandcardNum()
				end
			end
			if not target then target = self.friends[1] end
		else
			for _,p in ipairs(self.enemies) do
				if p:getHandcardNum() < num then
					target = p
					num = p:getHandcardNum()
				end
			end
			if not target then target = self.enemies[1] end
		end
	elseif kind == 2 then--手牌最多
		num = 0
		if isFriend then
			for _,p in ipairs(self.friends) do
				if p:getHandcardNum() > num then
					target = p
					num = p:getHandcardNum()
				end
			end
			if not target then target = self.friends[1] end
		else
			for _,p in ipairs(self.enemies) do
				if p:getHandcardNum() > num then
					target = p
					num = p:getHandcardNum()
				end
			end
			if not target then target = self.enemies[1] end
		end
	elseif kind == 3 then --体力最小
		num = 100
		if isFriend then
			for _,p in ipairs(self.friends) do
				if p:getHp() < num then
					target = p
					num = p:getHp()
				end
			end
			if not target then target = self.friends[1] end
		else
			for _,p in ipairs(self.enemies) do
				if p:getHp() < num then
					target = p
					num = p:getHp()
				end
			end
			if not target then target = self.enemies[1] end
		end
	elseif kind == 4 then --体力最大
		num = 0
		if isFriend then
			for _,p in ipairs(self.friends) do
				if p:getHp() > num then
					target = p
					num = p:getHp()
				end
			end
			if not target then target = self.friends[1] end
		else
			for _,p in ipairs(self.enemies) do
				if p:getHp() > num then
					target = p
					num = p:getHp()
				end
			end
			if not target then target = self.enemies[1] end
		end
	end
	if target then return target end
	return nil
end

se_chicheng_skill={}
se_chicheng_skill.name="se_chicheng"
table.insert(sgs.ai_skills,se_chicheng_skill)
se_chicheng_skill.getTurnUseCard=function(self,inclusive)
	local source = self.player
	if not (source:getHandcardNum() >= 2 or source:getHandcardNum() > source:getHp()) then return end
	if source:hasUsed("#se_chichengcard") then return end
	return sgs.Card_Parse("#se_chichengcard:.:")
end

sgs.ai_skill_use_func["#se_chichengcard"] = function(card,use,self)
	local cards=sgs.QList2Table(self.player:getHandcards())
	local needed = {}
	local num = 2
	if self.player:getHandcardNum() - self.player:getHp() > 2 then num = self.player:getHandcardNum() - self.player:getHp() end
	for _,acard in ipairs(cards) do
		if #needed < num then
			table.insert(needed, acard:getEffectiveId())
		end
	end
	if needed then
		use.card = sgs.Card_Parse("#se_chichengcard:"..table.concat(needed,"+")..":")
		return
	end
end

sgs.ai_use_value["se_chichengcard"] = 2
sgs.ai_use_priority["se_chichengcard"]  = 1.6

sgs.ai_skill_invoke.se_zhikong = function(self, data)
	local pname = data:toPlayer():objectName()
	local p
	for _,r in sgs.qlist(self.room:getAlivePlayers()) do
		if r:objectName() == pname then p = r end
	end
	if not p then return false end
	if self:isFriend(p) and self.player:getPile("akagi_lv"):length() > 1 and not p:hasSkills("SE_Pasheng|se_wushi") then return true end
	if self:isFriend(p) and p:getKingdom() == "kancolle" then return true end
	if p:objectName() == self.player:objectName() then return true end
	return false
end

sgs.ai_skill_invoke.se_leimu = function(self, data)
	if #self.enemies > 0 then return true end
	return false
end

sgs.ai_skill_playerchosen.se_leimu = function(self, targets)
	return mostPlayer(self, false, 3)
end

sgs.ai_skill_invoke.se_mowang = true

sgs.ai_skill_invoke.se_kuangquan = function(self, data)
	local damage = data:toDamage()
	if self:isEnemy(damage.to) then return true end
	return false
end

sgs.ai_skill_invoke.se_chongzhuang = function(self, data)
	if #self.enemies > 0 then return true end
	return false
end

sgs.ai_skill_playerchosen.se_chongzhuang = function(self, targets)
	local target = self.room:getCurrent():getNextAlive()
	local round = self.room:getCurrent()
	local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
	while target:objectName() ~= round:objectName() do
		if self:isEnemy(target) and self:isWeak(target) and self:slashIsEffective(slash, target) and not target:hasSkill("SE_Rennai") then return target end
		target = target:getNextAlive()
	end
	target = target:getNextAlive()
	while target:objectName() ~= round:objectName() do
		if self:isEnemy(target) and self:slashIsEffective(slash, target) and not target:hasSkill("SE_Rennai") then return target end 
		target = target:getNextAlive()
	end
	return self.enemies[1]
end

sgs.ai_skill_invoke.se_jifeng = true

sgs.ai_skill_choice["se_huibi"] = function(self, data)
	if self.player:getMark("@shimakaze_speed") > 4 then return "se_huibi_move" end
	return "se_huibi_plus"
end

sgs.ai_skill_invoke.se_qianlei = = function(self, data)
	local dying_data = data:toDying()
	local damage = dying_data.damage
	local der = dying_data.who
	return self:isEnemy(der) or self:isEnemy(damage.from)
end

sgs.ai_skill_choice["se_qianlei"] = function(self, data)
	local dying_data = data:toDying()
	local damage = dying_data.damage
	local der = dying_data.who
	if self:isEnemy(der) then return "se_qianlei_second" end
	return "se_qianlei_first"
end

sgs.ai_skill_invoke.se_shuacun = true