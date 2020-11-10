# Dota 2 but items are weird - Dota 2 custom game

### Version 0.0.3.

## Core Files
Core Files are the primary files which you should modify in order to get your basic game mode up and running.  There are 4 major files:

#### settings.lua
This file contains many special settings/properties that allows you to define the high-level behavior of your game mode.
You can define things like respawn times, number of teams on the map etc.  Each property is commented to help you understand it.

#### addon_game_mode.lua
This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc.

#### gamemode.lua
This is the primary gamemode script and should be used to assist in initializing your game mode.
This file contains helpful pseudo-event functions prepared for you for frequently needed initialization actions.

#### events.lua
This file contains hooked versions of most useful events that fire in the DotA 2 Engine.
You can drop your event functions in there to have your game mode react to events.

## Libraries

#### timers.lua [by BMDdota](https://github.com/bmddota)
This library allow for easily delayed/timed actions without the messiness of thinkers and dealing with pauses.

#### selection.lua [by Noya](https://github.com/MNoya)
This library allows for querying and managing the selection status of players from the server-side lua script.  It also allows for automatic redirection and selection event handling.
See [libraries/selection.lua](https://github.com/bmddota/barebones/blob/source2/game/dota_addons/barebones/scripts/vscripts/libraries/selection.lua) for usage details and examples.  

#### playerresource.lua
This library extends PlayerResource. It adds functions and handles that are important for detecting disconnected/abandoned players and for assigning heroes to players.

## Debugging
To debug code set the USE_DEBUG in settings.lua to true.

## Additional Information
- You can adjust the number of players allowed on each of your maps by editing both addoninfo.txt. and settings.lua
- DOTA 2 Scripting API both on Server and on Client side (maintained by ark120202): https://dota.tools/vscripts/
