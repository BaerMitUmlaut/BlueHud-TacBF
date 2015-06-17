//Shutdown on HC
if (!hasInterface && !isServer) exitWith {};

//Distribute settings if server
if (isServer && isMultiplayer) exitWith {
	//No server settings for now
};

[] spawn {
	BlueHudCurrentAlpha = 0.8;

	//For some reason, calling this to early kills the HUD
	sleep 1;
	("BHUDLayer" call BIS_fnc_rscLayer) cutRsc ["BlueHud", "PLAIN"];

	//Center map on [0,0] for map zoom constant calculation
	(uiNamespace getVariable "BlueHudMap") ctrlMapAnimAdd [0, 0.001, [0, 0, 0]];
	ctrlMapAnimCommit (uiNamespace getVariable "BlueHudMap");
	waitUntil {ctrlMapAnimDone (uiNamespace getVariable "BlueHudMap")};

	//How many square meters per pixel are drawn at a certain zoom level unfortunately depends on the map,
	//thus we need to calculate the correct map zoom. This is done by checking where it draws [0,0] and [0,10]
	//on the screen and comparing said distance to the zoom level.
	_delta = (((uiNamespace getVariable "BlueHudMap") ctrlMapWorldToScreen [0,0]) select 1) - (((uiNamespace getVariable "BlueHudMap") ctrlMapWorldToScreen [0,50]) select 1);
	//Now we calculate the map's zoom factor (which is directly related to the map size):
	BlueHUDMapZoomConstant = _delta * 0.001;
	//And finally the correct zoom factor (0.1 is the distance we want between [0,0] and [0,50] on the screen):
	_zoom = BlueHUDMapZoomConstant / 0.15;

	//We center this time on a custom "zero point" to make sure we don't get any terrain markers - this can be an issue if we stay at [0, 0]
	//This way everything seen on screen is actually drawn outside of the map
	BlueHUDMapZero = [(getNumber (configFile>>"CfgWorlds">>worldName>>"Grid">>"OffsetX")), (getNumber (configFile>>"CfgWorlds">>worldName>>"Grid">>"OffsetY")), 0];
	(uiNamespace getVariable "BlueHudMap") ctrlMapAnimAdd [0, _zoom, BlueHUDMapZero];
	ctrlMapAnimCommit (uiNamespace getVariable "BlueHudMap");
	waitUntil {ctrlMapAnimDone (uiNamespace getVariable "BlueHudMap")};

	//Create EventHandler to draw HUD
	[] call BlueHud_fnc_buildEH;

	BlueHud_initialized = true;
};