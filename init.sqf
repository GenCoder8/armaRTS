

findFromArray = compile preprocessFileLineNumbers "findFromArrayFn.sqf";

[] spawn
{
waituntil { ! isnull (player getvariable ["BIS_HC_scope",objnull]) };
waituntil {count hcallgroups player > 0};
[player] execvm ("hc\HC_GUI.sqf");
};

unitHighlights = [];

createBattleGroup =
{
 params ["_bgname","_bgSide","_spawnPos"];
 private _bgs = missionconfigfile >> "BattleGroups";

 _foundBgConfig = _bgs >> (str _bgSide) >> _bgname;
 
/*
_foundBgSide = west;

{
_checkBgCfg = _bgs >> (str _x) >> _bgname;
if(!isnull _checkBgCfg) exitWith
{
 _foundBgConfig = _checkBgCfg;
 _foundBgSide = _x;
};

} foreach
 [west,east];
*/

if(isnull _foundBgConfig) exitWith { hint "Error finding battle group"; }; // Error

_bgRoster = getArray _foundBgConfig;

_group = createGroup _bgSide;

_highlighted = [];

{
 _type = _x;

 //systemchat "Creating one...";

if(_type iskindof "man") then
{

 _unit = _group createUnit [_type, _spawnPos, [], 0, "FORM"];

 _highlighted = _highlighted + [_unit];
}
else
{
 _vehSpawn = [_spawnPos, 0, _type, _group] call BIS_fnc_spawnVehicle;
 _vehSpawn params ["_veh","_crew","_group"];
 _veh allowCrewInImmobile true;

 _highlighted = _highlighted + _crew + [_veh];
};

} foreach _bgRoster;

 unitHighlights = unitHighlights + _highlighted;

 //_subOrd = "HighCommandSubordinate" createVehicle [0,0,0];
 _lgroup = createGroup _bgSide;
 _subOrd = _lgroup createUnit ["HighCommandSubordinate", [0,0,0], [], 0, "NONE"];
 _subOrd synchronizeObjectsAdd [leader _group];


 systemchat format["Creating one... %1 %2 %3 %4", _group,_subOrd,leader _group, mainhc];

 mainhc synchronizeObjectsAdd [_subOrd];

 player hcsetgroup [_group];


_group spawn
{
 params ["_group"];

while { true } do
{
 _wps = waypoints _group;

if(count _wps > 0) then
{
 _lastWp = _wps select (count _wps - 1);

if(!(_group getVariable ["wpArrived",false])) then
{
if((waypointPosition _lastWp) distance2D (leader _group) < 10) then
{
 hint "ARRIVED";
 _group setVariable ["wpArrived",true];
};
};

};

 sleep 2;
};
};

};

sleep 0.01;

["mbt",west,getmarkerpos "ts"] call createBattleGroup;

["testteam",west,getmarkerpos "tt"] call createBattleGroup;


// \a3\ui_f_curator\data\cfgmarkers\kia_ca.paa

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
};

} foreach unitHighlights;

}];


// sleep 1;
cutRsc["ComOverlay","PLAIN",0];

execvm "fns.sqf";
execvm "gui.sqf";



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