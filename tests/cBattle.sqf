RTSmainPath = "armaRTS.Altis\";


_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

debugMode = true;

loadCovers = false;

//testCfgs = true;

#include "..\main.h"
DBGL_VISI call setDebugFlags;

["customBattle"] call openGameScreen;
