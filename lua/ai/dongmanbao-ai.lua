--一般性出牌编写
--[[
sgs.ai_skill_cardask["slash-jink"] = function(self, data, pattern, target)

	local effect = data:toSlashEffect()
	local cards = sgs.QList2Table(self.player:getHandcards())
	if (not target or self:isFriend(target)) and effect.slash:hasFlag("nosjiefan-slash") then return "." end
	if sgs.ai_skill_cardask.nullfilter(self, data, pattern, target) then return "." end
	if effect.nature == sgs.DamageStruct_Fire and self.player:hasSkill("ayshuiyong") then return "." end 
	if self.player:hasSkill("Sixu|renzha") and not self.player:faceUp() then return "." end --dongman
	if self:touhou_dontrespond(self.player, target) then return "." end	--touhou添加
	if target and target:isKongcheng() and target:getMark("touhou_guilty") > 0 and self.player:hasSkill("touhou_Guilty") then return "." end			--touhou
	if not target then self.room:writeToConsole(debug.traceback()) end
	if not target then return end
	if self:isFriend(target) then
		if not target:hasSkill("jueqing") then
			if target:hasSkill("rende") and self.player:hasSkill("jieming") then return "." end
			if target:hasSkill("pojun") and not self.player:faceUp() then return "." end
			if (target:hasSkill("jieyin") and (not self.player:isWounded()) and self.player:isMale()) and not self.player:hasSkill("leiji") then return "." end
			if self.player:isChained() and self:isGoodChainTarget(self.player) then return "." end
		end
	else
		if not self:hasHeavySlashDamage(target, effect.slash) then
			if target:hasSkill("mengjin") and not (target:hasSkill("qianxi") and target:distanceTo(self.player) == 1) then
				if self:hasSkills("jijiu|qingnang") and self.player:getCards("he"):length()>1 then return "." end
				if self:canUseJieyuanDecrease(target) then return "." end
				if self:getCardsNum("Peach") > 0 and not self.player:hasSkill("tuntian") and not self:willSkipPlayPhase() then
					return "."
				end
			end
		end
		if not (self.player:getHandcardNum() == 1 and self:hasSkills(sgs.need_kongcheng)) and 
					not (target:hasSkill("qianxi") and target:distanceTo(self.player) == 1)  then
			if isEquip("Axe", target) then
				if self:hasSkills(sgs.lose_equip_skill, target) and target:getEquips():length() > 1 then return "." end
				if target:getHandcardNum() - target:getHp() > 2 then return "." end
			elseif isEquip("Blade", target) then
				if self:hasHeavySlashDamage(target, effect.slash,self.player) then
				elseif self:getCardsNum("Jink") <= getCardsNum("Slash", target) or self:hasSkills("jijiu|qingnang") or self:canUseJieyuanDecrease(target) then
					return "."
				end
			end
		end
	end
	if target:hasSkill("dahe") and self.player:hasFlag("dahe") then
		for _, card in ipairs(self:getCards("Jink")) do
			if card:getSuit() == sgs.Card_Heart then
				return card:getId()
			end
		end
		return "."
	end
end

function SmartAI:willUseGodSalvation(card)
	if not card then self.room:writeToConsole(debug.traceback()) return false end
	local good, bad = 0, 0
	local wounded_friend = 0
	local wounded_enemy = 0
	if self.player:hasSkill("noswuyan") and self.player:isWounded() then return true end
	
	if self:hasSkills("jizhi") then good = good + 6 end
	if self:hasSkills("kongcheng|lianying") and self.player:getHandcardNum() == 1 then good = good + 15 end

	local liuxie = self.room:findPlayerBySkillName("huangen")
	if liuxie then
		if self:isFriend(self.player, liuxie) then
			good = good + 5 * liuxie:getHp()
		else
			bad = bad + 5 * liuxie:getHp()
		end
	end

	for _, friend in ipairs(self.friends) do
		good = good + 10 * getCardsNum("Nullification", friend)
		if not ((friend:hasSkill("zhichi") and self.room:getTag("Zhichi"):toString() == friend:objectName()) or friend:hasSkill("noswuyan")) then					
			if friend:isWounded() then
				wounded_friend = wounded_friend + 1
				good = good + 10
				if friend:isLord() then good = good + 11/(friend:getHp() + 0.1) end
				if self:hasSkills(sgs.masochism_skill, friend) then
					good = good + 5
				end
				if friend:hasSkill("LuaYaojing") and friend:getLostHp() > 1 then
					good = good + 10
				end
				if friend:getHp() <= 1 and self:isWeak(friend) then
					good = good + 5
					if friend:isLord() then good = good + 10 end	
				else
					if friend:isLord() then good = good + 5 end
				end
			elseif friend:hasSkill("danlao") then good = good + 5
			end
		end
	end

	for _, enemy in ipairs(self.enemies) do
		bad = bad + 10 * getCardsNum("Nullification", enemy)
		if not ((enemy:hasSkill("zhichi") and self.room:getTag("Zhichi"):toString() == enemy:objectName()) or enemy:hasSkill("noswuyan")) then
			if enemy:isWounded() then
				wounded_enemy = wounded_enemy + 1
				bad = bad + 10
				if enemy:isLord() then
					bad = bad + 11/(enemy:getHp() + 0.1)
				end
				if enemy:hasSkill("LuaYaojing") and enemy:getLostHp() > 1 then
					bad = bad + 10
				end
				if self:hasSkills(sgs.masochism_skill, enemy) then
					bad = bad + 5
				end
				if enemy:getHp() <= 1 and self:isWeak(enemy) then
					bad = bad + 5
					if enemy:isLord() then bad = bad + 10 end
				else
					if enemy:isLord() then bad = bad + 5 end
				end
			elseif enemy:hasSkill("danlao") then bad = bad + 5
			end
		end
	end
	return (good - bad > 5 and wounded_friend > 0)  or (wounded_friend == 0 and wounded_enemy == 0 and self:hasSkills("jizhi"))
end

function SmartAI:slashIsEffective(slash, to)
	if not slash or not to then self.room:writeToConsole(debug.traceback()) return end
	if to:hasSkill("zuixiang") and to:isLocked(slash) then return false end
	if to:hasSkill("yizhong") and not to:getArmor() then
		if slash:isBlack() then
			return false
		end
	end
	if (to:hasSkill("zhichi") and self.room:getTag("Zhichi"):toString() == to:objectName()) then
		return false
	end
	
	
	local natures = {
		Slash = sgs.DamageStruct_Normal,
		FireSlash = sgs.DamageStruct_Fire,
		ThunderSlash = sgs.DamageStruct_Thunder,
	}

	local nature = natures[slash:getClassName()]
	if self.player:hasSkill("zonghuo") then nature = sgs.DamageStruct_Fire end
	
	if self:hasSkills("Tianhuo|Huansha", self.player) then nature = sgs.DamageStruct_Fire end --dongman
	if self.player:hasSkill("Huansha") then nature = sgs.DamageStruct_Thunder end
	
	if not self:damageIsEffective(to, nature) then return false end

	if (to:hasArmorEffect("Vine") or to:getMark("@gale") > 0) and self:getCardId("FireSlash") and slash:isKindOf("ThunderSlash") and self:objectiveLevel(to) >= 3 then
		 return false
	end

	if IgnoreArmor(self.player, to) then
		return true
	end
	
	if self.player:hasSkill("touhou_Laevatain") or self.player:hasSkill("SAO_skill4") then			--touhou
		return true
	end
	
	if to:hasSkill("SE_Maoqun") then
		return false
	end
	if to:hasSkill("Lichang") then
		if to:getHp() <= 2 then
			return false
		end
	end
	if to:hasSkill("Tianhuo") then
		if slash:isKindOf("FireSlash") then
			return false
		end
	end
	if to:hasSkill("Huansha") then
		if slash:isKindOf("FireSlash") or slash:isKindOf("ThunderSlash") then
			return false
		end
	end
	
	
	local armor = to:getArmor()
	if armor then
		if armor:objectName() == "RenwangShield" then
			return not slash:isBlack()
		elseif armor:objectName() == "Vine" then
			local skill_name = slash:getSkillName() or ""
			local can_convert = false
			if skill_name == "guhuo" then
				can_convert = true
			else
				local skill = sgs.Sanguosha:getSkill(skill_name)
				if not skill or skill:inherits("FilterSkill") then
					can_convert = true
				end
			end
			return nature ~= sgs.DamageStruct_Normal or (can_convert and (self.player:hasWeapon("Fan") or (self.player:hasSkill("lihuo") and not self:isWeak())))
		end
	end

	return true
end

function SmartAI:maixueplayer(player)
	player = player or self.player
	if player:getHp() > 1 and (self:hasSkills("yiji|jieming|guixin|jinqu",player) or (player:hasSkill("touhou_huanlongyueni") and player:getEquips():length()>1)) or (player:hasSkill("renzha") and player:getPile("zha")<2) then
		return true
	end
	return
end
]]
--------------------------------函数
--雷电免疫
local function ThunderImmune(self, player)
	if player:hasSkill("LuaTianmo") and player:getMark("@tianmo") > 0 then return true end
	if self:hasSkills("SE_Maoqun|Tianhuo", player) then return true end
	return false
end

--装备
local function isEquip(name, player)
	for _,e in sgs.qlist(player:getEquips()) do
		if e:isKindOf(name) then
			return true
		end
	end
	return false
end

--是否有可以改判的角色
local function hasJudgePlayer(self, isFriend)
	for _,player in sgs.qlist(self.room:getAlivePlayers()) do
		if self:hasSkills("se_qidian|guicai|guidao", player) then
			if isFriend then
				if self:isFriend(player) then return true end
			else
				if self:isEnemy(player) then return true end
			end
		end
	end
	return false
end

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


-----------------------------------------------------------------------------------------------------------------------------
sgs.ai_chaofeng["Mikoto"] = 5
sgs.ai_chaofeng["Shana"] = 1
sgs.ai_chaofeng["Louise"] = 0
sgs.ai_chaofeng["Saito"] = 6
sgs.ai_chaofeng["Eustia"] = 4
sgs.ai_chaofeng["Touma"] = -2
sgs.ai_chaofeng["Okarin"] = 2
sgs.ai_chaofeng["Taiga"] = 3
sgs.ai_chaofeng["SE_Kirito"] = 5
sgs.ai_chaofeng["SE_Asuna"] = -3
sgs.ai_chaofeng["Nanami"] = -3
sgs.ai_chaofeng["SE_Eren"] = 6
sgs.ai_chaofeng["Kuroko"] = 5
sgs.ai_chaofeng["HYui"] = 5
sgs.ai_chaofeng["Alice"] = 5
sgs.ai_chaofeng["Sakamoto"] = -4
sgs.ai_chaofeng["Kanade"] = -1
sgs.ai_chaofeng["Rena"] = -1
sgs.ai_chaofeng["Rena_black"] = 5
sgs.ai_chaofeng["Saber"] = 3
sgs.ai_chaofeng["Kirei"] = 4
sgs.ai_chaofeng["Tomoya"] = 2
sgs.ai_chaofeng["Misaka_Imouto"] = 9
sgs.ai_chaofeng["Tukasa"] = 4
sgs.ai_chaofeng["Natsume_Rin"] = -2
sgs.ai_chaofeng["Leafa"] = 2
sgs.ai_chaofeng["Reimu"] = 4
sgs.ai_chaofeng["Kuroneko"] = 3
sgs.ai_chaofeng["Sugisaki"] = -1
sgs.ai_chaofeng["Kuroyukihime"] = 4
sgs.ai_chaofeng["Nagase"] = -3
sgs.ai_chaofeng["Kazehaya"] = -1
sgs.ai_chaofeng["Ayase"] = 5
sgs.ai_chaofeng["Akarin"] = -3
sgs.ai_chaofeng["Hikigaya"] = 5
sgs.ai_chaofeng["Chiyuri"] = 3
sgs.ai_chaofeng["AiAstin"] = 4
sgs.ai_chaofeng["Hakaze"] = 4
sgs.ai_chaofeng["Kotori"] = -5
sgs.ai_chaofeng["Kotori_white"] = 0
sgs.ai_chaofeng["Aria"] = 4
sgs.ai_chaofeng["Reki"] = 4
sgs.ai_chaofeng["Ange"] = 1
sgs.ai_chaofeng["Rivaille"] = 4
sgs.ai_chaofeng["Asagi"] = -2
sgs.ai_chaofeng["Riko"] = 3
sgs.ai_chaofeng["Kurumi"] = 5
sgs.ai_chaofeng["Sakura"] = -4
sgs.ai_chaofeng["Eugeo"] = -4

sgs.ai_chaofeng.Accelerator = -5
sgs.ai_chaofeng.Lelouch = 5

--青山七海
sgs.ai_skill_invoke["jinqu"] = true

sgs.ai_skill_playerchosen["jinqu"] = function(self, targets)
	local num = 100
	local target
	for _,p in ipairs(self.friends) do
		if p:getHandcardNum() < num and p:objectName() ~= self.player:objectName() then
			target = p
			num = p:getHandcardNum()
		end
	end
	if target then return target end
	return self.player
end

sgs.ai_playerchosen_intention["jinqu"] = -70


sgs.ai_need_damaged["jinqu"] = function (self, attacker)
	local need_card = false
	local current = self.room:getCurrent()
	if isEquip("Crossbow", current) or current:hasSkill("paoxiao") or current:hasFlag("shuangxiong") then need_card = true end
	if self:hasSkills("jieyin|jijiu",current) and self:getOverflow(current) <= 0 then need_card = true end
	if self:isFriend(current) and need_card then return true end

	self:sort(self.friends, "hp")

	if self.friends[1]:objectName()==self.player:objectName() and self:isWeak() and self:getCardsNum("Peach")==0 then return false end
	if #self.friends>1 and self:isWeak(self.friends[2]) then return true end	
	
	return self.player:getHp()==2 and sgs.turncount>2 and #self.friends>1
end

sgs.ai_skill_invoke["shengyou"] = function(self, data)
	if self.player:getHandcardNum() > 8 then return false end
	return true
end
--function sgs.ai_general_choice.huashen(self, choices)

--尤斯蒂亚
sgs.ai_skill_invoke["jinghua"] = true

sgs.ai_skill_playerchosen["jinghua"] = function(self, targets)
	local friends = {}
	for _,player in ipairs(self.friends) do
		if player:isAlive() and not (player:hasSkill("manjuan") and self.room:getCurrent():objectName() ~= player:objectName()) then
			table.insert(friends, player)
		end
	end
	self:sort(friends)
	
	local source = self.player
	local max_x = 5 - source:getHandcardNum()
	local target = source
	local judge = target:getJudgingArea()
	if judge:length() > 0 then
		return target
	end
	for _, friend in ipairs(friends) do
		if friend:getHp() < friend:getMaxHp() and self:hasSkills(sgs.masochism_skill, friend) then
			return friend
		end
	end
	
	for _, friend in ipairs(friends) do
		if friend:getHp() < friend:getMaxHp() and friend:getHp() == 1 then
			return friend
		end
	end
	
	for _, friend in ipairs(friends) do
		local x = 5 - friend:getHandcardNum()
		if friend:hasSkill("manjuan") then x = x + 1 end
		
		local judge = friend:getJudgingArea()
		if judge:length() > 0 then
			return friend
		end

		if x > max_x and friend:isAlive() then
			max_x = x
			target = friend
		end
	end
	
	return target
end

--sgs.ai_skillInvoke_intention.jinghua = -60

sgs.ai_skill_choice["jinghua"] = function(self, data)
	local source = self.player
	local judge = source:getJudgingArea()
	if judge:length() > 0 then
		return "jinghua_getcard"
	end
	if source:getHp() < source:getMaxHp() then return "jinghua_recover" end
	return "jinghua_drawcard"
end
		
sgs.ai_skill_invoke["jiushu"] = function(self, data)
	local dying_data = data:toDying()
	local source = dying_data.who
	for _,player in ipairs(self.friends) do
		if player:isAlive() and source:objectName() == player:objectName() then
			return true
		end
	end
	if source:objectName() == self.player:objectName() then
		return true
	end
	return false
end

--sgs.ai_skillInvoke_intention.jiushu = -100


--上条当麻
sgs.ai_skill_invoke.Huansha = function(self, data)
	local damage = data:toDamage()
	local source = damage.to
	for _,player in ipairs(self.friends) do
		if player:isAlive() and source:objectName() == player:objectName() then
			return true
		end
	end
	if source:objectName() == self.player:objectName() then
		return true
	end
	return false
end

--sgs.ai_skillInvoke_intention.Huansha = -70

--御坂美琴 vs
se_paoji_skill={}
se_paoji_skill.name="se_paoji"
table.insert(sgs.ai_skills,se_paoji_skill)
se_paoji_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasUsed("#se_paojicard") then return end
	if #self.enemies < 1 then return end
	if self.player:getMark("@ying") < 1 then return end
	if not hasJudgePlayer(self, true) then 
		if self.player:getHp() > 2 and self.player:getMark("@ying") < 4 then return end
		if self.player:getHp() > 1 and self.player:getMark("@ying") < 3 then return end
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy then
			if not ThunderImmune(self, enemy) and not isEquip("SilverLion",enemy) then
				return sgs.Card_Parse("#se_paojicard:.:")
			end
		end
	end
	return
end

sgs.ai_skill_use_func["#se_paojicard"] = function(card,use,self)
	local target
	local hp = 100
	for _,enemy in ipairs(self.enemies) do
		if not ThunderImmune(self, enemy) and not isEquip("SilverLion",enemy) and enemy:getHp() < hp and not self.room:isAkarin(enemy, self.player) then
			target = enemy
			hp = enemy:getHp()
		end
	end
	if target then
		use.card = sgs.Card_Parse("#se_paojicard:.:")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_skill_choice["se_paoji"] = function(self, choices)
	local choice_table = choices:split("+")
	local count = self.player:getMark("@ying")
	if hasJudgePlayer(self, true) then return "paoji_1" end
	if count > 2 then return "paoji_"..count end
	if self.player:getHp() < 2 then return "paoji_"..count end
	return choice_table[1]
end



sgs.ai_use_value["se_paojicard"] = 8
sgs.ai_use_priority["se_paojicard"]  = 2
sgs.ai_card_intention["se_paojicard"] = 100



--露易丝 vs
se_cairen_skill={}
se_cairen_skill.name="se_cairen"
table.insert(sgs.ai_skills,se_cairen_skill)
se_cairen_skill.getTurnUseCard=function(self,inclusive)
	local source = self.player
	if source:getPile("moli"):length() <= 3 then return end
	return sgs.Card_Parse("#se_cairencard:.:")
end

sgs.ai_skill_use_func["#se_cairencard"] = function(card,use,self)
	use.card = sgs.Card_Parse("#se_cairencard:.:")
	return
end
sgs.ai_use_value["se_cairencard"] = 8
sgs.ai_use_priority["se_cairencard"] = 10

sgs.ai_skill_invoke.Beizeng = function(self, data)
	if self.player:getMark("@shouhu") <= 1 then return false end
	if #self.enemies < 1 then return false end
	return true
end

sgs.ai_skill_playerchosen.Beizeng = function(self, targets)
	local target
	self:sort(self.enemies, "defense") 
	for _,enemy in ipairs(self.enemies) do
		if enemy:isAlive() then
			target = enemy
		end
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy:getHp() == 1 then
			target = enemy
		end
	end
	return target
end

--露易丝--才人 vs
se_zhijian_skill={}
se_zhijian_skill.name="se_zhijian"
table.insert(sgs.ai_skills,se_zhijian_skill)
se_zhijian_skill.getTurnUseCard=function(self,inclusive)
	local source = self.player
	if source:getPile("moli"):length() < 3 then return end
	if self.player:hasFlag("se_zhijiancard_used") then return end
	if #self.enemies < 1 or self.player:isKongcheng() then return end
	local cards=sgs.QList2Table(self.player:getHandcards())
	local OK = false
	for _,card in ipairs(cards) do
		if card:getNumber() > 6 then
			OK =true
		end
	end
	if OK then
		return sgs.Card_Parse("#se_zhijiancard:.:")
	end
end

sgs.ai_skill_use_func["#se_zhijiancard"] = function(card,use,self)
	use.card = sgs.Card_Parse("#se_zhijiancard:.:")
	return
end

sgs.ai_skill_playerchosen.se_zhijiancard = function(self, targets)
	local target
	self:sort(self.enemies,"handcard")
	for _,enemy in ipairs(self.enemies) do
		if enemy:isAlive() and not enemy:isKongcheng() and not enemy:hasSkill("tuntian") and not (enemy:getHandcardNum() == 1 and enemy:hasSkill("kongcheng")) and not self.room:isAkarin(enemy, self.player) then
			target = enemy
			break
		end
	end
	if target then return target end
end

sgs.ai_skill_pindian["se_zhijiancard"] = function(minusecard, self, requestor, maxcard, mincard)
	return maxcard
end

sgs.ai_use_priority["se_zhijiancard"] = 10
sgs.ai_card_intention["se_zhijiancard"]  = 80

se_hengsao_skill={}
se_hengsao_skill.name="se_hengsao"
table.insert(sgs.ai_skills,se_hengsao_skill)
se_hengsao_skill.getTurnUseCard=function(self,inclusive)
	local source = self.player
	if #self.enemies < 2 then return end
	if source:getHp() <= 2 then return end
	if source:getHp() <= 3 and #self.enemies < 3 then return end
	return sgs.Card_Parse("#se_hengsaocard:.:")
end

