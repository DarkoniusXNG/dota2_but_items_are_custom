-- In this file you can set up all the properties and settings for your game mode.
USE_DEBUG = true                       -- Should we print statements on almost every function/event call? For debugging.

BUTTINGS = {
	-- These will be the default settings shown on the Team Select screen.
	GAME_TITLE = "Dota 2 but...",

	GAME_MODE = "AP",                   -- "AR" "AP" All Random/ All Pick
	ALLOW_SAME_HERO_SELECTION = 0,      -- 0 = everyone must pick a different hero, 1 = can pick same
	HERO_BANNING = 0,                   -- 0 = no banning, 1 = banning phase
	--USE_BOTS = 0, -- TODO
	MAX_LEVEL = 30,

	UNIVERSAL_SHOP_MODE = 1,            -- 0 = normal, 1 = you can buy every item in every shop (secret/side/base).
	--ALWAYS_PASSIVE_GOLD = 0,			-- 0 = normal (always),  1 = when custom courier is dead passive gold is disabled;
	--COOLDOWN_PERCENTAGE = 100,          -- (default = 100) factor for all cooldowns
	GOLD_GAIN_PERCENTAGE = 100,         -- (default = 100) factor for gold income
	GOLD_PER_MINUTE = 95,               -- (default =  95) passive gold
	RESPAWN_TIME_PERCENTAGE = 100,      -- (default = 100) factor for respawn time
	XP_GAIN_PERCENTAGE = 100,           -- (default = 100) factor for xp income

	--TOMBSTONE = 0,                      -- 0 = normal, 1 = You spawn a tombstone when you die. Teammates can ressurect you by channeling it.
	--MAGIC_RES_CAP = 0,                  -- 0 = normal, 1 = Keeps Magic Resistance <100%
	--CLASSIC_ARMOR = 0,

	--NO_UPHILL_MISS = 0,                 -- 0 = normal, 1 = 0% uphill muss chance
	--OUTPOST_SHOP = 0,                   -- 0 = normal, 1 = jungle shops
	--SIDE_SHOP = 0,                      -- 0 = normal, 1 = bring back sideshops
	--FREE_COURIER = 1,
	XP_PER_MINUTE = 0,                  -- (normal dota = 0) everyone gets passive experience (like the passive gold)
	--COMEBACK_TIMER = 30,                -- timer (minutes) to start comeback XP / gold 
	--COMEBACK_GPM = 60,                  -- passive gold for the poorest team
	--COMEBACK_XPPM = 120,                -- passive experience for the lowest team
	--SHARED_GOLD_PERCENTAGE = 0,         -- all gold (except passive) is shared with teammates
	--SHARED_XP_PERCENTAGE = 0,           -- all experience (except passive) is shared with teammates

	ALT_WINNING = 0,                    -- 0 = normal, 1 = use these alternative winning conditions
	ALT_KILL_LIMIT = 100,               -- Kills for alternative winnning
	--ALT_TIME_LIMIT = 60,                -- Timer for alternative winning

	BUYBACK_RULES = 0,                  -- 0 = normal, 1 = use buyback restrictions
	--BUYBACK_LIMIT = 1,                  -- Max amount of buybacks
	BUYBACK_COOLDOWN = 600,             -- Cooldown for buyback
}

function table.copy(tabel)
	if ("table"~=type(tabel)) then error("Argument of table.copy() is not a table",2) end
	local out = {}
	for k,v in pairs(tabel) do
		out[k]=v
	end
	return out
end

BUTTINGS_DEFAULT = table.copy(BUTTINGS)

ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = BUTTINGS.UNIVERSAL_SHOP_MODE == 1             -- Should the shops contain all items?
ALLOW_SAME_HERO_SELECTION = BUTTINGS.ALLOW_SAME_HERO_SELECTION == 1       -- Should we let people select the same hero as each other
LOCK_TEAMS = false                      -- Should we Lock (true) or unlock (false) team assignemnt. If team assignment is locked players cannot change teams.

