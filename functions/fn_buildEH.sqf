private ["_eventHandler", "_realCenter", "_header", "_footer", "_drawSquad", "_drawProximity", "_drawPlayer", "_drawCompass", "_fade"];

//This is where the magic happens. You know, the whole bee and flower thing.
//I've decided to build this eventhandler "factory" to improve performance, it just
//saves a lot of ifs and other calculations that would else need to happen every frame.

//A quick test has shown that it improves performance quite a bit - it started to
//stutter when I added custom HUD size and the real center thing below and
//thankfully that doesn't happen anymore because of this function.


_realCenter = [0,20,0] vectorAdd BlueHUDMapZero;

_iconSizeBig = 15.8;
_iconSizeSmall = 14.3;

_header = "if (alive player && vehicle player == player) then {";
_footer = "};";

//Draws the squad on the HUD
_drawSquad = format ["{
	if !(player == _x) then {
		(uiNamespace getVariable 'BlueHudMap') drawIcon [('BlueHud\UI\' + (_x call BlueHud_fnc_getRole) + '.paa'),
			(_x call BlueHud_fnc_getColor),
			([((visiblePosition player) vectorDiff (visiblePosition _x)), ([] call BlueHud_fnc_getEyeDir)] call BlueHud_fnc_vectorRotate) vectorAdd %1,
			%2, %2,
			(-1 * ([] call BlueHud_fnc_getEyeDir) + direction _x + 180),
			'', false];
	};
} foreach units player;", _realCenter, _iconSizeSmall];

//Draws everyone in proximity on the HUD
_drawProximity = format ["{
	if ((side group _x) == (side group player) && player distance _x <= 20) then {
		if !(player == _x) then {
			(uiNamespace getVariable 'BlueHudMap') drawIcon [('BlueHud\UI\' + (_x call BlueHud_fnc_getRole) + '.paa'),
				(_x call BlueHud_fnc_getColor),
				([((visiblePosition player) vectorDiff (visiblePosition _x)), ([] call BlueHud_fnc_getEyeDir)] call BlueHud_fnc_vectorRotate) vectorAdd %1,
				%2, %2,
				(-1 * ([] call BlueHud_fnc_getEyeDir) + direction _x + 180),
				'', false];
		};
	};
} foreach ((getPos player) nearEntities ['CAManBase', 25]);", _realCenter, _iconSizeSmall];

//Draws the little dot that represents the player
_drawPlayer = format ["(uiNamespace getVariable 'BlueHudMap') drawIcon ['BlueHud\UI\Player.paa', (player call BlueHud_fnc_getColor), %1, %2, %2, 0, '', false];", _realCenter, _iconSizeBig];

_drawCompass = format ["if ('ItemCompass' in assignedItems player) then {
	(uiNamespace getVariable 'BlueHudMap') drawIcon ['BlueHud\UI\North.paa', [1,1,1,BlueHudCurrentAlpha], ([[0,18,0], (([] call BlueHud_fnc_getEyeDir) + 180)] call BlueHud_fnc_vectorRotate) vectorAdd %1, %2, %2, (([] call BlueHud_fnc_getEyeDir) * -1 - 180), '', false];
	(uiNamespace getVariable 'BlueHudMap') drawIcon ['BlueHud\UI\West.paa', [1,1,1,BlueHudCurrentAlpha], ([[0,18,0], (([] call BlueHud_fnc_getEyeDir) - 90)] call BlueHud_fnc_vectorRotate) vectorAdd %1, %2, %2, (([] call BlueHud_fnc_getEyeDir) * -1 + 90), '', false];
	(uiNamespace getVariable 'BlueHudMap') drawIcon ['BlueHud\UI\East.paa', [1,1,1,BlueHudCurrentAlpha], ([[0,18,0], (([] call BlueHud_fnc_getEyeDir) + 90)] call BlueHud_fnc_vectorRotate) vectorAdd %1, %2, %2, (([] call BlueHud_fnc_getEyeDir) * -1 - 90), '', false];
	(uiNamespace getVariable 'BlueHudMap') drawIcon ['BlueHud\UI\South.paa', [1,1,1,BlueHudCurrentAlpha], ([[0,18,0], ([] call BlueHud_fnc_getEyeDir)] call BlueHud_fnc_vectorRotate) vectorAdd %1, %2, %2, (([] call BlueHud_fnc_getEyeDir) * -1), '', false];
};", _realCenter, _iconSizeBig];

//Handles HUD Alpha depending on daylight
_dim = "if (visibleMap) then {
	BlueHudCurrentAlpha = 0;
} else {
	BlueHudCurrentAlpha = 0.8 * (((sunOrMoon max 0.1) + currentVisionMode player) min 1);
};";

_eventHandler = _header;

_eventHandler =  _eventHandler + _dim;

_eventHandler = _eventHandler + _drawProximity;

_eventHandler = _eventHandler + _drawPlayer;

_eventHandler =  _eventHandler + _drawCompass;

_eventHandler =  _eventHandler + _footer;

(uiNamespace getVariable "BlueHudMap") ctrlSetEventHandler ["Draw", _eventHandler];