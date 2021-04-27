RTSmainPath = "armaRTS.Altis\";


_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

debugMode = true;

loadCovers = true;

// setGroupIconsSelectable true;






["marker_0",120] call startBattleFieldZeus;

waituntil { battleReady };

_deployAreaPos = (call getPlayerSide) call getDeployArea;

_area = [_deployAreaPos,deployAreaSize];


[west,"testForce"] call createForce;

["LightMortarTeam",_area] call placeTestGroup;

["HeavyMortarTeam",_area] call placeTestGroup;


["placement"] call openGameScreen;


// call beginBattle;