sgs.ai_skill_use_func["#se_hengsaocard"] = function(card,use,self)
	local targets = sgs.SPlayerList()
	self:sort(self.enemies, "defense") 
	for _,enemy in ipairs(self.enemies) do
		if enemy and targets:length() < 3 and not self.room:isAkarin(enemy, self.player) then
			targets:append(enemy)
		end
	end
	if targets:length() >= 2 then
		use.card = sgs.Card_Parse("#se_hengsaocard:.:")
		if use.to then use.to = targets end
		return
	end
end

sgs.ai_use_priority["se_hengsaocard"] = 4.2
sgs.ai_card_intention["se_hengsaocard"]  = 108
--夏娜
function sgs.ai_cardneed.Zhena(to, card, self)
	return card:isKindOf("Weapon") or card:isKindOf("fire_attack") or card:isKindOf("fire_slash") or card:isKindOf("iron_chain")
end

sgs.ai_skill_invoke.Zhena = function(self, data)
	local damage = data:toDamage()
	local source = damage.to
	if self:isEnemy(source) and source:getHp() - damage.damage > 1 or self.player:getHp() <= 1 then
		return true
	end
	return false
end

--sgs.ai_skillInvoke_intention.Zhena = 80



sgs.ai_chaofeng.Shana = 4
sgs.ai_chaofeng.Shana2 = 4
sgs.ai_chaofeng.Shana3 = 4



--冈部伦太郎 vs
se_shixian_skill={}
se_shixian_skill.name="se_shixian"
table.insert(sgs.ai_skills,se_shixian_skill)
se_shixian_skill.getTurnUseCard=function(self,inclusive)
	local source = self.player
	if source:getMark("@time") == 0 then return end
	if source:getMark("@Benhuihe") > 0 then return end
	if source:getMark("@timepoint") > 0 then return end
	if source:getHandcardNum() < 4 then return end
	if source:getHp() ==1 and source:getHandcardNum() < 7 then return end
	if source:getHp() ==2 and source:getHandcardNum() < 6 then return end
	if source:getHp() ==3 and source:getHandcardNum() < 5 then return end
	return sgs.Card_Parse("#se_shixiancard:.:")
end

sgs.ai_skill_use_func["#se_shixiancard"] = function(card,use,self)
	local cards=sgs.QList2Table(self.player:getHandcards())
	local needed = {}
	for _,acard in ipairs(cards) do
		table.insert(needed, acard:getEffectiveId())
	end
	if self.player:getHp() >= 3 then
		if self.player:getArmor() then
			table.insert(needed, self.player:getArmor():getEffectiveId())
		end
		if self.player:getDefensiveHorse() then
			table.insert(needed, self.player:getDefensiveHorse():getEffectiveId())
		end
	else
		if self.player:getWeapon() then
			table.insert(needed, self.player:getWeapon():getEffectiveId())
		end
		if self.player:getOffensiveHorse() then
			table.insert(needed, self.player:getOffensiveHorse():getEffectiveId())
		end
	end
	use.card = sgs.Card_Parse("#se_shixiancard:"..table.concat(needed,"+")..":")
	return
end

sgs.ai_use_priority["se_shixiancard"] = 10



se_tiaoyue_skill={}
se_tiaoyue_skill.name="se_tiaoyue"
table.insert(sgs.ai_skills,se_tiaoyue_skill)
se_tiaoyue_skill.getTurnUseCard=function(self,inclusive)
	local source = self.player
	if source:getMark("@time") == 0 then return end
	if source:getMark("@timepoint") == 0 then return end
	if source:getMark("Benhuihe") > 0 then return end
	if source:getHp() >2 then return end
	local cards=sgs.QList2Table(self.player:getHandcards())
	local help_card_num = 0
	for _,acard in ipairs(cards) do
		if acard:isKindOf("Peach") or acard:isKindOf("Jink") or  acard:isKindOf("Analeptic") then
			help_card_num = help_card_num + 1
		end
	end
	if source:getHp() ==2 and (help_card_num > 0 and source:getHandcardNum() <= 3) then return end
	return sgs.Card_Parse("#se_tiaoyuecard:.:")
end

sgs.ai_skill_use_func["#se_tiaoyuecard"] = function(card,use,self)
	use.card = sgs.Card_Parse("#se_tiaoyuecard:.:")
	return
end



sgs.ai_use_priority["se_tiaoyuecard"] = 3.6


--逢坂大河（有待提高）
sgs.ai_skill_invoke.Zhudao = true
--来源
sgs.ai_skill_playerchosen.Laiyuan = function(self, targets)
	local source = self.player
	
	for _,player in ipairs(self.friends) do
		if player:isAlive() and player:getJudgingArea():length() > 0 then
			return player
		end
	end
	
	for _,player in ipairs(self.enemies) do
		if player:isAlive() and (player:hasSkill("liegong") or player:hasSkill("Zhena")) and player:getWeapon() then
			return player
		end
	end
	
--[[	if source:getArmor() then
		if #self.friends_noself > 0 then
			for _,player in ipairs(self.friends_noself) do
				if player:isAlive() and self:isWeak(player) and not player:getArmor() then
					return source
				end
			end
		end
	end
	if source:getDefensiveHorse() then
		if #self.friends_noself > 0 then
			for _,player in ipairs(self.friends_noself) do
				if player:isAlive() and self:isWeak(player) and not player:getDefensiveHorse() then
					return source
				end
			end
		end
	end]]
	
	if not source:getArmor() then
		for _,player in ipairs(self.enemies) do
			if player:isAlive() and player:getArmor() and not player:hasSkill("xuanfeng|xiaoji") then
				return player
			end
		end
	end
	if not source:getDefensiveHorse() then
		for _,player in ipairs(self.enemies) do
			if player:isAlive() and player:getDefensiveHorse() and not player:hasSkill("xuanfeng|xiaoji") then
				return player
			end
		end
	end
	if not source:getWeapon() then
		for _,player in ipairs(self.enemies) do
			if player:isAlive() and player:getWeapon() and not player:hasSkill("xuanfeng|xiaoji") then
				return player
			end
		end
	end
	if not source:getOffensiveHorse() then
		for _,player in ipairs(self.enemies) do
			if player:isAlive() and player:getOffensiveHorse() and not player:hasSkill("xuanfeng|xiaoji") then
				return player
			end
		end
	end
	
	if #self.enemies == 1 then
		for _,badpeople in ipairs(self.enemies) do
			if badpeople:isAlive() and not badpeople:hasSkill("kongcheng") then
				return badpeople
			end
		end
	end
	

	for _,player in ipairs(self.friends) do
		if player:isAlive() and not player:getWeapon() then
			for _,badpeople in ipairs(self.enemies) do
				if badpeople:isAlive() and badpeople:getWeapon() then
					return badpeople
				end
			end
		end
	end
	for _,player in ipairs(self.friends) do
		if player:isAlive() and not player:getOffensiveHorse() then
			for _,badpeople in ipairs(self.enemies) do
				if badpeople:isAlive() and badpeople:getOffensiveHorse() then
					return badpeople
				end
			end
		end
	end
	for _,player in ipairs(self.friends) do
		if player:isAlive() and not player:getArmor() then
			for _,badpeople in ipairs(self.enemies) do
				if badpeople:isAlive() and badpeople:getArmor() then
					return badpeople
				end
			end
		end
	end
	for _,player in ipairs(self.friends) do
		if player:isAlive() and not player:getDefensiveHorse() then
			for _,badpeople in ipairs(self.enemies) do
				if badpeople:isAlive() and badpeople:getDefensiveHorse() then
					return badpeople
				end
			end
		end
	end
	
	for _,player in ipairs(self.enemies) do
		if player:isAlive() and not player:isKongcheng() then
			return player
		end
	end
	return 
end
--竹刀的选牌
sgs.ai_skill_cardchosen.Zhudao = function(self, who, flags)
	local source = self.player
	
	if self:isFriend(who) and who:getJudgingArea():length() > 0 then
		local cards = who:getJudgingArea()
		return cards[1]
	end
	
	if self:isEnemy(who) and who:hasSkill("liegong|Zhena") and who:isAlive() and who:getWeapon() and not who:hasSkill("xuanfeng|xiaoji") then
		for _,player in ipairs(self.friends) do
			if player:isAlive() and not player:getWeapon() then
				local card = who:getWeapon()
				return card
			end
		end
	end
--[[	if source:getArmor() and who:objectName() == source:objectName() then 
		local card = who:getArmor()
		return card
	end
	if source:getDefensiveHorse() and who:objectName() == source:objectName() then 
		local card = who:getDefensiveHorse()
		return card
	end]]
	if not ((not source:getArmor() and who:getArmor()) or (not source:getDefensiveHorse() and who:getDefensiveHorse()) or (not source:getWeapon() and who:getWeapon()) or (not source:getOffensiveHorse() and who:getOffensiveHorse())) then
		if self:isEnemy(who) and who:isAlive() and not who:hasSkill("kongcheng") and not who:isKongcheng() and #self.enemies==1 then
			local cards = who:getHandcards()
			return cards[1]
		end
	end
	
	
	
	if self:isEnemy(who) and who:isAlive() and who:getArmor() and not who:hasSkill("xuanfeng|xiaoji") then
		for _,player in ipairs(self.friends) do
			if player:isAlive() and not player:getArmor() then
				local card = who:getArmor()
				return card
			end
		end
	end
	if self:isEnemy(who) and who:isAlive() and who:getDefensiveHorse() and not who:hasSkill("xuanfeng|xiaoji") then
		for _,player in ipairs(self.friends) do
			if player:isAlive() and not player:getDefensiveHorse() then
				local card = who:getDefensiveHorse()
				return card
			end
		end
	end
	if self:isEnemy(who) and who:isAlive() and who:getWeapon() and not who:hasSkill("xuanfeng|xiaoji") then
		for _,player in ipairs(self.friends) do
			if player:isAlive() and not player:getWeapon() then
				local card = who:getWeapon()
				return card
			end
		end
	end
	if self:isEnemy(who) and who:isAlive() and who:getOffensiveHorse() and not who:hasSkill("xuanfeng|xiaoji") then
		for _,player in ipairs(self.friends) do
			if player:isAlive() and not player:getOffensiveHorse() then
				local card = who:getOffensiveHorse()
				return card
			end
		end
	end
	
	if self:isEnemy(who) and who:isAlive() and not who:isKongcheng() then
		local cards = who:getHandcards()
		return cards[1]
	end
	return nil
end

sgs.ai_playerchosen_intention.Zhudao = function(from, to)
	local intention = 60
	sgs.updateIntention(from, to, intention)
end

--给予
sgs.ai_skill_playerchosen.Quxiang = function(self, targets)
	local source = self.player
	
	for _,player in ipairs(self.friends) do
		if player:isAlive() and player:getJudgingArea():length() > 0 then
			for _, target in sgs.qlist(targets) do
				if self:isEnemy(target) and target:getJudgingArea():length() == 0 then
					return target
				end
			end
		end
	end
	
	for _,player in ipairs(self.enemies) do
		if player:isAlive() and (player:hasSkill("liegong") or player:hasSkill("Zhena")) and player:getWeapon() then
			for _,goodguy in sgs.qlist(targets) do
				if self:isFriend(goodguy) and not goodguy:getWeapon() then
					return goodguy
				end
			end
		end
	end
	
--[[	if source:getArmor() then
		for _,player in sgs.qlist(targets) do
			if self:isFriend(player) and self:isWeak(player) and not player:getArmor() then
				return player
			end
		end
	end
	if source:getDefensiveHorse() then
		for _,player in sgs.qlist(targets) do
			if self:isFriend(player) and self:isWeak(player) and not player:getDefensiveHorse() then
				return player
			end
		end
	end]]
	
	if not source:getArmor() then
		for _,player in sgs.qlist(targets) do
			if self:isEnemy(player) and player:getArmor() and not player:hasSkill("xuanfeng|xiaoji") then
				return source
			end
		end
	end
	if not source:getDefensiveHorse() then
		for _,player in sgs.qlist(targets) do
			if self:isEnemy(player) and player:getDefensiveHorse() and not player:hasSkill("xuanfeng|xiaoji") then
				return source
			end
		end
	end
	if not source:getWeapon() then
		for _,player in sgs.qlist(targets) do
			if self:isEnemy(player) and player:getWeapon() and not player:hasSkill("xuanfeng|xiaoji") then
				return source
			end
		end
	end
	if not source:getOffensiveHorse() then
		for _,player in sgs.qlist(targets) do
			if self:isEnemy(player) and player:getOffensiveHorse() and not player:hasSkill("xuanfeng|xiaoji") then
				return source
			end
		end
	end
	
	if #self.enemies == 1 then
		for _,badpeople in ipairs(self.enemies) do
			if badpeople:isAlive() and not badpeople:hasSkill("kongcheng") then
				return source
			end
		end
	end

	for _,badpeople in ipairs(self.enemies) do
		if badpeople:isAlive() and badpeople:getWeapon() then
			for _,player in sgs.qlist(targets) do
				if self:isFriend(player) and not player:getWeapon() then
					if player:hasSkill("xuanfeng|xiaoji|Zhudao") then
						return player
					end
				end
			end
			for _,player in sgs.qlist(targets) do
				if self:isFriend(player) and not player:getWeapon() then
					return player
				end
			end
		end
	end

	for _,badpeople in ipairs(self.enemies) do
		if badpeople:isAlive() and badpeople:getOffensiveHorse() then
			for _,player in sgs.qlist(targets) do
				if self:isFriend(player) and not player:getOffensiveHorse() then
					if player:hasSkill("xuanfeng|xiaoji|Zhudao") then
						return player
					end
				end
			end
			for _,player in sgs.qlist(targets) do
				if self:isFriend(player) and not player:getOffensiveHorse() then
					return player
				end
			end
		end
	end
	for _,badpeople in ipairs(self.enemies) do
		if badpeople:isAlive() and badpeople:getArmor() then
			for _,player in sgs.qlist(targets) do
				if self:isFriend(player) and not player:getArmor() then
					if player:hasSkill("xuanfeng|xiaoji|Zhudao") then
						return player
					end
				end
			end
			for _,player in sgs.qlist(targets) do
				if self:isFriend(player) and not player:getArmor() then
					return player
				end
			end
		end
	end
	for _,badpeople in ipairs(self.enemies) do
		if badpeople:isAlive() and badpeople:getDefensiveHorse() then
			for _,player in sgs.qlist(targets) do
				if self:isFriend(player) and not player:getDefensiveHorse() then
					if player:hasSkill("xuanfeng|xiaoji|Zhudao") then
						return player
					end
				end
			end
			for _,player in sgs.qlist(targets) do
				if self:isFriend(player) and not player:getDefensiveHorse() then
					return player
				end
			end
		end
	end
	
	local cardNumMin = 100
	local bestguy = source
	for _,player in ipairs(self.enemies) do
		if player:isAlive() and not player:isKongcheng() then
			for _,goodguy in sgs.qlist(targets) do
				local cardNum = goodguy:getHandcardNum()
				if cardNum < cardNumMin and self:isFriend(goodguy) then
					cardNumMin = cardNum
					bestguy = goodguy
				end
			end
			return bestguy
		end
	end
	return source
end

sgs.ai_playerchosen_intention.Quxiang = function(from, to)
	local intention = -60
	sgs.updateIntention(from, to, intention)
end

--思绪，准备复制粘贴就好。。

sgs.ai_skill_cardchosen.Sixu = function(self, who, flags)
	local source = self.player
	
	if self:isFriend(who) and who:getJudgingArea():length() > 0 then
		local cards = who:getJudgingArea()
		return cards[1]
	end
	
	if self:isEnemy(who) and who:hasSkill("liegong|Zhena") and who:isAlive() and who:getWeapon() and not who:hasSkill("xuanfeng|xiaoji") then
		for _,player in ipairs(self.friends) do
			if player:isAlive() and not player:getWeapon() then
				local card = who:getWeapon()
				return card
			end
		end
	end
--[[	if source:getArmor() and who:objectName() == source:objectName() then 
		local card = who:getArmor()
		return card
	end
	if source:getDefensiveHorse() and who:objectName() == source:objectName() then 
		local card = who:getDefensiveHorse()
		return card
	end]]
	if not ((not source:getArmor() and who:getArmor()) or (not source:getDefensiveHorse() and who:getDefensiveHorse()) or (not source:getWeapon() and who:getWeapon()) or (not source:getOffensiveHorse() and who:getOffensiveHorse())) then
		if self:isEnemy(who) and who:isAlive() and not who:hasSkill("kongcheng") and not who:isKongcheng() and #self.enemies==1 then
			local cards = who:getHandcards()
			return cards[1]
		end
	end
	
	
	
	if self:isEnemy(who) and who:isAlive() and who:getArmor() and not who:hasSkill("xuanfeng|xiaoji") then
		for _,player in ipairs(self.friends) do
			if player:isAlive() and not player:getArmor() then
				local card = who:getArmor()
				return card
			end
		end
	end
	if self:isEnemy(who) and who:isAlive() and who:getDefensiveHorse() and not who:hasSkill("xuanfeng|xiaoji") then
		for _,player in ipairs(self.friends) do
			if player:isAlive() and not player:getDefensiveHorse() then
				local card = who:getDefensiveHorse()
				return card
			end
		end
	end
	if self:isEnemy(who) and who:isAlive() and who:getWeapon() and not who:hasSkill("xuanfeng|xiaoji") then
		for _,player in ipairs(self.friends) do
			if player:isAlive() and not player:getWeapon() then
				local card = who:getWeapon()
				return card
			end
		end
	end
	if self:isEnemy(who) and who:isAlive() and who:getOffensiveHorse() and not who:hasSkill("xuanfeng|xiaoji") then
		for _,player in ipairs(self.friends) do
			if player:isAlive() and not player:getOffensiveHorse() then
				local card = who:getOffensiveHorse()
				return card
			end
		end
	end
	
	if self:isEnemy(who) and who:isAlive() and not who:isKongcheng() then
		local cards = who:getHandcards()
		return cards[1]
	end
	return nil
end

sgs.ai_skill_invoke.Sixu = function(self, data)
	local Can_get_Card_Num = 0
	local tool = 0
	if self.player:getWeapon() then
		tool = tool -1
	end
	if self.player:getArmor() then
		tool = tool -1
	end
	if self.player:getOffensiveHorse() then
		tool = tool -1
	end
	if self.player:getDefensiveHorse() then
		tool = tool -1
	end
	local tool_s = tool
	for _,player in ipairs(self.enemies) do
		if player:isAlive() then
				if player:getWeapon() then
					tool = tool +1
				end
				if self.player:getArmor() then
					tool = tool +1
				end
				if self.player:getOffensiveHorse() then
					tool = tool +1
				end
				if self.player:getDefensiveHorse() then
					tool = tool +1
				end
				Can_get_Card_Num = Can_get_Card_Num + player:getHandcardNum() + tool
				tool = tool_s
		end
	end
	local i = 0
	for _,player in ipairs(self.friends) do
		if player:isAlive() then
			if player:getJudgingArea():length() > 0 then
				Can_get_Card_Num = Can_get_Card_Num + 1
			end
			if player:hasSkill("Fangzhu|jujian") then
				i = i+1
			end
		end
	end
	local source = self.player
	if (Can_get_Card_Num >=2 or source:getHp() == 1) and (source:getHandcardNum() > source:getHp() or i>0) then
		return true
	end
	return
end

sgs.Zhudao_keep_value = sgs.xiaoji_keep_value



--桐人亚丝娜 vs
function sgs.ai_cardneed.se_erdao(to, card, self)
	return card:isKindOf("Weapon")
end


se_erdao_skill={}
se_erdao_skill.name="se_erdao"
table.insert(sgs.ai_skills,se_erdao_skill)
se_erdao_skill.getTurnUseCard=function(self,inclusive)
	if #self.enemies < 1 or self.player:isKongcheng() then return end
	local too_weak = true
	for _,player in ipairs(self.enemies) do
		if player:getHp() >= 2 and self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), player) and self:slashIsEffective(sgs.Sanguosha:cloneCard("thunder_slash", sgs.Card_NoSuit, 0), player) and self:slashIsEffective(sgs.Sanguosha:cloneCard("fire_slash", sgs.Card_NoSuit, 0), player) then
			too_weak = false
		end
	end
	if too_weak then return end
	local source = self.player
	local OK_num = 0
	if source:getWeapon() then
		OK_num = OK_num + 1
	end
	local cards = sgs.QList2Table(self.player:getHandcards())
	for _,acard in ipairs(cards) do
		if acard:isKindOf("Weapon") then
			OK_num = OK_num + 1
		end
	end
	if OK_num > 1 then
		return sgs.Card_Parse("#se_erdaocard:.:")
	end
end

sgs.ai_skill_use_func["#se_erdaocard"] = function(card,use,self)
	local target
	self:sort(self.enemies, "defense") 
	for _,enemy in ipairs(self.enemies) do
		if enemy:getHp() > 1 and self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), enemy) then
			target = enemy
		end
	end
	if not target then
		for _,enemy in ipairs(self.enemies) do
			if enemy and self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), enemy) then
				target = enemy
			end
		end
	end
	if target then
		local needed = {}
		if self.player:getWeapon() then
			table.insert(needed, self.player:getWeapon():getEffectiveId())
		end
		local cards = sgs.QList2Table(self.player:getHandcards())
		for _,acard in ipairs(cards) do
			if acard:isKindOf("Weapon") then
				table.insert(needed, acard:getEffectiveId())
				if #needed > 1 then
					break
				end
			end
		end
		use.card = sgs.Card_Parse("#se_erdaocard:"..table.concat(needed,"+")..":")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_erdaocard"] = 8
sgs.ai_use_priority["se_erdaocard"]  = 8
sgs.ai_card_intention.se_erdaocard = 108



