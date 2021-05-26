
debugMode = false;
loadCovers = true;
testCfgs = false;

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

findFromArray = RTSmainPath+"scripts\findFromArrayFn.sqf" call compileFile;


 getAngle = RTSmainPath+"scripts\math\getAngleFn.sqf" call compileFile;
 getVecLength = RTSmainPath+"scripts\math\getVecLengthFn.sqf" call compileFile;
 getVecDir = RTSmainPath+"scripts\math\getVecDirFn.sqf" call compileFile;
 getvector = RTSmainPath+"scripts\math\getvectorFn.sqf" call compileFile;
 addvector = RTSmainPath+"scripts\math\addVecFn.sqf" call compileFile;
 angleDist = RTSmainPath+"scripts\math\angleDistFn.sqf" call compileFile;
 make360 = RTSmainPath+"scripts\math\make360Fn.sqf" call compileFile;


"scripts\fns.sqf" call execFile;

"scripts\bgFns.sqf" call execFile;

"core\battleGroups.sqf" call execFile;

"core\bgPool.sqf" call execFile;

"core\forces.sqf" call execFile;

"core\zeus.sqf" call execFile;

"core\aicom.sqf" call execFile;

"scripts\garrison.sqf" call execFile;

"scripts\unitAi.sqf" call execFile;

"scripts\spawnArea.sqf" call execFile;

"scripts\mortar.sqf" call execFile;

"scripts\cover.sqf" call execFile;

"scripts\battleField.sqf" call execFile;

"scripts\globalMap.sqf" call execFile;

"scripts\misc.sqf" call execFile;

"scripts\supports.sqf" call execFile;

"gui\gfns.sqf" call execFile;

"gui\battleGui.sqf" call execFile;

"gui\actButtons.sqf" call execFile;

"gui\supports.sqf" call execFile;

"gui\upGui.sqf" call execFile;

"gui\customBattle.sqf" call execFile;

"gui\gmGui.sqf" call execFile;



["gui\battleGuiLoop.sqf",false] call execFile;


// Save the battle map markers to list 
gmBattleLocations = call getBattleLocations;

