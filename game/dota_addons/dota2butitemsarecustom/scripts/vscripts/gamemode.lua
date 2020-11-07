-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
BAREBONES_VERSION = "2.0.10"

-- Selection library (by Noya) provides player selection inspection and management from server lua
require('libraries/selection')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')
-- filters.lua
require('filters')

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function barebones:PostLoadPrecache()
	DebugPrint("[BAREBONES] Performing Post-Load precache.")
	--PrecacheItemByNameAsync("item_example_item", function(...) end)
	--PrecacheItemByNameAsync("example_ability", function(...) end)

	--PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
	--PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function barebones:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game.")
  
  if BUTTINGS.GAME_MODE ~= "AR" then
    -- Force Random a hero for every player that didnt pick a hero when time runs out
    local delay = HERO_SELECTION_TIME + HERO_SELECTION_PENALTY_TIME + STRATEGY_TIME - 0.1
    if ENABLE_BANNING_PHASE then
	  delay = delay + BANNING_PHASE_TIME
    end
    Timers:CreateTimer(delay, function()
	  for playerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
	    if PlayerResource:IsValidPlayerID(playerID) then
		  -- If this player still hasn't picked a hero, random one
		  -- PlayerResource:IsConnected(index) is custom-made; can be found in 'player_resource.lua' library
		  if not PlayerResource:HasSelectedHero(playerID) and PlayerResource:IsConnected(playerID) and not PlayerResource:IsBroadcaster(playerID) then
		    PlayerResource:GetPlayer(playerID):MakeRandomHeroSelection() -- this will cause an error if player is disconnected, that's why we check if player is connected
		    PlayerResource:SetHasRandomed(playerID)
		    PlayerResource:SetCanRepick(playerID, false)
		    DebugPrint("[BAREBONES] Randomed a hero for a player number "..playerID)
		  end
	    end
	  end
    end)
  end
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function barebones:OnGameInProgress()
	DebugPrint("[BAREBONES] The game has officially begun.")

