RTSmainPath = "armaRTS.Altis\";



folderPrefix = "";
compileFile =
{
 params ["_path"];
 _path = folderPrefix + _path;
 private _code = compile preprocessFileLineNumbers _path;
 _code
};

 getAngle = RTSmainPath+"math\getAngleFn.sqf" call compileFile;
 getVecLength = RTSmainPath+"math\getVecLengthFn.sqf" call compileFile;
 getVecDir = RTSmainPath+"math\getVecDirFn.sqf" call compileFile;
 getvector = RTSmainPath+"math\getvectorFn.sqf" call compileFile;
 addvector = RTSmainPath+"math\addVecFn.sqf" call compileFile;
 angleDist = RTSmainPath+"math\angleDistFn.sqf" call compileFile;
 make360 = RTSmainPath+"math\make360Fn.sqf" call compileFile;

for "_i" from 0 to 1000 do
{

_v1 = [getdir player + 90, -100 + random 200 ] call getvector;
_v2 = [getdir player, -50 + random 100 ] call getvector;
_vf = [_v1,_v2] call addvector;
_vf = [getpos player,_vf] call addvector;

_mrk = createmarker [format["%1",random 1000], _vf];
_mrk setMarkerShape "icon";
_mrk setMarkerType "mil_dot";
_mrk setMarkerColor "ColorRed";

};