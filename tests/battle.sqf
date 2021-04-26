RTSmainPath = "armaRTS.Altis\";


_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

debugMode = true;

loadCovers = false;

// setGroupIconsSelectable true;






["marker_0",120] call startBattleFieldZeus;

waituntil { battleReady };

_deployAreaPos = (call getPlayerSide) call getDeployArea;

_area = [_deployAreaPos,deployAreaSize];


["LightMortarTeam",_area] call placeTestGroup;

["HeavyMortarTeam",_area] call placeTestGroup;


["placement"] call openGameScreen;


// call beginBattle;
