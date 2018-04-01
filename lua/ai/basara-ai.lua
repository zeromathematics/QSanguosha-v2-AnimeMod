function askForShowGeneral(self, choices)
	local triggerEvent = self.player:getTag("triggerEvent"):toInt()
	local data = self.player:getTag("triggerEventData")
	local generals = self.player:getTag("roles"):toString():split("+")
	local players = {}
	for _, general in ipairs(generals) do
		local player = sgs.ServerPlayer(self.room)
		player:setGeneral(sgs.Sanguosha:getGeneral(general))
		table.insert(players, player)
	end

	if triggerEvent == sgs.DamageInflicted then
		local damage = data:toDamage()
		for _, player in ipairs(players) do
			if damage and player:hasSkills(sgs.masochism_skill .. "|zhichi|zhiyu|fenyong") and not self:isFriend(damage.from, damage.to) then return "yes" end
			if damage and damage.damage > self.player:getHp() + self:getAllPeachNum() then return "yes" end
		end
	elseif triggerEvent == sgs.CardEffected then
		local effect = data:toCardEffect()
		for _, player in ipairs(players) do
			if self.room:isProhibited(effect.from, player, effect.card) and self:isEnemy(effect.from, effect.to) then return "yes" end
			if player:hasSkill("xiangle") and effect.card:isKindOf("Slash") then return "yes" end
			if player:hasSkill("jiang") and ((effect.card:isKindOf("Slash") and effect.card:isRed()) or effect.card:isKindOf("Duel")) then return "yes" end
			if player:hasSkill("tuntian") then return "yes" end
		end
	end

	if self.room:alivePlayerCount() <= 3 then return "yes" end
	if sgs.getValue(self.player) < 6 then return "no" end
	local skills_to_show = "bazhen|yizhong|zaiqi|feiying|buqu|kuanggu|kofkuanggu|guanxing|luoshen|tuxi|nostuxi|zhiheng|qiaobian|" ..
							"longdan|liuli|longhun|shelie|luoying|anxian|yicong|wushuang|jueqing|niepan"
	for _, player in ipairs(players) do
		if player:hasSkills(skills_to_show) then return "yes" end
	end
	if self.player:getDefensiveHorse() and self.player:getArmor() and not self:isWeak() then return "yes" end
end

sgs.ai_skill_choice.RevealGeneral = function(self, choices)
	if askForShowGeneral(self, choices) == "yes" then return "yes" end

	local anjiang = 0
	for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do
		if player:getGeneralName() == "anjiang" then
			anjiang = anjiang + 1
		end
	end
	if math.random() > (anjiang + 1) / (self.room:alivePlayerCount() + 1) then
		return "yes"
	else
		return "no"
	end
end