end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function barebones:InitGameMode()
	DebugPrint("[BAREBONES] Starting to load Game Rules.")

	CustomNetTables:SetTableValue("butt_settings", "default", BUTTINGS)
	CustomGameEventManager:RegisterListener("butt_setting_changed", function(_,kv)
		BUTTINGS[kv.setting] = kv.value
		print(kv.setting, ":", kv.value)
	end)
	CustomGameEventManager:RegisterListener("butt_on_clicked", function(_,kv)
		local name = kv.button
		if name == "RESET" then
			-- BUTTINGS = table.copy(BUTTINGS_DEFAULT)
			for k, v in pairs(BUTTINGS_DEFAULT) do
				CustomGameEventManager:Send_ServerToAllClients("butt_setting_changed", {setting = k, value = v})
			end
		end
	end)
	CustomGameEventManager:RegisterListener("endscreen_butt", function(_,request)
		local playerInfo = {}
		print("endscreen_butt requested")
		for k,v in pairs(request) do
			print("req",k,v,type(k))
			local pID = tonumber(k)
			if pID then
				-- print(pID,v.team)
				playerInfo[pID] = { team = v.team }
				playerInfo[pID].Kills = PlayerResource:GetKills(pID).." ("..PlayerResource:GetStreak(pID)..")"
				playerInfo[pID].Damage = PlayerResource:GetRawPlayerDamage(pID)
				playerInfo[pID].Healing = PlayerResource:GetHealing(pID)
				playerInfo[pID].LH = PlayerResource:GetLastHits(pID).." ("..PlayerResource:GetLastHitStreak(pID)..")"
				playerInfo[pID].GPM = math.floor(PlayerResource:GetGoldPerMin(pID)+0.5)
				playerInfo[pID].EPM = math.floor(PlayerResource:GetXPPerMin(pID)+0.5)
				playerInfo[pID].TotalXP = PlayerResource:GetTotalEarnedXP(pID)
				playerInfo[pID].DamageTaken = PlayerResource:GetCreepDamageTaken(pID) + PlayerResource:GetHeroDamageTaken(pID) + PlayerResource:GetTowerDamageTaken(pID)
				playerInfo[pID].GetGoldSpentOnItems = PlayerResource:GetGoldSpentOnItems(pID)
				playerInfo[pID].RunePickups = PlayerResource:GetRunePickups(pID)
			end
		end
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(request.PlayerID), "endscreen_butt", playerInfo)
	end)

	-- Setup rules
	--GameRules:SetSameHeroSelectionEnabled(ALLOW_SAME_HERO_SELECTION)
	--GameRules:SetUseUniversalShopMode(UNIVERSAL_SHOP_MODE)
	GameRules:SetHeroRespawnEnabled(ENABLE_HERO_RESPAWN)

	GameRules:SetHeroSelectionTime(HERO_SELECTION_TIME) --THIS IS IGNORED when "EnablePickRules" is "1" in 'addoninfo.txt' !
	GameRules:SetHeroSelectPenaltyTime(HERO_SELECTION_PENALTY_TIME)
	
	GameRules:SetPreGameTime(PRE_GAME_TIME)
	GameRules:SetPostGameTime(POST_GAME_TIME)
	GameRules:SetShowcaseTime(SHOWCASE_TIME)
	GameRules:SetStrategyTime(STRATEGY_TIME)

	GameRules:SetTreeRegrowTime(TREE_REGROW_TIME)

	if USE_CUSTOM_HERO_LEVELS then
		GameRules:SetUseCustomHeroXPValues(true)
	end

	GameRules:SetStartingGold(NORMAL_START_GOLD)

	if USE_CUSTOM_HERO_GOLD_BOUNTY then
		GameRules:SetUseBaseGoldBountyOnHeroes(false) -- if true Heroes will use their default base gold bounty which is similar to creep gold bounty, rather than DOTA specific formulas
	end

	GameRules:SetHeroMinimapIconScale(MINIMAP_ICON_SIZE)
	GameRules:SetCreepMinimapIconScale(MINIMAP_CREEP_ICON_SIZE)
	GameRules:SetRuneMinimapIconScale(MINIMAP_RUNE_ICON_SIZE)
	GameRules:SetFirstBloodActive(ENABLE_FIRST_BLOOD)
	GameRules:SetHideKillMessageHeaders(HIDE_KILL_BANNERS)
	GameRules:LockCustomGameSetupTeamAssignment(LOCK_TEAMS)

	-- This is multi-team configuration stuff
	if USE_AUTOMATIC_PLAYERS_PER_TEAM then
		local num = math.floor(10/MAX_NUMBER_OF_TEAMS)
		local count = 0
		for team,number in pairs(TEAM_COLORS) do
			if count >= MAX_NUMBER_OF_TEAMS then
				GameRules:SetCustomGameTeamMaxPlayers(team, 0)
			else
				GameRules:SetCustomGameTeamMaxPlayers(team, num)
			end
			count = count + 1
		end
	else
		local count = 0
		for team,number in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
			if count >= MAX_NUMBER_OF_TEAMS then
				GameRules:SetCustomGameTeamMaxPlayers(team, 0)
			else
				GameRules:SetCustomGameTeamMaxPlayers(team, number)
			end
			count = count + 1
		end
	end

	if USE_CUSTOM_TEAM_COLORS then
		for team,color in pairs(TEAM_COLORS) do
			SetTeamCustomHealthbarColor(team, color[1], color[2], color[3])
		end
	end

	DebugPrint("[BAREBONES] Done with setting Game Rules.")

	-- Event Hooks / Listeners
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(barebones, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(barebones, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(barebones, 'OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(barebones, 'OnConnectFull'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(barebones, 'OnDisconnect'), self)
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(barebones, 'OnItemPickedUp'), self)
	ListenToGameEvent('last_hit', Dynamic_Wrap(barebones, 'OnLastHit'), self)
	ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(barebones, 'OnRuneActivated'), self)
	ListenToGameEvent('tree_cut', Dynamic_Wrap(barebones, 'OnTreeCut'), self)

	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(barebones, 'OnAbilityUsed'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(barebones, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(barebones, 'OnNPCSpawned'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(barebones, 'OnPlayerPickHero'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(barebones, 'OnPlayerReconnect'), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap(barebones, 'OnPlayerChat'), self)

	ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(barebones, 'OnTowerKill'), self)
	ListenToGameEvent("dota_player_selected_custom_team", Dynamic_Wrap(barebones, 'OnPlayerSelectedCustomTeam'), self)
	ListenToGameEvent("dota_npc_goal_reached", Dynamic_Wrap(barebones, 'OnNPCGoalReached'), self)

	-- Change random seed for math.random function
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
	math.randomseed(tonumber(timeTxt))

	DebugPrint("[BAREBONES] Setting filters.")

	local gamemode = GameRules:GetGameModeEntity()

	-- Setting the Order filter 
	gamemode:SetExecuteOrderFilter(Dynamic_Wrap(barebones, "OrderFilter"), self)

	-- Setting the Damage filter
	gamemode:SetDamageFilter(Dynamic_Wrap(barebones, "DamageFilter"), self)

	-- Setting the Modifier filter
	gamemode:SetModifierGainedFilter(Dynamic_Wrap(barebones, "ModifierFilter"), self)

	-- Setting the Experience filter
	gamemode:SetModifyExperienceFilter(Dynamic_Wrap(barebones, "ExperienceFilter"), self)

	-- Setting the Tracking Projectile filter
	gamemode:SetTrackingProjectileFilter(Dynamic_Wrap(barebones, "ProjectileFilter"), self)

	-- Setting the bounty rune pickup filter
	gamemode:SetBountyRunePickupFilter(Dynamic_Wrap(barebones, "BountyRuneFilter"), self)

	-- Setting the Healing filter
	gamemode:SetHealingFilter(Dynamic_Wrap(barebones, "HealingFilter"), self)

	-- Setting the Gold Filter
	gamemode:SetModifyGoldFilter(Dynamic_Wrap(barebones, "GoldFilter"), self)

	-- Setting the Inventory filter
	gamemode:SetItemAddedToInventoryFilter(Dynamic_Wrap(barebones, "InventoryFilter"), self)

	DebugPrint("[BAREBONES] Done with setting Filters.")

	-- Global Lua Modifiers
	LinkLuaModifier("modifier_custom_invulnerable", "modifiers/modifier_custom_invulnerable", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_custom_passive_gold", "modifiers/modifier_custom_passive_gold.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_custom_passive_xp", "modifiers/modifier_custom_passive_xp.lua", LUA_MODIFIER_MOTION_NONE)

	print("[BAREBONES] initialized.")
	DebugPrint("[BAREBONES] Done loading the game mode!\n\n")
	
	-- Increase/decrease maximum item limit per hero
	Convars:SetInt('dota_max_physical_items_purchase_limit', 64)
end

-- This function is called as the first player loads and sets up the game mode parameters
function barebones:CaptureGameMode()
	local gamemode = GameRules:GetGameModeEntity()
	
	-- Set GameMode parameters
	gamemode:SetRecommendedItemsDisabled(RECOMMENDED_BUILDS_DISABLED)
	gamemode:SetCameraDistanceOverride(CAMERA_DISTANCE_OVERRIDE)
	--gamemode:SetBuybackEnabled(BUYBACK_ENABLED)
	gamemode:SetCustomBuybackCostEnabled(CUSTOM_BUYBACK_COST_ENABLED)
	--gamemode:SetCustomBuybackCooldownEnabled(CUSTOM_BUYBACK_COOLDOWN_ENABLED)
	gamemode:SetTopBarTeamValuesOverride(USE_CUSTOM_TOP_BAR_VALUES) -- Check if it works
	gamemode:SetTopBarTeamValuesVisible(TOP_BAR_VISIBLE)

	-- if USE_CUSTOM_XP_VALUES then
		-- gamemode:SetUseCustomHeroLevels(true)
		-- gamemode:SetCustomXPRequiredToReachNextLevel(XP_PER_LEVEL_TABLE)
	-- end

	gamemode:SetBotThinkingEnabled(USE_STANDARD_DOTA_BOT_THINKING)
	gamemode:SetTowerBackdoorProtectionEnabled(true)

	gamemode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
	gamemode:SetGoldSoundDisabled(DISABLE_GOLD_SOUNDS)
	--gamemode:SetRemoveIllusionsOnDeath(REMOVE_ILLUSIONS_ON_DEATH)

	gamemode:SetAlwaysShowPlayerInventory(SHOW_ONLY_PLAYER_INVENTORY)
	--gamemode:SetAlwaysShowPlayerNames(true) -- use this when you need to hide real hero names
	gamemode:SetAnnouncerDisabled(DISABLE_ANNOUNCER)
	if FORCE_PICKED_HERO ~= nil then
		gamemode:SetCustomGameForceHero(FORCE_PICKED_HERO) -- THIS WILL NOT WORK when "EnablePickRules" is "1" in 'addoninfo.txt' !
	else
		gamemode:SetDraftingHeroPickSelectTimeOverride(HERO_SELECTION_TIME)
		gamemode:SetDraftingBanningTimeOverride(0)
		-- if ENABLE_BANNING_PHASE then
			-- gamemode:SetDraftingBanningTimeOverride(BANNING_PHASE_TIME)
		-- end
	end
	--gamemode:SetFixedRespawnTime(FIXED_RESPAWN_TIME) -- FIXED_RESPAWN_TIME should be float
	gamemode:SetFountainConstantManaRegen(FOUNTAIN_CONSTANT_MANA_REGEN)
	gamemode:SetFountainPercentageHealthRegen(FOUNTAIN_PERCENTAGE_HEALTH_REGEN)
	gamemode:SetFountainPercentageManaRegen(FOUNTAIN_PERCENTAGE_MANA_REGEN)
	gamemode:SetLoseGoldOnDeath(LOSE_GOLD_ON_DEATH)
	gamemode:SetMaximumAttackSpeed(MAXIMUM_ATTACK_SPEED)
	gamemode:SetMinimumAttackSpeed(MINIMUM_ATTACK_SPEED)
	gamemode:SetStashPurchasingDisabled(DISABLE_STASH_PURCHASING)

	gamemode:SetUseDefaultDOTARuneSpawnLogic(true)

	gamemode:SetUnseenFogOfWarEnabled(USE_UNSEEN_FOG_OF_WAR)
	gamemode:SetDaynightCycleDisabled(DISABLE_DAY_NIGHT_CYCLE)
	gamemode:SetKillingSpreeAnnouncerDisabled(DISABLE_KILLING_SPREE_ANNOUNCER)
	gamemode:SetStickyItemDisabled(DISABLE_STICKY_ITEM)
	gamemode:SetPauseEnabled(ENABLE_PAUSING)
	gamemode:SetCustomScanCooldown(CUSTOM_SCAN_COOLDOWN)
	gamemode:SetCustomGlyphCooldown(CUSTOM_GLYPH_COOLDOWN)
	gamemode:DisableHudFlip(FORCE_MINIMAP_ON_THE_LEFT)

	gamemode:SetFreeCourierModeEnabled(true)
end

function barebones:AdjustGameMode()
	DebugPrint("[DOTA BUTT] Adjusting game mode settings and rules that were set by the host.")
	BUTTINGS = BUTTINGS or {}
	UNIVERSAL_SHOP_MODE = BUTTINGS.UNIVERSAL_SHOP_MODE == 1
	ALLOW_SAME_HERO_SELECTION = BUTTINGS.ALLOW_SAME_HERO_SELECTION == 1
	ENABLE_BANNING_PHASE = BUTTINGS.HERO_BANNING == 1
	PASSIVE_GOLD_PER_MINUTE = BUTTINGS.GOLD_PER_MINUTE
	PASSIVE_XP_PER_MINUTE = BUTTINGS.XP_PER_MINUTE
	CUSTOM_BUYBACK_COOLDOWN_ENABLED = BUTTINGS.BUYBACK_COOLDOWN ~= 480
	CUSTOM_BUYBACK_COOLDOWN_TIME = BUTTINGS.BUYBACK_COOLDOWN
	END_GAME_ON_KILLS = BUTTINGS.ALT_WINNING == 1
	KILLS_TO_END_GAME_FOR_TEAM = BUTTINGS.ALT_KILL_LIMIT
	USE_CUSTOM_XP_VALUES = BUTTINGS.MAX_LEVEL ~= 30
	MAX_LEVEL = BUTTINGS.MAX_LEVEL
	if MAX_LEVEL < 30 then
      XP_PER_LEVEL_TABLE = {}
	  XP_PER_LEVEL_TABLE[1] = 0
	end
	for i = #XP_PER_LEVEL_TABLE+1, MAX_LEVEL do
		XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + i*100
	end

	GameRules:SetSameHeroSelectionEnabled(ALLOW_SAME_HERO_SELECTION)
	GameRules:SetUseUniversalShopMode(UNIVERSAL_SHOP_MODE)
	
	local gamemode = GameRules:GetGameModeEntity()

	if BUTTINGS.GAME_MODE == "AR" then
		local delay = 0
		if ENABLE_BANNING_PHASE then
			delay = BANNING_PHASE_TIME
		end

		gamemode:SetThink( function()
			for playerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			  if PlayerResource:IsValidPlayerID(playerID) then
				if not PlayerResource:HasSelectedHero(playerID) and PlayerResource:IsConnected(playerID) and not PlayerResource:IsBroadcaster(playerID) then
				  PlayerResource:GetPlayer(playerID):MakeRandomHeroSelection() -- this will cause an error if player is disconnected, that's why we check if player is connected
				  PlayerResource:SetHasRandomed(playerID)
				  PlayerResource:SetCanRepick(playerID, false)
				  DebugPrint("[DOTA BUTT] Randomed a hero for a player number "..playerID)
				end
			  end
			end
		end, delay)
	end
	
	if ENABLE_BANNING_PHASE then
		gamemode:SetDraftingBanningTimeOverride(BANNING_PHASE_TIME)
	end

	gamemode:SetBuybackEnabled(BUYBACK_ENABLED)
	gamemode:SetCustomBuybackCooldownEnabled(CUSTOM_BUYBACK_COOLDOWN_ENABLED)

	if USE_CUSTOM_XP_VALUES then
		gamemode:SetUseCustomHeroLevels(true)
		gamemode:SetCustomXPRequiredToReachNextLevel(XP_PER_LEVEL_TABLE)
	end
end
