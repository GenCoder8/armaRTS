folderPrefix = "";
compileFile =
{
 params ["_path"];
 _path = folderPrefix + _path;
 private _code = compile preprocessFileLineNumbers _path;
 _code
};

 getAngle = RTSmainPath+"scripts\math\getAngleFn.sqf" call compileFile;
 getVecLength = RTSmainPath+"scripts\math\getVecLengthFn.sqf" call compileFile;
 getVecDir = RTSmainPath+"scripts\math\getVecDirFn.sqf" call compileFile;
 getvector = RTSmainPath+"scripts\math\getvectorFn.sqf" call compileFile;
 addvector = RTSmainPath+"scripts\math\addVecFn.sqf" call compileFile;
 angleDist = RTSmainPath+"scripts\math\angleDistFn.sqf" call compileFile;
 make360 = RTSmainPath+"scripts\math\make360Fn.sqf" call compileFile;

_w = execvm (RTSmainPath+"bgFns.sqf");
waituntil { scriptdone _w };


_w = execvm (RTSmainPath+"bgPool.sqf");
waituntil { scriptdone _w };


_w = execvm (RTSmainPath+"gui\overlay.sqf");
//waituntil { scriptdone _w };


_w = execvm (RTSmainPath+"gui\unitPool.sqf");
waituntil { scriptdone _w };

