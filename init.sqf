RTSmainPath = "";


_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

debugMode = false;

loadCovers = true;

//testCfgs = true;

["customBattle"] call openGameScreen;