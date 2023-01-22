DZE_CLICK_ACTIONS = [		
    //////Bomb's crafting Script
    //Just give it the configname you want to use, and it will do the rest. See "Matches1" config for example in bombs_craftAnything.sqf
    ["ItemMatchboxEmpty","Fill Matches","['Matches1'] execVM 'scripts\bombs_craftAnything.sqf';","true"],
    // In the example above:
    // "Matches1" is the configname that it finds in the CONFIG SECTION in the bombs_craftAnything.sqf file
    // "ItemMatchboxEmpty" is the item that you right click on to use the action. In this case, it's an item that will be removed from your inventory, but it's not necessary to do this.
    // "Fill Matches" is the text that will show up in the right click action menu

    //Turret Crafting Examples
    ["KSVK_DZE","Craft KORD Turret","['KORD_Turret'] execVM 'scripts\bombs_craftAnything.sqf';","true"],
    ["UK59_DZ","Craft DSHKM Turret","['DSHKM_Turret'] execVM 'scripts\bombs_craftAnything.sqf';","true"],
    ["Barrett_MRAD_Iron_DZ","Craft M2 Turret","['M2_Turret'] execVM 'scripts\bombs_craftAnything.sqf';","true"],
    ["ItemFlashlight","Craft Search Light Turret","['SEARCH_Turret'] execVM 'scripts\bombs_craftAnything.sqf';","true"]
	];