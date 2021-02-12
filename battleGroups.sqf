
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