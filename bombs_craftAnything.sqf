// Why make several files when I can just make one very dynamic file.
// I'm not going to have this support taking magazines or tools out of the backpack because fuck that shit.
// Made by Bomb for TLF server

// This script's functionality is to be a very dynamic script which lets you craftAnything, as the name implies. Please read through the comments below between lines 17 and 35 to understand how to use this script.

// Version 1.0.0
// Released 2023-01-22 for the public to use.

if (dayz_actionInProgress) exitWith {localize "str_player_actionslimit" call dayz_rollingMessages;};

dayz_actionInProgress = true;

//get parameters
local _configSetting = _this select 0;

// inits, don't edit
local _exit = false;
local _craftedItems = [];
local _craftedDisplayNames = "";
local _requiredMagazines = []; //EDIT IN CONFIG SECTION IF DESIRED. 
local _removeMags = []; //EDIT IN CONFIG SECTION IF DESIRED. do not have items in here that are not in required mags... This does support something awful looking like: _removeMags = ["ItemBandage",["ItemBandage",2],["ItemBandage",3]]; which would mean remove 6 bandages. Pointless, but just as example.
local _requiredTools = []; //EDIT IN CONFIG SECTION IF DESIRED. 
local _removeTools = []; //EDIT IN CONFIG SECTION IF DESIRED. do not have items in here that are not in required tools... Also don't have the same item twice here. It only supports 1 of any tool.
local _needNear = []; //EDIT IN CONFIG SECTION IF DESIRED. Looks for these objects within 5 meters, or whatever is defined in the config. "workshop" and "fire" are special cases, checking for multiple objects of that type.
local _needNearDistance = 5; //EDIT IN CONFIG SECTION IF DESIRED.

//CONFIG SECTION! THIS IS WHERE YOU EDIT....
switch (true) do {
    case (_configSetting == "Matches1"): { // RoadFlares to Matches Script. Matches1 should be called from configVariables. See example configVariables.sqf file.
        _requiredMagazines = ["HandRoadFlare","PartWoodPile"]; // This is the required magazines. Script will check if player has these magazines. If not, it will exit.
        _removeMags = _requiredMagazines; // This is the magazines that will be removed from the player. Note: Anything you put in here must be in the required magazines, or else they can use this script without having all required magazines.
        _requiredTools = ["ItemMatchboxEmpty","ItemKnife"]; // This is the required tools/weapons. Script will check if player has these tools/weapons. If not, it will exit.
        _removeTools = ["ItemMatchboxEmpty"]; // This is the tools/weapons that will be removed from the player. Note: Anything you put in here must be in the required tools, or else they can use this script without having all required tools.
        _craftedItems = ["ItemMatchbox"]; // This is the items that will be added to the player. Note: This can be an array of items, or just a single item. If you want to add more than one of an item, you can do it like this: ["ItemMatchbox",2] which would add 2 matchboxes to the player, however this is a bad example as you can only have 1 matchbox in your inventory. THIS CAN BE WEAPONS, MAGAZINES, OR EVEN A BACKPACK IF THE PLAYER IS NOT WEARING A BACKPACK.
    };

    //Turrets
    case (_configSetting == "KORD_Turret"): { //KORD TURRET KIT
        _requiredMagazines = ["bulk_empty",["ItemPole",3],["ItemScrews",2]];
        _removeMags = _requiredMagazines;
        _requiredTools = ["ItemToolbox","Screwdriver_DZE","Wrench_DZE","KSVK_DZE"]; 
        _removeTools = ["KSVK_DZE"];
        _craftedItems = ["KORD_MG_Static_kit"];
        _needNear = ["Advanced_WorkBench_DZ"];
    };
    case (_configSetting == "DSHKM_Turret"): { //DSHKM TURRET KIT
        _requiredMagazines = ["bulk_empty",["ItemPole",3],["ItemScrews",2]];
        _removeMags = _requiredMagazines;
        _requiredTools = ["ItemToolbox","Screwdriver_DZE","Wrench_DZE","UK59_DZ"]; 
        _removeTools = ["UK59_DZ"];
        _craftedItems = ["DSHKM_MG_Static_kit"];
        _needNear = ["Advanced_WorkBench_DZ"];
    };
    case (_configSetting == "M2_Turret"): { //M2 TURRET KIT
        _requiredMagazines = ["bulk_empty",["ItemPole",3],["ItemScrews",2]];
        _removeMags = _requiredMagazines;
        _requiredTools = ["ItemToolbox","Screwdriver_DZE","Wrench_DZE","Barrett_MRAD_Iron_DZ"]; 
        _removeTools = ["Barrett_MRAD_Iron_DZ"];
        _craftedItems = ["M2_MG_Static_kit"];
        _needNear = ["Advanced_WorkBench_DZ"];
    };
    case (_configSetting == "SEARCH_Turret"): { //SearchLight Turret Kit
        _requiredMagazines = ["bulk_empty",["ItemPole",2],"ItemScrews","ItemLightBulb"];
        _removeMags = _requiredMagazines;
        _requiredTools = ["ItemToolbox","Screwdriver_DZE","Wrench_DZE","ItemFlashlight"]; 
        _removeTools = ["ItemFlashlight"];
        _craftedItems = ["SearchLight_Static_kit"];
        _needNear = ["Advanced_WorkBench_DZ"];
    };


    default {
        _exit = true;
    };
};
//////////
if (_exit) exitWith {
    dayz_actionInProgress = false;
    systemchat "ERROR. Report this to the server admin. (Error Code 6969)";
};

