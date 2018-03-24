sgs.ai_chaofeng.itomakoto = -2
sgs.ai_chaofeng.ayanami = 3
sgs.ai_chaofeng.keima = 0
sgs.ai_chaofeng.SPkirito = 3
sgs.ai_chaofeng.odanobuna = 3
sgs.ai_chaofeng.yuuta = -2
sgs.ai_chaofeng.tsukushi = -2
sgs.ai_chaofeng.mao_maoyu = 1
sgs.ai_chaofeng.sheryl = 5
sgs.ai_chaofeng.aoitori = 3
sgs.ai_chaofeng.batora = -4
sgs.ai_chaofeng.kyouko = 4
sgs.ai_chaofeng.diarmuid = 6
sgs.ai_chaofeng.ikarishinji = -5
sgs.ai_chaofeng.redarcher = 2
sgs.ai_chaofeng.redo = 2
sgs.ai_chaofeng.runaria = -3
sgs.ai_chaofeng.fuwaaika = 5
sgs.ai_chaofeng.slsty = -2
sgs.ai_chaofeng.rokushikimei = 4
sgs.ai_chaofeng.bernkastel = 5
sgs.ai_chaofeng.hibiki = 4
sgs.ai_chaofeng.kntsubasa = 2
sgs.ai_chaofeng.khntmiku = 5
sgs.ai_chaofeng.yukinechris = 5


--装备
local function isEquip(name, player)
	for _,e in sgs.qlist(player:getEquips()) do
		if e:isKindOf(name) then
			return true
		end
	end
	return false
end
--渣
sgs.ai_skill_cardchosen.renzha = function(self, who, flags)
	if who:objectName() == self.player:objectName() then
		local cards = who:getHandcards()
		self:sortByUseValue(cards, true)
		return cards:first():getEffectiveId()
	end
end

sgs.ai_skill_invoke.renzha = function(self, data)
	if not self.player:faceUp() then
		return true
	end
	return false
end

luarenzha_skill={}
luarenzha_skill.name="luarenzha"
table.insert(sgs.ai_skills,luarenzha_skill)
luarenzha_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasFlag("haochuan_used") then return end
	if self.player:getPile("zha"):length() == 0 then return end
	if #self.friends - #self.enemies > 1  then return end --麻烦的部分
	local use = 0
	local all_f = 0
	local all_e = 0
	for _,enemy in ipairs(self.enemies) do
		if enemy then
			all_e = all_e + enemy:getHandcardNum()
			if enemy:getDefensiveHorse() then
				use = use - 1
			end
			if enemy:getHp() == 1 then
				use = use + 1
			end
		end
	end
	for _,friend in ipairs(self.friends) do
		if friend then
			all_f = all_f + friend:getHandcardNum()
			if friend:getDefensiveHorse() then
				use = use + 1
			end
			if friend:getHp() == 1 then
				use = use - 1
			end
		end
	end
	if all_f - all_e >= 3 then use = use + 2 end
	if all_f - all_e < -3 then return end
	local lord = self.room:getLord()
	if self.player:getRole() == "rebel" then
		if lord:getHp() == 1 then use = use + 1 end
	elseif self.player:getRole() == "loyalist" or self.player:getRole() == "renegade" then
		if lord:getHp() == 1 then use = use - 1 end
	end
	if self.player:getRole() == "renegade" then
		use = use + 1
	end
	if self.player:getHp() == 1 then use = use + 2 end
	if self.player:getPile("zha"):length() <= 1 then use = use - 2 end
	if use > 0 then
		return sgs.Card_Parse("#luarenzhacard:.:")
	end
	return
end

sgs.ai_skill_use_func["#luarenzhacard"] = function(card,use,self)
	use.card = card
	return
end

sgs.ai_use_priority["luarenzhacard"] = 4.2
sgs.ai_card_intention["luarenzhacard"]  = 0

--凌波丽
sgs.ai_skill_invoke.weixiao = function(self, data)
	if self.player:getHandcardNum() < 2 then return false end
	for _,card in sgs.qlist(self.player:getHandcards()) do
		if card:getNumber() >= 4 then
			return true
		end
	end
	return false
