RTSmainPath = "armaRTS.Altis\";


_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

debugMode = true;

loadCovers = true;

// setGroupIconsSelectable true;






//["marker_0",120] call startBattleFieldZeus;



[west,"testForce"] call createForce;

nextBattleMap = "marker_0";

["placement"] call openGameScreen;

waituntil { battleReady };

_deployAreaPos = (call getPlayerSide) call getDeployArea;

_area = [_deployAreaPos,deployAreaSize];



["LightMortarTeam",_area] call placeTestGroup;

["HeavyMortarTeam",_area] call placeTestGroup;


// call beginBattle;
