
RTSmainPath = "armaRTS.Altis\";

_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

debugMode = true;

[call getPlayerSide,"HeavyTeam"] call addBattleGroupToPool;
[call getPlayerSide,"LightTeam"] call addBattleGroupToPool;
[call getPlayerSide,"mbt"] call addBattleGroupToPool;


//[manPoolWest,"testteam"] call createBattleGroupFromPool;

//[manPoolWest,"mbt"] call createBattleGroupFromPool;


sleep 0.1;
createDialog "UnitPoolDlg";


call createBgPoolPanels;