if sgs.GetConfig("EnableHegemony", false) then

	sgs.isRolePredictable = function(classical)
		return false
	end

	sgs.ai_loyalty = {
		lord = {},
		loyalist = {},
		rebel = {},
		renegade = {},
		careerist = {},
	}
	sgs.ai_explicit = {}

	sgs.ai_skill_choice.RevealGeneral = function(self, choices, data)
		if askForShowGeneral(self, choices) == "yes" then return "yes" end

		for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do
			if self:isFriend(player) then return "yes" end
		end

		if sgs.ai_loyalty[self:getHegRole()][self.player:objectName()] == 160 then return "yes" end

		local anjiang = 0
		for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do
			if player:getGeneralName() == "anjiang" then
				anjiang = anjiang + 1
			end
		end

		if math.random() > (anjiang + 1) / (self.room:alivePlayerCount() + 2) then
			return "yes"
		else
			return "no"
		end
	end


	local init = SmartAI.initialize
	function SmartAI:initialize(player)
		if not sgs.initialized then
			for _, aplayer in sgs.qlist(player:getRoom():getAllPlayers()) do
				sgs.ai_explicit[aplayer:objectName()] = ""
			end
		end
		init(self, player)
	end

	function SmartAI:hasHegSkills(skills, players)
		for _, player in ipairs(players) do
			if player:hasSkills(skills) then return true end
		end
		return false
	end

	function SmartAI:getHegRole()
		return self.player:getHegemonyRole()
	end

	function SmartAI:getHegGeneralName(player)
		player = player or self.player
		local names = player:property("basara_generals"):toString():split("+")
		if #names > 0 then return names[1] else return player:getGeneralName() end
	end

	function SmartAI:objectiveLevel(player, recursive)
		if not player then return 0 end
		if self.player == player then return -5 end
		local lieges = {}
		local liege_hp = 0
		for _, aplayer in sgs.qlist(self.room:getOtherPlayers(self.player)) do
			if self:getHegRole() == aplayer:getHegemonyShownRole() and aplayer:getHegemonyShownRole() ~= "careerist" then table.insert(lieges, aplayer) end
			liege_hp = liege_hp + aplayer:getHp()
		end

		local plieges = {}
		local modifier = 0
		for _, aplayer in sgs.qlist(self.room:getOtherPlayers(self.player)) do
			local role = aplayer:getHegemonyShownRole()
			if aplayer:getKingdom() == "god" then role = sgs.ai_explicit[aplayer:objectName()] end
			if role then plieges[role] = (plieges[role] or 0) + 1 end
		end
		if table.contains(plieges, "careerist") then plieges["careerist"] = 1 end
		local roles = { "lord", "loyalist", "rebel", "renegade", "careerist"}
		local max_role = 0
		for _, arole in ipairs(roles) do
			if (plieges[arole] or 0) > max_role then max_role = plieges[arole] end
		end

		if max_role > 0 then
			local kingdom = player:getKingdom()
			local role = player:getHegemonyShownRole()
			if kingdom == "god" then role = sgs.ai_explicit[player:objectName()] end
			if not role or (plieges[role] or 0) < max_role then modifier = -2
			elseif (plieges[role] or 0) > 2 then modifier = 2 end
		end

		if self:getHegRole() == player:getHegemonyShownRole() and self:getHegRole() ~= "careerist" then
			if recursive then return -3 end
			if self.player:getKingdom() == "god" and #lieges >= 2 then
				self:sort(lieges, "hp")
				if player:objectName() ~= lieges[1]:objectName() then return -3 end
				local enemy, enemy_hp = 0, 0
				for _, aplayer in sgs.qlist(self.room:getOtherPlayers(self.player)) do
					if self:objectiveLevel(aplayer, true) > 0 then enemy = enemy + 1 enemy_hp = enemy_hp + aplayer:getHp() end
				end
				local liege
				if enemy_hp - enemy >= liege_hp - #lieges then return -3 else return 4 end
			end
			return -3
		elseif player:getKingdom() ~= "god" then return 5 + modifier
		elseif sgs.ai_explicit[player:objectName()] == self:getHegRole() then
			if self.player:getKingdom() ~= "god" and #lieges >= 1 and not recursive then
				for _, aplayer in sgs.qlist(self.room:getOtherPlayers(self.player)) do
					if self:objectiveLevel(aplayer, true) >= 0 then return -1 end
				end
				return 4
			end
			return -1
		elseif (sgs.ai_loyalty[self:getHegRole()][player:objectName()] or 0) == -160 then return 5 + modifier
		elseif (sgs.ai_loyalty[self:getHegRole()][player:objectName()] or 0) < -80 then return 4 + modifier
		end

		return 0
	end

	function SmartAI:isFriend(player)
		return self:objectiveLevel(player) < 0
	end

	function SmartAI:isEnemy(player)
		return self:objectiveLevel(player) >= 0
	end

	sgs.ai_card_intention["general"] = function(from, to, level)
		-- sgs.hegemony_to = to
		return -level
	end

	sgs.updateIntention = function(player, to, intention, card)
		intention = -intention
		local roles = { "lord", "loyalist", "rebel", "renegade", "careerist"}
		if player:getKingdom() ~= "god" then
			for _, arole in ipairs(roles) do
				sgs.ai_loyalty[arole][player:objectName()] = -160
			end
			if player:getHegemonyShownRole() and player:getHegemonyShownRole() ~= "careerist" then
				sgs.ai_loyalty[player:getHegemonyShownRole()][player:objectName()] = 160
			end
			sgs.ai_explicit[player:objectName()] = player:getHegemonyShownRole()
			return
		end
		local role = to:getHegemonyShownRole()
		if to:getKingdom() ~= "god" then
			sgs.ai_loyalty[role][player:objectName()] = (sgs.ai_loyalty[role][player:objectName()] or 0) + intention
			if sgs.ai_loyalty[role][player:objectName()] > 160 then sgs.ai_loyalty[role][player:objectName()] = 160 end
			if sgs.ai_loyalty[role][player:objectName()] < -160 then sgs.ai_loyalty[role][player:objectName()] = -160 end
		elseif sgs.ai_explicit[player:objectName()] ~= "" then
			role = sgs.ai_explicit[player:objectName()]
			sgs.ai_loyalty[role][player:objectName()] = (sgs.ai_loyalty[role][player:objectName()] or 0) + intention * 0.7
			if sgs.ai_loyalty[role][player:objectName()] > 160 then sgs.ai_loyalty[role][player:objectName()] = 160 end
			if sgs.ai_loyalty[role][player:objectName()] < -160 then sgs.ai_loyalty[role][player:objectName()] = -160 end
		else
			for _, aplayer in sgs.qlist(player:getRoom():getAlivePlayers()) do
				local kingdom = aplayer:getKingdom()
				local role = aplayer:getHegemonyShownRole()
				if aplayer:objectName() ~= to:objectName() and kingdom ~= "god" and (sgs.ai_loyalty[role][player:objectName()] or 0) > -80 then
					sgs.ai_loyalty[role][player:objectName()] = (sgs.ai_loyalty[role][player:objectName()] or 0) - intention * 0.2
					if sgs.ai_loyalty[role][player:objectName()] > 160 then sgs.ai_loyalty[role][player:objectName()] = 160 end
					if sgs.ai_loyalty[role][player:objectName()] < -160 then sgs.ai_loyalty[role][player:objectName()] = -160 end
				end
			end
		end
		local neg_loyalty_count, pos_loyalty_count, max_loyalty, max_role = 0, 0
		for _, arole in ipairs(roles) do
			local list = sgs.ai_loyalty[arole]
			if not max_loyalty then max_loyalty = (list[player:objectName()] or 0) max_role = arole end
			if (list[player:objectName()] or 0) < 0 then
				neg_loyalty_count = neg_loyalty_count + 1
			elseif (list[player:objectName()] or 0) > 0 then
				pos_loyalty_count = pos_loyalty_count + 1
			end
			if max_loyalty < (list[player:objectName()] or 0) then
				max_loyalty = (list[player:objectName()] or 0)
				max_role = arole
			end
		end
		if neg_loyalty_count > 2 or pos_loyalty_count > 0 then
			sgs.ai_explicit[player:objectName()] = max_role
		else
			sgs.ai_explicit[player:objectName()] = ""
		end
	end

	function SmartAI:updatePlayers(clear_flags, update)
		local flist = {}
		local elist = {}
		self.friends = flist
		self.enemies = elist
		self.friends_noself = {}

		local players = sgs.QList2Table(self.room:getOtherPlayers(self.player))
		for _, aplayer in ipairs(players) do
			if self:isFriend(aplayer) then table.insert(flist, aplayer) end
		end
		for _, aplayer in ipairs(flist) do
			table.insert(self.friends_noself, aplayer)
		end
		table.insert(flist, self.player)
		for _, aplayer in ipairs(players) do
			if self:isEnemy(aplayer) then table.insert(elist, aplayer) end
		end
	end

	-- function SmartAI:printAll(player, intention)
	-- 	local name = player:objectName()
	-- 	self.room:writeToConsole(self:getHegGeneralName(player) .. math.floor(intention * 10) / 10
	-- 							.. " R" .. math.floor((sgs.ai_loyalty["loyalist"][name] or 0) * 10) / 10
	-- 							.. " G" .. math.floor((sgs.ai_loyalty["rebel"][name] or 0) * 10) / 10
	-- 							.. " B" .. math.floor((sgs.ai_loyalty["lord"][name] or 0) * 10) / 10
	-- 							.. " Q" .. math.floor((sgs.ai_loyalty["renegade"][name] or 0) * 10) / 10
	-- 							.. " Y" .. math.floor((sgs.ai_loyalty["careerist"][name] or 0) * 10) / 10
	-- 							.. " E" .. (sgs.ai_explicit[name] or "nil"))
	-- end
end
