
debugMode = false;
loadCovers = true;
testCfgs = false;

rtsDebugMode = profileNamespace getvariable ["rtsDebugMode",false];


// Important
player allowDamage false;
enableSaving [false, false];

_index = player createDiarySubject ["rtsEntry","arma RTS"];


player createDiaryRecord ["rtsEntry", ["Credits", str composeText [
"Thanks to the whole arma3 community for their help!<br/>" +
"And special thanks to sarogahtyp for his pathfinding code<br/>" +
"hcpookie for the unsung graphics<br/>" +
"kremator for testing!"
]
]];

player createDiaryRecord ["rtsEntry", ["About", str composeText [
"Arma RTS mission by GC8 <br/>" +
"Version: " + (str (getNumber(missionConfigFile >> "RtsVersion")))
]
]];

errmsg =
{
private "_print";
_print = "";

if((typename  _this) == "ARRAY") then {
_print = format _this;}
else {
_print = _this;
};

_print = "RTS ERROR: " + _print;

player globalchat _print;
//_print remoteExecCall ["printError"]; 

diag_log _print;
};



folderPrefix = "";
compileFile =
{
 params ["_path"];
 _path = folderPrefix + _path;
 private _code = compile preprocessFileLineNumbers _path;
 _code
};

execFile =
{
params ["_file",["_wait",true]];
_w = execvm (RTSmainPath + _file);
if(_wait) then
{
waituntil { scriptdone _w };
};
};


"core\mods.sqf" call execFile; // here for the startup code


usedMod = profilenamespace getVariable ["aRtsModUsed", "Vanilla" ];
usedDifficulty = profilenamespace getVariable ["aRtsDifficulty", 0 ];

_usedModCfg = missionconfigfile >> "SupportedMods" >> usedMod;

if(!(_usedModCfg call isModloaded)) then // If unloaded mod
{
 _list = call getAvailableModList;
 usedMod = "";
 if(count _list == 0) exitWith {}; // Bad error

 usedMod = _list # 0;
};

if(usedMod == "") exitWith { diag_log "Mission loading aborted"; }; // Abort loading



findFromArray = RTSmainPath+"scripts\findFromArrayFn.sqf" call compileFile;


 getAngle = RTSmainPath+"scripts\math\getAngleFn.sqf" call compileFile;
 getVecLength = RTSmainPath+"scripts\math\getVecLengthFn.sqf" call compileFile;
 getVecDir = RTSmainPath+"scripts\math\getVecDirFn.sqf" call compileFile;
 getvector = RTSmainPath+"scripts\math\getvectorFn.sqf" call compileFile;
 addvector = RTSmainPath+"scripts\math\addVecFn.sqf" call compileFile;
 angleDist = RTSmainPath+"scripts\math\angleDistFn.sqf" call compileFile;
 make360 = RTSmainPath+"scripts\math\make360Fn.sqf" call compileFile;


 shortPathDijkstra = RTSmainPath+"scripts\dl\fn_shortPathDijkstra.sqf" call compileFile;


"scripts\fns.sqf" call execFile;

"scripts\debug.sqf" call execFile;

"scripts\bgFns.sqf" call execFile;

"scripts\bgTraits.sqf" call execFile;

"core\battleGroups.sqf" call execFile;

"core\bgPool.sqf" call execFile;

"core\forces.sqf" call execFile;

"core\zeus.sqf" call execFile;

"core\aicom.sqf" call execFile;

"core\aiComGm.sqf" call execFile;

"core\savegame.sqf" call execFile;

"scripts\morale.sqf" call execFile;

"scripts\visibility.sqf" call execFile;

"scripts\garrison.sqf" call execFile;

"scripts\unitAi.sqf" call execFile;

"scripts\weaponFreeze.sqf" call execFile;

"scripts\weaponPickup.sqf" call execFile;

"scripts\spawnArea.sqf" call execFile;

"scripts\mortar.sqf" call execFile;

"scripts\cover.sqf" call execFile;

"scripts\battleField.sqf" call execFile;

"scripts\globalMap.sqf" call execFile;

"scripts\misc.sqf" call execFile;

"scripts\supports.sqf" call execFile;

"scripts\aiArtillery.sqf" call execFile;

"gui\gfns.sqf" call execFile;

"gui\mainmenu.sqf" call execFile;

"gui\unitList.sqf" call execFile;

"gui\battleGui.sqf" call execFile;

"gui\actButtons.sqf" call execFile;

"gui\supports.sqf" call execFile;

"gui\upGui.sqf" call execFile;

"gui\customBattle.sqf" call execFile;

"gui\gmGui.sqf" call execFile;

"gui\savegame.sqf" call execFile;

"gui\settings.sqf" call execFile;

["gui\battleGuiLoop.sqf",false] call execFile;