sgs.ai_skill_invoke.se_erdaoTwice = function(self, data)
	local use = data:toCardUse()
	if use.card:isKindOf("Duel") then 
		if use.to and self:getCardsNum("Slash") >= use.to:at(0):getSlashCount() then
			return true
		end
	elseif use.card:isKindOf("Snatch") or use.card:isKindOf("Dismantlement") then
		local target = use.to and use.to:at(0)
		if target and target:getCards("hej"):length() > 0 then
			if self:isFriend(target) then
				if (target:containsTrick("supply_shortage") or target:containsTrick("indulgence")) and not target:containsTrick("YanxiaoCard") then
					return true
				elseif self:isFriend(target) and target:containsTrick("lightning") and self:getFinalRetrial(target) ~= 1 then
					return true
				elseif target:isWounded() and isEquip("SilverLion",target) then 
					return true
				elseif target:hasSkill("xiaoji") and target:getEquips():length()>0 then 
					return true
				end
			else
				if target:getCards("he"):length()>0 then
					return true
				elseif target:getCards("j"):length() >0 then
					if target:containsTrick("YanxiaoCard") or (target:containsTrick("lightning") and self:getFinalRetrial(target) ~= 1 and #self.enemies > #self.friends) then
						return true
					end
				end				
			end
		end
	elseif use.card:isKindOf("ExNihilo") then
		return true
	elseif use.card:isKindOf("Collateral") then
		return true
	end
	return "." 
end

--sgs.ai_skillInvoke_intention.se_erdaoTwice = 100


se_yekong_skill={}
se_yekong_skill.name="se_yekong"
table.insert(sgs.ai_skills,se_yekong_skill)
se_yekong_skill.getTurnUseCard=function(self,inclusive)
	if self.player:getMark("@Yuzora") == 0 then return end
	local total_damage = 0
	for _,friend in ipairs(self.friends) do
		if friend then
			total_damage = total_damage + friend:getMaxHp() - friend:getHp()
		end
	end
	if #self.friends == 1 and total_damage < 2 then return end
	if #self.friends == 2 and total_damage < 2 and self.player:getHp() > 1 then return end
	if #self.friends > 2 and total_damage < 3 and self.player:getHp() > 1 then return end
	return sgs.Card_Parse("#se_yekongcard:.:")
end

sgs.ai_skill_use_func["#se_yekongcard"] = function(card,use,self)
	if self:getCardsNum("duel") > 0 or self:getCardsNum("dismantlement") > 0 or self:getCardsNum("snatch") > 0 or self:getCardsNum("ex_nihilo") > 0 then
		use.card = card
	end
	if self.player:getHp() == 1 then
		use.card = card
	end
	local help = 0
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("SE_Shanguang") or friend:hasSkill("se_jianwu") or friend:hasSkill("Huajian") then
			help = help + 1
		end
		if friend:getHp() <= 2 then
			help = help + 1
		end
	end
	if help >= 1 then
		use.card = card
	end
end

sgs.ai_use_value["se_yekongcard"] = 8
sgs.ai_use_priority["se_yekongcard"]  = 10
sgs.ai_card_intention.se_yekongcard = -100

sgs.ai_skill_invoke.se_yekongRe = function(self, data)
	return true
end

sgs.ai_skill_playerchosen.se_yekongRe = function(self, targets)
	local minHp = 100
	local target
	for _,friend in ipairs(self.friends) do
		local hp = friend:getHp()
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
	if target then return target end
	return self.player
end

sgs.ai_skill_invoke.Yuzora_Shanguang = function(self, data)
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("SE_Shanguang") then 
			return true
		end
	end
end

sgs.ai_skill_invoke.Yuzora_se_jianwu = function(self, data)
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("se_jianwu") then 
			return true
		end
	end
end

--亚丝娜
sgs.ai_skill_invoke.SE_Dixian = function(self, data)
	local damage = data:toDamage()
	local source = damage.from
	if self:isEnemy(source) then
		return true
	end
	return false
end

--sgs.ai_skillInvoke_intention.SE_Dixian = 80


sgs.ai_skill_playerchosen.SE_Dixian = function(self, targets)
	local target
	self:sort(self.enemies, "defense") 
	for _,enemy in ipairs(self.enemies) do
		if enemy then
			target = enemy
		end
	end
	if target then return target end
	return self.enemies[1]
end

sgs.ai_playerchosen_intention.SE_Dixian = function(from, to)
	local intention = 80
	sgs.updateIntention(from, to, intention)
end

sgs.ai_skill_invoke.SE_Shanguang = function(self, data)
	local damage = data:toDamage()
	local source = damage.to
	if self:isEnemy(source) and not source:hasSkill("tuntian") then
		return true
	end
	return false
end

sgs.ai_skill_cardchosen.SE_Shanguang = function(self, who, flags)
	if who:getArmor() then return who:getArmor() end
	if who:getHandcardNum() == 1 and not who:hasSkill("kongcheng") then
		local cards = who:getHandcards()
		return cards[1]
	end
	if who:getWeapon() then return who:getWeapon() end
	if who:getOffensiveHorse() then return who:getOffensiveHorse() end
	if who:getDefensiveHorse() then return who:getDefensiveHorse() end
	if who:getHandcardNum() > 1 then
		local cards = who:getHandcards()
		return cards[1]
	end
	return
end
		
		
		
--艾伦
se_chouyuan_skill={}
se_chouyuan_skill.name="se_chouyuan"
table.insert(sgs.ai_skills,se_chouyuan_skill)
se_chouyuan_skill.getTurnUseCard=function(self,inclusive)
	if #self.enemies < 1 or self.player:getMark("@hates") < 1 then return end
	local too_weak = true
	for _,player in ipairs(self.enemies) do
		if player:getHp() >= 2 then
			too_weak = false
		end
	end
	if too_weak then return end
	local lord = self.room:getLord()
	if self.player:getRole() =="lord" or self.player:getRole() =="loyalist" or self.player:getRole() =="rebel" then
		return sgs.Card_Parse("#se_chouyuancard:.:")
	end
	if	self.player:getRole() =="renegade" then
		if #self.friends + 1 >= #self.enemies and (self.player:getHp() >= 3 or lord:getHp() >= 3) then return end
		if #self.friends >= #self.enemies and (self.player:getHp() >= 2 or lord:getHp() >= 2) then return end
		return sgs.Card_Parse("#se_chouyuancard:.:")
	end
end


sgs.ai_skill_use_func["#se_chouyuancard"] = function(card,use,self)
	local target
	self:sort(self.enemies, "defense") 
	local lord = self.room:getLord()
	if self.player:getRole() =="rebel" then
		target = lord
	end
	if self.player:getRole() =="loyalist" or self.player:getRole() =="lord" then
		for _,enemy in ipairs(self.enemies) do
			if enemy then
				target = enemy
			end
		end
	end
	if self.player:getRole() =="renegade" then
		if #self.friends == #self.enemies then
			for _,enemy in ipairs(self.enemies) do
				if enemy:getRole() == "rebel" and enemy then
					target = enemy
				end
			end
		end
		if #self.friends + 1 == #self.enemies then
			for _,enemy in ipairs(self.enemies) do
				if enemy then
					target = enemy
				end
			end
		end
		if lord:getHp() <= 2 then
			for _,enemy in ipairs(self.enemies) do
				if enemy:getRole() == "rebel" and enemy then
					target = enemy
				end
			end
		end
	end
	if target then
		use.card = sgs.Card_Parse("#se_chouyuancard:.:")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_chouyuancard"] = 8
sgs.ai_use_priority["se_chouyuancard"]  = 8
sgs.ai_card_intention["se_chouyuancard"]  = 108

sgs.ai_skill_invoke.SE_Qixin = function(self, data)
	return true
end

--sgs.ai_skillInvoke_intention.SE_Qixin = 100

sgs.ai_skill_choice.SE_Qixin = function(self, choices, data)
	local target = self.player:getRoom():getCurrent()
	if self:isFriend(target) then
		local slashs = self:getCards("Slash")
		if #slashs == 0 then
			return "Qixin_setcard"
		end
		return "Qixin_slashto" 
	end
	return "Qixin_setcard"
end

sgs.ai_skill_playerchosen.SE_Qixin = function(self, targets)
	return self:findPlayerToDraw(false, 1)
end












------------------------------------------------------------------------------------------------------------------------------

--第二期

--白井黑子 瞬闪 vs
se_shunshan_skill={}
se_shunshan_skill.name="se_shunshan"
table.insert(sgs.ai_skills,se_shunshan_skill)
se_shunshan_skill.getTurnUseCard=function(self,inclusive)
	if #self.enemies < 1 or self.player:hasFlag("se_shunshan_used")  then return end
	return sgs.Card_Parse("#se_shunshancard:.:")
end


sgs.ai_skill_use_func["#se_shunshancard"] = function(card,use,self)
	local target
	if #self.enemies < 1 then return end
	self:sort(self.enemies, "defense") 
	for _,enemy in ipairs(self.enemies) do
		if enemy:isAlive() and enemy:getDefensiveHorse() and self.player:getOffensiveHorse() and enemy:getMark("@Stop") > 0 then
			target = enemy
		end
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy:isAlive() and enemy:getDefensiveHorse() and self.player:getOffensiveHorse() and enemy:getMark("@Stop") == 0 then
			target = enemy
		end
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy:isAlive() and not enemy:getDefensiveHorse() and enemy:getMark("@Stop") > 0 then
			target = enemy
		end
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy:isAlive() and not enemy:getDefensiveHorse() and enemy:getMark("@Stop") == 0 then
			target = enemy
		end
	end
	if target then
		use.card = sgs.Card_Parse("#se_shunshancard:.:")
		local next_people = target:getNextAlive()
		if use.to then use.to:append(next_people) end
		return
	end
end

sgs.ai_use_value["se_shunshancard"] = 8
sgs.ai_use_priority["se_shunshancard"]  = 7

sgs.ai_skill_playerchosen.se_shunshan = function(self, targets)
	local list = self.room:getAlivePlayers()
	for _,player in sgs.qlist(list) do
		if player:getNextAlive():objectName() == self.player:objectName() then
			return player
		end
	end
	return
end

sgs.ai_playerchosen_intention.se_shunshan = function(from, to)
	local intention = 100
	sgs.updateIntention(from, to, intention)
end

--[[
sgs.ai_skill_invoke.se_shunshan_Another = function(self, data)
	if #self.friends > 1 then return true end
	return false
end

sgs.ai_skill_playerchosen.se_shunshan_Another = function(self, targets)
	local list = self.room:getAlivePlayers()
	local F_Num_Max = 0
	local friend_chosen
	for _,friend in ipairs(self.friends) do
		local F_Num = 1
		local N1 = friend:getNextAlive()
		local N2 = N1:getNextAlive()
		local N3 = N2:getNextAlive()
		if self:isFriend(N1) then F_Num = F_Num + 1 end
		if self:isFriend(N2) then F_Num = F_Num + 1 end
		if self:isFriend(N3) then F_Num = F_Num + 1 end
		if F_Num > F_Num_Max then
			F_Num_Max = F_Num
			friend_chosen = friend
		end
	end
	if friend_chosen then
		for _,player in sgs.qlist(list) do
			if player:getNextAlive():objectName() == friend_chosen:objectName() then
				return player
			end
		end
	end
end
]]

--白井黑子 憧憬
se_chongjing_skill={}
se_chongjing_skill.name="se_chongjing"
table.insert(sgs.ai_skills,se_chongjing_skill)
se_chongjing_skill.getTurnUseCard=function(self,inclusive)
	if #self.friends < 1 or self.player:getMark("@longing") < 1 then return end
	local no_sister = true
	for _,player in ipairs(self.friends) do
		if not player:isMale() and player:objectName() ~= self.player:objectName() then
			no_sister = false
		end
	end
	local mikoto_unknown = false
	local list = self.room:getAlivePlayers()
	for _,player in sgs.qlist(list) do
		if player:getGeneralName() == "Mikoto" then
			if not self:isFriend(player) and not self:isEnemy(player) then
				mikoto_unknown = true
			end
		end
	end
	if no_sister or mikoto_unknown then return end
	local lord = self.room:getLord()
	if self.player:getRole() =="lord" or self.player:getRole() =="loyalist" or self.player:getRole() =="rebel" then
		return sgs.Card_Parse("#se_chongjingcard:.:")
	end
	if	self.player:getRole() =="renegade" then
		if #self.friends + 1 >= #self.enemies and (self.player:getHp() >= 3 or lord:getHp() >= 3) then return end
		if #self.friends >= #self.enemies and (self.player:getHp() >= 2 or lord:getHp() >= 2) then return end
		return sgs.Card_Parse("#se_chongjingcard:.:")
	end
end


sgs.ai_skill_use_func["#se_chongjingcard"] = function(card,use,self)
	local target = nil
	self:sort(self.friends, "defense") 
	local lord = self.room:getLord()
	if self.player:getRole() =="rebel" or self.player:getRole() =="lord" or self.player:getRole() =="loyalist" then
		for _,friend in ipairs(self.friends) do
			if not friend:isMale() and friend:objectName() ~= self.player:objectName() then
				target = friend
			end
		end
	end
	if self.player:getRole() =="renegade" then
		if #self.friends == #self.enemies then
			for _,friend in ipairs(self.friends) do
				if friend:getRole() == "lord" and not friend:isMale() and friend:objectName() ~= self.player:objectName()  then
					target = friend
				end
			end
		end
		if #self.friends + 1 <= #self.enemies then
			for _,friend in ipairs(self.friends) do
				if (friend:getRole() == "lord" or friend:getRole() == "rebel") and not friend:isMale() and friend:objectName() ~= self.player:objectName() then
					target = friend
				end
			end
		end
		if lord:getHp() <= 2 then
			for _,friend in ipairs(self.friends) do
				if friend:getRole() == "lord" and not friend:isMale() and friend:objectName() ~= self.player:objectName() then
					target = friend
				end
			end
		end
	end
	if self.player:getRole() =="loyalist" then
		if not lord:isMale() then
			target = lord
		end
	end
	if self.player:getRole() =="rebel" or self.player:getRole() =="lord" or self.player:getRole() =="loyalist" then
		for _,friend in ipairs(self.friends) do
			if friend:getGeneralName() == "Mikoto" then
				target = friend
			end
		end
	end
	if target then
		use.card = sgs.Card_Parse("#se_chongjingcard:.:")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_chongjingcard"] = 8
sgs.ai_use_priority["se_chongjingcard"]  = 8
sgs.ai_card_intention["se_chongjingcard"]  = -100

sgs.ai_skill_invoke.se_chongjing_Attack = function(self, data)
	local damage = data:toDamage()
	local victim = damage.to
	local source = damage.from
	if self:isEnemy(victim) or self:isEnemy(source) then
		return true
	end
end

--白井黑子 解束
se_jieshu_skill={}
se_jieshu_skill.name="se_jieshu"
table.insert(sgs.ai_skills,se_jieshu_skill)
se_jieshu_skill.getTurnUseCard=function(self,inclusive)
	if #self.friends < 1 then return end
	local target = false
	for _,friend in ipairs(self.friends) do
		if friend:getMark("@Stop") > 0 then
			target = true
		end
	end
	if not target then return end
	if target then
		return sgs.Card_Parse("#se_jieshucard:.:")
	end
end


sgs.ai_skill_use_func["#se_jieshucard"] = function(card,use,self)
	local target
	for _,friend in ipairs(self.friends) do
		if friend:getMark("@Stop") > 0 then
			target = friend
		end
	end
	if target then
		use.card = sgs.Card_Parse("#se_jieshucard:.:")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_jieshucard"] = 6
sgs.ai_use_priority["se_jieshucard"]  = 4
sgs.ai_card_intention["se_jieshucard"]  = -50

--平泽唯
sgs.ai_skill_invoke.dai = function(self, data)
	return true
end

sgs.ai_skill_playerchosen.dai = function(self, targets)
	local minHp = 100
	local target
	for _,friend in ipairs(self.friends) do
		local hp = friend:getHp()
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
	if target then return target end
	return self.player
end

sgs.ai_playerchosen_intention.dai = function(from, to)
	local intention = -60
	sgs.updateIntention(from, to, intention)
end

sgs.ai_skill_invoke.daiVS = function(self, data)
	local dying_data = data:toDying()
	local source = dying_data.who
	if self.player:getMark("@daiwei") < 2 then return false end
	if self:isFriend(source) then return true end
	return false
end

--sgs.ai_skillInvoke_intention.daiVS = -80

sgs.ai_skill_invoke.zhuchang = function(self, data)
	local list = self.room:getAlivePlayers()
	local target
	for _,player in sgs.qlist(list) do
		if player:hasFlag("zhuchang_search") then
			target = player
		end
	end
	if self:isFriend(target) then return true end
	return false
end
--sgs.ai_skillInvoke_intention.zhuchang = -80


--爱丽丝 vs
se_tianming_skill={}
se_tianming_skill.name="se_tianming"
table.insert(sgs.ai_skills,se_tianming_skill)
se_tianming_skill.getTurnUseCard=function(self,inclusive)
	if not sgs.Slash_IsAvailable(self.player) or self.player:getMark("@Tianming") < 12 then return end
	local cards = self.player:getCards("h")	
	cards=sgs.QList2Table(cards)
	self:sortByUseValue(cards,true)
	for _,card in ipairs(cards)  do
		if card:isKindOf("Slash") then
			return
		end
	end
	if #self.friends >= #self.enemies then return end
	local card = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit,0)
	return sgs.Card_Parse(("slash:se_tianming[%s:%s]=%d"):format(card:getSuitString(),card:getNumberString(),card:getEffectiveId()))
end


sgs.ai_view_as.se_tianming = function(card, player, card_place)
	if player:hasFlag("jink_to") then
		if player:getMark("@Tianming") < 17 then return end
		local cards = player:getCards("h")	
		cards=sgs.QList2Table(cards)
		for _,card in ipairs(cards)  do
			if card:isKindOf("Jink") then
				return
			end
		end
		local card = sgs.Sanguosha:cloneCard("jink", sgs.Card_NoSuit,0)
		return ("jink:se_tianming[%s:%s]=%d"):format(card:getSuitString(),card:getNumberString(),card:getEffectiveId())
	elseif player:hasFlag("slash_to") then
		if player:getMark("@Tianming") < 12 then return end
		local cards = player:getCards("h")	
		cards=sgs.QList2Table(cards)
		for _,card in ipairs(cards)  do
			if card:isKindOf("Slash") then
				return
			end
		end
		local card = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit,0)
		return ("slash:se_tianming[%s:%s]=%d"):format(card:getSuitString(),card:getNumberString(),card:getEffectiveId())
	elseif player:hasFlag("null_to") then
		if player:getMark("@Tianming") < 30 or (player:getMark("@Tianming") > 110 and player:getMark("@Tianming") <140) then return end
		local cards = player:getCards("h")	
		cards=sgs.QList2Table(cards)
		for _,card in ipairs(cards)  do
			if card:isKindOf("Nullification") then--null部分有问题
				return
			end
		end
		local card = sgs.Sanguosha:cloneCard("nullification", sgs.Card_NoSuit,0)
		return ("nullification:se_tianming[%s:%s]=%d"):format(card:getSuitString(),card:getNumberString(),card:getEffectiveId())
	end
end

se_jianwu_skill={}
se_jianwu_skill.name="se_jianwu"
table.insert(sgs.ai_skills,se_jianwu_skill)
se_jianwu_skill.getTurnUseCard=function(self,inclusive)
	local source = self.player
	if source:getMark("@Tianming") < 130 then return end
	if #self.enemies < 2 then return end
	return sgs.Card_Parse("#se_jianwucard:.:")
end

sgs.ai_skill_use_func["#se_jianwucard"] = function(card,use,self)
	local targets = sgs.SPlayerList()
	self:sort(self.enemies, "defense") 
	for _,enemy in ipairs(self.enemies) do
		if enemy and targets:length() < 3 and enemy:faceUp() then
			targets:append(enemy)
		end
	end
	if targets:length() >= 1 then
		use.card = sgs.Card_Parse("#se_jianwucard:.:")
		if use.to then use.to = targets end
		return
	end
end

sgs.ai_use_priority["se_jianwucard"] = 6
sgs.ai_card_intention["se_jianwucard"]  = 100

se_kanhu_skill={}
se_kanhu_skill.name="se_kanhu"
table.insert(sgs.ai_skills,se_kanhu_skill)
se_kanhu_skill.getTurnUseCard=function(self,inclusive)
	local source = self.player
	if source:hasFlag("se_kanhucard_used") then return end
	if source:getMark("@Tianming") < 20 then return end
	local target = 0
	for _,friend in ipairs(self.friends) do
		if friend:getHp()~=friend:getMaxHp() then
			target = 1
		end
	end
	if target == 1 then
		return sgs.Card_Parse("#se_kanhucard:.:")
	end
end

sgs.ai_skill_use_func["#se_kanhucard"] = function(card,use,self)
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
		use.card = sgs.Card_Parse("#se_kanhucard:.:")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_kanhucard"] = 6
sgs.ai_use_priority["se_kanhucard"] = 9
sgs.ai_card_intention["se_kanhucard"]  = -100


--坂本龙太
sgs.ai_skill_invoke.SE_Xianjing = function(self, data)
	local damage = data:toDamage()
	local source = damage.from
	if self:isEnemy(source) then
		return true
	end
	return false
end

--sgs.ai_skillInvoke_intention.SE_Xianjing = 80

