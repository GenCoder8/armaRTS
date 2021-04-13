RTSmainPath = "armaRTS.Altis\";


_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

debugMode = true;

// setGroupIconsSelectable true;


beginBattle =
{


//plrZeus allowCuratorLogicIgnoreAreas true;
 
//plrZeus removeCuratorEditingArea 0;

call activateBattleGui;
};





["marker_0",120] call beginBattlePlacement;

waituntil { battleReady };

_deployAreaPos = (call getPlayerSide) call getDeployArea;

_area = [_deployAreaPos,deployAreaSize];


["LightMortarTeam",_area] call placeTestGroup;

["HeavyMortarTeam",_area] call placeTestGroup;


call beginBattle;
