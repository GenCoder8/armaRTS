
folderPrefix = "";
compileFile =
{
 params ["_path"];
 _path = folderPrefix + _path;
 private _code = compile preprocessFileLineNumbers _path;
 _code
};

 getAngle = "math\getAngleFn.sqf" call compileFile;
 getVecLength = "math\getVecLengthFn.sqf" call compileFile;
 getVecDir = "math\getVecDirFn.sqf" call compileFile;
 getvector = "math\getvectorFn.sqf" call compileFile;
 addvector = "math\addVecFn.sqf" call compileFile;
 angleDist = "math\angleDistFn.sqf" call compileFile;
 make360 = "math\make360Fn.sqf" call compileFile;


findFromArray = compile preprocessFileLineNumbers "findFromArrayFn.sqf";

[] spawn
{
waituntil { ! isnull (player getvariable ["BIS_HC_scope",objnull]) };
waituntil {count hcallgroups player > 0};
[player] execvm ("hc\HC_GUI.sqf");
};

execvm "fns.sqf";
execvm "scripts\garrison.sqf";
execvm "bgFns.sqf";
execvm "battleGroups.sqf";
execvm "gui.sqf";

sleep 0.01;

["mbt",west,getmarkerpos "ts"] call createBattleGroup;

["testteam",west,getmarkerpos "tt"] call createBattleGroup;
["testteam",west,getmarkerpos "tt2"] call createBattleGroup;


// 

addMissionEventHandler ["Draw3D",
{

{
 _x params ["_obj"];

 _show = alive _obj;

if(_show) then
{
 if(_obj iskindof "man") then
 {
  _show = vehicle _obj == _obj; 
 }
 else
 {
  _show = count crew _obj > 0;
 };
};

_circle = _obj getVariable ["circle",objNull];

if(_show) then
{

if(isnull _circle) then
{
//systemchat "creating circle";

 _circle = "VR_Area_01_circle_4_grey_F" createVehicle position _obj;
 _circle setObjectTexture [0, "#(argb,8,8,3)color(0,0.80,0,1,co)"];
 _obj setVariable ["circle",_circle];
};

 _p = getposATL _obj;
 _p set [2, _p # 2 + 0.1];
 _circle setposATL _p;

}
else
{

if(!isnull _circle) then
{
//systemchat "Deleting circle";

 deletevehicle _circle;
 _obj setVariable ["circle",objNull];
};

// Show KIA for while
if( !alive _obj && !isnull _obj ) then
{

_showTime = _obj getvariable ["kiaShowTime", 0];
if(_showTime == 0) then
{
_obj setvariable ["kiaShowTime", time];
};

if( (time - _showTime) < 30 ) then
{
 drawIcon3D ["\a3\ui_f_curator\data\cfgmarkers\kia_ca.paa", [1,1,1,1], getposATL _obj, 1, 1, 0, "", false];
};

};

};


} foreach unitHighlights;

}];


// sleep 1;




cutRsc["ComOverlay","PLAIN",0];



/*
{
 _group = _x;

if(side _group == west) then
{

{


_x spawn
{
 params ["_man"];
 _circle = "VR_Area_01_circle_4_grey_F" createVehicle position _man;

_circle setObjectTexture [0, "#(argb,8,8,3)color(0,0.80,0,1,co)"];

while { alive _man } do
{
 _p = getposATL _man;
 _p set [2, _p # 2 + 0.1];
 _circle setposATL _p;
 sleep 0.05;
};

deletevehicle _circle;

};

} foreach units _group;
 
};

} foreach allgroups;
*/