sgs.ai_skill_invoke["SE_Boming"] = function(self, data)
	if self.player:getMark("@HIMIKO") == 0 then return false end
	local dying_data = data:toDying()
	local source = dying_data.who
	if self:isFriend(source) then
		local skill_list = self.player:getVisibleSkillList()
		local i = 0
		for _,skill in sgs.qlist(skill_list) do
			if skill:objectName()~="SE_Boming" and skill:objectName()~="SE_Xianjing" and skill:objectName()~="SE_BomingGet" then
				i = i + 1
			end
		end
		if i ==0 then return false end
		if source:objectName() == self.player:objectName() then return true end
		if self.player:getRole() =="renegade" then
			if source:objectName() ~= self.player:objectName() and source:getRole() ~= "lord" then return false end
		end
		if i == 1 and #self.friends > 2 then return false end
		if i >= 2 then return true end
		return false
	end
end

--sgs.ai_skillInvoke_intention.SE_Boming = -80

--立华奏 vs
se_qiyuan_skill={}
se_qiyuan_skill.name="se_qiyuan"
table.insert(sgs.ai_skills,se_qiyuan_skill)
se_qiyuan_skill.getTurnUseCard=function(self,inclusive)
	local source = self.player
	if source:getMark("@se_qiyuan") == 0 then return end
	local room = source:getRoom()
	local deathplayer = {}
	for _,p in sgs.qlist(room:getPlayers()) do
		if p:isDead() and p:getMaxHp() >= 2 then
			table.insert(deathplayer,p:getGeneralName())
		end
	end
	if #deathplayer==0 then return end
	if #deathplayer>0 then
		return sgs.Card_Parse("#se_qiyuancard:.:")
	end
end

sgs.ai_skill_use_func["#se_qiyuancard"] = function(card,use,self)
	use.card = sgs.Card_Parse("#se_qiyuancard:.:")
	return
end

sgs.ai_use_value["se_qiyuancard"] = 8
sgs.ai_use_priority["se_qiyuancard"] = 7

sgs.ai_skill_choice["se_qiyuan"] = function(self, choices, data)
	local source = self.player
	local room = source:getRoom()
	local maxHpMax = 2
	local theP
	for _,p in sgs.qlist(room:getPlayers()) do
		if p:isDead() and p:getMaxHp() >= 2 then
			if p:getMaxHp() > maxHpMax then
				maxHpMax = p:getMaxHp()
				theP = p
			end
		end
	end
	if theP then return theP end
	local choice_table = choices:split("+")
	return choice_table[1]
end

sgs.ai_event_callback[sgs.CardFinished].se_qiyuancard = function(self,player,data)
	local use = data:toCardUse()
	if use.card and use.card:objectName() == "se_qiyuancard" then
		local room = player:getRoom()
		for _, sb in sgs.qlist(room:getOtherPlayers(player)) do
			if sb:hasFlag("se_qiyuan_ed") then
				sgs.role_evaluation[sb:objectName()][sb:getRole()] = 10000
				room:setPlayerFlag(sb,"-se_qiyuan_ed")
			end
		end
	end
end

sgs.ai_skill_invoke.Lichang = function(self, data)
	return true
end

--手刃实验

se_shouren_skill={}
se_shouren_skill.name="se_shouren"
table.insert(sgs.ai_skills,se_shouren_skill)
se_shouren_skill.getTurnUseCard=function(self,inclusive)
	local source = self.player
	if source:hasFlag("se_shourencard_used") then return end
	if #self.enemies == 0 then return end
	return sgs.Card_Parse("#se_shourencard:.:")
end

sgs.ai_skill_use_func["#se_shourencard"] = function(card,use,self)
	local target
	local minHp = 100
	for _,enemy in ipairs(self.enemies) do
		local hp = enemy:getHp()
		if self:hasSkills(sgs.masochism_skill, enemy) then hp = hp - 1 end
		if hp < minHp then
			minHp = hp
			target = enemy
		end
	end
	if target then
		use.card = sgs.Card_Parse("#se_shourencard:.:")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_shourencard"] = 8
sgs.ai_use_priority["se_shourencard"] = 2
sgs.ai_card_intention["se_shourencard"]  = 60

sgs.ai_skill_choice.Pifu_Kanade = function(self, data)
	local x = math.random(1,3)
	if x == 1 then
		return "Kanade_1"
	elseif x == 2 then
		return "Kanade_2"
	else
		return "Kanade_3"
	end
end



--龙宫礼奈
sgs.ai_skill_invoke.Zizhu = function(self, data)
	return true
end

--Saber
se_shengjian_skill={}
se_shengjian_skill.name="se_shengjian"
table.insert(sgs.ai_skills,se_shengjian_skill)
se_shengjian_skill.getTurnUseCard=function(self,inclusive)
	if #self.enemies < 1 then return end
	local source = self.player
	if source:hasFlag("se_shengjiancard_used") then return end
	local power = 0
	local target
	for _,enemy in ipairs(self.enemies) do
		local force = math.abs(source:getEquips():length() - enemy:getEquips():length()) + (enemy:getEquips():length())/2
		if force > power then
			if not enemy:hasSkill("xiaoji") and not enemy:hasSkill("xuanfeng") and not enemy:hasSkill("Zhudao") then
				target = enemy
				power = force
			end
		end
	end
	if not target then return end
	if power < 2 then return end
	if target and power >= 2 then
		return sgs.Card_Parse("#se_shengjiancard:.:")
	end
end

sgs.ai_skill_use_func["#se_shengjiancard"] = function(card,use,self)
	local target
	local source = self.player
	local power = 0
	for _,enemy in ipairs(self.enemies) do
		local force = math.abs(source:getEquips():length() - enemy:getEquips():length()) + (enemy:getEquips():length())/2
		if force > power then
			if not enemy:hasSkill("xiaoji") and not enemy:hasSkill("xuanfeng") and not enemy:hasSkill("Zhudao") then
				target = enemy
				power = force
			end
		end
	end
	if target and power >= 2 then
		use.card = sgs.Card_Parse("#se_shengjiancard:.:")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_shengjiancard"] = 8
sgs.ai_use_priority["se_shengjiancard"]  = 5
sgs.ai_card_intention.se_shengjiancard = 90

--言峰绮礼
sgs.ai_skill_invoke.Yuyue = function(self, data)
	return true
end

sgs.ai_skill_invoke.Xianhai = function(self, data)
	local list = self.room:getAlivePlayers()
	local Friend_XD = true
	local target
	for _,p in sgs.qlist(list) do
		if p:hasSkill("Xianhai") then
			if self:isEnemy(p) then
				Friend_XD = false
			end
		end
	end
	if Friend_XD then
		if self:hasSkills(sgs.masochism_skill, self.player) then
			return true
		end
	elseif not Friend_XD then
		if self:hasSkills(sgs.masochism_skill, self.player) then
			return true
		end
	end
	if self.player:getHp() <= 1 then
		return true
	end
	return false
end

sgs.ai_skill_playerchosen.Xianhai = function(self, targets)
	local list = self.room:getAlivePlayers()
	local Friend_XD = true
	local target
	for _,p in sgs.qlist(list) do
		if p:hasSkill("Xianhai") then
			if self:isEnemy(p) then
				Friend_XD = false
			end
		end
	end
	if Friend_XD then
		if self:hasSkills(sgs.masochism_skill, self.player) then
			self:sort(self.enemies, "defense") 
			for _,enemy in ipairs(self.enemies) do
				if enemy then
					target = enemy
				end
			end
		end
	elseif not Friend_XD then
		if self:hasSkills(sgs.masochism_skill, self.player) then
			self:sort(self.friends, "defense") 
			for _,friend in ipairs(self.friends) do
				if friend then
					target = friend
				end
			end
		end
	end
	if self.player:getHp() <= 1 then
		if Friend_XD then
			if self.player:getRole() == "rebel" then
				for _,friend in ipairs(self.friends) do
					if friend then
						target = friend
					end
				end
			elseif self.player:getRole() == "loyalist" then
				for _,enemy in ipairs(self.enemies) do
					if enemy then
						target = enemy
					end
				end
			end
		elseif not Friend_XD then
			if self.player:getRole() == "rebel" then
				for _,enemy in ipairs(self.enemies) do
					if enemy then
						target = enemy
						break
					end
				end
			elseif self.player:getRole() == "loyalist" then
				target = self.room:getLord()
			end
		end
	end
	if target then return target end
	return self.player
end

--冈崎朋也
se_zhuren_skill={}
se_zhuren_skill.name="se_zhuren"
table.insert(sgs.ai_skills,se_zhuren_skill)
se_zhuren_skill.getTurnUseCard=function(self,inclusive)
	if #self.friends <= 1 then return end
	local source = self.player
	if source:isKongcheng() then return end
	if source:hasUsed("#se_zhurencard") then return end
	return sgs.Card_Parse("#se_zhurencard:.:")
end

sgs.ai_skill_use_func["#se_zhurencard"] = function(card,use,self)
	local target
	local source = self.player
	local max_num = source:getMaxHp() - source:getHp() + 1
	local max_x = 0
	for _,friend in ipairs(self.friends) do
		local x = 5 - friend:getHandcardNum()
		if friend:hasSkill("manjuan") then x = x + 1 end

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
		use.card = sgs.Card_Parse("#se_zhurencard:"..table.concat(needed,"+")..":")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_zhurencard"] = 4
sgs.ai_use_priority["se_zhurencard"]  = 2.4
sgs.ai_card_intention["se_zhurencard"]  = -60

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
				else
					return "Tomoyo_Couple"
				end
			end
		end
		return "Nagisa_Protector"
	elseif self.player:getRole() == "renegade" then
		if lord:getHp() <= 2 then
			return "Fuko_summoner"
		end
		return "Nagisa_Protector"
	end
end

sgs.ai_skill_playerchosen.se_diangong_st = function(self, targets)
	local target
	for _,friend in ipairs(self.friends) do
		if not friend:hasSkill("se_diangong_def") then
			target = friend
		end
	end
	if target then return target end
	return self.player
end

sgs.ai_skill_playerchosen.Shouyang_st = function(self, targets)
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

sgs.ai_playerchosen_intention.Shouyang_st = function(from, to)
	local intention = -100
	sgs.updateIntention(from, to, intention)
end

local se_diangong_skill={}
se_diangong_skill.name="se_diangong"
table.insert(sgs.ai_skills,se_diangong_skill)
se_diangong_skill.getTurnUseCard=function(self,inclusive)
	local cards = sgs.QList2Table(self.player:getHandcards()) 
	self:sortByUseValue(cards,true)  
	for _,acard in ipairs(cards) do
		if self:getKeepValue(acard)<4 and acard:isBlack() then    
			local number = acard:getNumberString()
			local card_id = acard:getEffectiveId()
			local suit = acard:getSuitString()
			return sgs.Card_Parse(("lightning:se_diangong[%s:%s]=%d"):format(suit, number, card_id))
		end
	end
end
sgs.ai_use_value["se_diangong"] = 8
sgs.ai_use_priority["se_diangong"]  = 2.5

sgs.ai_skill_invoke.Shouyang = function(self, data)
	return true
end

sgs.ai_skill_invoke.Haixing = function(self, data)
	local dying_data = data:toDying()
	local source = dying_data.who
	local mygod= self.room:findPlayerBySkillName("Haixing")
	if self:isFriend(mygod) then
		return true
	end
	return false
end

--sgs.ai_skillInvoke_intention.Haixing = -80

--第三期
--朝田诗乃
se_jianyu_skill={}
se_jianyu_skill.name="se_jianyu"
table.insert(sgs.ai_skills,se_jianyu_skill)
se_jianyu_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasFlag("se_jianyucard_used") then return end
	if #self.enemies < 1 then return end
	return sgs.Card_Parse("#se_jianyucard:.:")
end

sgs.ai_skill_use_func["#se_jianyucard"] = function(card,use,self)
	local targets = sgs.SPlayerList()
	for _,enemy in ipairs(self.enemies) do
		if targets:length() < self.player:getMaxHp() - self.player:getHp()+1 and not enemy:inMyAttackRange(self.player) and not isEquip("Vine",enemy) then
			targets:append(enemy)
		end
	end
	if targets:length() < self.player:getMaxHp() - self.player:getHp()+1 then
		for _,enemy1 in ipairs(self.enemies) do
			if targets:length() < self.player:getMaxHp() - self.player:getHp() +1 and enemy1:inMyAttackRange(self.player) and not isEquip("Vine",enemy1) then
				targets:append(enemy1)
			end
		end
	end
	if targets:length() > 0 then
		use.card = sgs.Card_Parse("#se_jianyucard:.:")
		if use.to then use.to = targets end
		return
	end
end

sgs.ai_use_value["se_jianyucard"] = 8
sgs.ai_use_priority["se_jianyucard"]  = 2
sgs.ai_card_intention["se_jianyucard"] = 100
--御坂妹
sgs.ai_skill_invoke.se_qidian = function(self, data)
	if #self.enemies == 0 then return false end
	return true
end

sgs.ai_skill_playerchosen["se_qidian"] = function(self, targets)
	local target
	self:sort(self.enemies, "defense") 
	for _,enemy in ipairs(self.enemies) do
		if enemy then
			target= enemy
			break
		end
	end
	if target then return target end
	return false
end

sgs.ai_playerchosen_intention.se_qidian = function(from, to)
	local intention = 80
	sgs.updateIntention(from, to, intention)
end

sgs.se_qidian_suit_value = {
	heart = 3.9,
	club = 3.9,
	spade = 3.5
}

function sgs.ai_cardneed.se_qidian(to, card, self)
	for _, player in sgs.qlist(self.room:getAllPlayers()) do
		if self:getFinalRetrial(to) == 1 then 
			if player:containsTrick("lightning") and not player:containsTrick("YanxiaoCard") then
				return card:getSuit() == sgs.Card_Spade and card:getNumber() >= 2 and card:getNumber() <= 9 and not self:hasSkills("hongyan|wuyan")
			end
			if self:isFriend(player) and self:willSkipDrawPhase(player) then
				return card:getSuit() == sgs.Card_Club
			end
			if self:isFriend(player) and self:willSkipPlayPhase(player) then
				return card:getSuit() == sgs.Card_Heart
			end
		end
	end
end

sgs.ai_skill_cardask["#se_qidian"]=function(self, data)
	local judge = data:toJudge()
	local all_cards = sgs.QList2Table(self.player:getCards("he"))
	if #all_cards==0 then return "." end
	local cards = {}
	for _, card in ipairs(all_cards) do
		table.insert(cards, card)
	end
	if #cards == 0 then return "." end
	if judge.who:hasSkill("se_paoji") and self:isFriend(judge.who) and self:getAllPeachNum()> 0  then
		self:sortByKeepValue(cards)
		for _,bcard in ipairs(cards) do
			if bcard:getSuit() == sgs.Card_Spade then
				return "#se_qidiancard:"..bcard:getEffectiveId()..":"
			end
		end
	end
	if judge.who:hasSkill("se_paoji") and self:isEnemy(judge.who) and self:getAllPeachNum()> 0  then
		self:sortByKeepValue(cards)
		for _,bcard in ipairs(cards) do
			if bcard:getSuit() ~= sgs.Card_Spade then
				return "#se_qidiancard:"..bcard:getEffectiveId()..":"
			end
		end
	end
	if judge.who:hasSkill("Haixing") and self:isFriend(judge.who) and self:getAllPeachNum()> 0  then
		self:sortByKeepValue(cards)
		for _,bcard in ipairs(cards) do
			if bcard:getSuit() == sgs.Card_Diamond or bcard:getSuit() == sgs.Card_Heart or bcard:getNumber() > 8 then
				return "#se_qidiancard:"..bcard:getEffectiveId()..":"
			end
		end
	end
	if judge.who:hasSkill("Haixing") and self:isEnemy(judge.who) and self:getAllPeachNum()> 0  then
		self:sortByKeepValue(cards)
		for _,bcard in ipairs(cards) do
			if bcard:getSuit() ~= sgs.Card_Diamond and bcard:getSuit() ~= sgs.Card_Heart and bcard:getNumber() < 8 then
				return "#se_qidiancard:"..bcard:getEffectiveId()..":"
			end
		end
	end
	if self:needRetrial(judge) then
		local cards = sgs.QList2Table(self.player:getHandcards())
		local card_id = self:getRetrialCardId(cards, judge)
		if card_id ~= -1 then
			return "#se_qidiancard:"..card_id..":"
		end
	end

	return "."
end

--[[sgs.ai_skill_cardask["#se_qidian"]=function(self, data)
    local judge = data:toJudge()	
	local all_cards = sgs.QList2Table(self.player:getCards("he"))
	local all_hcards = sgs.QList2Table(self.player:getCards("h"))
	if #all_cards==0 then return "." end
	local cards = {}
	for _, card in ipairs(all_cards) do
		table.insert(cards, card)
	end
	local hcards={}
	for _, card in ipairs(all_hcards) do
		table.insert(hcards, card)
	end
	if #cards == 0 then return "." end
	
	if judge.who:hasSkill("touhou_sichongcunzai") and self:isFriend(judge.who) and self:getAllPeachNum()> 0  then
		self:sortByKeepValue(cards)
		for _,bcard in ipairs(cards) do
			if bcard:getSuit() == 3 then
				return "#se_qidiancard:"..bcard:getEffectiveId()..":"
			end
		end
	end
	if judge.who:hasSkill("se_paoji") and self:isFriend(judge.who) and self:getAllPeachNum()> 0  then
		self:sortByKeepValue(cards)
		for _,bcard in ipairs(cards) do
			if bcard:getSuit() == sgs.Card_Spade then
				return "#se_qidiancard:"..bcard:getEffectiveId()..":"
			end
		end
	end
	if judge.who:hasSkill("se_paoji") and self:isEnemy(judge.who) and self:getAllPeachNum()> 0  then
		self:sortByKeepValue(cards)
		for _,bcard in ipairs(cards) do
			if bcard:getSuit() ~= sgs.Card_Spade then
				return "#se_qidiancard:"..bcard:getEffectiveId()..":"
			end
		end
	end
	if judge.who:hasSkill("Haixing") and self:isFriend(judge.who) and self:getAllPeachNum()> 0  then
		self:sortByKeepValue(cards)
		for _,bcard in ipairs(cards) do
			if bcard:getSuit() == sgs.Card_Diamond or bcard:getSuit() == sgs.Card_Heart or bcard:getNumber() > 8 then
				return "#se_qidiancard:"..bcard:getEffectiveId()..":"
			end
		end
	end
	if judge.who:hasSkill("Haixing") and self:isEnemy(judge.who) and self:getAllPeachNum()> 0  then
		self:sortByKeepValue(cards)
		for _,bcard in ipairs(cards) do
			if bcard:getSuit() ~= sgs.Card_Diamond and bcard:getSuit() ~= sgs.Card_Heart and bcard:getNumber() < 8 then
				return "#se_qidiancard:"..bcard:getEffectiveId()..":"
			end
		end
	end
	local card_id = self:getRetrialCardId(cards, judge)
	if card_id then
		if not self:needRetrial(judge) and judge.who:hasSkill("luoshen") then return "." end
		--if not self:needRetrial(judge) and judge.who:hasSkill("touhou_sichongcunzai") then return "." end
		local hcard_ids = self:getRetrialCardIdtable(hcards, judge)
		self:sortByKeepValue(hcard_ids)
		for _,acard in ipairs(hcard_ids) do
			if acard:isKindOf("Slash") or (acard:isKindOf("Jink") and self:getCardsNum("Jink")>1) then
				return "#se_qidiancard:"..acard:getEffectiveId()..":"
			end
		end
		for _,acard in ipairs(hcard_ids) do
			if (acard:isKindOf("Weapon")  and self.player:getWeapon()) or (acard:isKindOf("Armor") and self.player:getArmor()) or 
			(acard:isKindOf("DefensiveHorse") and self.player:getDefensiveHorse()) or (acard:isKindOf("OffensiveHorse") and self.player:getOffensiveHorse()) then
				return "#se_qidiancard:"..acard:getEffectiveId()..":"
			end
		end
		if self:needRetrial(judge) then
			local card_ids = self:getRetrialCardIdtable(cards, judge)
			self:sortByKeepValue(card_ids)
			for _,card in ipairs(card_ids) do
				return "#se_qidiancard:"..card:getEffectiveId()..":"
			end
		end
	elseif card_id == -1 then
		if self:needRetrial(judge) then
			self:sortByKeepValue(hcards)
			for _,card in ipairs(hcards) do
				if self:getUseValue(card) >= 6 or self:getKeepValue(card) >= 6 then return end
				return "#se_qidiancard:"..card:getEffectiveId()..":"
			end
		end
	end	
	return false
end
]]

--佟司

se_zhiyu_skill={}
se_zhiyu_skill.name="se_zhiyu"
table.insert(sgs.ai_skills,se_zhiyu_skill)
se_zhiyu_skill.getTurnUseCard=function(self,inclusive)
	if #self.friends <= 1 then return end
	if self.player:isKongcheng() then return end
	local invoke = false
	for _,card in sgs.qlist(self.player:getHandcards()) do
		if card:isKindOf("EquipCard") then
			invoke = true
			break
		end
		if card:getSuit() == sgs.Card_Heart then
			if self.player:isWounded() then
				invoke = true
				break
			else
				if self.player:getHandcardNum() > self.player:getHp() then
					invoke = true
					break
				end
			end
		end
	end
	if not invoke then return end
	return sgs.Card_Parse("#se_zhiyucard:.:")
end