end

sgs.ai_skill_cardchosen.weixiao = function(self, who, flags)
	local card_num_max = 0
	local card_n
	local card_dis = 0
	for _,card in sgs.qlist(self.player:getHandcards()) do
		if card:getNumber() > card_num_max then
			card_n = card
			card_dis = card:getNumber() - card_num_max
			card_num_max = card:getNumber()
		end
	end
	local card_num_enemy_max = 0
	for _,enemy in ipairs(self.enemies) do
		if enemy:isAlive() and enemy:getHandcardNum() > card_num_enemy_max then
			card_num_enemy_max = enemy:getHandcardNum()
		end
	end
	if card_num_enemy_max < card_num_max/2 then self.room:setPlayerFlag(self.player, "choice_a") end
	if card_dis > 2 and card_num_enemy_max >= 4 then self.room:setPlayerFlag(self.player, "choice_b") end
	if card_dis <= 2 then self.room:setPlayerFlag(self.player, "choice_a") end
	if card_n then
		return card_n
	end
	return self.player:getHandcards():first()
end

sgs.ai_skill_cardchosen.weixiao_second = function(self, who, flags)
	local card_num_max = 0
	local card_n
	for _,card in sgs.qlist(self.player:getHandcards()) do
		if card:getNumber() > card_num_max then
			card_n = card
			card_num_max = card:getNumber()
		end
	end
	if card_n then
		return card_n
	end
	return self.player:getHandcards():first()
end

sgs.ai_skill_choice.weixiao = function(self, choices, data)
	if self.player:hasFlag("choice_b") then
		if #self.enemies > 0 then
			return "b"
		end
		return "a"
	elseif self.player:hasFlag("choice_a") then
		return "a"
	end
	return "a"
end


sgs.ai_skill_playerchosen.weixiao = function(self, targets)
	local target
	if self.player:hasFlag("choice_b") then
		if #self.enemies > 0 then
			local cards = 0
			for _,enemy in ipairs(self.enemies) do
				if enemy:isAlive() and enemy:getHandcardNum() > cards then
					target = enemy
					cards = enemy:getHandcardNum()
				end
			end
		else
			local cards = 100
			for _,friend in ipairs(self.friends) do
				if friend:isAlive() and friend:getHandcardNum() < cards then
					target = friend
					cards = friend:getHandcardNum()
				end
			end
		end
	elseif self.player:hasFlag("choice_a") then
		local cards = 100
		for _,friend in ipairs(self.friends) do
			if friend:isAlive() and friend:getHandcardNum() < cards then
				target = friend
				cards = friend:getHandcardNum()
			end
		end
		if self.room:getAlivePlayers():length() <= 3 then
			target = self.player
		end
	end
	if target then return target end
	return self.player
end

--SP桐人
sgs.ai_skill_invoke.LuaChanshi = function(self, data)
	local use=data:toCardUse()
	local target1
	self:sort(self.enemies,"defense")
	for _, enemy in ipairs(self.enemies) do
		if self.player:canSlash(enemy, use.card, true) and self:slashIsEffective(use.card, enemy) and not use.to:contains(enemy) then
			target1 = enemy
			break
		end
	end
	if target1 then self.room:setPlayerFlag(target1, "LuaChanshi_target") return true end
	return
end

sgs.ai_skill_playerchosen.LuaChanshi = function(self, targets)
	for _, ap in sgs.qlist(targets) do
		if ap:hasFlag("LuaChanshi_target") then
			self.room:setPlayerFlag(ap, "-LuaChanshi_target")
			return ap
		end
	end
	return targets:first()
end

sgs.ai_playerchosen_intention.LuaChanshi = function(from, to)
	local intention = 55
	if to:hasSkill("leiji") or to:hasSkill("liuli") or to:hasSkill("tianxiang") then
		intention = 0
	end
	sgs.updateIntention(from, to, intention)
end

--神大人
luagonglue_skill={}
luagonglue_skill.name="luagonglue"
table.insert(sgs.ai_skills,luagonglue_skill)
luagonglue_skill.getTurnUseCard=function(self,inclusive)
	if #self.enemies < 1 or self.player:hasUsed("#luagongluecard") then return end
	return sgs.Card_Parse("#luagongluecard:.:")
