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

// Incase empty array passed
//if(isnil "_group") exitWith { [] };

private _units = [];
if(typename _group == "ARRAY") then
{
 _units = _group;
 _group = group (_units # 0); // Need this below
}
else
{
 _units = units _group;
};
 
private _vehs = [];
{
 private _veh = vehicle _x;
 
 // todo maybe remove this check for speed, doesnt work with static weapons anyway (not if dead/civilian)
 if(side _x != civilian && isnull (group _veh) && !(_veh isKindof "StaticWeapon")) then { ["Vehicle has no group! %1 %2",_group, _units] call errmsg; };

 if( (_incParachutes || ((tolower (typeof _veh)) find "parachute") < 0 )
 && _veh != _x && alive _veh && alive _x && (group _veh) == _group) then
 {
  _vehs pushBackUnique (vehicle _x);
 };
} forEach _units;

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

resetUnitScripts =
{
 params ["_group"];
 {
  _x call resetUnitScript;

 } foreach (units _group);
};

resetUnitScript =
{
 params ["_man"];

 private _us = _man getVariable ["unitScript",scriptNull];
 if(!isnull _us) then { terminate _us; };
 _man setVariable ["unitScript",scriptNull];
};

applyStopSCript =
{
 params ["_man","_stopPos"];

 // Make sure ended
 _man call resetUnitScript;

private _us = [_man,_stopPos] spawn
{
 params ["_man","_stopPos"];
 waituntil { sleep 0.5; _man distance _stopPos < 1 };
 dostop _man;
};

_man setVariable ["unitScript",_us];
 
};

getRankIcon =
{
params ["_rank"];

private _icon = switch(_rank) do
{
 case 0: { "\a3\ui_f\data\gui\cfg\ranks\private_gs.paa" };
 case 1: { "\a3\ui_f\data\gui\cfg\ranks\corporal_gs.paa" };
 case 2: { "\a3\ui_f\data\gui\cfg\ranks\sergeant_gs.paa" };
 case 3: { "\a3\ui_f\data\gui\cfg\ranks\lieutenant_gs.paa" };
 case 4: { "\a3\ui_f\data\gui\cfg\ranks\captain_gs.paa" };
 case 5: { "\a3\ui_f\data\gui\cfg\ranks\major_gs.paa" };
 case 6: { "\a3\ui_f\data\gui\cfg\ranks\colonel_gs.paa" };
};

_icon
};

rankToNumber =
{
 params ["_rankName"];

 private _rankId = ["PRIVATE","CORPORAL","SERGEANT","LIEUTENANT","MAJOR","COLONEL"] find _rankName;

 _rankId
};

getRankFromCfg =
{
params ["_bgCfg","_index"];
private _rank = "PRIVATE";
private _ranks = getArray (_bgCfg >> "ranks");
if(_index < (count _ranks)) then
{
 _rank = _ranks select _index;
};
_rank
};


getPlayerSide =
{
playerside
};

getGroupAverageSkill =
{
 params ["_group"];

 if(count (units _group) == 0) exitWith { 0 };

 private _skill = 0;
 {
  _skill = _skill + (skill _x);
 } forEach (units _group);

 _skill = _skill / (count (units _group));

 _skill
};

experienceStatus = ["Green", "Regular", "Veteran", "Elite"];

getExperienceStr =
{
 params ["_skill"];
 private _expName = "Recruit";

 {

 if(_skill >= (_foreachIndex * 0.30)) then
 {
  _expName = _x;
 };

 } foreach experienceStatus;

 _expName
};


safeDelete =
{
 params ["_man"];
 if(isnull _man) exitWith {};

 if(_man iskindof "man") then
 {

// A must or buggy (ghosts)
if(_man getVariable ["channelReg",false]) then
{
supportChannel radioChannelRemove [_man];
};

 if(_man call inVehicle) then
 {
 (vehicle _man) deleteVehicleCrew _man;
 }
 else
 {

 deleteVehicle _man;
 };
 }
 else
 {
  ["SafeDelete not man %1",_man] call errmsg;
 };
};

safeDeleteVeh =
{
 params ["_veh"];
 
if(!(_veh iskindof "man")) then
{

 {
  _x call safeDelete;
 } forEach (crew _veh);
 
 deleteVehicle _veh;

}
else
{
 ["SafeDeleteVeh not veh %1",_veh] call errmsg;
};

};

safeDeleteAny =
{
 params ["_obj"];
if(_obj iskindof "man") then
{
 _obj call safeDelete;
}
else
{
 _obj call safeDeleteVeh;
};
};

deleteGroupInstantly =
{
 params ["_group", ["_delayUnits",false]];
 
 if(isnull _group) exitWith {}; // Todo problem...
 
 private _vehs = _group call getvehicles;

  
 // Objects get sometimes delay deleted
 [_group,_vehs,_delayUnits] spawn
 {
  params ["_group","_vehs","_delayUnits"];
  
  if(_delayUnits) then
  {
  sleep 5;
  };
  
 {
 
_x call safeDelete;
 
 } foreach (units _group);
 
 { _x call safeDeleteVeh; } foreach _vehs;
 
  deleteGroup _group;
 };

};