sgs.ai_skill_use_func["#se_zhiyucard"] = function(card,use,self)
	local target
	local card_to
	local de_friend
	for _,card in sgs.qlist(self.player:getHandcards()) do
		if card:isKindOf("Armor") then
			for  _,friend in ipairs(self.friends) do
				if not friend:getArmor() and friend:objectName() ~= self.player:objectName() then
					target = friend
					card_to = card
					break
				end
				if friend:objectName() ~= self.player:objectName() then
					de_friend = friend
				end
			end
			if not target then
				target = de_friend
				card_to = card
			end
		end
		if target then break end
		if card:isKindOf("Weapon") then
			for  _,friend in ipairs(self.friends) do
				if not friend:getWeapon() and friend:objectName() ~= self.player:objectName() then
					target = friend
					card_to = card
					break
				end
				if friend:objectName() ~= self.player:objectName() then
					de_friend = friend
				end
			end
			if not target then
				target = de_friend
				card_to = card
			end
		end
		if target then break end
		if card:isKindOf("DefensiveHorse") then
			for  _,friend in ipairs(self.friends) do
				if not friend:getDefensiveHorse() and friend:objectName() ~= self.player:objectName() then
					target = friend
					card_to = card
					break
				end
				if friend:objectName() ~= self.player:objectName() then
					de_friend = friend
				end
			end
			if not target then
				target = de_friend
				card_to = card
			end
		end
		if target then break end
		if card:isKindOf("OffensiveHorse") then
			for  _,friend in ipairs(self.friends) do
				if not friend:getOffensiveHorse() and friend:objectName() ~= self.player:objectName() then
					target = friend
					card_to = card
					break
				end
				if friend:objectName() ~= self.player:objectName() then
					de_friend = friend
				end
			end
			if not target then
				target = de_friend
				card_to = card
			end
		end
		if target then break end
	end
	if not target then
		for _,card in sgs.qlist(self.player:getHandcards()) do
			if card:getSuit() == sgs.Card_Heart then
				if self.player:isWounded() then
					local hpMin = 100
					for  _,friend in ipairs(self.friends) do
						if friend:getHp() < hpMin and friend:objectName() ~= self.player:objectName() then
							target = friend
							card_to = card
							hpMin = friend:getHp()
						end
					end
				else
					if self.player:getHandcardNum() > self.player:getHp() then
						local hpMin = 100
						for  _,friend in ipairs(self.friends) do
							if friend:getHp() < hpMin and friend:objectName() ~= self.player:objectName() then
								target = friend
								card_to = card
								hpMin = friend:getHp()
							end
						end
					end
				end
			end
			if target then break end
		end
	end
	if target and card_to then
		use.card = sgs.Card_Parse("#se_zhiyucard:"..card_to:getEffectiveId()..":")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_zhiyucard"] = 8
sgs.ai_use_priority["se_zhiyucard"]  = 9.7
sgs.ai_card_intention["se_zhiyucard"]  = -60

se_liaoli_skill={}
se_liaoli_skill.name="se_liaoli"
table.insert(sgs.ai_skills,se_liaoli_skill)
se_liaoli_skill.getTurnUseCard=function(self,inclusive)
	if #self.friends == 0 then return end
	if self.player:hasFlag("se_liaoli_used") then return end
	if self.player:isKongcheng() then return end
	local invoke = false
	local Card_H_Num = 0
	for _,card in sgs.qlist(self.player:getHandcards()) do
		if card:getSuit() ~= sgs.Card_Heart then
			Card_H_Num = Card_H_Num + 1
			if not self.player:isWounded() then
				invoke = true
				break
			end
			for  _,friend in ipairs(self.friends) do
				if friend:getJudgingArea():length() > 0 then
					invoke = true
					break
				end
			end
		end
	end
	if Card_H_Num > self.player:getMaxHp() - self.player:getHp() then
		invoke = true
	end
	if not invoke then return end
	return sgs.Card_Parse("#se_liaolicard:.:")
end

sgs.ai_skill_use_func["#se_liaolicard"] = function(card,use,self)
	local target
	local card_to
	local judge_num = 0
	for  _,friend in ipairs(self.friends) do
		if friend:getJudgingArea():length() > judge_num and friend:getMark("@se_liaoli") == 0 then
			target = friend
			judge_num = friend:getJudgingArea():length()
		end
	end
	if not target then
		local handcard_num = 0
		for  _,friend in ipairs(self.friends) do
			if friend:getHandcardNum() > handcard_num and friend:getMark("@se_liaoli") == 0 then
				target = friend
				handcard_num = friend:getHandcardNum()
			end
		end
	end
	if not target and self.player:getMark("@se_liaoli") == 0 then target = self.player end
	local hcard = self.player:getHandcards()
	local cards=sgs.QList2Table(hcard)
	self:sortByUseValue(cards, true)	
	card_to = cards[1]
	if target and card_to then
		use.card = sgs.Card_Parse("#se_liaolicard:"..card_to:getEffectiveId()..":")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_liaolicard"] = 9
sgs.ai_use_priority["se_liaolicard"]  = 9.8
sgs.ai_card_intention["se_liaolicard"]  = -100

sgs.ai_skill_invoke.se_zhiyu = function(self, data)
	return true
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
se_zhiling_skill.name="se_zhiling"
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
	return sgs.Card_Parse("#se_zhilingcard:.:")
end

sgs.ai_skill_use_func["#se_zhilingcard"] = function(card,use,self)
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
		use.card = sgs.Card_Parse("#se_zhilingcard:.:")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_zhilingcard"] = 9
sgs.ai_use_priority["se_zhilingcard"]  = 9.8
sgs.ai_card_intention["se_zhilingcard"]  = 50

sgs.ai_skill_invoke.SE_Zhixing = function(self, data)
	local dying_data = data:toDying()
	local source = dying_data.who
	for _,p in sgs.qlist(self.room:getAlivePlayers()) do
		if p:isMale() and self:isFriend(source) and not p:isKongcheng() then
			return true
		end
	end
end


sgs.ai_skill_playerchosen.SE_Zhixing = function(self, targets)
	local target
	for _,friend in ipairs(self.friends) do
		if friend:isMale() and friend:getHandcardNum() <= 2 then
			target= friend
			break
		end
	end
	if not target then
		for _,enemy in ipairs(self.enemies) do
			if enemy:isMale() and not enemy:isKongcheng() then
				target= enemy
				break
			end
		end
	end
	if target then return target end
	return false
end

 sgs.ai_cardshow.SE_Zhixing = function(self, requestor)
	local cards = sgs.QList2Table(self.player:getHandcards())
	self:sortByUseValue(cards, true)
	if self:isFriend(requestor) then
		for _, card in ipairs(cards) do
			if card:getSuit() == sgs.Card_Diamond then return card end
		end
	end
	if self:isFriend(requestor) then
		for _, card in ipairs(cards) do
			if card:getSuit() == sgs.Card_Heart then return card end
		end
	end
	return self.player:getRandomHandCard()
end


--莉法
sgs.ai_skill_invoke.SE_Zhuzhen_Trick = function(self, data)
	if #self.friends > 1 then
		return true
	end
	return false
end

sgs.ai_skill_playerchosen.SE_Zhuzhen_Trick = function(self, targets)
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("se_erdao") and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("Xuwu") and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("jizhi") and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:getHp() > 2 and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	return false
end

sgs.ai_skill_invoke.SE_Zhuzhen_Equip = function(self, data)
	return true
end

sgs.ai_skill_invoke.SE_Zhuzhen_Equip = function(self, data)
	if self.player:getPhase() == sgs.Player_NotActive then
		return true
	else
		if #self.friends > 1 then
			return true
		end
	end
	return false
end

sgs.ai_skill_playerchosen.SE_Zhuzhen_Equip = function(self, targets)
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("Zhudao") and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("se_zhiyu") and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("se_erdao") and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("xuanfeng") and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("xiaoji") and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:getHp() > 2 and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	return false
end

sgs.ai_skill_playerchosen.SE_Zhuzhen_Equip_Out = function(self, targets)
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("Zhudao") and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("se_zhiyu") and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("se_erdao") and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("xuanfeng") and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:hasSkill("xiaoji") and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:getHp() > 2 and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	return self.player
end


--灵梦
sgs.ai_skill_invoke.SE_Mengfeng = function(self, data)
	if #self.friends > 1 then
		if (self.player:getHandcardNum() > 3 and self.player:getHp() > 2) or (self.player:getHandcardNum() > 4 and self.player:getHp() > 1) or (self.player:getHandcardNum() > 6 and self.player:getHp() > 0) then
			for _,p in ipairs(self.friends) do
				if ((p:getHp() > 2 and p:getHandcardNum() > 1) or not p:faceUp()) and p:objectName() ~= self.player:objectName() then
					return true
				end
			end
		else
			for _,p in ipairs(self.friends) do
				if not p:faceUp() and p:objectName() ~= self.player:objectName() then
					return true
				end
			end
		end
	end
	if self.room:getAllPlayers(true):length() == 2 then
		if self.player:getHandcardNum() > 1 and self.player:getHp() > 1 then return true end
	end
	return false
end

sgs.ai_skill_playerchosen.SE_Mengfeng = function(self, data)
	if #self.friends > 1 then
		if (self.player:getHandcardNum() > 3 and self.player:getHp() > 2) or (self.player:getHandcardNum() > 4 and self.player:getHp() > 1) or (self.player:getHandcardNum() > 6 and self.player:getHp() > 0) then
			for _,p in ipairs(self.friends) do
				if not p:faceUp() and p:objectName() ~= self.player:objectName() then
					return p
				end
			end
			for _,p in ipairs(self.friends) do
				if (p:getHp() > 2 and p:getHandcardNum() > 1) and p:objectName() ~= self.player:objectName() then
					return p
				end
			end
		else
			for _,p in ipairs(self.friends) do
				if not p:faceUp() and p:objectName() ~= self.player:objectName() then
					return p
				end
			end
		end
	end
	return false
end

sgs.ai_skill_choice.SE_Mengfeng = function(self, choices, data)
	if #self.friends > 1 then
		if (self.player:getHandcardNum() > 3 and self.player:getHp() > 2) or (self.player:getHandcardNum() > 4 and self.player:getHp() > 1) or (self.player:getHandcardNum() > 6 and self.player:getHp() > 0) then
			for _,p in ipairs(self.friends) do
				if not p:faceUp() and p:objectName() ~= self.player:objectName() then
					return "TurnOver_target"
				end
			end
			for _,p in ipairs(self.friends) do
				if (p:getHp() > 2 and p:getHandcardNum() > 1) and p:objectName() ~= self.player:objectName() then
					return "LoseHp_target"
				end
			end
		else
			for _,p in ipairs(self.friends) do
				if not p:faceUp() and p:objectName() ~= self.player:objectName() then
					return "TurnOver_target"
				end
			end
		end
	end
	return false
end


sgs.ai_skill_invoke.SE_Nagong = function(self, data)
	local Reimu = self.room:findPlayerBySkillName("SE_Nagong")
	if self:isFriend(Reimu) then
		if (self.player:getHandcardNum() > 1 and self.player:getHp() < 2) or (self.player:getHandcardNum() > 1 and self.player:getHp() < self.player:getMaxHp()) or self.player:getHandcardNum() > 2 then
			return true
		end
		if self.player:hasFlag("SE_Mengfeng_Turn") then
			if self.player:getHandcardNum() > 1 then
				return true
			end
		end
	end
	return false
end

sgs.ai_skill_invoke.SE_Nagong_Geiqian_2 = function(self, data)
	local Reimu = self.room:findPlayerBySkillName("SE_Nagong")
	if self:isFriend(Reimu) then
		if (self.player:getHandcardNum() > 0 and self.player:getHp() < 2) or (self.player:getHandcardNum() > 0 and self.player:getHp() < self.player:getMaxHp()) or self.player:getHandcardNum() > 3 then
			return true
		end
		if self.player:hasSkill("se_zhuren") then
			return true
		end
	end
	return false
end

--黑猫

sgs.ai_skill_invoke.SE_Yishi = function(self, data)
	for _,p in ipairs(self.friends) do
		if p:isMale() then
			return true
		end
	end
	return false
end

sgs.ai_skill_playerchosen.SE_Yishi = function(self, targets)
	local lord = self.room:getLord()
	for _,p in ipairs(self.friends) do
		if p:isMale() and p:objectName() == lord:objectName() then
			return p
		end
	end
	local hp = 0
	local max_man
	local hp_min = 100
	local min_man
	for _,p in ipairs(self.friends) do
		if p:isMale() and p:getHp() > hp then
			hp = p:getHp()
			max_man = p
		end
		if p:isMale() and p:getHp() < hp_min then
			hp_min = p:getHp()
			min_man = p
		end
	end
	if hp_min == 1 then return min_man end
	return max_man
end

se_dushe_skill={}
se_dushe_skill.name="se_dushe"
table.insert(sgs.ai_skills,se_dushe_skill)
se_dushe_skill.getTurnUseCard=function(self,inclusive)
	local source = self.player
	if self.player:hasFlag("se_dushecard") then return end
	if #self.enemies < 1 or self.player:isKongcheng() then return end
	local can_man = false
	for _,enemy in ipairs(self.enemies) do
		if enemy:getHandcardNum() > 0 then
			can_man = true
		end
	end
	if not can_man then return end
	local cards=sgs.QList2Table(self.player:getHandcards())
	local OK = false
	for _,card in ipairs(cards) do
		if card:getNumber() > 8 then
			OK =true
		end
	end
	if OK then
		return sgs.Card_Parse("#se_dushecard:.:")
	end
end

sgs.ai_skill_use_func["#se_dushecard"] = function(card,use,self)
	use.card = sgs.Card_Parse("#se_dushecard:.:")
	return
end

sgs.ai_skill_playerchosen.se_dushecard = function(self, targets)
	local B
	local R
	for _,card in sgs.qlist(self.player:getHandcards()) do 
		if card:isBlack() then B = true end
		if card:isRed() then R = true end
	end
	if B then
		for _,enemy in ipairs(self.enemies) do
			if enemy:isAlive() and not enemy:isKongcheng() and not enemy:hasSkill("tuntian") and not (enemy:getHandcardNum() == 1 and enemy:hasSkill("kongcheng")) then
				if enemy:getEquips():length() > 2 then
					self.room:setPlayerFlag(enemy,"se_dushe_Equip")
					return enemy
				end
			end
		end
	end
	if R then
		for _,enemy in ipairs(self.enemies) do
			if enemy:isAlive() and not enemy:isKongcheng() and not enemy:hasSkill("tuntian") and not (enemy:getHandcardNum() == 1 and enemy:hasSkill("kongcheng")) then
				if enemy:getHp() == 1 or enemy:getHp() == 2 then
					self.room:setPlayerFlag(enemy,"se_dushe_Dm")
					return enemy
				end
			end
		end
	end
	if B then
		for _,enemy in ipairs(self.enemies) do
			if enemy:isAlive() and not enemy:isKongcheng() and not enemy:hasSkill("tuntian") and not (enemy:getHandcardNum() == 1 and enemy:hasSkill("kongcheng")) then
				if enemy:getEquips():length() > 1 then
					self.room:setPlayerFlag(enemy,"se_dushe_Equip")
					return enemy
				end
			end
		end
	end
	if R then
		for _,enemy in ipairs(self.enemies) do
			if enemy:isAlive() and not enemy:isKongcheng() and not enemy:hasSkill("tuntian") and not (enemy:getHandcardNum() == 1 and enemy:hasSkill("kongcheng")) then
				self.room:setPlayerFlag(enemy,"se_dushe_Dm")
				return enemy
			end
		end
	end
end

sgs.ai_skill_pindian["se_dushecard"] = function(minusecard, self, requestor, maxcard, mincard)
	return maxcard
end

sgs.ai_skill_choice.se_dushecard = function(self, choices, data)
	for _,p in sgs.qlist(self.room:getAlivePlayers()) do
		if p:hasFlag("se_dushe_Equip") then return "se_dushe_Discard" end
		if p:hasFlag("se_dushe_Dm") then return "se_dushe_Damage" end
	end
	return false
end

sgs.ai_use_priority["se_dushecard"] = 4
sgs.ai_card_intention["se_dushecard"]  = 80


--杉崎鍵
sgs.ai_skill_invoke.SE_Kurimu = function(self, data)
	return true
end

sgs.ai_skill_invoke.SE_Minatsu = function(self, data)
	if #self.enemies == 0 then return false end
	return true
end

sgs.ai_skill_invoke.SE_Chizuru = function(self, data)
	return true
end

sgs.ai_skill_invoke.SE_Mafuyu = function(self, data)
	if #self.enemies == 0 then return false end
	return true
end

sgs.ai_skill_playerchosen.SE_Kurimu = function(self, targets)
	for _,friend in ipairs(self.friends) do
		if friend:getHandcardNum() < 3 and friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	return targets[1]
end

sgs.ai_skill_playerchosen.SE_Minatsu = function(self, targets)
	if #self.enemies == 0 then return self.player end
	self:sort(self.enemies, "defense") 
	for _,enemy in ipairs(self.enemies) do
		if enemy then
			return enemy
		end
	end
	return self.enemies[1]
end

sgs.ai_skill_playerchosen.SE_Chizuru = function(self, targets)
	local minHp = 100
	local target
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
	if target then
		return target
	end
	return self.player
end

sgs.ai_skill_playerchosen.SE_Mafuyu = function(self, targets)
	local card_num = 0
	local target
	if #self.enemies == 0 then return self.player end
	for _,enemy in ipairs(self.enemies) do
		if enemy:getHandcardNum() - enemy:getHp() > card_num then
			target = enemy
			card_num = enemy:getHandcardNum() - enemy:getHp()
		end
	end
	if target then
		return target
	end
	return self.enemies[1]
end

--黑雪姬

se_xunyu_skill={}
se_xunyu_skill.name="se_xunyu"
table.insert(sgs.ai_skills,se_xunyu_skill)
se_xunyu_skill.getTurnUseCard=function(self,inclusive)
	if #self.enemies < 1 then return end
	if self.player:isKongcheng() then return end
	local cards=sgs.QList2Table(self.player:getHandcards())
	if self.player:getMark("@SE_Chaopin_Red") > 0 then
		if self.player:hasUsed("#se_xunyucard") then return end
		return sgs.Card_Parse("#se_xunyucard:.:")
	end
	local card_OK = false
	for _,acard in ipairs(cards) do
		if not acard:isKindOf("Jink") and not acard:isKindOf("Peach") and not acard:isKindOf("Analeptic") then
			card_OK = true
		end
	end
	if not card_OK then return end
	if self.player:getMark("@SE_Chaopin_Blue") > 0 then
		if self.player:usedTimes("#se_xunyucard") >= 3 then return end
	elseif self.player:getMark("@SE_Chaopin_Blue") == 0 then
		if self.player:hasUsed("#se_xunyucard") then return end
	end
	if self.player:getMark("@SE_Chaopin_Green") > 0 then return end
	for _,enemy in ipairs(self.enemies) do
		if self.player:inMyAttackRange(enemy) and not isEquip("EightDiagram",enemy) and not isEquip("Vine",enemy) then
			return sgs.Card_Parse("#se_xunyucard:.:")
		end
	end
end

sgs.ai_skill_use_func["#se_xunyucard"] = function(card,use,self)
	local cards=sgs.QList2Table(self.player:getHandcards())
	local target
	local card
	if self.player:getMark("@SE_Chaopin_Red") > 0 then
		for _,enemy in ipairs(self.enemies) do
			if not self:hasSkills(sgs.masochism_skill, enemy) then
				target = enemy
			end
		end
		for _,enemy in ipairs(self.enemies) do
			if not self:hasSkills(sgs.masochism_skill, enemy) and enemy:getHp() == 1 then
				target = enemy
			end
		end
		if not target then target = self.enemies[1] end
		use.card = sgs.Card_Parse("#se_xunyucard:.:")
		if use.to then use.to:append(target) end
		return
	end
	for _,acard in ipairs(cards) do
		if not acard:isKindOf("Jink") and not acard:isKindOf("Peach") and not acard:isKindOf("Analeptic") then
			card = acard
		end
	end
	if self.player:getMark("@SE_Chaopin_Blue") > 0 then
		card = cards[1]
	end
	local min_people
	local min_Hp = 100
	for _,enemy in ipairs(self.enemies) do
		if not self:hasSkills(sgs.masochism_skill, enemy) and self.player:inMyAttackRange(enemy) and not isEquip("EightDiagram",enemy) and not isEquip("Vine",enemy) then
			if enemy:getHp() <= min_Hp then
				min_people = enemy
				min_Hp = enemy:getHp()
			end
		end
	end
	if self.player:getMark("@SE_Chaopin_Blue") > 0 then
		local min_Hp = 100
		for _,enemy in ipairs(self.enemies) do
			if self.player:inMyAttackRange(enemy) and not isEquip("Vine",enemy) then
				if enemy:getHp() <= min_Hp then
					min_people = enemy
					min_Hp = enemy:getHp()
				end
			end
		end
		local min_Hp = 100
		for _,enemy in ipairs(self.enemies) do
			if not self:hasSkills(sgs.masochism_skill, enemy) and self.player:inMyAttackRange(enemy) then
				if enemy:getHp() <= min_Hp then
					min_people = enemy
					min_Hp = enemy:getHp()
				end
			end
		end
	end
	target = min_people
	if target and card then
		use.card = sgs.Card_Parse("#se_xunyucard:"..card:getEffectiveId()..":")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_xunyucard"] = 9
sgs.ai_use_priority["se_xunyucard"]  = 3.2
sgs.ai_card_intention["se_xunyucard"]  = 80



sgs.ai_skill_invoke.SE_Chaopin = function(self, data)
	return true
end

