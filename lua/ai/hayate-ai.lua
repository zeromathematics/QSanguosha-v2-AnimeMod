--枪兵
sgs.ai_skill_invoke.bimie = function(self, data)
	local damage = data:toDamage()
	local target = damage.to
	if self:isEnemy(target) then
		return true
	end
	return false
end
