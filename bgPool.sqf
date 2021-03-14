
/*
getPoolSide =
{
 private _ret = east;

 if(_this == manPoolWest) then { _ret = west; };

 _ret
};*/


#define UTYPE_NUMBER_INFANTRY 0
#define UTYPE_NUMBER_VEHICLE  1
#define UTYPE_NUMBER_CREW     2


getSideText =
{
 str _this
};

getManPool =
{
 params ["_side"];

private _pool = switch(_side) do
{
 case east: { manPoolEast };
 case west: { manPoolWest };
 default { "invalid side for man pool" call errmsg; };
};

 _pool
};

vehicleAttributes = [];

#define VEH_ATTRS_TYPE   0
#define VEH_ATTRS_CREW   1


manPoolWest = [];
manPoolEast = [];

#define MANP_TYPE  0
#define MANP_RANK  1
#define MANP_SKILL 2

getVehicleAttrs =
{
params ["_type"];
private _idx = vehicleAttributes findIf { (_x # VEH_ATTRS_TYPE) == _type };
if(_idx < 0) exitWith { [] };

vehicleAttributes select _idx 
};

addUnitEntryToPool =
{
 params ["_manPool","_type","_rank","_skill"];

diag_log format ["Adding man to pool: %1 - %2 - %3", _type, _rank, _skill ];

_pushToPool =
{
 _manPool = [_this] + _manPool; // Add to beginning to maintain same order
};

[_type,_rank,_skill] call _pushToPool;

if(!(_type iskindOf "man")) then
{
_vattrs = _type call getVehicleAttrs;

if(count _vattrs == 0) then
{
 // Figure vehicle crew types
 _veh = _type createVehicle [0,0,0];
 createVehicleCrew _veh;
 _crew = crew _veh;

diag_log format["--- Adding vehicle crew attrs %1 %2 %3 ---", _veh,_crew,_crew apply { typeof _x }];

vehicleAttributes pushback [_type,_crew apply { typeof _x }];

{
 _veh deleteVehicleCrew _x;
} foreach _crew;

deleteVehicle _veh;
};

// Add crew to pool
_vattrs = _type call getVehicleAttrs;
{
[_x,"PRIVATE",_skill] call _pushToPool; // Same skill, todo rank
} foreach (_vattrs # VEH_ATTRS_CREW);

}
else
{
 if(debugMode) then
 {
  // If not regognized type
 if(!(_type call isTankCrew) && !(_type call isInfantry) && !(_type call isSniper)) then
{
 ["Unknown unit type '%1'", _type] call errmsg;
};
 };
};

};

getUnitEntryFromPool =
{
 params ["_manPool","_type","_kindFn"];
 private _entry = [];
 {
  //if(_type == (_x # MANP_TYPE)) then
  if([_type,(_x # MANP_TYPE)] call _kindFn) then
  {
   _entry = _manPool deleteAt _foreachIndex;
   break;
  };
 } foreach _manPool;

if(count _entry == 0) then
{
 ["getUnitEntryFromPool failed %1",_type] call errmsg;
};

 _entry
};

isOfSpecialType =
{
 params ["_manType","_cfg"];
 private _units = getArray(_cfg >> "units");

 (_manType in _units)
};

isTankCrew =
{
 params ["_manType"];
 private _cfg = missionconfigfile >> "RTSDefs" >> "TankCrews";

 [_manType,_cfg] call isOfSpecialType
};

isInfantry =
{
 params ["_manType"];
 private _cfg = missionconfigfile >> "RTSDefs" >> "Infantry";

 [_manType,_cfg] call isOfSpecialType
};

isSniper =
{
 params ["_manType"];
 private _cfg = missionconfigfile >> "RTSDefs" >> "Snipers";

 [_manType,_cfg] call isOfSpecialType
};

isUnitType =
{
 params ["_type","_wantType"];
 _type == _wantType
};

getBattleGroupCfg =
{
 params ["_side","_bgname"];

 _side = str _side;

 private _cfg = missionconfigfile >> "BattleGroups" >> _side;
 private _ce = _cfg >> _bgname;

 if(isnull _ce) then
 {
  ["Invalid BG name '%1'", _bgname] call errmsg;
 };

 _ce
};

addBattleGroupToPool =
{
 params ["_side","_bgname"];

 private _manPool = _side call getManPool;

 private _ce = [_side,_bgname] call getBattleGroupCfg;

 _skill = 0.8;

 private _units = getArray(_ce >> "units");
 {
  _rank = [_ce,_foreachIndex] call getRankFromCfg;

  [_manPool,_x,_rank,random [0.1,_skill, 0.8]] call addUnitEntryToPool;

  _skill = _skill - 0.1;
  if(_skill < 0.1) then { _skill = 0.1; };
 } foreach _units;

};

retBattleGroupToPool =
{
 params ["_group"];

 private _side = side _group;

 private _manPool = _side call getManPool;

 {
  private _man = _x;

  [_manPool,_man,rank _man,skill _man] call addUnitEntryToPool;

 } foreach (units _group);
};

retAllBattleGroupsToPool =
{
  params ["_side"];

  private _groups = allgroups select { _side == (side _x) && (leader _group != player) };

 // Loop backwards to keep same order as when picked from the pool
 for "_i" from (count _groups - 1) to 0 step -1 do
 {
  private _group = _groups select _i;

  _group call retBattleGroupToPool;

  _group call deleteGroupInstantly;
 };
 
};

createBattleGroupFromPool =
{
 params ["_side","_bgname","_pos"];

 private _manPool = _side call getManPool;

 private _ce = [_side,_bgname] call getBattleGroupCfg;

 if(isnull _ce) exitWith { "Failed to get battlegroup cfg" call errmsg; };

 private _group = creategroup _side;

_setupMan =
{
params ["_unit"];
_unit setRank (_entry # MANP_RANK);
_unit setSkill (_entry # MANP_SKILL);

_unit setVariable ["orgSkill", skill _unit]; // Needed later
};

 private _units = getArray(_ce >> "units");
 {
  private _ue = _x;

 // Create vehicle
 if(!(_ue iskindOf "man")) then
 {
  // Get vehicle
 private _vehEntry = [_manPool,_ue,isUnitType] call getUnitEntryFromPool;

 private _vattrs = (_vehEntry # MANP_TYPE) call getVehicleAttrs;
 
if(count _vattrs == 0) then
{
 "error finding vehicle attributes" call errmsg;
};


_sveh = [_pos, 0, (_vehEntry # MANP_TYPE), _group] call BIS_fnc_spawnVehicle;
_sveh params ["_veh", "_crew", "_group"];

_veh setVariable ["utypeNumber", UTYPE_NUMBER_VEHICLE]; // Not really needed

private _crewList = _vattrs # VEH_ATTRS_CREW;

if(count _crewList != count _crew) then
{
["Crew arrays size mismatch!"] call errmsg;
};

 // Take from pool and set skills, etc.
 {
 private _ce = _x;
 private _entry = [_manPool,_ce,isTankCrew] call getUnitEntryFromPool;

 _cm = _crew # _foreachIndex;
 _cm call _setupMan;
 _cm setVariable ["utypeNumber", UTYPE_NUMBER_CREW];

 } foreach _crewList;
 
 }
 else
 {
  // Create infantry

  private _entry = [_manPool,_ue,isInfantry] call getUnitEntryFromPool;

if(count _entry == 0) exitWith 
{
 ["Failed to get infantry entry"] call errmsg;
};

 // Set skills, etc
 _unit = _group createUnit [_entry # MANP_TYPE, _pos, [], 0, "FORM"];
 _unit call _setupMan;
 _unit setVariable ["utypeNumber", UTYPE_NUMBER_INFANTRY];

 };

 } foreach _units;

 _group call registerBattleGroup;
};

getUnitTypeNumbers =
{
params ["_ue"];

private _counts = [0,0,0];

 // vehicle
if(!(_ue iskindOf "man")) then
{
 _counts set [UTYPE_NUMBER_VEHICLE, (_counts # UTYPE_NUMBER_VEHICLE) + 1];

private _vattrs = _ue call getVehicleAttrs;

private _crewList = _vattrs # VEH_ATTRS_CREW;

 _counts set [UTYPE_NUMBER_CREW, (_counts # UTYPE_NUMBER_CREW) + count _crewList];

}
else // infantry
{
 _counts set [UTYPE_NUMBER_INFANTRY, (_counts # UTYPE_NUMBER_INFANTRY) + 1];
};

_counts
};

countListTypeNumbers =
{
 params ["_units"];

 private _counts = [0,0,0];

{
  private _ue = _x;
 _cn = _ue call getUnitTypeNumbers;
  _counts = [_counts,_cn] call addList;

} foreach _units;

 _counts
};

countBgPoolNeed =
{
 params ["_bgname"];

 _side = call getPoolSide;
 _pos = getPos player;

 private _ce = [_side,_bgname] call getBattleGroupCfg;

private _counts = [0,0,0];

 private _units = getArray(_ce >> "units");
 _counts = [_units] call countListTypeNumbers;

 _counts
};

addList =
{
 params ["_counts1","_counts2"];

 { _counts1 set [_foreachIndex, (_counts1 # _foreachIndex) + _x ]; } foreach _counts2;

 _counts1
};

subList =
{
 params ["_counts1","_counts2"];

 { _counts1 set [_foreachIndex, (_counts1 # _foreachIndex) - _x ]; } foreach _counts2;

 _counts1
};