sgs.ai_skill_choice.SE_Chaopin = function(self, choices, data)
	local weak = #self.enemies - #self.friends
	local can_Slash =false
	for _,enemy in ipairs(self.enemies) do
		if self.player:inMyAttackRange(enemy) then
			can_slash = true
		end
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy:getHp() == 1 then
			if self.player:inMyAttackRange(enemy) then
				if self.player:getHandcardNum() < 2 then
					return "SE_Chaopin_Red"
				else
					return "SE_Chaopin_Blue"
				end
			else
				return "SE_Chaopin_Red"
			end
		end
	end
	if weak == 1 then--注意攻击范围
		if self.player:getHandcardNum() < 2 then return "SE_Chaopin_Green" end
		if self.player:getHandcardNum() < 4 then return "SE_Chaopin_Red" end
		if not can_slash then return "SE_Chaopin_Red" end
		return "SE_Chaopin_Blue"
	elseif weak > 1 then
		if self.player:getHandcardNum() < 5 then return "SE_Chaopin_Green" end
		if not can_slash then return "SE_Chaopin_Green" end
		return "SE_Chaopin_Blue"
	elseif weak == 0 or weak == -1 then
		if self.player:getHandcardNum() < 3 then return "SE_Chaopin_Green" end
		if self.player:getHandcardNum() < 5 then return "SE_Chaopin_Red" end
		if not can_slash then return "SE_Chaopin_Red" end
		return "SE_Chaopin_Blue"
	elseif weak < -1 then
		if self.player:getHandcardNum() < 5 then return "SE_Chaopin_Green" end
		if not can_slash then return "SE_Chaopin_Green" end
		return "SE_Chaopin_Blue"
	end
end


--永瀬伊織
sgs.ai_need_damaged.SE_Qifen = function (self, attacker)
	return self.player:getHp() < self.player:getMaxHp()
end

sgs.SE_Qifen_keep_value = 
{
    Peach 		= 9,
    Analeptic 	= 8,
}

sgs.ai_skill_invoke.SE_Qifen = function(self, data)
	if self.player:getHp() < self.player:getMaxHp() then return true end
	if self.player:getHp() == self.player:getMaxHp() then
		if #self.friends >= #self.enemies then return true end
	end
	return false
end
--sgs.ai_skillInvoke_intention.SE_Qifen = -5

sgs.ai_skill_invoke.SE_Mishi = function(self, data)
	local dying_data = data:toDying()
	local source = dying_data.who
	local mygod= self.room:findPlayerBySkillName("SE_Mishi")
	local good
	if (self:isFriend(source) and not self:isFriend(mygod)) or (not self:isFriend(source) and self:isFriend(mygod)) then
		good = true
	end
	if not good then return false end
	local peach_num = 0
	local jink_num = 0
	for _,card in sgs.qlist(mygod:getHandcards()) do
		if card:isKindOf("Peach") or card:isKindOf("Analeptic") then
			peach_num = peach_num + 1
		end
		if card:isKindOf("Jink") then
			jink_num = jink_num + 1
		end
	end
	if good then
		if mygod:getHp() > 0 and peach_num > 2 then return true end
		if mygod:getHp() > 0 and peach_num > 1 and jink_num > 0 then return true end
		if mygod:getHp() > 1 and peach_num > 1 then return true end
		if mygod:getHp() > 1 and peach_num > 0 and jink_num > 0 then return true end
		if mygod:getHp() > 2 and peach_num > 0 then return true end
		if mygod:getHp() > 2 and jink_num > 0 then return true end
	end
	return false
end
--sgs.ai_skillInvoke_intention.SE_Mishi = 100

sgs.ai_skill_invoke.SE_Zhufu = function(self, data)
	if #self.friends <= 1 then return false end
	return true
end

sgs.ai_skill_playerchosen.SE_Zhufu = function(self, targets)
	local max_num = 0
	local good_to
	for _,friend in ipairs(self.friends) do
		if self.player:getHandcardNum() - friend:getHandcardNum() > max_num and friend:objectName() ~= self.player:objectName() then
			good_to = friend
			max_num = self.player:getHandcardNum() - friend:getHandcardNum()
		end
	end
	if good_to then return good_to end
	for _,friend in ipairs(self.friends) do
		if friend:objectName() ~= self.player:objectName() then
			return friend
		end
	end
	return self.friends[1]
end

--sgs.ai_skillInvoke_intention.SE_Zhufu = -100

--风早翔太
sgs.ai_skill_invoke.SE_Xiuse = function(self, data)
	local hp = self.player:getHp()
	local list = self.room:getAlivePlayers()
	local targets_f = sgs.SPlayerList()
	local targets_e = sgs.SPlayerList()
	for _,p in sgs.qlist(list) do
		if not p:isMale() and self:isFriend(p) then
			targets_f:append(p)
		end
	end
	for _,p in sgs.qlist(list) do
		if not p:isMale() and self:isEnemy(p) then
			targets_e:append(p)
		end
	end
	if targets_f:length() > 0 then return true end
	if hp <= 1 then
		if targets_e:length() > 0 then
			return true
		end
	end
	return false
end

sgs.ai_skill_playerchosen.SE_Xiuse = function(self, targets)
	local hp = self.player:getHp()
	local list = self.room:getAlivePlayers()
	local targets_f = sgs.SPlayerList()
	local targets_e = sgs.SPlayerList()
	for _,p in sgs.qlist(list) do
		if not p:isMale() and self:isFriend(p) then
			targets_f:append(p)
		end
	end
	for _,p in sgs.qlist(list) do
		if not p:isMale() and self:isEnemy(p) then
			targets_e:append(p)
		end
	end
	if hp <= 1 then
		if targets_e:length() > 0 then
			for _,enemy in sgs.qlist(targets_e) do
				if enemy:getHp() < 2 and enemy:faceUp() then
					return enemy
				end
			end
			for _,enemy in sgs.qlist(targets_e) do
				if enemy and enemy:faceUp() then
					return enemy
				end
			end
		end
	end
	if targets_f:length() > 0 then
		for _,friend in sgs.qlist(targets_f) do
			if friend:getHp() < 2 then
				return friend
			end
		end
		for _,friend in sgs.qlist(targets_f) do
			if friend then
				return friend
			end
		end
	end
	for _,friend in sgs.qlist(targets_f) do
		if friend then
			return friend
		end
	end
end

sgs.ai_skill_invoke.SE_Shuanglang = function(self, data)
	local target = self.room:getCurrent()
	local Godsan=self.room:findPlayerBySkillName("SE_Shuanglang")
	if data:toDamage() then
		local victim = data:toDamage().to
		if Godsan and self:isFriend(victim) then
			return true
		end
	end
	if Godsan and self:isFriend(target) then
		return true
	end
	return false
end
--sgs.ai_skillInvoke_intention.SE_Shuanglang = -100

sgs.ai_skill_invoke.SE_Lianmu = function(self, data)
	local list = self.room:getAlivePlayers()
	local targets_f = sgs.SPlayerList()
	for _,p in sgs.qlist(list) do
		if not p:isMale() and self:isFriend(p) then
			targets_f:append(p)
		end
	end
	if targets_f:length() > 0 then return true end
	return false
end

sgs.ai_skill_playerchosen.SE_Lianmu = function(self, targets)
	local list = self.room:getAlivePlayers()
	local targets_f = sgs.SPlayerList()
	for _,p in sgs.qlist(list) do
		if not p:isMale() and self:isFriend(p) then
			targets_f:append(p)
		end
	end
	local min_Hp = 100
	local target
	if self:isFriend(self.room:getLord()) and self.room:getLord():getHp() <= 2 then
		return self.room:getLord()
	end
	for _,friend in sgs.qlist(targets_f) do
		if friend:getHp() < min_Hp then
			min_Hp = friend:getHp()
			target = friend
		end
	end
	if target then return target end
	for _,friend in sgs.qlist(targets_f) do
		if friend then
			return friend
		end
	end
end
--sgs.ai_skillInvoke_intention.SE_Lianmu = -100

--新垣あやせ
sgs.ai_skill_invoke.SE_Feiti = function(self, data)
	local list = self.room:getAlivePlayers()
	local targets = sgs.SPlayerList()
	for _,p in sgs.qlist(list) do
		if p:isMale() then
			targets:append(p)
		end
	end
	if targets:length() > 0 then return true end
	return false
end

sgs.ai_skill_playerchosen.SE_Feiti = function(self, targets)
	local list = self.room:getAlivePlayers()
	local targets = sgs.SPlayerList()
	for _,p in sgs.qlist(list) do
		if p:isMale() then
			targets:append(p)
		end
	end
	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) and p:hasSkill("SE_Shuanglang") then
			return p
		end
	end
	local card_num = 100
	local target
	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) then
			if p:getHandcardNum() < card_num then
				target = p
				card_num = p:getHandcardNum()
			end
		end
	end
	if target then
		return target
	end
	for _,p in sgs.qlist(targets) do
		return p
	end
end


sgs.ai_skill_choice.SE_Feiti = function(self, choices, data)
	local list = self.room:getAlivePlayers()
	local target
	for _,p in sgs.qlist(list) do
		if p:hasFlag("SE_Feiti_Target") then
			target = p
		end
	end
	if self:isFriend(target) then return "SE_Feiti_Get" end
	return "SE_Feiti_Not_Get"
end

--[[sgs.ai_skillInvoke_intention.SE_Feiti = function(from, to, yesorno)
	if to:hasFlag("SE_Feiti_Good") then
		sgs.updateIntention(from, to, -80)
	else
		sgs.updateIntention(from, to, 60)
	end
end]]
--(暂时有问题)
sgs.ai_skill_invoke.SE_Menghei = function(self, data)
	local damage = data:toDamage()
	if self.player:objectName() == damage.from:objectName() then
		if self:isEnemy(damage.to) then
			return true
		end
	end
	if self.player:objectName() == damage.to:objectName() then
		local danteng = damage.from
		for _,p in sgs.qlist(self.room:getAlivePlayers()) do
			if danteng:distanceTo(p) <= 1 then
				if self:isEnemy(p) then
					return true
				end
			end
		end
	end
	return false
end

sgs.ai_skill_playerchosen.SE_Menghei = function(self, targets)
	local hp_min = 100
	local target
	for _, ap in sgs.qlist(targets) do
		if self:isEnemy(ap) and ap:getHp() < hp_min then
			target = ap
			hp_min = ap:getHp()
		end
	end
	if target then return target end
	return targets:first()
end
--sgs.ai_skillInvoke_intention.SE_Menghei = -45

se_gaobai_skill={}
se_gaobai_skill.name="se_gaobai"
table.insert(sgs.ai_skills,se_gaobai_skill)
se_gaobai_skill.getTurnUseCard=function(self,inclusive)
	if self.player:getMark("@Gaobai") < 1 then return end
	if #self.friends < 1 then return end
	local OK = false
	for _,p in sgs.qlist(self.room:getAlivePlayers()) do
		if p:isMale() and self:isFriend(p) and p:getHp() == 1 then
			OK = true
		end
		if p:isMale() and self:isFriend(p) and p:getHp() == 2 and self.player:getHp() == 1 and p:getMaxHp() == 3 then
			OK = true
		end
	end
	if OK then
		return sgs.Card_Parse("#se_gaobaicard:.:")
	end
	return
end

sgs.ai_skill_use_func["#se_gaobaicard"] = function(card,use,self)
	local target
	for _,p in sgs.qlist(self.room:getAlivePlayers()) do
		if p:isMale() and self:isFriend(p) and p:getHp() == 1 then
			target = p
		end
		if p:isMale() and self:isFriend(p) and p:getHp() == 2 and self.player:getHp() == 1 and p:getMaxHp() == 3 then
			target = p
		end
		if p:isMale() and self:isFriend(p) and p:getHp() == 1 and p:getMaxHp() == 3 then
			target = p
		end
	end
	if target then
		use.card = card
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_gaobaicard"] = 10
sgs.ai_use_priority["se_gaobaicard"]  = 4
sgs.ai_card_intention.se_gaobaicard = -100

--阿卡林
sgs.ai_skill_invoke.SE_Touming = function(self, data)
	local num = self.room:getAlivePlayers():length()
	if num > 3 then return true end
	if self.player:getHp() < 3 then return true end
	return false
end

sgs.ai_skill_invoke.SE_Tuanzi = function(self, data)
	local card = data:toCardUse().card
	local people = self.player:getNextAlive()
	if card:isKindOf("Peach") or card:isKindOf("Jink") or  card:isKindOf("Analeptic") or card:isKindOf("EquipCard") or card:isNDTrick() then
		if self:isFriend(people) then return true end
		if self.player:getHandcardNum() - self.player:getHp() < 2 then return true end
		return false
	end
	if self:isFriend(people) and isEquip("Crossbow", people) then
		if card:isKindOf("Slash") then return true end
	end
	return false
end

--比企鹅
sgs.ai_skill_invoke.SE_Zishang = function(self, data)
	local damage = data:toDamage()
	local victim = damage.to
	if self:isFriend(victim) then
		if self.player:getHp() > 2 or (victim:getHp() == 1 and self.player:getHp() > 1) then
			for _,friend in ipairs(self.friends) do
				if friend:getHp() < friend:getMaxHp() and friend:objectName() ~= self.player:objectName() then
					if self:isEnemy(damage.from) then return true end
				end
			end
		end
	end
	if self.room:getAllPlayers(true):length() == 2 then
		if self.player:getHp() >=2 and victim:faceUp() then return true end
	end
	return false
end

sgs.ai_skill_playerchosen.SE_Zishang = function(self, targets)
	local hp_min = 100
	local target
	for _, ap in sgs.qlist(targets) do
		if self:isFriend(ap) and ap:getHp() < hp_min then
			target = ap
			hp_min = ap:getHp()
		end
	end
	if target then return target end
	return targets:first()
end
--sgs.ai_skillInvoke_intention.SE_Zishang = -60

sgs.ai_skill_choice.SE_Zibi = function(self, data)
	if self.player:getHp() < self.player:getMaxHp() then
		return "SE_Zibi_R"
	end
	return "SE_Zibi_D"
end

--千百合
se_huanyuan_skill={}
se_huanyuan_skill.name="se_huanyuan"
table.insert(sgs.ai_skills,se_huanyuan_skill)
se_huanyuan_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasFlag("se_huanyuan_used") then return end
	if self.player:getMark("se_huanyuan_Pre_MaxHp") <= 0 then return end
	if #self.friends < 2 and #self.enemies < 1 then return end
	for _,friend in ipairs(self.friends) do
		if friend:getMark("se_huanyuan_Pre_Hp") - friend:getHp() + (friend:getMark("se_huanyuan_Pre_MaxHp") - friend:getMaxHp())*2 > 0 then
			return sgs.Card_Parse("#se_huanyuancard:.:")
		end
		if friend:getMark("se_huanyuan_Pre_Handcards") > friend:getHandcardNum() then
			return sgs.Card_Parse("#se_huanyuancard:.:")
		end
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy:getHp() - enemy:getMark("se_huanyuan_Pre_Hp") + (enemy:getMaxHp() - enemy:getMark("se_huanyuan_Pre_MaxHp"))*2>0 then
			return sgs.Card_Parse("#se_huanyuancard:.:")
		end
	end
	return
end

sgs.ai_skill_use_func["#se_huanyuancard"] = function(card,use,self)
	local target
	local value = 0
	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
		local p_v = 0
		if self:isFriend(p) then
			if p:getMark("se_huanyuan_Pre_Hp") - p:getHp() + (p:getMark("se_huanyuan_Pre_MaxHp") - p:getMaxHp())*2> p_v then
				p_v = p:getMark("se_huanyuan_Pre_Hp") - p:getHp() + (p:getMark("se_huanyuan_Pre_MaxHp") - p:getMaxHp())*2
			end
			if p:getMark("se_huanyuan_Pre_Handcards") - p:getHandcardNum() > p_v*2 then
				p_v = (p:getMark("se_huanyuan_Pre_Handcards") - p:getHandcardNum())/2
			end
		elseif self:isEnemy(p) then
			if p:getHp() - p:getMark("se_huanyuan_Pre_Hp") + (p:getMaxHp() - p:getMark("se_huanyuan_Pre_MaxHp"))*2> p_v then
				p_v = p:getHp() - p:getMark("se_huanyuan_Pre_Hp") + (p:getMaxHp() - p:getMark("se_huanyuan_Pre_MaxHp"))*2
			end
		end
		if p_v > value then
			value = p_v
			target = p
		end
	end
	if target then
		use.card = card
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_huanyuancard"] = 10
sgs.ai_use_priority["se_huanyuancard"]  = 2
sgs.ai_card_intention.se_huanyuancard = -20

se_chengling_skill={}
se_chengling_skill.name="se_chengling"
table.insert(sgs.ai_skills,se_chengling_skill)
se_chengling_skill.getTurnUseCard=function(self,inclusive)
	if self.player:getMark("@LimeBell") < 1 then return end
	if #self.friends < 2 then return end
	local OK = 0
	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
		if self:isFriend(p) and p:getMaxHp() - p:getHp() >= 2 then
			OK = OK + 1
		end
		if self:isFriend(p) and self.player:getHp() == 1 and p:getMaxHp() - p:getHp() >= 1 then
			OK = OK + 1
		end
		if self:isEnemy(p) and p:getMark("@waked") > 0 and p:getHp() > 2 then
			OK = OK + 1
		end
	end
	if #self.friends == 1 then OK = OK + 1 end
	if OK > 1 then
		return sgs.Card_Parse("#se_chenglingcard:.:")
	end
	return
end

sgs.ai_skill_use_func["#se_chenglingcard"] = function(card,use,self)
	local targets = sgs.SPlayerList()
	for _,enemy in ipairs(self.enemies) do
		if enemy:getMark("@waked") > 0 and enemy:getHp() > 2 and targets:length() < 2 then
			targets:append(enemy)
		end
	end
	for _,friend in ipairs(self.friends) do
		if (friend:getMaxHp() - friend:getHp() >= 2 or (self.player:getHp() == 1 and friend:getMaxHp() - friend:getHp() >= 1)) and targets:length() < 2 then
			targets:append(friend)
		end
	end
	if targets then
		use.card = sgs.Card_Parse("#se_chenglingcard:.:")
		if use.to then use.to = targets end
		return
	end
end

sgs.ai_use_value["se_chenglingcard"] = 10
sgs.ai_use_priority["se_chenglingcard"]  = 7
sgs.ai_card_intention.se_chenglingcard = -100

--艾
sgs.ai_skill_invoke.SE_Shouzang = function(self, data)
	local dying_data = data:toDying()
	local source = dying_data.who
	if self:isEnemy(source) then return true end
	return false
end

sgs.ai_skill_invoke.SE_Xiangren = function(self, data)
	local dying_data = data:toDying()
	local source = dying_data.who
	if self:isFriend(source) then return true end
	return false
end

--锁部叶风
se_jiejie_skill={}
se_jiejie_skill.name="se_jiejie"
table.insert(sgs.ai_skills,se_jiejie_skill)
se_jiejie_skill.getTurnUseCard=function(self,inclusive)
	local source = self.player
	if source:getMark("@MagicEquip") == 0 then return end
	local target = 0
	for _,friend in ipairs(self.friends) do
		if friend:getMark("@Kekkai") == 0 then
			target = 1
			break
		end
	end
	if target == 1 then
		return sgs.Card_Parse("#se_jiejiecard:.:")
	end
	return
end

sgs.ai_skill_use_func["#se_jiejiecard"] = function(card,use,self)
	local target
	local minHp = 100
	for _,friend in ipairs(self.friends) do
		if friend:getMark("@Kekkai") == 0 then
			local hp = friend:getHp()
			if self:hasSkills(sgs.masochism_skill, friend) then
				hp = hp + 1
			end
			if friend:isLord() then
				hp = hp - 1
			end
			if hp < minHp then
				minHp = hp
				target = friend
			end
		end
	end
	if self.player:getHp() < 3 and self.player:getMark("@Kekkai") == 0 then
		target = self.player
	end
	if target then
		use.card = sgs.Card_Parse("#se_jiejiecard:.:")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_jiejiecard"] = 6
sgs.ai_use_priority["se_jiejiecard"] = 9
sgs.ai_card_intention["se_jiejiecard"]  = -100

--五河琴里
se_jiangui_skill={}
se_jiangui_skill.name="se_jiangui"
table.insert(sgs.ai_skills,se_jiangui_skill)
se_jiangui_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasUsed("#se_jianguicard") then return end
	if #self.enemies < 1 then return end
	return sgs.Card_Parse("#se_jianguicard:.:")
end

sgs.ai_skill_use_func["#se_jianguicard"] = function(card,use,self)
	local targets = sgs.SPlayerList()
	for _,enemy in ipairs(self.enemies) do
		if enemy then
			targets:append(enemy)
		end
	end
	if targets then
		use.card = sgs.Card_Parse("#se_jianguicard:.:")
		use.to = targets
		return
	end
end

sgs.ai_use_value["se_jianguicard"] = 10
sgs.ai_use_priority["se_jianguicard"] = 9
sgs.ai_card_intention["se_jianguicard"]  = 60

sgs.ai_skill_invoke.SE_Wufan = function(self, data)
	if #self.enemies == 0 then return false end
	if self.player:getMark("@Efreet") >= 4 then return true end
	local total_enemy_num,average_enemy_hp,least_enemy_hp = checkEnemyDetailed(self, data)
	local total_friend_num,average_friend_hp,least_friend_hp = checkFriendDetailed(self, data)
	local hp = self.player:getHp()
	if self.player:getMark("@Efreet") == 3 then
		if hp < 3 then return true end
		if least_enemy_hp == 1 then return true end
		if total_friend_num < total_enemy_num or average_enemy_hp >= average_friend_hp then return true end
		if total_friend_num == total_enemy_num and average_enemy_hp >= average_friend_hp + 1 then return true end
		if total_friend_num > total_enemy_num then return true end
	elseif self.player:getMark("@Efreet") == 2 then
		if total_friend_num + 1 < total_enemy_num or average_enemy_hp > average_friend_hp + 1 then return true end
		if least_enemy_hp == 1 then return true end
		if hp < 2 then return true end
		if total_friend_num <=2 then return true end
	elseif self.player:getMark("@Efreet") == 1 then
		if hp < 2 and total_friend_num <= 2 then return true end
		if total_friend_num == 1 and total_enemy_num > 1 then return true end
	end	
	return false
