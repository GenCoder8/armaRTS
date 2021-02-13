getGroupInfantry =
{
 params ["_group"];
 
 private _men = (units _group) select
 {
  (_x call isInfantry) && (alive _x) && !(captive _x) && ((typeof _x) != "Logic")
 };
 _men
};

isInfantry =
{
 params ["_unit"];
 
 private _isInf = true; 
 private _role = assignedVehicleRole _unit;
 if(count _role > 0) then
 {
 _isInf = (_role select 0) == "cargo";
 
 if( ((tolower (typeof (vehicle _unit))) find "parachute") >= 0 ) then
 {
  _isInf = true;
 };
 
 if(!_isInf) then
 {
  // Server only  feature
  if(!(isnil "isGatherAbleVehicle")) then
  {
  // If inside some vehicle the man is still infantry if he is in vehicle that does not belong to the group
  _isInf = !([group _unit,vehicle _unit] call isGatherAbleVehicle);
  };
 };
 
 };
 _isInf
};

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


surrenderAI =
{
 params ["_man"];
 if(isPlayer _man) exitWith {}; // Make sure not player
 
 _man setCaptive true;
 
 removeAllWeapons _man;
 
 _man playMove "AmovPercMstpSsurWnonDnon";
 
 //systemchat format["Surrendering %1", _man];
 
 // Custom cleanup
 [_man] spawn
 {
 params ["_man"];
 sleep 60;
 _man call safeDelete;
 };
};