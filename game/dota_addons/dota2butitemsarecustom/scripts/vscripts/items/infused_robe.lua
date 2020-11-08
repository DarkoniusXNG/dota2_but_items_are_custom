LinkLuaModifier("modifier_item_infused_robe_damage_block", "items/infused_robe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_infused_robe_damage_barrier", "items/infused_robe.lua", LUA_MODIFIER_MOTION_NONE)

item_infused_robe = class({})

function item_infused_robe:GetIntrinsicModifierName()
	return "modifier_intrinsic_multiplexer"
end

function item_infused_robe:GetIntrinsicModifierNames()
	return {
		"modifier_generic_bonus",
		"modifier_item_infused_robe_damage_block",
	}
end

function item_infused_robe:OnSpellStart()
	local caster = self:GetCaster()
	local barrier_duration = self:GetSpecialValueFor("barrier_duration")
	local barrier_hp = self:GetSpecialValueFor("barrier_block")

	-- Apply the buff
	caster:AddNewModifier(caster, self, "modifier_item_infused_robe_damage_barrier", {duration = barrier_duration, barrier = barrier_hp})

	-- Sound
	caster:EmitSound("Hero_Abaddon.AphoticShield.Cast")
end

---------------------------------------------------------------------------------------------------

modifier_item_infused_robe_damage_block = modifier_item_infused_robe_damage_block or class({})

function modifier_item_infused_robe_damage_block:IsHidden()
	return true
end

function modifier_item_infused_robe_damage_block:IsDebuff()
	return false
end

function modifier_item_infused_robe_damage_block:IsPurgable()
	return false
end

function modifier_item_infused_robe_damage_block:OnCreated(event)
	if not IsServer() then
		return
	end

	local ability = self:GetAbility()
	if ability and not ability:IsNull() then
		self.block_chance = ability:GetSpecialValueFor("damage_block_chance")
		self.block_amount = ability:GetSpecialValueFor("damage_block")
	end
end

modifier_item_infused_robe_damage_block.OnRefresh = modifier_item_infused_robe_damage_block.OnCreated

function modifier_item_infused_robe_damage_block:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}

	return func
end

if IsServer() then
	function modifier_item_infused_robe_damage_block:GetModifierTotal_ConstantBlock(event)
		local parent = self:GetParent()
		local attacker = event.attacker
		local damage_type = event.damage_type

		-- If the parent has Anti-Damage barrier, dont block anything, let the barrier do its job instead
		if parent:HasModifier("modifier_item_infused_robe_damage_barrier") then
			return 0
		end

		-- Don't work on illusions
		if parent:IsIllusion() then
			return 0
		end

		-- Check if attacker exists
		if not attacker or attacker:IsNull() then
			return 0
		end

		-- Check if its self damage
		if parent == attacker then
			return 0
		end

		-- Don't block damage from towers and the fountain
		if attacker:IsTower() or attacker:IsFountain() then
			return 0
		end
		
		local block_amount = 0
		if self.block_amount then
			block_amount = math.min(event.damage, self.block_amount)
		end
		if self.block_chance then
			if RollPercentage(self.block_chance) then
				-- Show block message
				if damage_type == DAMAGE_TYPE_PHYSICAL then
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, parent, block_amount, nil)
				else
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, parent, block_amount, nil)
				end

				return block_amount
			end
		end

		return 0
	end
end

---------------------------------------------------------------------------------------------------

modifier_item_infused_robe_damage_barrier = modifier_item_infused_robe_damage_barrier or class({})

function modifier_item_infused_robe_damage_barrier:IsHidden()
	return false
end

function modifier_item_infused_robe_damage_barrier:IsDebuff()
	return false
end

function modifier_item_infused_robe_damage_barrier:IsPurgable()
	return false
end

function modifier_item_infused_robe_damage_barrier:OnCreated(event)
	if not IsServer() then
		return
	end

	self:SetStackCount(event.barrier)
end

function modifier_item_infused_robe_damage_barrier:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}

	return func
end

if IsServer() then
	function modifier_item_infused_robe_damage_barrier:GetModifierTotal_ConstantBlock(event)
		local parent = self:GetParent()
		local attacker = event.attacker
		
		-- Don't work on illusions
		if parent:IsIllusion() then
			return 0
		end

		-- Check if attacker exists
		if not attacker or attacker:IsNull() then
			return 0
		end

		-- Check if its self damage
		if parent == attacker then
			return 0
		end

		-- start with the maximum block amount
		local blockAmount = event.damage
		-- grab the remaining barrier hp
		local hp = self:GetStackCount()

		-- don't block more than remaining hp
		blockAmount = math.min(blockAmount, hp)

		-- reduce barrier hp
		self:SetStackCount(hp - blockAmount)

		-- destroy the modifier if hp is reduced to nothing
		if self:GetStackCount() <= 0 then
		  self:Destroy()
		end

		return blockAmount
	end
end

function modifier_item_infused_robe_damage_barrier:GetEffectName()
	return "particles/units/heroes/hero_medusa/medusa_mana_shield_oldbase.vpcf"
end

--function modifier_item_infused_robe_damage_barrier:GetEffectAttachType()
	--return --follow_origin
--end