end

--对对方全面调查
function checkEnemyDetailed(self, data)
	local total_enemy_num = 0
	local average_enemy_hp = 0
	local least_enemy_hp = 100
	for _,enemy in ipairs(self.enemies) do
		total_enemy_num = total_enemy_num + 1
		average_enemy_hp = average_enemy_hp + enemy:getHp()
		if enemy:getHp() < least_enemy_hp then
			least_enemy_hp = enemy:getHp()
		end
	end
	average_enemy_hp = average_enemy_hp / total_enemy_num
	return total_enemy_num,average_enemy_hp,least_enemy_hp
end

function checkFriendDetailed(self, data)
	local total_friend_num = 0
	local average_friend_hp = 0
	local least_friend_hp = 100
	for _,friend in ipairs(self.friends) do
		total_friend_num = total_friend_num + 1
		average_friend_hp = average_friend_hp + friend:getHp()
		if friend:getHp() < least_friend_hp then
			least_friend_hp = friend:getHp()
		end
	end
	average_friend_hp = average_friend_hp / total_friend_num
	return total_friend_num,average_friend_hp,least_friend_hp
end


--亚里亚
sgs.ai_skill_invoke.SE_Shuangqiang = function(self, data)
	local damage = data:toDamage()
	local source = damage.to
	if self:isEnemy(source) then
		return true
	end
	return false
end

sgs.ai_skill_invoke.SE_Xinlai = function(self, data)
	local damage = data:toDamage()
	local source = damage.to
	if self:isEnemy(source) then
		return true
	end
	return false
end

sgs.ai_skill_choice["SE_Xinlai"] = function(self, choices, data)
	local target = data:toPlayer()
	if self:isFriend(target) then
		return string.format("Give Card to:"..target:getGeneralName())
	end
	return "SE_Xinlai_Not"
end

--雷姬
sgs.ai_skill_invoke.SE_Zhiyuan = function(self, data)
	return true
end

sgs.ai_skill_choice["SE_Zhiyuan"] = function(self, choices, data)
	local target = data:toPlayer()
	if self:isFriend(target) then
		return string.format("Make Judge on:"..target:getGeneralName())
	end
	return "SE_Zhiyuan_Not"
end

--右代宫缘寿
sgs.ai_skill_invoke["SE_Qizhuang"] = function(self, data)
	if #self.enemies > 0 then
		return true
	end
	return false
end

sgs.ai_skill_playerchosen["Lucifer"] = function(self, targets)
	local target
	local min_hp = 100
	for _,ap in sgs.qlist(targets) do
		if self:isEnemy(ap) and ap:getMark("@Belphegor") == 0 then
			if self:hasSkills(sgs.masochism_skill, ap) then return ap end
			if ap:getHp() < min_hp then
				min_hp = ap:getHp()
				target = ap
			end
		end
	end
	if target then return target end
	return self.enemies[1]
end
--sgs.ai_skillInvoke_intention["Lucifer"] = 80

sgs.ai_skill_playerchosen["Leviathan"] = function(self, targets)
	local target
	local equip_max = 0
	for _,ap in sgs.qlist(targets) do
		if self:isEnemy(ap) then
			if ap:getEquips():length() > equip_max then
				equip_max = ap:getEquips():length()
				target = ap
			end
		end
	end
	if target then return target end
	return self.enemies[1]
end
--sgs.ai_skillInvoke_intention["Leviathan"] = 50

sgs.ai_skill_playerchosen["Satan"] = function(self, targets)
	local target
	local min_hp = 100
	for _,ap in sgs.qlist(targets) do
		if self:isEnemy(ap) and ap:getMark("@Belphegor") == 0 then
			if not self:hasSkills(sgs.masochism_skill, ap) then 
				if ap:getHp() < min_hp then
					min_hp = ap:getHp()
					target = ap
				end
			end
		end
	end
	if target then return target end
	return self.enemies[1]
end
--sgs.ai_skillInvoke_intention["Satan"] = 40

sgs.ai_skill_playerchosen["Belphegor"] = function(self, targets)
	local target
	for _,ap in sgs.qlist(targets) do
		if self:isEnemy(ap) then
			if ap:getMark("@Satan") == 0 and ap:getMark("@Lucifer") == 0 then 
				target = ap
			end
		end
	end
	if target then return target end
	return self.enemies[1]
end
--sgs.ai_skillInvoke_intention["Belphegor"] = 60

sgs.ai_skill_playerchosen["Beelzebub"] = function(self, targets)
	local target
	local least_num = 100
	for _,ap in sgs.qlist(targets) do
		if self:isFriend(ap) then
			if ap:getHandcardNum() < least_num then
				least_num = ap:getHandcardNum()
				target = ap
			end
		end
	end
	if target then return target end
	return self.friends[1]
end
--sgs.ai_skillInvoke_intention["Beelzebub"] = -60

sgs.ai_skill_playerchosen["Asmodeus"] = function(self, targets)
	local target
	local least_hp = 100
	for _,ap in sgs.qlist(targets) do
		if self:isFriend(ap) then
			if ap:getHp() < least_hp then
				least_hp = ap:getHp()
				target = ap
			end
		end
	end
	if target then return target end
	return self.friends[1]
end
--sgs.ai_skillInvoke_intention["Asmodeus"] = -80

sgs.ai_skill_invoke["Lucifer"] = true
sgs.ai_skill_invoke["Leviathan"] = true
sgs.ai_skill_invoke["Satan"] = true
sgs.ai_skill_invoke["Belphegor"] = true
sgs.ai_skill_invoke["Beelzebub"] = true
sgs.ai_skill_invoke["Asmodeus"] = true
sgs.ai_skill_invoke["Mammon"] = true



sgs.ai_skill_invoke.SE_Fanhun = function(self, data)
	for _,p in sgs.qlist(self.room:getPlayers()) do
		if p:isDead() and p:getMaxHp() >= 1 then
			if self:isFriend(p) then return true end
		end
	end
	return false
end

sgs.ai_skill_choice["SE_Fanhun_choose"] = function(self, choices, data)
	for _,p in sgs.qlist(self.room:getPlayers()) do
		if p:isDead() and p:getMaxHp() >= 1 then
			if self:isFriend(p) then return p:getGeneralName() end
		end
	end
	local choice_table = choices:split("+")
	return choice_table[1]
end

sgs.ai_skill_choice.SE_Fanhun = function(self, data)
	if self.player:getMark("@Mahou_ai") > 0 then
		return true
	end
	return false	
end

--兵长
se_zhanjing_skill={}
se_zhanjing_skill.name="se_zhanjing"
table.insert(sgs.ai_skills,se_zhanjing_skill)
se_zhanjing_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasFlag("se_zhanjing_used")  then return end
	if #self.enemies < 1 then return end 
	return sgs.Card_Parse("#se_zhanjingcard:.:")
end

sgs.ai_skill_use_func["#se_zhanjingcard"] = function(card,use,self)
	local target
	for _,p in ipairs(self.enemies) do
		if p:getHandcardNum() > 3 then
			target = p
			break
		end
	end
	for _,p in ipairs(self.enemies) do
		if p:getMaxHp() > self.player:getMaxHp() then
			target = p
			break
		end
	end
	for _,p in ipairs(self.enemies) do
		if p:getHandcardNum() > 6 then
			target = p
			break
		end
	end
	if not target then target = self.enemies[1] end
	use.card = card
	if use.to then use.to:append(target) end
	return
end

sgs.ai_use_value["se_zhanjingcard"] = 8
sgs.ai_use_priority["se_zhanjingcard"] = 8
sgs.ai_card_intention["se_zhanjingcard"]  = 80


--蓝羽浅葱
sgs.ai_skill_invoke.SE_Guanli = function(self, data)
	local PlayerNow = data:toPlayer()
	if self:isEnemy(PlayerNow) then
		sgs.SE_Guanli_reason = "enemy_discard"
		if PlayerNow:getHandcardNum() - PlayerNow:getMaxCards() > 1 then
			if self.player:getHandcardNum() > 3 then return true end
		elseif PlayerNow:getHandcardNum() - PlayerNow:getMaxCards() > 2 then
			if self.player:getHandcardNum() > 2 then return true end
		elseif PlayerNow:getHandcardNum() - PlayerNow:getMaxCards() > 4 then
			if self.player:getHandcardNum() > 0 then return true end
			if self.player:getEquips():length() > 0 then return true end
		end
		if self.room:getAllPlayers(true):length() == 2 then return true end
	elseif self:isFriend(PlayerNow) then
		if self.player:getHandcardNum() > 0 then
			if self:hasSkills("se_chouyuan|se_shunshan|se_kanhu|se_shengjian|se_jianyu|se_huanyuan|se_zhanjing|LuaGonglue|LuaBoxue|",PlayerNow) then
				sgs.SE_Guanli_reason = "friend_play"
				return true
			end
			if self:hasSkills("SE_Guanli|SE_Weigong|SE_Zhufu|LuaLuowang",PlayerNow) then
				sgs.SE_Guanli_reason = "friend_draw"
				return true
			end
		end
		if self.player:getHandcardNum() > 3 then
			sgs.SE_Guanli_reason = "friend_draw"
			return true
		end
	end
	return false
end

sgs.ai_skill_choice["SE_Guanli"] = function(self, choices, data)
	if sgs.SE_Guanli_reason == "friend_draw" then return "Gl_draw"
	elseif sgs.SE_Guanli_reason == "friend_play" then return "Gl_play"
	elseif sgs.SE_Guanli_reason == "enemy_discard" then return "Gl_discard"
	end
end

se_poyi_skill={}
se_poyi_skill.name="se_poyi"
table.insert(sgs.ai_skills,se_poyi_skill)
se_poyi_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasFlag("se_poyi_used")  then return end
	local AIList = sgs.SPlayerList()
	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do	
		if p:getAI() ~= nil and self:isEnemy(p) then
			AIList:append(p)
		end
	end
	if AIList:length() < 1 then return end 
	return sgs.Card_Parse("#se_poyicard:.:")
end

sgs.ai_skill_use_func["#se_poyicard"] = function(card,use,self)
	use.card = card
	return
end

sgs.ai_use_value["se_poyicard"] = 5
sgs.ai_use_priority["se_poyicard"] = 2
sgs.ai_card_intention["se_poyicard"]  = 0

sgs.ai_skill_playerchosen["se_poyi1"] = function(self, targets)
	local target
	local maxHp = 0
	local room = self.player:getRoom()
	for _,p in sgs.qlist(targets) do	
		if p:getAI() ~= nil and self:isEnemy(p) and p:getHp() > maxHp then
			target = p
			maxHp = p:getHp()
		end
	end
	if target then 
		return target
	end
	return self.enemies[1]
end

sgs.ai_skill_playerchosen["se_poyi2"] = function(self, targets)
	local target
	local maxHp = 0
	local room = self.player:getRoom()
	for _,p in sgs.qlist(targets) do	
		if p:getAI() ~= nil and self:isEnemy(p) and p:getHp() > maxHp then
			target = p
			maxHp = p:getHp()
		end
	end
	if not target then 
		for _,p in sgs.qlist(targets) do	
			if self:isEnemy(p)then
				target = p
			end
		end
	end
	if target then 
		return target
	end
	return self.enemies[1]
end

sgs.ai_card_intention["se_poyicard"] = function(card, from, to)
	if sgs.SE_se_poyi1 then
		sgs.updateIntention(sgs.SE_se_poyi1, from, -50)
		if sgs.SE_se_poyi2 then
			sgs.updateIntention(sgs.SE_se_poyi2, sgs.SE_se_poyi1, 200)
			sgs.updateIntention(sgs.SE_se_poyi1, sgs.SE_se_poyi2, 200)
			sgs.SE_se_poyi2 = nil
		end
		sgs.SE_se_poyi1 = nil
	end
end

--理子
sgs.ai_skill_choice["SE_Yirong"] = function(self, choices, data)
	local phase = self.player:getPhase()
	if phase == sgs.Player_RoundStart then
		if self.player:getHp() <=1 or #self.enemies == 0 and choices:matchOne("SE_Huifu") then return "SE_Huifu" end
		if choices:matchOne("SE_Weigong") then return "SE_Weigong" end
	elseif phase == sgs.Player_Play then
		for _,card in sgs.qlist(self.player:getHandcards()) do
			if card:isKindOf("FireAttack") and choices:matchOne("Tianhuo") then return "Tianhuo" end
		end
		if self.player:getAttackRange() > 2 then
			local slash_num
			for _,card in sgs.qlist(self.player:getHandcards()) do
				if card:isKindOf("slash") and choices:matchOne("SE_Juji") then return "SE_Juji" end
			end
		end
		if choices:matchOne("LuaGungnir") then return "LuaGungnir" end
	elseif phase == sgs.Player_Discard then
		if self.player:getHp() == 1 and self.player:getHandcardNum() < 4 then
			for _,p in ipairs(self.enemies) do
				if p:getHp() == 1 then
					if choices:matchOne("SE_Dapo") then return "SE_Dapo" end
				end
			end
		end
		if self.player:getHandcardNum() == 0 then
			if choices:matchOne("kongcheng") then return "kongcheng" end
		end
		if self.player:getHp() <= 1 and self.player:getHandcardNum() <= 2 then
			if choices:matchOne("Jianqiao") then return "Jianqiao" end
		end
		if self.player:getHandcardNum() - self.player:getHp() >= 2 then
			if choices:matchOne("SE_Kuluo") then return "SE_Kuluo" end
		end
		if choices:matchOne("Tianhuo") then return "Tianhuo" end
	end
	if choices:matchOne("Buyaozhexie") then return "Buyaozhexie" end
	local choice_table = choices:split("+")
	return choice_table[1]
end


se_youhuo_skill ={}
se_youhuo_skill.name = "se_youhuo"
table.insert(sgs.ai_skills,se_youhuo_skill)
se_youhuo_skill.getTurnUseCard = function(self,inclusive)
	if self.player:hasFlag("se_youhuo_used") then return end
	if self.player:isKongcheng() then return end
	local target
	for _,p in ipairs(self.enemies) do
		if p:getHandcardNum() > 0 then target = p end
	end
	if not target then return end
	return sgs.Card_Parse("#se_youhuocard:.:")
end
sgs.ai_skill_use_func["#se_youhuocard"] = function(card, use, self)
	local target
	local card
	for _,p in ipairs(self.enemies) do
		if p:getHandcardNum() > 2 and p:getHp() < 3 then target = p end
	end
	if not target then
		for _,p in ipairs(self.enemies) do
			if p:getHandcardNum() > 1 and p:getHp() < 4 then target = p end
		end
	end
	if not target then
		for _,p in ipairs(self.enemies) do
			if p:getHandcardNum() > 0 then target = p end
		end
	end
	for _, acard in sgs.qlist(self.player:getHandcards()) do			
		if not acard:isKindOf("peach") then
			card = acard
		end
	end
	if not target then return end
	if not card then card = self.player:getHandcards():first() end
	if card and target then
		use.card = sgs.Card_Parse("#se_youhuocard:"..card:getEffectiveId()..":") 
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_youhuocard"] = 8
sgs.ai_use_priority["se_youhuocard"]  = 5
sgs.ai_card_intention["se_youhuocard"]  = 80

sgs.ai_skill_choice["Youhuo"] = function(self, choices, data)
	local num = 0
	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
		if p:getMark("@Baskervilles") == 1 and self:isEnemy(p) then
			num = num + 1
		end
	end
	local Riko = self.room:findPlayerBySkillName("se_youhuo")
	if num >= 2 then
		if self.player:getHp() > 2 and Riko:getHp() == 3 then return "se_youhuo_Recovery" end
	end
	return "se_youhuo_Obtain"
end

sgs.ai_skill_choice["Youhuo_Obtain"] = function(self, choices, data)
	local target = data:toPlayer()
	if self:isFriend(target) then
		return string.format("Allow to obtain card:"..target:getGeneralName())
	end
	return "Youhuo_Obtain_Not"
end

--狂三
sgs.ai_skill_invoke.SE_Qidan = function(self, data)
	if #self.enemies > 0 then return true end
	return false
end

sgs.ai_skill_invoke.SE_Shidan = function(self, data)
	for _,p in ipairs(self.enemies) do
		if p:faceUp() then return true end
	end
	return false
end

local function getMinHpEnemy(self)
	local min_hp = 100
	local target
	for _,p in ipairs(self.enemies) do
		if p:getHp() < min_hp then
			target = p
		end
	end
	if target then return target end
	return self.enemies[1]
end


sgs.ai_skill_playerchosen.SE_Qidan = function(self, targets)
	local p = getMinHpEnemy(self)
	if p:faceUp() then return p end
	for _,p in ipairs(self.enemies) do
		if p:faceUp() then return p end
	end
	return self.enemies[1]
end

sgs.ai_skill_playerchosen.SE_Shidan = function(self, targets)
	for _,p in ipairs(self.enemies) do
		if p:getMark("@Qidan_attacked") > 0 then return p end
	end
	return getMinHpEnemy(self)
end

sgs.ai_skill_invoke.SE_Badan = function(self, data)
	if self.player:getMark("@Eight") == 0 then return false end
	if self.player:getHp() <= 1 then return true end
end

sgs.ai_skill_choice["SE_Badan"] = function(self, data)
	return "SE_Badan_Odd"
end

--小樱
--优吉欧
se_qingqiangwei_skill={}
se_qingqiangwei_skill.name="se_qingqiangwei"
table.insert(sgs.ai_skills,se_qingqiangwei_skill)
se_qingqiangwei_skill.getTurnUseCard=function(self,inclusive)
	local source = self.player
	local eNum = 0
	local fNum = 0
	for _,p in sgs.qlist(self.room:getAlivePlayers()) do
		local dist = source:distanceTo(p)
		if dist <= source:getMaxHp() - source:getHp() + 1 then
			if self:isFriend(p) then
				fNum = fNum + 1
			else
				eNum = eNum + 1
			end
		end
	end
	local work = true
	if eNum == 0 or eNum < fNum+1 then work = false end
	if work then
		return sgs.Card_Parse("#se_qingqiangweicard:.:")
	end
end

sgs.ai_skill_use_func["#se_qingqiangweicard"] = function(card,use,self)
	use.card = card
	return
end
sgs.ai_use_value["se_qingqiangweicard"] = 8
sgs.ai_use_priority["se_qingqiangweicard"] = 10


sgs.ai_skill_invoke.SE_Huajian = function(self, data)
	if #self.friends > 1 then return true end
	return false
end

sgs.ai_skill_playerchosen.SE_Huajian = function(self, targets)
	local bestChoice
	local bestP = 0
	for _,p in ipairs(self.friends_noself) do
		if p:isAlive() and p:objectName() ~= self.player:objectName() then
			local point = 0
			if p:hasSkill("se_erdao") then point = point + 20 end
			if p:hasSkill("Zhena") then point = point + 10 end
			if p:hasSkill("se_xunyu") then point = point + 30 end
			if p:hasSkill("LuaCangshan") then point = point + 9 end
			if p:hasSkill("LuaSaoshe") then point = point + 30 end
			if p:getHp() > 2 then point = point + 3 end
			if p:getHp() <= 1 then point = point - 10 end
			if point > bestP then
				bestP = point
				bestChoice = p
			end
		end
	end
	if bestChoice then return bestChoice end
	return self.friends[1]
end


--古手梨花


sgs.ai_skill_invoke["SE_Shenghua"] = true

sgs.ai_skill_choice["SE_Shenghua"] = "suipian"

sgs.ai_skill_invoke["SE_Wumai"] = function(self, data)
	local damage = data:toDamage()
	if self:isFriend(damage.from) and self.player:getPile("Fragments"):length() > 4 then return false end
	return true
end
--??...
se_mipa_skill ={}
se_mipa_skill.name = "se_mipa"
table.insert(sgs.ai_skills,se_mipa_skill)
se_mipa_skill.getTurnUseCard = function(self,inclusive)
	local Fr = self.player:getPile("Fragments"):length()
	if Fr == 0 then return end
	local tf = 0
	if Fr == 1 then
		for _,p in ipairs(self.enemies) do
			if p:getMark("@mipa_basic")>0 or p:getMark("@mipa_notbasic")>0 then tf = tf - 5 end
			if p:getHp() <= 1 then tf = tf + 10 end
			if p:getHandcardNum() > 5 then tf = tf + 1 end
			if p:getWeapon() and p:getWeapon():isKindOf("Crossbow") and p:getHandcardNum() > 3 then tf = tf + 11 end
		end
	elseif Fr == 2 then
		for _,p in ipairs(self.enemies) do
			if p:getMark("@mipa_basic")>0 or p:getMark("@mipa_notbasic")>0 then tf = tf - 1 end
			if p:getHp() <= 1 then tf = tf + 11 end
			if p:getHandcardNum() > 3 then tf = tf + 1 end
			if p:getHandcardNum() > 6 then tf = tf + 4 end
			if p:getHandcardNum() > 8 then tf = tf + 10 end
			if p:getWeapon() and p:getWeapon():isKindOf("Crossbow") and p:getHandcardNum() > 3 then tf = tf + 11 end
		end
	elseif Fr >= 3 then
		for _,p in ipairs(self.enemies) do
			if p:getHp() <= 1 then tf = tf + 11 end
			if p:getHandcardNum() > 3 then tf = tf + 4 end
			if p:getHandcardNum() > 6 then tf = tf + 5 end
			if p:getHandcardNum() > 8 then tf = tf + 11 end
			if self:hasSkills("SE_Juji|SE_Juji_Reki|se_chouyuan|LuaTianmo|LuaBimie|LuaPoshi|LuaGungnir|LuaSaoshe",p) and p:getHandcardNum() > 1 then tf = tf + 11 end
			if p:getWeapon() and p:getWeapon():isKindOf("Crossbow") and p:getHandcardNum() > 3 then tf = tf + 11 end
		end
	end
	if #self.enemies == 1 then tf = 100 end
	if tf > 10 then return sgs.Card_Parse("#se_mipacard:.:") end
	return
