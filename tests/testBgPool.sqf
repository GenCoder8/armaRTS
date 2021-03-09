
RTSmainPath = "armaRTS.Altis\";

_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

[manPoolWest,"testteam"] call addBattleGroupToPool;
[manPoolWest,"testteam"] call addBattleGroupToPool;
[manPoolWest,"mbt"] call addBattleGroupToPool;


//[manPoolWest,"testteam"] call createBattleGroupFromPool;

//[manPoolWest,"mbt"] call createBattleGroupFromPool;


sleep 0.1;
createDialog "UnitPoolDlg";


call createBgPoolPanels;
