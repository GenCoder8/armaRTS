
RTSmainPath = "armaRTS.Altis\";

_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

debugMode = true;

[west,"Tester1","Force1", "" ] call createForce;


//[manPoolWest,"testteam"] call createBattleGroupFromPool;

//[manPoolWest,"mbt"] call createBattleGroupFromPool;


sleep 0.1;

["poolSelect"] call openGameScreen;