end


sgs.ai_skill_use_func["#luagongluecard"] = function(card,use,self)
	local target
	self:sort(self.enemies, "defense")
	local lord = self.room:getLord()
	if self.player:getRole() =="rebel" then
		if not lord:isKongcheng() then
			target = lord
		end
	else
		for _,enemy in ipairs(self.enemies) do
			if not enemy:isKongcheng() then
				target = enemy
			end
		end
	end
	if target then
		use.card = sgs.Card_Parse("#luagongluecard:.:")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["luagongluecard"] = 8
sgs.ai_use_priority["luagongluecard"]  = 8
sgs.ai_card_intention["luagongluecard"]  = 60


--信奈
sgs.ai_skill_choice.LuaChigui = function(self, choices, data)
	local peaches = 0
	local hand_weapon = 0
	for _,card in sgs.qlist(self.player:getHandcards()) do
		if card:isKindOf("Peach") then
			peaches = peaches + 1
		end
		if card:isKindOf("Weapon") then
			hand_weapon = hand_weapon + 1
		end
	end
	if self.player:getHp() <= 2 and peaches == 0 then return "cancel" end
	if self.player:getHp() <= 1 and peaches <= 1 then return "cancel" end
	if self.player:getHp() <= 2 and self.player:getWeapon()  then return "cancel" end
	if self.player:getHp() <= 3 and hand_weapon > 0 then return "cancel" end
	local dest
	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
		if p:getWeapon() and p:getWeapon():objectName() == data:toString() then
			dest = p
		end
	end
	if self:isEnemy(dest) then return "chigui_gain" end
	return "cancel"
end


sgs.ai_skill_invoke.LuaBuwu = function(self, data)
	local damage = data:toDamage()
	local dest = damage.to
	if not self:isFriend(dest) then
		if dest:getHp() <= 3 then
			if dest:faceUp() then
				return true
			end
		end
	end
	return false
end


sgs.ai_skill_invoke.LuaTianmoDefense = function(self, data)
	if self.player:getMark("@tianmo") == 0 then return false end
	return true
end

--勇太
LuaWangxiang_skill={}
LuaWangxiang_skill.name="LuaWangxiang"
table.insert(sgs.ai_skills,LuaWangxiang_skill)
LuaWangxiang_skill.getTurnUseCard=function(self,inclusive)
	local wxhcn = self.player:getHandcardNum()
	local losehp = self.player:getMaxHp() - self.player:getHp()
	if wxhcn > losehp then return end
	local cards = self.player:getCards("h")
	cards=sgs.QList2Table(cards)
	self:sortByUseValue(cards,true)
	local card_nd = cards[1]
	if not card_nd then return end
	return sgs.Card_Parse(("ex_nihilo:LuaWangxiang[%s:%s]=%d"):format(card_nd:getSuitString(),card_nd:getNumberString(),card_nd:getEffectiveId()))
end

sgs.ai_use_value["LuaWangxiang"] = 10
sgs.ai_use_priority["LuaWangxiang"]  = 9

luablackflame_skill={}
luablackflame_skill.name="luablackflame"
table.insert(sgs.ai_skills,luablackflame_skill)
luablackflame_skill.getTurnUseCard=function(self,inclusive)
	if #self.enemies < 1 then return end
	local source = self.player
	if source:hasUsed("#luablackflamecard") then return end
	if self.player:getHp() <= 2 then return end
	return sgs.Card_Parse("#luablackflamecard:.:")
end

sgs.ai_skill_use_func["#luablackflamecard"] = function(card,use,self)
	local target
	local source = self.player
	for _,enemy in ipairs(self.enemies) do
		target = enemy
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy:getHp() == 2 then
			target = enemy
		end
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy:getHp() == 1 then
			target = enemy
		end
	end
	if target then
		use.card = sgs.Card_Parse("#luablackflamecard:.:")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["luablackflamecard"] = 8
