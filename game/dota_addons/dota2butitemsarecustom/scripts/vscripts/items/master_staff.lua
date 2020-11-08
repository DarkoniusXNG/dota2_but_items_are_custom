LinkLuaModifier("modifier_item_master_staff_muted", "items/master_staff.lua", LUA_MODIFIER_MOTION_NONE)

item_master_staff = class({})

function item_master_staff:GetIntrinsicModifierName()
	return "modifier_generic_bonus"
end

function item_master_staff:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	-- Don't do anything if target has Spell Block
	if target:TriggerSpellAbsorb(self) then
		return
	end

	local debuff_duration = self:GetSpecialValueFor("mute_duration")
	
	local function DispelEnemy(unit)
		if unit then
			unit:RemoveModifierByName("modifier_eul_cyclone")
			unit:RemoveModifierByName("modifier_brewmaster_storm_cyclone")
			-- Basic Dispel
			local RemovePositiveBuffs = true
			local RemoveDebuffs = false
			local BuffsCreatedThisFrameOnly = false
			local RemoveStuns = false
			local RemoveExceptions = false
			unit:Purge(RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
		end
	end

	if target:IsIllusion() then
		-- Sound on illusions is before the actual effect
		target:EmitSound("DOTA_Item.Nullifier.Target")
		-- Kill the illusions
		target:Kill(self, caster)
	else
		DispelEnemy(target)

		-- Apply item debuff
		target:AddNewModifier(caster, self, "modifier_item_master_staff_muted", {duration = debuff_duration})

		-- Sound on real heroes is after actual effect
		target:EmitSound("DOTA_Item.Nullifier.Target")
	end
end

---------------------------------------------------------------------------------------------------

modifier_item_master_staff_muted = modifier_item_master_staff_muted or class({})

function modifier_item_master_staff_muted:IsHidden()
  return false
end

function modifier_item_master_staff_muted:IsDebuff()
  return true
end

function modifier_item_master_staff_muted:IsPurgable()
  return true
end

function modifier_item_master_staff_muted:OnCreated()
	if not IsServer() then
		return
	end
	
	local parent = self:GetParent()
	local caster = self:GetCaster()
	
	CustomItemDisable(caster, parent)
end

function modifier_item_master_staff_muted:OnDestroy()
	if not IsServer() then
		return
	end
	
	local parent = self:GetParent()
	local caster = self:GetCaster()
	
	CustomItemEnable(caster, parent)
end

function modifier_item_master_staff_muted:GetEffectName()
	return "particles/items4_fx/nullifier_mute_debuff.vpcf"
end

function modifier_item_master_staff_muted:GetStatusEffectName()
	return "particles/status_fx/status_effect_nullifier.vpcf"
end

-- This function disables inventory and removes item passives.
function CustomItemDisable(caster, unit)
	local passive_item_modifiers_exceptions ={
		"modifier_item_empty_bottle",
		"modifier_item_observer_ward",
		"modifier_item_tome_of_knowledge",
		"modifier_item_sentry_ward",
		"modifier_item_blink_dagger",
		"modifier_item_armlet_unholy_strength"
	}
	if unit then
		for itemSlot = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
			local item = unit:GetItemInSlot(itemSlot)
			if item then
				local item_owner = item:GetPurchaser()
				local unit_owner = unit:GetOwner()
				local caster_owner = caster:GetOwner()

				-- Store original purchaser only for the first time when CustomItemDisable is called 
				if item.original_purchaser == nil then
					item.original_purchaser = item_owner
				end

				if item_owner == unit then
					item:SetPurchaser(caster)
				elseif item_owner == unit_owner then
					item:SetPurchaser(caster_owner)
				end
			end
		end
		-- Find All modifiers (ALL buffs, debuffs, passives)
		local all_modifiers = unit:FindAllModifiers()
		-- Iterate through each one and check their ability
		for _, modifier in pairs(all_modifiers) do
			if modifier then
				local modifier_ability = modifier:GetAbility()			-- can be nil
				if modifier_ability then
					if modifier_ability:IsItem() then
						if not modifier_ability:IsNeutralDrop() then
							-- Get the duration of the item modifier
							local item_modifier_duration = modifier:GetDuration()
							-- If the modifier duration is -1 (infinite duration) there is a chance that this is a passive modifier
							if item_modifier_duration == -1 then
								-- Get the name of the item modifier
								local item_modifier_name = modifier:GetName()
								-- Initializing handle: safe_to_remove
								modifier.safe_to_remove = true
								for i = 1, #passive_item_modifiers_exceptions do
									if item_modifier_name == passive_item_modifiers_exceptions[i] then
										modifier.safe_to_remove = false
									end
								end
								if modifier.safe_to_remove == true then
									unit:RemoveModifierByName(item_modifier_name)
								end
							end
						end
					end
				end
			end
		end

		-- Preventing dropping and selling items in inventory
		unit:SetHasInventory(false)
		unit:SetCanSellItems(false)
	else
		print("unit is nil!")
	end
end

-- This function enables inventory and item passives if they were disabled with CustomItemDisable
function CustomItemEnable(caster, unit)
	if unit then
		for itemSlot = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
			local item = unit:GetItemInSlot(itemSlot)
			if item then
				local item_owner = item:GetPurchaser()
				local unit_owner = unit:GetOwner()
				local caster_owner = caster:GetOwner()
				if item_owner == caster then
					item:SetPurchaser(unit)
				elseif item_owner == caster_owner then
					item:SetPurchaser(unit_owner)
				end

				if item.original_purchaser then
					item:SetPurchaser(item.original_purchaser)
				end
			end
		end

		-- Enable dropping and selling items back
		unit:SetHasInventory(true)
		unit:SetCanSellItems(true)

		-- To reset unit's items and their passive modifiers: add an item and remove it (really Hacky way of doing it)
		-- HasAnyAvailableInventorySpace() is bugged in that it counts wards as empty inventory slots for some reason; I made a custom one
		--[[
			local function HasAnyAvailableInventorySpace_Custom(unit)
				for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
					-- This will work only if unit has GetItemInSlot method
					local item = unit:GetItemInSlot(i)

					-- If there is not item in a slot, then we have a free space
					if not item then
						return true
					end
				end

				-- If we got here, then we don't have a free space
				return false
			end
			if HasAnyAvailableInventorySpace_Custom(unit) then
				local new_item = CreateItem("item_magic_wand", unit, unit)
				unit:AddItem(new_item)
				new_item:RemoveSelf()
			end
		]]
		for itemSlot = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
			local item = unit:GetItemInSlot(itemSlot)
			if item then
				if item:IsInBackpack() == false then
					item:OnUnequip()
					item:OnEquip()
				end
			end
		end

		unit:CalculateStatBonus()
	else
		print("unit is nil!")
	end
end
