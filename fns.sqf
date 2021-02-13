getVehicles =
{
 params ["_group",["_incParachutes",false]];
 
private _vehs = [];
{
 private _veh = vehicle _x;
 
 // todo maybe remove this check for speed, doesnt work with static weapons anyway
 if(isnull (group _veh) && !(_veh isKindof "StaticWeapon")) then { ["Vehicle has no group! %1 %2",_group, units _group] call errmsg; };

 if( (_incParachutes || ((tolower (typeof _veh)) find "parachute") < 0 )
 && _veh != _x && alive _veh && alive _x && (group _veh) == _group) then
 {
  _vehs pushBackUnique (vehicle _x);
 };
} forEach (units _group);

_vehs
};

inVehicle =
{
 params ["_unit"];
 (vehicle _unit) != _unit
};
