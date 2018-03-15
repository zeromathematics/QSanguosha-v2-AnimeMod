sgs.ai_skill_invoke.xingfu=function(self,data)
  return true
end

sgs.ai_skill_invoke.m_qinshi=function(self,data)
  if data:toDamage() then
    local damage=data:toDamage()
    return self:isEnemy(damage.to)
  end
end

sgs.ai_skill_invoke.mshengjian=function(self,data)
  return true
end

sgs.Seniorious_suit_value={
  heart=5,
  diamond=3.5
}

sgs.ai_skill_invoke.confession=function(self,data)
  return true
end

void_skill={}
void_skill.name="void"
table.insert(sgs.ai_skills,void_skill)
void_skill.getTurnUseCard=function(self,inclusive)
  local source = self.player
  if source:hasFlag("void_used") then return end
  return sgs.Card_Parse("#voidcard:.:")
end

sgs.ai_skill_use_func["#voidcard"] = function(card,use,self)
  local target
  local m = 0
  for _,friend in ipairs(self.friends) do
    local n = friend:getHandcardNum()
    if n > math.max(1,m) then
      m = n
      target =friend
    end
  end
  for _,enemy in ipairs(self.enemies) do
    local n = enemy:getHandcardNum()
    if n > m+2 then
      m = n
      target =enemy
    end
  end
  if target then
    use.card = sgs.Card_Parse("#voidcard:.:")
    if use.to then use.to:append(target) end
    return
  end
end

sgs.ai_use_priority["voidcard"]=10

sgs.ai_skill_invoke.Izhiai=function(self,data)
  return true
end

sgs.ai_skill_invoke.shengmingxian=function(self,data)
  local room=sgs.Self:getRoom()
  local dest
  for _,p in sgs.qlist(room:getAlivePlayers()) do
    if p:getGeneralName()=="oumashu" then
      dest=p
    end
  end
  return self:isFriend(dest)
end