CUSTOM_GAME_SETUP_TIME = 25.0           -- How long should custom game setup last - the screen where players pick a team?
HERO_SELECTION_TIME = 60.0              -- How long should we let people select their hero? Should be at least 5 seconds.
HERO_SELECTION_PENALTY_TIME = 30.0      -- How long should the penalty time for not picking a hero last? During this time player loses gold.
ENABLE_BANNING_PHASE = BUTTINGS.HERO_BANNING == 1            -- Should we enable banning phase? Set to true if "EnablePickRules" is "1" in 'addoninfo.txt'
BANNING_PHASE_TIME = 20.0               -- How long should the banning phase last? This will work only if "EnablePickRules" is "1" in 'addoninfo.txt'
STRATEGY_TIME = 20.0                    -- How long should strategy time last? Bug: You can buy items during strategy time and it will not be spent!
SHOWCASE_TIME = 0.0                     -- How long should show case time be?
PRE_GAME_TIME = 90.0                    -- How long after showcase time should the horn blow and the game start?
POST_GAME_TIME = 180.0                   -- How long should we let people stay around before closing the server automatically?
TREE_REGROW_TIME = 300.0                -- How long should it take individual trees to respawn after being cut down/destroyed?

NORMAL_START_GOLD = 600                 -- Starting Gold
PASSIVE_GOLD_PER_MINUTE = BUTTINGS.GOLD_PER_MINUTE
PASSIVE_XP_PER_MINUTE = BUTTINGS.XP_PER_MINUTE

RECOMMENDED_BUILDS_DISABLED = false     -- Should we disable the recommended item builds for heroes? Turns the panel for showing recommended items at the shop off/on.
CAMERA_DISTANCE_OVERRIDE = 1134.0       -- How far out should we allow the camera to go? 1134 is the default in Dota.

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

BUYBACK_ENABLED = BUTTINGS.BUYBACK_RULES == 0                  -- Should we allow players to buyback when they die?
CUSTOM_BUYBACK_COST_ENABLED = false     -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = BUTTINGS.BUYBACK_COOLDOWN ~= 480  -- Should we use a custom buyback time?
CUSTOM_BUYBACK_COOLDOWN_TIME = BUTTINGS.BUYBACK_COOLDOWN            -- Custom buyback cooldown time (needed if CUSTOM_BUYBACK_COOLDOWN_ENABLED is true).
BUYBACK_FIXED_GOLD_COST = 500           -- Fixed custom buyback gold cost (needed if CUSTOM_BUYBACK_COST_ENABLED is true).

CUSTOM_SCAN_COOLDOWN = 210              -- Custom cooldown of Scan in seconds. Doesn't affect Scan's starting cooldown!
CUSTOM_GLYPH_COOLDOWN = 300             -- Custom cooldown of Glyph in seconds. Doesn't affect Glyph's starting cooldown!

DISABLE_FOG_OF_WAR_ENTIRELY = false     -- Should we disable fog of war entirely for both teams?
USE_UNSEEN_FOG_OF_WAR = false           -- Should we make unseen and fogged areas of the map completely black until uncovered by each team? 
-- NOTE: DISABLE_FOG_OF_WAR_ENTIRELY must be false for USE_UNSEEN_FOG_OF_WAR to work
USE_STANDARD_DOTA_BOT_THINKING = false  -- Should we have bots act like they would in Dota? (This requires 3 lanes, vanilla items, vanilla heroes etc)

USE_CUSTOM_HERO_GOLD_BOUNTY = false     -- Should the gold for hero kills be modified (true) or same as in default Dota (false)?
HERO_KILL_GOLD_BASE = 110               -- Hero gold bounty base value
HERO_KILL_GOLD_PER_LEVEL = 10           -- Hero gold bounty increase per level
HERO_KILL_GOLD_PER_STREAK = 60          -- Hero gold bounty per his kill-streak (Killing Spree: +HERO_KILL_GOLD_PER_STREAK gold; Ultrakill: +2 x HERO_KILL_GOLD_PER_STREAK gold ...)

USE_CUSTOM_HERO_LEVELS = false          -- Should the heroes give a custom amount of XP when killed? Can malfunction for levels above 30!

USE_CUSTOM_TOP_BAR_VALUES = true        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

--REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies? DOESN'T WORK
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players acquire gold?

END_GAME_ON_KILLS = BUTTINGS.ALT_WINNING == 1               -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = BUTTINGS.ALT_KILL_LIMIT        -- How many kills for a team should signify an end of game?

USE_CUSTOM_XP_VALUES = BUTTINGS.MAX_LEVEL ~= 30            -- Should we use custom XP values to level up heroes, or the default Dota numbers?
MAX_LEVEL = BUTTINGS.MAX_LEVEL                             -- What level should we let heroes get to? (USE_CUSTOM_XP_VALUES must be true).
-- NOTE: MAX_LEVEL and XP_PER_LEVEL_TABLE will not work if USE_CUSTOM_XP_VALUES is false or nil.

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
XP_PER_LEVEL_TABLE[1] = 0
XP_PER_LEVEL_TABLE[2] = 200
XP_PER_LEVEL_TABLE[3] = 600
XP_PER_LEVEL_TABLE[4] = 1000
XP_PER_LEVEL_TABLE[5] = 1600
XP_PER_LEVEL_TABLE[6] = 2200
XP_PER_LEVEL_TABLE[7] = 2600
XP_PER_LEVEL_TABLE[8] = 3100
XP_PER_LEVEL_TABLE[9] = 3800
XP_PER_LEVEL_TABLE[10] = 4500
XP_PER_LEVEL_TABLE[11] = 5100
XP_PER_LEVEL_TABLE[12] = 6000
XP_PER_LEVEL_TABLE[13] = 7000
XP_PER_LEVEL_TABLE[14] = 8100
XP_PER_LEVEL_TABLE[15] = 9200
XP_PER_LEVEL_TABLE[16] = 9400
XP_PER_LEVEL_TABLE[17] = 9800
XP_PER_LEVEL_TABLE[18] = 11000
XP_PER_LEVEL_TABLE[19] = 12400
XP_PER_LEVEL_TABLE[20] = 13900
XP_PER_LEVEL_TABLE[21] = 15400
XP_PER_LEVEL_TABLE[22] = 16150
XP_PER_LEVEL_TABLE[23] = 18150
XP_PER_LEVEL_TABLE[24] = 20400
XP_PER_LEVEL_TABLE[25] = 22000
for i = 26, MAX_LEVEL do
  XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + i*100
end

ENABLE_FIRST_BLOOD = true               -- Should we enable first blood for the first kill in this game?
HIDE_KILL_BANNERS = false               -- Should we hide the kill banners that show when a player is killed?
LOSE_GOLD_ON_DEATH = false              -- Should we have players lose the normal amount of dota gold on death?
SHOW_ONLY_PLAYER_INVENTORY = false      -- Should we allow players to only see their own inventory even when selecting other units?
DISABLE_STASH_PURCHASING = false        -- Should we prevent players from being able to buy items into their stash when not at a shop?
DISABLE_ANNOUNCER = false               -- Should we disable the announcer from working in the game?
FORCE_PICKED_HERO = nil                 -- What hero should we force all players to spawn as? (e.g. "npc_dota_hero_axe").  Use nil to allow players to pick their own hero.
-- This will not work if "EnablePickRules" is "1" in 'addoninfo.txt'!

SKILL_POINTS_AT_EVERY_LEVEL = false     -- Should we allow heroes to gain skill points even at levels 17, 19, 21, 22, 23 and 24?
-- NOTE: If SKILL_POINTS_AT_EVERY_LEVEL is true, there will be strange interactions with heroes like Invoker and Meepo.

-- NOTE: use FIXED_RESPAWN_TIME if you want the same respawn time on every level.
MAX_RESPAWN_TIME = 125					-- Default Dota doesn't have a limit (it can go above 125). Fast game modes should have 20 seconds.
USE_CUSTOM_RESPAWN_TIMES = false		-- Should we use custom respawn times (true) or dota default (false)?