sgs.ai_use_priority["luablackflamecard"]  = 10
sgs.ai_card_intention.luablackflamecard = 90


--经济学魔王
luaboxue_skill={}
luaboxue_skill.name="luaboxue"
table.insert(sgs.ai_skills,luaboxue_skill)
luaboxue_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasUsed("#luaboxuecard") then return end
	if #self.friends < 2 then return end
	return sgs.Card_Parse("#luaboxuecard:.:")
end

sgs.ai_skill_use_func["#luaboxuecard"] = function(card,use,self)
	local targets = sgs.SPlayerList()
	for _,friend in ipairs(self.friends) do
		targets:append(friend)
	end
	if targets then
		use.card = sgs.Card_Parse("#luaboxuecard:.:")
		if use.to then use.to = targets end
		return
	end
end

sgs.ai_use_value["luatiaojiaocard"] = 8
sgs.ai_use_priority["luatiaojiaocard"]  = 10
sgs.ai_card_intention.luatiaojiaocard = -60

sgs.ai_skill_choice.luaboxuecard = function(self, choices, data)
	return "gx"
end

--裸王
--[[
sgs.ai_skill_playerchosen.LuaLuowang = function(self, targets)
	local list = self.room:getAlivePlayers()
	local card_min = 100
	local target
	for _,friend in ipairs(self.friends) do
		local card_num = friend:getHandcardNum()
		if friend:getHp() == 1 then
			card_num = card_num - 1
		end
		if friend:getArmor() then
			card_num = card_num + 1
		end
		if friend:getHandcardNum() > friend:getHp() then
			card_num = card_num - 1
		end
		if card_num < card_min then
			card_min = card_num
			target = friend
		end
	end
	if target then return target end
	return self.friends[1]
end]]

--真嗣乖乖
sgs.ai_skill_invoke.LuaBaozou = true

--红A
luatouyingVS_skill={}
luatouyingVS_skill.name="luatouyingVS"
table.insert(sgs.ai_skills,luatouyingVS_skill)
luatouyingVS_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasUsed("#luatouyingcard") then return end
	if self.player:getWeapon() then return end
	return sgs.Card_Parse("#luatouyingcard:.:")
end

sgs.ai_skill_use_func["#luatouyingcard"] = function(card,use,self)
	use.card = card
	return
end

sgs.ai_use_priority["luatouyingcard"] = 10
sgs.ai_card_intention["luatouyingcard"]  = 0

sgs.ai_skill_choice.luatouyingVS= function(self, choices)
	if self.player:getWeapon() then return "crossbow" end
	local slashNum = 0
	local cardNum = 0
	for _,card in sgs.qlist(self.player:getHandcards()) do
		if card:isKindOf("Slash") then
			slashNum = slashNum + 1
		end
		cardNum = cardNum + 1
	end
	if slashNum == 0 then
		return "spear"
	end
	if slashNum > 2 then
		return "crossbow"
	end
	if cardNum > 6 then
		return "axe"
	end
	for _,p in sgs.qlist(self.room:getOtherPlayers(self.player)) do
		if self:isEnemy(p) then
			if p:getArmor() and p:getArmor():isKindOf("Vine") then
				return "fan"
			end
			if not p:getArmor() and p:getHandcardNum() == 0 then
				return "guding_blade"
			end
			if not p:isMale() and not p:getArmor() then
				return "double_sword"
			end
			if p:getArmor() and p:getArmor() then
				return "qinggang_sword"
			end
		end
	end
	return "double_sword"
end


LuaGongqi_skill={}
LuaGongqi_skill.name="LuaGongqi"
table.insert(sgs.ai_skills,LuaGongqi_skill)
LuaGongqi_skill.getTurnUseCard=function(self,inclusive)
	for _,card in sgs.qlist(self.player:getHandcards()) do
		if card:isKindOf("Weapon") and sgs.Slash_IsAvailable(self.player) then
			return sgs.Card_Parse(("slash:LuaGongqi[%s:%s]=%d"):format(card:getSuitString(),card:getNumberString(),card:getEffectiveId()))
		end
	end
	return
end

