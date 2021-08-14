RTSmainPath = "armaRTS.Altis\";


_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

debugMode = true;

loadCovers = true;

// setGroupIconsSelectable true;



iscustombattle = true; // So that ending battle works properly


//["marker_0",120] call startBattleFieldZeus;



[west,"testForce"] call createForce;

["marker_0",110] call setNextBattleArgs;

_deployAreaPos = (call getPlayerSide) call getDeployArea;

_area = [_deployAreaPos,deployAreaSize];


//["Patton",_area] call placeTestGroup;

["LightMortarTeam",_area] call placeTestGroup;

["HeavyMortarTeam",_area] call placeTestGroup;

["AntiTankTeam",_area] call placeTestGroup;

["ReconTeam",_area] call placeTestGroup;

["Sniper",_area] call placeTestGroup;

//["Patton",_area] call placeTestGroup;

//["Sheridan",_area] call placeTestGroup;

["MachineGunTeam",_area] call placeTestGroup;




for "_i" from 1 to 9 do
{
 ["HeavyMortarTeam",_area] call placeTestGroup;
};


["placement"] call openGameScreen;

waituntil { battleGuiReady };








// call beginBattle;
