private ["_color", "_fireTeamID"];

_fireTeamID = _this getVariable ["ICE_sqdMgt_fireTeamID", 0];
_color = [[1,1,1], [102/255,172/255,71/255], [70/255,156/255,168/255], [198/255,190/255,82/255]] select _fireTeamID;
_color pushBack (BlueHudCurrentAlpha min ((45 - (player distance _this)) / 10));
_color