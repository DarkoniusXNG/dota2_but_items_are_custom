LinkLuaModifier("modifier_item_ultimate_king_bar_damage_shield", "items/ultimate_king_bar.lua", LUA_MODIFIER_MOTION_NONE)

item_ultimate_king_bar = class({})

function item_ultimate_king_bar:GetIntrinsicModifierName()
	return "modifier_generic_bonus"
end

function item_ultimate_king_bar:OnSpellStart()
	local caster = self:GetCaster()
	local buff_duration = self:GetSpecialValueFor("duration")
	
	local function BKBPurge(unit)
		if unit then
			-- Basic Dispel
			local RemovePositiveBuffs = false
			local RemoveDebuffs = true
			local BuffsCreatedThisFrameOnly = false
			local RemoveStuns = false
			local RemoveExceptions = false
			unit:Purge(RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
		end
	end

	-- Dispel debuffs
	BKBPurge(caster)

	-- Apply the buff
	caster:AddNewModifier(caster, self, "modifier_item_ultimate_king_bar_damage_shield", {duration = buff_duration})

	-- Sound
	caster:EmitSound("DOTA_Item.BlackKingBar.Activate")
end

function item_ultimate_king_bar:IsRefreshable()
	return false
end

---------------------------------------------------------------------------------------------------

modifier_item_ultimate_king_bar_damage_shield = modifier_item_ultimate_king_bar_damage_shield or class({})

function modifier_item_ultimate_king_bar_damage_shield:IsHidden()
	return false
end

function modifier_item_ultimate_king_bar_damage_shield:IsDebuff()
	return false
end

function modifier_item_ultimate_king_bar_damage_shield:IsPurgable()
	return false
end

function modifier_item_ultimate_king_bar_damage_shield:OnCreated()
	if not IsServer() then
		return
	end

end

function modifier_item_ultimate_king_bar_damage_shield:CheckState()
    local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

    return state
end

function modifier_item_ultimate_king_bar_damage_shield:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}

	return funcs
end

function modifier_item_ultimate_king_bar_damage_shield:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_item_ultimate_king_bar_damage_shield:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_item_ultimate_king_bar_damage_shield:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_item_ultimate_king_bar_damage_shield:GetModifierModelScale()
	return 40
end

function modifier_item_ultimate_king_bar_damage_shield:GetEffectName()
    return "particles/test_particle/damage_immunity.vpcf" --"particles/items_fx/black_king_bar_avatar.vpcf"
end

--function modifier_item_ultimate_king_bar_damage_shield:GetEffectAttachType()
	--return --follow_origin
--end

function modifier_item_ultimate_king_bar_damage_shield:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_item_ultimate_king_bar_damage_shield:StatusEffectPriority()
	return 12
end