sgs.ai_use_priority["LuaGongqi"] = 6
sgs.ai_card_intention["LuaGongqi"]  = 100



luajianyu_skill={}
luajianyu_skill.name="luajianyu"
table.insert(sgs.ai_skills,luajianyu_skill)
luajianyu_skill.getTurnUseCard=function(self,inclusive)
	local yong = self.player:getPile("yong")
	local alivenum = self.room:getAlivePlayers()
	if yong:length() < alivenum then return end
	if #self.friends - 1 > #self.enemies then return end
	return sgs.Card_Parse("#luajianyucard:.:")
end

sgs.ai_skill_use_func["#luajianyucard"] = function(card,use,self)
	use.card = card
	return
end


sgs.ai_skill_invoke.LuaChitian = function(self, data)
	return true
end

--雷德
sgs.ai_skill_invoke.LuaChamberMove = function(self, data)
	if self.player:getMark("@Chamber") == 1 then
		if self.player:getHp() < 2 then
			return true
		end
	end
	if self.player:getMark("@Chamber") == 0 then
		return true
	end
	return false
end

sgs.ai_skill_playerchosen.LuaRedoWake = function(self, targets)
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
end

--月长石
luayukong_skill={}
luayukong_skill.name="luayukong"
table.insert(sgs.ai_skills,luayukong_skill)
luayukong_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasUsed("#luayukongcard") then return end
	if self.player:getPile("si"):length() == 0 then return end
	if self.player:getAttackRange() > 2 then return end
	if #self.enemies <= 1 then return end
	return sgs.Card_Parse("#luayukongcard:.:")
end


sgs.ai_skill_use_func["#luayukongcard"] = function(card,use,self)
	use.card = card
	return
end

sgs.ai_use_priority["luayukongcard"] = 10
sgs.ai_card_intention["luayukongcard"]  = 0

sgs.ai_skill_invoke.LuaQisi = function(self, data)
	local effect = data:toCardEffect()
	local source = effect.from
	local card = effect.card
	if card:isKindOf("Slash") then
		local itsar = source:getAttackRange()
		if itsar <= 3 then
			return true
		end
	end
	return false
end

--爱花（通过）
local function getSlashNum(player)
	local num = 0
	for _,card in sgs.qlist(player:getHandcards()) do
		if card:isKindOf("Slash") then
			num = num + 1
		end
	end
	return num
end

local luaposhi_skill={}
luaposhi_skill.name="luaposhi"
table.insert(sgs.ai_skills,luaposhi_skill)
luaposhi_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasUsed("#luaposhicard") then return end
	if #self.enemies < 1 then return end
	if getSlashNum(self.player) < 2 then return end
	if self.player:getHp() < 2 then return end
	if getSlashNum(self.player) < 3 and self.player:getHp() < 3 then return end
	return sgs.Card_Parse("#luaposhicard:.:")
end

sgs.ai_skill_use_func["#luaposhicard"] = function(card,use,self)
	use.card = sgs.Card_Parse("#luaposhicard:.:")
	return
end

sgs.ai_use_value["luaposhicard"] = 7
sgs.ai_use_priority["luaposhicard"] = 9

sgs.ai_skill_invoke.LuaLiansuo = true
sgs.ai_skill_invoke.LuaYinguo = function(self, data)
	for _,p in sgs.qlist(self.room:getAlivePlayers()) do
		if p:isMale() and self:isFriend(p) then
			return true
		end
	end
	return false
end

sgs.ai_skill_playerchosen.LuaYinguo = function(self, targets)
	local min_card_num = 100
	local target
	for _,p in sgs.qlist(targets) do
		if p:isMale() and self:isFriend(p) then
			if p:getHandcardNum() < min_card_num then
				target = p
				min_card_num = p:getHandcardNum()
			end
		end
	end
	if target then return target end
	return targets:first()
end

--赌徒
sgs.ai_skill_use_func["#yanhuoacquirecard"] = function(card,use,self)
	local others = self.player:getSiblings()
	local target
	for _,p in sgs.qlist(others) do
		if p:hasSkill("slyanhuo") and not p:getPile("confuse"):isEmpty() and self:isEnemy(p) then
			target = p
			break
		end
	end
	if target then
		use.card = card
		if use.to then use.to:append(target) end
		return
	end