_craftedItems = _craftedItems call bomb_combineArrayOfDuplicates;
local _backpackSpawnCount = 0;
{
    local _currentItem = _x;
    local _count = 1;
    if (typeName _currentItem == "ARRAY") then {
        _currentItem = _x select 0;
        _count = _x select 1;
    };
    
    if (_craftedDisplayNames != "") then {
        if (_forEachIndex == ((count _craftedItems) - 1)) then {
            _craftedDisplayNames = _craftedDisplayNames + " and ";
        } else {
            _craftedDisplayNames = _craftedDisplayNames + ", ";
        };
    };
    if (_count != 1) then {
        _craftedDisplayNames = _craftedDisplayNames + str _count + "x ";
    } else {
        _craftedDisplayNames = _craftedDisplayNames + "a ";
    };
    call {
        if (isClass(configFile >> 'CfgWeapons' >> _currentItem)) exitWith {
            _craftedDisplayNames = _craftedDisplayNames + str getText(configFile >> "CfgWeapons" >> _currentItem >> "displayName");
        };
        if (isClass(configFile >> 'CfgMagazines' >> _currentItem)) exitWith {
            _craftedDisplayNames = _craftedDisplayNames + str getText(configFile >> "CfgMagazines" >> _currentItem >> "displayName");
        };
        if (isClass(configFile >> 'CfgVehicles' >> _currentItem)) exitWith {
            if (_currentItem isKindOf "Bag_Base_EP1") then {
                if (!isNull (unitBackpack player)) then {
                    _backpackSpawnCount = _backpackSpawnCount + 1;
                    _craftedDisplayNames = _craftedDisplayNames + str getText(configFile >> "CfgVehicles" >> _currentItem >> "displayName");
                } else {
                    _exit = true;
                    systemChat "You can not craft a backpack when you are already wearing a backpack!";
                };
                if (_backpackSpawnCount > 1 || _count > 1) then {
                    _exit = true;
                    systemChat "Tell Admin they can only spawn ONE backpack in this script.";
                };
            } else {
                _exit = true;
                systemChat "WHY ARE YOU SPAWNING A VEHICLE. Tell admin they need to fix this.";
            };
        };
        _exit = true;
    };
} forEach _craftedItems;
if (_exit) exitWith {
    dayz_actionInProgress = false;
    systemchat "ERROR. Report this to the server admin. (Error Code 420 420)";
};
if (_craftedDisplayNames == "") then {_craftedDisplayNames = _craftedItems};

_removeMags = _removeMags call bomb_combineArrayOfDuplicates; //remove duplicates and puts strings into an array. Example: ["equip_duct_tape","ItemRuby",["equip_duct_tape",4]] becomes [["equip_duct_tape",5],["ItemRuby",1]]
_requiredMagazines = _requiredMagazines call bomb_combineArrayOfDuplicates;

// Check for nearby required objects
local _abort = false;
local _reason = "";
local _isNear = 0;
if ("fire" in _needNear) then {
	local _pPos = [player] call FNC_GetPos;
	_isNear = {inflamed _x} count (_pPos nearObjects _needNearDistance);
	if (_isNear == 0) then {
		_abort = true;
		_reason = localize "STR_EPOCH_FIRE";
	};
    _needNear = _needNear - ["fire"];
};
if ("workshop" in _needNear) then {
	_isNear = count (nearestObjects [player, DZE_Workshops, _needNearDistance]);
	if (_isNear == 0) then {
		_abort = true;
        if (_reason != "") then {
            _reason = _reason + " and " + localize "STR_EPOCH_WORKBENCH_NEARBY";
        } else {
            _reason = localize "STR_EPOCH_WORKBENCH_NEARBY";
        };
	};
    _needNear = _needNear - ["workshop"];
};
if (count _needNear > 0) then {
    {
        _isNear = count (nearestObjects [player, [_x], _needNearDistance]);
	    if(_isNear == 0) then {
		    _abort = true;
            if (_reason == "") then {
                _reason = str _x;
            } else {
                _reason = _reason + ", " + str _x;
            };
	    };
    } forEach _needNear;
};
if (_abort) exitWith {
	format[localize "str_epoch_player_149",_reason,_needNearDistance] call dayz_rollingMessages;
	dayz_actionInProgress = false;
};