end
sgs.ai_skill_use_func["#se_mipacard"] = function(card, use, self)
	local target
	local Fr = self.player:getPile("Fragments"):length()
	for _,p in ipairs(self.enemies) do
		if p:getWeapon() and p:getWeapon():isKindOf("Crossbow") and p:getHandcardNum() > 3 and (p:getMark("@mipa_basic")==0 and p:getMark("@mipa_notbasic")==0) then 
			target = p 
			break
		end
	end
	if not target then
		if Fr == 3 then
			for _,p in ipairs(self.enemies) do
				if self:hasSkills("SE_Juji|SE_Juji_Reki|se_chouyuan|LuaTianmo|LuaBimie|LuaPoshi|LuaGungnir|LuaSaoshe",p) and p:getHandcardNum() > 1 and (p:getMark("@mipa_basic")==0 and p:getMark("@mipa_notbasic")==0) then
					target = p 
					break
				end
			end
		end
		if not target then
			local ma = 0
			for _,p in ipairs(self.enemies) do
				if p:getHandcardNum() > ma and (p:getMark("@mipa_basic")==0 and p:getMark("@mipa_notbasic")==0) then
					ma = p:getHandcardNum()
					target = p
				end
			end
		end
	end
	if target and (target:getMark("@mipa_basic")==0 and target:getMark("@mipa_notbasic")==0) then
		use.card = card
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["se_mipacard"] = 5
sgs.ai_use_priority["se_mipacard"] = 5
sgs.ai_skill_choice["se_mipa"] = "Mipa_Basic"

--优
--恶心的1技能

--二技能
se_tongling_skill ={}
se_tongling_skill.name = "se_tongling"
table.insert(sgs.ai_skills,se_tongling_skill)
se_tongling_skill.getTurnUseCard = function(self,inclusive)
	if #self.enemies == 0 then return end
	if self.player:getMark("@se_tongling") == 0 then return end
	return sgs.Card_Parse("#se_tonglingcard:.:")
end
sgs.ai_skill_use_func["#se_tonglingcard"] = function(card, use, self)

	use.card = card
	return
end
sgs.ai_use_value["se_tonglingcard"] = 10
sgs.ai_use_priority["se_tonglingcard"] = 10

sgs.ai_skill_choice["se_tongling_kd"] = "se_tongling_kill"

sgs.ai_skill_playerchosen["se_tongling_k"] = function(self, targets)
	--if 待补充
	return self.enemies[1]
end

--由理
sgs.ai_skill_invoke["SE_Zuozhan"] = true

sgs.ai_skill_choice["SE_Zuozhan1"] = function(self, data)
	local room = self.room
	local p = room:getCurrent()
	if self:isEnemy(p) then
		return "1_Zuozhan"
	else
		if p:getHandcardNum() <= p:getHp() then return "4_Zuozhan" else return "2_Zuozhan" end
	end	
	return "1_Zuozhan"
end

sgs.ai_skill_choice["SE_Zuozhan2"] = function(self, data)
	local room = self.room
	local p = room:getCurrent()
	if self:isEnemy(p) then
		if p:getHandcardNum() <= 1 and p:getHp() <= 2 then
			return "3_Zuozhan"
		else
			return "2_Zuozhan"
		end
	else
		if p:getHandcardNum() <= p:getHp() then return "2_Zuozhan" else return "3_Zuozhan" end
	end	
	return "2_Zuozhan"
end

sgs.ai_skill_choice["SE_Zuozhan3"] = function(self, data)
	local room = self.room
	local p = room:getCurrent()
	if self:isEnemy(p) then
		if p:getHandcardNum() <= 1 and p:getHp() <= 2 then
			return "2_Zuozhan"
		else
			return "4_Zuozhan"
		end
	else
		if p:getHandcardNum() <= p:getHp() then return "3_Zuozhan" else return "4_Zuozhan" end
	end	
	return "3_Zuozhan"
end

sgs.ai_skill_choice["SE_Zuozhan4"] = function(self, data)
	local room = self.room
	local p = room:getCurrent()
	if self:isEnemy(p) then
		if p:getHandcardNum() <= 1 and p:getHp() <= 2 then
			return "4_Zuozhan"
		else
			return "3_Zuozhan"
		end
	else
		return "1_Zuozhan"
	end	
	return "4_Zuozhan"
end

--雪菜
sgs.ai_skill_invoke["SE_Shengmu"] = function(self, data)
	local da = data:toDamage()
	if self:isFriend(da.to) then return true end
	return false
end

--雪菜2
sgs.ai_skill_invoke["se_jianshi"] = function(self, data)
	return #self.enemies > 0
end


sgs.ai_skill_playerchosen["SE_JianshiTr"] = function(self, targets)
	for _,p in ipairs(self.friends) do
		if p:getMark("@Wuwei")> self.room:getAlivePlayers():length() then return p end
	end
	for _,p in ipairs(self.enemies) do
		local target
		local GoodMark = {"@Asmodeus","@Baskervilles","@Beelzebub","@daiwei","@Chamber","@Efreet","@Eight","@Father_daughter","@Frozen_Eu","@Fuko","@Gaobai","@hates","@HIMIKO",
	"@Kekkai","@kizuna","@LimeBell","@longing","@MagicEquip","@Mahou_ai","@Mammon","@Patience","@se_qiyuan","@shenmin","@shouhu","@Tianming","@tianmo","@Yuzorano"}
		for i = 1, #GoodMark do
			if p:getMark(GoodMark[i])> 1 then return p end
			if p:getMark(GoodMark[i])> 0 then target = p end
		end
	end
	if target then return target end
	return getMinHpEnemy(self)
end


se_jianshi_skill ={}
se_jianshi_skill.name = "se_jianshi"
table.insert(sgs.ai_skills,se_jianshi_skill)
se_jianshi_skill.getTurnUseCard = function(self,inclusive)
	if #self.friends <= 1 then return end
	if self.player:getMark("@surveillance") <= 1 then return end
	for _,p in ipairs(self.friends) do
		if p:getMark("@surveillance") == 0 and p:getHp() > 1 then return sgs.Card_Parse("#se_jianshicard:.:") end
	end
	return
end
sgs.ai_skill_use_func["#se_jianshicard"] = function(card, use, self)
	local target
	--if 待补充
	for _,p in ipairs(self.friends) do
		if p:getMark("@surveillance") == 0 and p:getHp() > 1 then target = p end
	end
	if target then
		use.card = card
		if use.to then use.to:append(target) end
		return
	end
end
sgs.ai_use_value["se_jianshicard"] = 10
sgs.ai_use_priority["se_jianshicard"] = 6

sgs.ai_skill_invoke["SE_Heimu"] = true

--家务
sgs.ai_skill_invoke["SE_Jiawu"] = function(self, data)
	if self.player:getPhase() == sgs.Player_Discard and self.player:getMark("jiawu_fin") > 4 then 
		self.player:setMark("jiawu_fin",0)
		return false 
	end
	if self.player:getPhase() == sgs.Player_Discard then
		self.player:setMark("jiawu_fin",self.player:getMark("jiawu_fin") + 1)
	end
	return true
end

sgs.ai_skill_choice["SE_Jiawu"] = function(self, data)
	if self.player:hasFlag("SE_Jiawu_EquipCard") then
		if not self.player:getWeapon() then return "SE_Jiawu_use" end
		return "SE_Jiawu_give"
	else
		if self.player:getHp() <= 2 and self.player:isWounded() then return "SE_Jiawu_use" end
	end
	return "SE_Jiawu_give"
end

sgs.ai_skill_invoke["SE_Zhandan"] = function(self, data)
	local dam = data:toDamage()
	if dam.to and self:isFriend(dam.to) then return true end
	return false
end

sgs.ai_skill_invoke["SE_Lingshang"] = function(self, data)
	local cardType = data:toString()
	local peaches = self:getCardsNum("Peach")
	if cardType == "BasicCard" then
		if self:isWeak(self.player) then return false end
		if peaches > 0 and self.player:hasSkill("SE_Guiling") then return false end
	end
	return true
end

sgs.ai_skill_choice["SE_Lingshang_type"] = function(self, data)
	for _,p in ipairs(self.friends) do
		if self:isWeak(p) then return "BasicCard" end
	end
	return "TrickCard"
end

sgs.ai_skill_choice["SE_Lingshang"] = function(self, choices, data)--复杂的技能
	local choice_table = choices:split("+")
	if self.player:getPhase() == sgs.Player_Play and #self.enemies > 0 then
		if self.player:getWeapon() and self.player:getWeapon():isKindOf("Crossbow") then
			if not self.player:getOffensiveHorse() and self.player:getHandcardNum() > self.player:getHp() + 1 then
				if table.contains(choice_table, "ChiTu") then return "ChiTu" end
				if table.contains(choice_table, "DaYuan") then return "DaYuan" end
				if table.contains(choice_table, "ZiXing") then return "ZiXing" end
			end
			if self.player:getHandcardNum() > self.player:getHp() then
				if table.contains(choices, "slash") then return "slash" end
			end
		end
	end
	for _,p in ipairs(self.friends) do
		if self:isWeak(p) then
			if table.contains(choice_table, "peach") then return "peach" end
		end
		if self:isWeak(p) and p:objectName() == self.player:objectName() then
			if table.contains(choice_table, "jink") then return "jink" end
		end
	end
	if table.contains(choice_table, "ex_nihilo") then return "ex_nihilo" end
	if #self.enemies > #self.friends and table.contains(choice_table, "savage_assault") then return "savage_assault" end
	if #self.enemies < #self.friends and table.contains(choice_table, "duel") then return "duel" end
	if table.contains(choice_table, "archery_attack") then return "archery_attack" end
	if table.contains(choice_table, "indulgence") then return "indulgence" end
	return choice_table[1]
end

--wuwei 
sgs.ai_skill_invoke["SE_Wuwei"] = function(self, data)
	local use = data:toCardUse()
	if use.to:length() > 1 then return true end
	local target = use.to:at(0)
	if self:isFriend(target) then return false end
	if target:hasSkill("SE_Rennai") or target:hasArmorEffect("silver_lion") then return false end
	local player = use.from
	if player:getMark("@Wuwei") > self.room:getAllPlayers(true):length() and player:getMark("@Wuwei") > 4 then return true end
	if target:isKongcheng() then return true end
	if self:getCardsNum("Slash") > 1 and target:getHandcardNum() > 2 and player:getMark("@Wuwei") <= 2 then return false end
	if player:getMark("@Wuwei") < 3 and self:getCardsNum("Slash") > 1 then return true end
	if self:isWeak(target) and math.random(1, 2) == 1 then return true end
	if target:getHandcardNum() == 1 and math.random(1, 3) > 1 then return true end
	if target:getHandcardNum() > 3 then return false end
	return math.random(1, 5) == 1
end

--tiansuo
sgs.ai_skill_invoke["SE_Tiansuo"] = function(self, data)
	local use = data:toCardUse()
	if self:isEnemy(use.to:at(0)) then return true end
	return false
end

sgs.ai_skill_invoke["se_gate"] = true

sgs.ai_skill_choice["se_gate"] = function(self, choices, data)
	local brave_shine_num = 0
	for _,p in ipairs(self.enemies) do
		if p:isChained() then brave_shine_num = brave_shine_num + 1 end
	end
	if brave_shine_num > 0 then return "gateFire" end
	local target = data:toPlayer()
	if not self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), target) then return "gateFire" end
	return "gateNormal"
end

se_gate_skill={}
se_gate_skill.name="se_gate"
table.insert(sgs.ai_skills,se_gate_skill)
se_gate_skill.getTurnUseCard=function(self,inclusive)
	local player = self.player
	local hasWea = false
	if player:getWeapon() then hasWea = true end
	if not hasWea then
		if player:getPile("pika_gob"):length() > 0 then
			for _,p in ipairs(self.enemies) do
				if self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), p) or self:slashIsEffective(sgs.Sanguosha:cloneCard("fire_slash", sgs.Card_NoSuit, 0), p) then
					hasWea = true
					break
				end
			end
		end
	end
	if not hasWea then
		for _,card in sgs.qlist(player:getHandcards()) do
			if card:isKindOf("Weapon") then
				hasWea = true
				break
			end
		end
	end
	if hasWea then
		return sgs.Card_Parse("#se_gatecard:.:")
	end
end

sgs.ai_skill_use_func["#se_gatecard"] = function(card,use,self)
	local cards=sgs.QList2Table(self.player:getHandcards())
	local needed = {}
	for _,acard in ipairs(cards) do
		if acard:isKindOf("Weapon") then
			table.insert(needed, acard:getEffectiveId())
		end
	end
	if self.player:getWeapon() then
		table.insert(needed, self.player:getWeapon():getEffectiveId())
	end
	if needed then
		use.card = sgs.Card_Parse("#se_gatecard:"..table.concat(needed,"+")..":")
		return
	end

	use.card = sgs.Card_Parse("#se_gatecard:.:")
	return
end

sgs.ai_use_value["se_gatecard"] = 8
sgs.ai_use_priority["se_gatecard"]  = 5

sgs.ai_skill_playerchosen["se_gate"] = function(self, targets)
	for _,p in ipairs(self.enemies) do
		if not p:isChained() and self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), p) and self:isWeak(p) then return p end
	end
	for _,p in ipairs(self.enemies) do
		if not p:isChained() and self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), p) then return p end
	end
	for _,p in ipairs(self.enemies) do
		if not p:isChained() and self:slashIsEffective(sgs.Sanguosha:cloneCard("fire_slash", sgs.Card_NoSuit, 0), p) then return p end
	end
	return self.enemies[1]
end

--
se_origin_skill={}
se_origin_skill.name="se_origin"
table.insert(sgs.ai_skills,se_origin_skill)
se_origin_skill.getTurnUseCard=function(self,inclusive)
	if (not self.player:isLord() and self.player:getMaxHp() > 3) or self.player:getMaxHp() > 4 and self:getCardsNum("Slash") > 0 then
		return sgs.Card_Parse("#se_origincard:.:")
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy:getHandcardNum() == 0 and self.player:inMyAttackRange(enemy) and self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), enemy) and self:getCardsNum("Slash") > 0 then
			if self.player:getMark("@origin_bullet") > 0 then return end
			return sgs.Card_Parse("#se_origincard:.:")
		end
	end
end

sgs.ai_skill_use_func["#se_origincard"] = function(card,use,self)
	use.card = sgs.Card_Parse("#se_origincard:.:")
	return
end

sgs.ai_use_value["se_origincard"] = 6
sgs.ai_use_priority["se_origincard"]  = 5

sgs.ai_skill_choice["se_origin"] = function(self, choices, data)
	local use = data:toCardUse()
	local target = use.to:at(0)
	if not self:isEnemy(target) then return "use_normal" end
	if target:getHandcardNum() == 0 and self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), target) then return "use_origin" end
	if self:getCardsNum("Slash") > 0 and math.random(1, 15) == 1 then return "use_origin" end
	if self.player:hasFlag("slash_one") and math.random(1, 4) > 1 then return "use_origin" end
	if math.random(1, 10) == 1 then return "use_origin" end
	return "use_normal"
end

se_bilingvs_skill={}
se_bilingvs_skill.name="se_bilingvs"
table.insert(sgs.ai_skills,se_bilingvs_skill)
se_bilingvs_skill.getTurnUseCard=function(self,inclusive)
	if self.player:getMark("@Biling_kiri") == 0 then return end
	if #self.enemies == 0 then return end
	for _,enemy in ipairs(self.enemies) do
		if enemy:getGeneral2() then
			return sgs.Card_Parse("#se_bilingvscard:.:")
		end
	end
	if #self.enemies == 1 or #self.friends == 1 then return end
	for _,enemy in ipairs(self.enemies) do
		if enemy:getHp() <= 1 and self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), enemy) then
			return sgs.Card_Parse("#se_bilingvscard:.:")
		end
	end
	if self.player:getHp() == 1 then
		for _,enemy in ipairs(self.enemies) do
			if enemy:getHp() <= 2 and self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), enemy) then
				return sgs.Card_Parse("#se_bilingvscard:.:")
			end
		end
	end
end

sgs.ai_skill_use_func["#se_bilingvscard"] = function(card,use,self)
	if self.player:getMark("@Biling_kiri") == 0 then return end
	if #self.enemies == 0 then return end
	local target
	for _,enemy in ipairs(self.enemies) do
		if enemy:getGeneral2() then
			target = enemy
		end
	end
	if not target then
		if #self.enemies == 1 or #self.friends == 1 then return end
		for _,enemy in ipairs(self.enemies) do
			if enemy:getHp() <= 1 and self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), enemy) then
				target = enemy
			end
		end
	end

	if not target then
		if self.player:getHp() == 1 then
			for _,enemy in ipairs(self.enemies) do
				if enemy:getHp() <= 2 and self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), enemy) then
					target = enemy
				end
			end
		end
	end

	if not target then return end
	if use.to then use.to:append(target) end
	use.card = sgs.Card_Parse("#se_bilingvscard:.:")
	return
end

sgs.ai_skill_playerchosen["se_biling"] = function(self, targets)
	if self.player:getRole() =="rebel" then
		local lord = self.room:getLord()
		if targets:contains(lord) then return lord end
	else
		for _,p in sgs.qlist(targets) do
			if self:isFriend(p) and self:hasSkills("SE_Juji|SE_Juji_Reki|LuaTianmo|LuaBimie|LuaGungnir|SE_Shuangqiang",p) then return p end
		end
		for _,p in sgs.qlist(targets) do
			if self:isFriend(p) then return p end
		end
	end
end

sgs.ai_use_value["se_bilingvscard"] = 8
sgs.ai_use_priority["se_bilingvscard"]  = 1.8
sgs.ai_card_intention.se_bilingvscard = 100

sgs.ai_skill_invoke["se_jianqiao"] = function(self, data)
	local damage = data:toDamage()
	if self:isFriend(damage.to) and (self:getCardsNum("Peach") == 0 or damage.damage > 1) and not (damage.to:hasSkill("SE_Rennai") or damage.to:hasSkill("lingti")) then return true end
	return false
end

--se_shifeng
sgs.ai_skill_invoke["se_shifeng"] = function(self, data)
	local damage = data:toDamage()
	if self:isFriend(damage.to) then return true end
	return false
end

sgs.ai_view_as.se_zhiyan = function(card, player, card_place)
	if player:getMark("@Yukino_shifeng") < math.floor(player:getRoom():getAlivePlayers():length()/ 5) + 1 then return end
	return ("nullification:se_zhiyan[%s:%s]=."):format(sgs.Card_NoSuit, 0)
end

sgs.ai_skill_invoke["se_wenchang"] = function(self, data)
	local damage = data:toDamage()
	if self:isFriend(damage.to) then return true end
	return false
end

sgs.ai_skill_invoke["se_yuanxin"] = function(self, data)
	local damage = data:toDamage()
	if self:isFriend(damage.to) and not damage.from:hasSkill("SE_Shuangqiang") then return true end
	return false
end

sgs.ai_skill_invoke["se_linmo"] = function(self, data)
	local use=data:toCardUse()
	if self:isWeak() and (use.card:isKindOf("Peach") or use.card:isKindOf("Analeptic")) then return true end
	if self.player:getWeapon() and self.player:getWeapon():isKindOf("Crossbow") and use.card:isKindOf("Slash") then return true end
	if not self:isWeak() and (use.card:isKindOf("Snatch") or use.card:isKindOf("ExNihilo") or use.card:isKindOf("Dismantlement") or use.card:isKindOf("reijyuu")) then return true end
	return false
end

sgs.ai_view_as.se_linmo = function(card, player, card_place)
	if player:getPile("drawing"):length() == 0 then return end
	local suit = card:getSuitString()
	local number = card:getNumberString()
	local card_id = card:getEffectiveId()

	local tp

	if sgs.Sanguosha:getCard(player:getPile("copying"):at(0)):isKindOf("BasicCard") then tp = "BasicCard" end
	if sgs.Sanguosha:getCard(player:getPile("copying"):at(0)):isKindOf("TrickCard") then tp = "TrickCard" end
	if sgs.Sanguosha:getCard(player:getPile("copying"):at(0)):isKindOf("EquipCard") then tp = "EquipCard" end
	if not tp then return end


	if card_place == sgs.Player_PlaceHand then
		if card:isKindOf(tp) then
			local name = sgs.Sanguosha:getCard(player:getPile("drawing"):at(0)):objectName()
			return (name..":se_linmo[%s:%s]=%d"):format(suit, number, card_id)
		end
	end
end

sgs.ai_skill_invoke["se_fupao"] = function(self, data)
	local use=data:toCardUse()
	if self:isFriend(use.from) then return true end
	return false
end