end

--这个判断甚为复杂。。。
sgs.ai_skill_invoke.slyanhuo = function(self, data)
	local damage = data:toDamage()
	if self:isEnemy(damage.from) then return true end
	return false
end

local yanhuovs_skill={}
yanhuovs_skill.name="slyanhuo"
table.insert(sgs.ai_skills,yanhuovs_skill)
yanhuovs_skill.getTurnUseCard=function(self,inclusive)
	if self.player:getPile("confuse"):length() < 4 and self.player:getHandcardNum() > 0 then
		return sgs.Card_Parse("#slyanhuocard:.:")
	end
end

sgs.ai_skill_use_func["#slyanhuocard"] = function(card,use,self)
	local card_to
	for _,card in sgs.qlist(self.player:getHandcards()) do
		if not card:isKindOf("Peach") and not card:isKindOf("Nullification") and not card:isKindOf("Analeptic") then
			card_to = card
			break
		end
	end
	if not card_to then return end
	use.card = sgs.Card_Parse("#slyanhuocard:"..card_to:getEffectiveId()..":")
	return
end

--64m
sgs.ai_skill_invoke.LuaHeartlead = function(self, data)
	local use = data:toCardUse()
	local source = use.from
	local target = use.to:first()
	local card = use.card
	if card:isKindOf("Peach") and self:isEnemy(target) then return true end
	if self:isEnemy(source) and self:isFriend(target) and self.player:getHp() > 1 then return true end
	if self:isEnemy(source) and self:isFriend(target) and target:getHp() == 1 then return true end
	return false
end

sgs.ai_skill_choice["LuaHeartlead"] = "chained"

sgs.ai_skill_playerchosen.LuaHeartlead = function(self, targets)
	local positive = true
	for _,p in sgs.qlist(self.room:getAlivePlayers()) do
		if p:getHp() <= 0 and self:isEnemy(p) then
			positive = false
		end
	end
	if positive then
		for _,p in sgs.qlist(targets) do
			if p:isEnemy() then return p end
		end
	else
		for _,p in sgs.qlist(targets) do
			if p:isFriend() and p:getHp() < p:getMaxHp() then return p end
		end
	end
	return targets:first()
end
--不确定...这个或许有别的考量
sgs.ai_skill_invoke.LuaHeartlead = function(self, data)
	if self.player:getHp() == 1 and self.player:getHandcardNum() < 3 then return true end
	return false
end

--奇迹+碎片
sgs.ai_skill_invoke["qiji"] = function(self, data)
	local dying = data:toDying()
	if self:isFriend(dying.who) then return true end
	return false
end


--萌战
sgs.ai_skill_invoke["moesenskill"] = function(self, data)
	local p = data:toPlayer()
	if self:isFriend(p) then return true end
	return false
end

--响（通过）
local luasynchrogazer_skill={}
luasynchrogazer_skill.name="luasynchrogazer"
table.insert(sgs.ai_skills,luasynchrogazer_skill)
luasynchrogazer_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasFlag("SucSyn") then return end
	if #self.enemies < 1 then return end
	return sgs.Card_Parse("#luasynchrogazercard:.:")
end

sgs.ai_skill_use_func["#luasynchrogazercard"] = function(card,use,self)
	use.card = sgs.Card_Parse("#luasynchrogazercard:.:")
	return
end

sgs.ai_use_value["luasynchrogazercard"] = 7
sgs.ai_use_priority["luasynchrogazercard"] = 9


sgs.ai_skill_playerchosen["luasynchrogazer_Target"] = function(self, targets)
	local min_hp = 100
	local target
	for _,p in sgs.qlist(targets) do
		if self:isEnemy(p) then
			if p:getHp() < min_hp then
				target = p
				min_hp = p:getHp()
			end
		end
	end
	if target then return target end
	return targets:first()
end

sgs.ai_skill_playerchosen["luasynchrogazer_Friend"] = function(self, targets)
	local min_card_num = 100
	local target
	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) then
			if p:getHandcardNum() < min_card_num then
				target = p
				min_card_num = p:getHandcardNum()
			end
		end
	end
	if target then return target end
	return targets:first()
