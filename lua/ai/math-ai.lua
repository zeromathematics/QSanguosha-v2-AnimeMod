sgs.ai_skill_invoke.xingfu=function(self,data)
return true
end

sgs.ai_skill_invoke.m_qinshi=function(self,data)
if self.event==sgs.DamageCaused then
local damage=data:toDamage()
return self:isEnemy(damage.to)
end
end

sgs.ai_skill_invoke.mshengjian_tri=function(self,data)
return true
end

sgs.Seniorious_suit_value={
     heart=5,
	 diamond=3.5
}

sgs.ai_skill_invoke.confession=function(self,data)
return true
end