-- Fill this table with respawn times on each level if USE_CUSTOM_RESPAWN_TIMES is true.
CUSTOM_RESPAWN_TIME = {}
CUSTOM_RESPAWN_TIME[1] = 5
CUSTOM_RESPAWN_TIME[2] = 7
CUSTOM_RESPAWN_TIME[3] = 9
CUSTOM_RESPAWN_TIME[4] = 13
CUSTOM_RESPAWN_TIME[5] = 16
CUSTOM_RESPAWN_TIME[6] = 26
CUSTOM_RESPAWN_TIME[7] = 28
CUSTOM_RESPAWN_TIME[8] = 30
CUSTOM_RESPAWN_TIME[9] = 32
CUSTOM_RESPAWN_TIME[10] = 34
CUSTOM_RESPAWN_TIME[11] = 36
CUSTOM_RESPAWN_TIME[12] = 44
CUSTOM_RESPAWN_TIME[13] = 46
CUSTOM_RESPAWN_TIME[14] = 48
CUSTOM_RESPAWN_TIME[15] = 50
CUSTOM_RESPAWN_TIME[16] = 52
CUSTOM_RESPAWN_TIME[17] = 54
CUSTOM_RESPAWN_TIME[18] = 65
CUSTOM_RESPAWN_TIME[19] = 70
CUSTOM_RESPAWN_TIME[20] = 75
CUSTOM_RESPAWN_TIME[21] = 80
CUSTOM_RESPAWN_TIME[22] = 85
CUSTOM_RESPAWN_TIME[23] = 90
CUSTOM_RESPAWN_TIME[24] = 95
CUSTOM_RESPAWN_TIME[25] = 100

if MAX_LEVEL > 25 then
	for i = 26, MAX_LEVEL do
		CUSTOM_RESPAWN_TIME[i] = CUSTOM_RESPAWN_TIME[i-1] + 5
	end
end

FOUNTAIN_CONSTANT_MANA_REGEN = -1       -- What should we use for the constant fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_MANA_REGEN = -1     -- What should we use for the percentage fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_HEALTH_REGEN = -1   -- What should we use for the percentage fountain health regen?  Use -1 to keep the default dota behavior.
MAXIMUM_ATTACK_SPEED = 700              -- What should we use for the maximum attack speed?
MINIMUM_ATTACK_SPEED = 10               -- What should we use for the minimum attack speed?

DISABLE_DAY_NIGHT_CYCLE = false         -- Should we disable the day night cycle from naturally occurring? (Manual adjustment still possible)
DISABLE_KILLING_SPREE_ANNOUNCER = false -- Should we disable the killing spree announcer?
DISABLE_STICKY_ITEM = false             -- Should we disable the sticky item button in the quick buy area?
ENABLE_PAUSING = true                   -- Should we allow players to pause the game?

FORCE_MINIMAP_ON_THE_LEFT = false       -- Should we disable hud flip aka force the default dota hud positions? 
-- Note: Some players have minimap on the right and gold/shop on the left.

MAX_NUMBER_OF_TEAMS = 2                         -- How many potential teams can be in this game mode?
USE_CUSTOM_TEAM_COLORS = false                  -- Should we use custom team colors?
USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS = false      -- Should we use custom team colors to color the players/minimap?

TEAM_COLORS = {}                        -- If USE_CUSTOM_TEAM_COLORS is set, use these colors.
TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }  --    Teal
TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }   --    Yellow
TEAM_COLORS[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }  --    Pink
TEAM_COLORS[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }   --    Orange
TEAM_COLORS[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }   --    Blue
TEAM_COLORS[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }  --    Green
TEAM_COLORS[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }   --    Brown
TEAM_COLORS[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }  --    Cyan
TEAM_COLORS[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }  --    Olive
TEAM_COLORS[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }  --    Purple

USE_AUTOMATIC_PLAYERS_PER_TEAM = true   -- Should we set the number of players to 10 / MAX_NUMBER_OF_TEAMS?

CUSTOM_TEAM_PLAYER_COUNT = {}           -- If we're not automatically setting the number of players per team, use this table
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 5 -- you need to set this for each map if maps have a different max number of players per team
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 5 -- you need to set this for each map if maps have a different max number of players
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_1] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_2] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_3] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_4] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_5] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_6] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_7] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_8] = 0