//check if the player has the correct tools
if (["", _requiredTools, "none"] call dze_requiredItemsCheck) then {
    local _hasMags = true;
    //check if the player has the correct magazines
    if (count _requiredMagazines > 0) then {
        {
            if (typeName _x == "ARRAY") then {
                local _thisItem = _x select 0;
                if ({_thisItem == _x} count magazines player < (_x select 1)) then {
                    _hasMags = false;
                };
            } else {
                if (!(_x in magazines player)) then {
                    _hasMags = false;
                };
            };
        } forEach _requiredMagazines;
    };
    if (_hasMags) then {
        //Success, close menu, do the animation, remove the shit, and repair the thing.
        closeDialog 0;

        //animation
        local _exitWith = [
            //["dayz_playerUID in DZE_PlotManagementAdmins","admin"],
            ["r_interrupt",format ["Crafting %1 interrupted!",_craftedDisplayNames]],
            ["(player getVariable['inCombat',false])","You can't craft while in combat!"]
        ] call fnc_bike_crafting_animation;

        if (_exitWith != "nil" /*&& {_exitWith != "admin"}*/) exitWith {
            dayz_actionInProgress = false;
            taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
            systemchat format ["%1",_exitWith];
        };

        //remove the required magazines and weapons
        if (count _removeMags > 0) then {
            {
                if (typeName _x == "ARRAY") then {
                    for "_i" from 0 to ((_x select 1)-1) do {
                        player removeMagazine (_x select 0);
                    };
                } else {
                    player removeMagazine _x;
                };
            } forEach _removeMags;
        };
        if (count _removeTools > 0) then {
            {
                if (typeName _x == "ARRAY") then { //it really shouldn't ever be an array, but just in case...
                    for "_i" from 0 to ((_x select 1)-1) do {
                        player removeWeapon (_x select 0);
                    };
                } else {
                    player removeWeapon _x;
                };
            } forEach _removeTools;
        };

        //craft the item(s)
        {
            local _currentItem = _x;
            local _count = 1;
            if (typeName _currentItem == "ARRAY") then {
                _currentItem = _x select 0;
                _count = _x select 1;
            };
            
            call {
                if (isClass(configFile >> 'CfgWeapons' >> _currentItem)) exitWith {
                    for "_i" from 0 to (_count-1) do {
                        player addWeapon _currentItem;
                    };
                };
                if (isClass(configFile >> 'CfgMagazines' >> _currentItem)) exitWith {
                    for "_i" from 0 to (_count-1) do {
                        player addMagazine _currentItem;
                    };
                };
                if (isClass(configFile >> 'CfgVehicles' >> _currentItem)) exitWith {
                    if (_currentItem isKindOf "Bag_Base_EP1") then {
                        for "_i" from 0 to (_count-1) do {
                            player addBackpack _currentItem;
                        };
                    } else {
                        systemChat "You are spawning a vehicle? Tell the admin this is odd behavior.";
                    };
                };
            };
        } forEach _craftedItems;

        closeDialog 0; //done, but let's close the menu again in case they opened it during the animation.
        call player_forceSave;
        dayz_actionInProgress = false;
        format ["You have crafted %1", _craftedDisplayNames] call dayz_rollingMessages;

    } else {
        systemChat "You are missing the following magazine(s): ";
        {
            if (typeName _x == "ARRAY") then {
                local _thisItem = _x select 0;
                if ({_thisItem == _x} count magazines player < (_x select 1)) then {
                    local _displayName = str (getText(configFile >> "CfgMagazines" >> (_x select 0) >> "displayName"));
                    if (_x select 1 > 1) then {
                        systemChat format ["%1 x %2",_displayName,_x select 1];
                    } else {
                        systemChat _displayName;
                    };
                };
            } else {
                if (!(_x in magazines player)) then {
                    systemChat str (getText(configFile >> "CfgMagazines" >> _x >> "displayName"));
                };
            };
        } forEach _requiredMagazines;
        dayz_actionInProgress = false;
        
    };
};