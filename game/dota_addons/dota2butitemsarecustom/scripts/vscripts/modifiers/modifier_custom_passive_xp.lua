modifier_custom_passive_xp = modifier_custom_passive_xp or class({})

function modifier_custom_passive_xp:IsPermanent()
	return true
end
function modifier_custom_passive_xp:IsHidden()
	return true
end
function modifier_custom_passive_xp:IsPurgable()
	return false
end

function modifier_custom_passive_xp:OnCreated()
	if not IsServer() then
		return
	end
	local parent = self:GetParent()

	local XP_PER_MINUTE = PASSIVE_XP_PER_MINUTE
	DebugPrint("Passive XPM is: ")
	DebugPrint(XP_PER_MINUTE)

	if XP_PER_MINUTE ~= 0 then
		self.xpTickTime = 60/XP_PER_MINUTE
		self.xpPerTick = 1
	else
		self.xpPerTick = 0
		self:Destroy()
	end
	if self.xpTickTime then
		self:StartIntervalThink(self.xpTickTime)
	end
end

function modifier_custom_passive_xp:OnIntervalThink()
	if not IsServer() then
		return
	end
	local parent = self:GetParent()
	local game_state = GameRules:State_Get()
	if game_state >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		parent:AddExperience(self.xpPerTick, DOTA_ModifyXP_Unspecified, false, true)
	end
end
