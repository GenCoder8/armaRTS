RTSmainPath = "armaRTS.Altis\";


_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

debugMode = true;

loadCovers = true;

// setGroupIconsSelectable true;






//["marker_0",120] call startBattleFieldZeus;



[west,"testForce"] call createForce;

["marker_0",110] call setNextBattleArgs;

_deployAreaPos = (call getPlayerSide) call getDeployArea;

_area = [_deployAreaPos,deployAreaSize];


["Patton",_area] call placeTestGroup;

["LightMortarTeam",_area] call placeTestGroup;

["HeavyMortarTeam",_area] call placeTestGroup;


["placement"] call openGameScreen;

waituntil { battleReady };








// call beginBattle;
