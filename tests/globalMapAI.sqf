RTSmainPath = "armaRTS.Altis\";



folderPrefix = "";
compileFile =
{
 params ["_path"];
 _path = folderPrefix + _path;
 private _code = compile preprocessFileLineNumbers _path;
 _code
};

_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

loadCovers = false;

debugMode = true;

sleep 0.1;

DBGL_AIGM call setDebugFlags;

[west,"Tester1","Force1", west call getStartLoc ] call createForce;
//[west,"testers2","Roster2", "marker_31" ] call createForce;

[east,"testersE","Force1", east call getStartLoc ] call createForce;
[east,"testersE2","Force2", east call getStartLoc ] call createForce;


call initGlobalMap;

"globalmap" call openGameScreen;

[] call beginGmMovePhase;