end



sgs.ai_use_value["luasynchrogazercard"] = 7
sgs.ai_use_priority["luasynchrogazercard"] = 1.8

--某翅膀（通过?...）
LuaCangshan_skill={}
LuaCangshan_skill.name="LuaCangshan"
table.insert(sgs.ai_skills,LuaCangshan_skill)
LuaCangshan_skill.getTurnUseCard=function(self,inclusive)
	local has_equip = false
	local equip
	for _,card in sgs.qlist(self.player:getHandcards()) do
		if card:isKindOf("EquipCard") then
			has_equip = true
			equip = card
		end
	end
	if not has_equip then
		for  _,card in sgs.qlist(self.player:getEquips()) do
			if not ((self.player:getWeapon() and card:getEffectiveId() == self.player:getWeapon():getId()) and card:isKindOf("Crossbow")) then
				equip =  card
			end
		end
	end
	if not sgs.Slash_IsAvailable(self.player) or not has_equip then return end
	return sgs.Card_Parse(("slash:LuaCangshan[%s:%s]=%d"):format(equip:getSuitString(),equip:getNumberString(),equip:getEffectiveId()))
end

sgs.ai_view_as.LuaCangshan = function(card, player, card_place)
	local has_equip = false
	local equip
	for _,card in sgs.qlist(player:getHandcards()) do
		if card:isKindOf("EquipCard") then
			has_equip = true
			equip = card
		end
	end
	if not has_equip then return end
	local pattern = sgs.Sanguosha:getCurrentCardUsePattern()
	if pattern == "true" then
		local cards = player:getCards("h")
		cards=sgs.QList2Table(cards)
		for _,card in ipairs(cards)  do
			if card:isKindOf("Jink") then
				return
			end
		end
		return ("jink:LuaCangshan[%s:%s]=%d"):format(equip:getSuitString(),equip:getNumberString(),equip:getEffectiveId())
	elseif pattern == "true" then
		local cards = player:getCards("h")
		cards=sgs.QList2Table(cards)
		for _,card in ipairs(cards)  do
			if card:isKindOf("Slash") then
				return
			end
		end
		return ("slash:LuaCangshan[%s:%s]=%d"):format(equip:getSuitString(),equip:getNumberString(),equip:getEffectiveId())
	end
end


local luayuehuang_skill={}
luayuehuang_skill.name="luayuehuang"
table.insert(sgs.ai_skills,luayuehuang_skill)
luayuehuang_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasFlag("SucYh") then return end
	if #self.friends < 2 then return end
	return sgs.Card_Parse("#luayuehuangcard:.:")
end

sgs.ai_skill_use_func["#luayuehuangcard"] = function(card,use,self)
	use.card = sgs.Card_Parse("#luayuehuangcard:.:")
	return
end

sgs.ai_use_value["luayuehuangcard"] = 7
sgs.ai_use_priority["luayuehuangcard"] = 9


--未来（通过）
sgs.ai_skill_invoke["LuaJingming"] = function(self, data)
	local p = data:toPlayer()
	if self.player:getHandcardNum() > 1 then
		if self:isFriend(p) then
			if isEquip("Crossbow", p) then return false end
			if p:getHp() == 1 and p:getHandcardNum() < 2 then return true end
			if p:getHp() == 2 and p:getHandcardNum() < 1 then return true end
			if p:getHandcardNum() + 5 < p:getHp() then return true end
		end
	end
	if self:isEnemy(p) then
		if p:getHandcardNum() > 3 and isEquip("Crossbow", p) then return true end
		if self:hasSkills("SE_Juji|SE_Juji_Reki|se_chouyuan|LuaTianmo|LuaBimie|luaposhi|LuaGungnir|luasaoshe",p) and p:getHandcardNum() > 1 then return true end
		if self:isWeak(self.player) and p:inMyAttackRange(self.player) then return true end
	end
	return false
end


