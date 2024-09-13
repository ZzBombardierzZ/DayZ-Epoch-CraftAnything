# Bomb's craftAnything for DayZ Epoch 1.0.7.1+
A script I originally wrote for TLF servers, but with their permission I am releasing to the public to celebrate getting the A2 Community Dev role in the Epoch Discord.
This script allows you to add a ton of craftable items to your server. It is super modular, and takes up very little space. It is also very easy to configure. You can add as many configs as you want. TLF has come up with about 40 custom crafting configs, I have included their turret configs in the example configVariables.sqf file.

I was inspired by deployAnything which is an excellent script and provides easy object or vehicle placements.

## Features
- Ability to add a right-click option to any magazine or weapon/tool, and then add requirements to craft something from that right-clicked item.
- Modular and Lightweight System
- Highly configurable, supporting all sorts of different crafting requirements.

## Installation & Setup
1. Download the code as a zip file
2. Copy the craftAnything.sqf file into your mission folder, inside of a "scripts" folder. Example: "ServerRoot\mpmissions\DayZ_Epoch_11.Chernarus\scripts\craftAnything.sqf"
3. In your compiles.sqf file, copy the `bomb_combineArrayOfDuplicates` section in the provided compiles.sqf file and paste it in your compiles.sqf file somewhere under `if (!isDedicated) then {` as shown in the file.
4. In configVariables.sqf, find the `DZE_CLICK_ACTIONS` array and add the desired configs to it. See the example configVariables.sqf file for more info.
5. Go into the newly created craftAnything.sqf file and edit the "CONFIG SECTION" to your liking. Read the comments in the file for more info.

## Battleye Filters Warning
If you are using Battleye on your server, you will need to update your scripts.txt file to allow the script to run. I am not going to provide a list of filters unfortunately. It is fairly easy to do yourself. You can look at https://opendayz.net/threads/a-guide-to-battleye-filters.21066/ to learn more about BattlEye filters and use https://github.com/eraser1/BE_AEG to generate scripts.txt filters automatically.

# Credits
As mentioned before, I originally wrote this script for TLF servers. I would like to thank them for allowing me to release this to the public. I would also like to thank the Epoch Discord community for their help and support and for giving me the opportunity to become a Community Developer.

# License
There is none. But please give credit where credit is due. If you do use this script and enjoy it, consider leting me know. I would love to see what you do with it.

# Contact
If you have any questions, comments, or concerns, please feel free to contact me on Discord `Bomb99` or in the Epoch Discord server.

# Changelog
* v1.0.0 - 2023-01-22 - Initial release
* v1.0.1 - 2023-04-12 - Added `bomb_combineArrayOfDuplicates` function to compiles.sqf file. Thanks to Gnominger in discord for pointing out this issue.