sgs.ai_skill_choice["LuaJingming"] = function(self, choices, data)
	local target
	for _,p in sgs.qlist(self.room:getAlivePlayers()) do
		if p:getMark("noslash_jm") == 1 then
			target = p
		end
	end
	if not target then return "youdiscard" end
	if self:isEnemy(target) then
		return "youdiscard"
	else
		if target:getMaxHp() - target:getHp()  > 0 and target:getHandcardNum() >= 1 then return "recover" end
		return "eachdraw"
	end
	return "youdiscard"
end

local luayingxian_skill={}
luayingxian_skill.name="luayingxian"
table.insert(sgs.ai_skills,luayingxian_skill)
luayingxian_skill.getTurnUseCard=function(self,inclusive)
	if self.player:hasFlag("Sucyx") then return end
	if #self.friends < 2 then return end
	return sgs.Card_Parse("#luayingxiancard:.:")
end

sgs.ai_skill_use_func["#luayingxiancard"] = function(card,use,self)
	use.card = sgs.Card_Parse("#luayingxiancard:.:")
	return
end

sgs.ai_use_value["luayingxiancard"] = 7
sgs.ai_use_priority["luayingxiancard"] = 9

--kurisu（通过）
luasaoshe_skill={}
luasaoshe_skill.name="luasaoshe"
table.insert(sgs.ai_skills,luasaoshe_skill)
luasaoshe_skill.getTurnUseCard=function(self,inclusive)
	if #self.enemies < 1 then return end
	if self.player:isKongcheng() then return end
	local cards=sgs.QList2Table(self.player:getHandcards())
	local card_OK = false
	for _,acard in ipairs(cards) do
		if not acard:isKindOf("Jink") and not acard:isKindOf("Peach") and not acard:isKindOf("Analeptic") then
			card_OK = true
		end
	end
	if not card_OK then return end
	for _,enemy in ipairs(self.enemies) do
		if self.player:inMyAttackRange(enemy) and enemy:getMark("SaosheX") < 2 and not enemy:isCardLimited(sgs.Sanguosha:cloneCard("Slash"), sgs.Card_MethodUse) and not isEquip("EightDiagram",enemy) and not isEquip("Vine",enemy) then
			return sgs.Card_Parse("#luasaoshecard:.:")
		end
	end
end

sgs.ai_skill_use_func["#luasaoshecard"] = function(card,use,self)
	local cards=sgs.QList2Table(self.player:getHandcards())
	local target
	local card
	for _,acard in ipairs(cards) do
		if not acard:isKindOf("Jink") and not acard:isKindOf("Peach") and not acard:isKindOf("Analeptic") then
			card = acard
		end
	end
	local min_people
	local min_Hp = 100
	for _,enemy in ipairs(self.enemies) do
		if not self:hasSkills(sgs.masochism_skill, enemy) and self:slashIsEffective(sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0), enemy) and enemy:getMark("SaosheX") < 2 and not enemy:isCardLimited(sgs.Sanguosha:cloneCard("Slash"), sgs.Card_MethodUse) and self.player:inMyAttackRange(enemy) and not isEquip("EightDiagram",enemy) and not isEquip("Vine",enemy) then
			if enemy:getHp() <= min_Hp then
				min_people = enemy
				min_Hp = enemy:getHp()
			end
		end
	end
	target = min_people
	if target and card then
		use.card = sgs.Card_Parse("#luasaoshecard:"..card:getEffectiveId()..":")
		if use.to then use.to:append(target) end
		return
	end
end

sgs.ai_use_value["luasaoshecard"] = 9
sgs.ai_use_priority["luasaoshecard"]  = 3.2
sgs.ai_card_intention["luasaoshecard"]  = 80

sgs.ai_skill_invoke.LuaDikai = function(self, data)
	local yukine = self.room:findPlayerBySkillName("LuaDikai")
	if self:isFriend(yukine) then return true end
	return false
end

--补充 裸王
sgs.ai_skill_playerchosen["LuaLuowang"] = function(self, targets)
	if self.player:hasFlag("luoDraw") then
		return self:findPlayerToDraw(true)
	else
		return self:findPlayerToDiscard("he", true)
	end
end
