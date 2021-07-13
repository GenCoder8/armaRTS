
#include "..\main.h"


//forcePools = createHashMap;
curPlrForce = [];
curEnemyForce = [];


getCurForce =
{
 params ["_side"];
 private _pool = [];
 if(_side == (call getPlayerSide)) then
 {
  _pool = curPlrForce;
 }
 else
 {
  _pool = curEnemyForce;
 };

 _pool
};

getManPool =
{
 params ["_side"];

private _pool = switch(_side) do
{
 // Todo plr side
 case east: { if(count curEnemyForce == 0) then { "East force pool not set" call errmsg; }; curEnemyForce # FORCE_MAN_POOL };
 case west: { if(count curPlrForce == 0) then { "West force pool not set" call errmsg; }; curPlrForce # FORCE_MAN_POOL };
 default { "invalid side for man pool" call errmsg; };
};

 _pool
};

getForceBgTypes =
{
 params ["_force"];
 _force # FORCE_BG_TYPES
};

getForcePool =
{
 params ["_force"];
 _force # FORCE_MAN_POOL
};

vehicleAttributes = [];




// Keeps all the bgs that can be used
selectableBgs = [];

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
 params ["_manPool","_type","_rank","_skill","_cfg"];

 private _ranks = getArray(_cfg >> "ranks");

// diag_log format ["Adding unit to pool: %1 - %2 - %3", _type, _rank, _skill ];

_pushToPool =
{
 
 //_manPool insert [0, [[_this]]]; // Add to beginning to maintain same order

 _manPool pushback _this;

 //_manPool2 = [_this] + _manPool;
};

[_type,_rank,_skill] call _pushToPool;

if(!(_type iskindOf "man")) then // If vehicle
{
_vattrs = _type call getVehicleAttrs;

if(count _vattrs == 0) then
{
 // Figure vehicle crew types
 _veh = _type createVehicle [0,0,0];
 createVehicleCrew _veh;
 _crew = crew _veh;


 private _size = _veh call getObjectSize;
 private _vehSize = ((_size select 0) / 2) max ((_size select 1) / 2);


diag_log format["--- Adding vehicle crew attrs %1 %2 %3 ---", _veh,_crew,_crew apply { typeof _x }];

vehicleAttributes pushback [_type,_crew apply { typeof _x },_vehSize];

{
 _veh deleteVehicleCrew _x;
} foreach _crew;

deleteVehicle _veh;
};

// Add crew to pool
_vattrs = _type call getVehicleAttrs;
{
_crewtype = _x;
if(!(_crewtype call isTankCrew)) then { ["Tank crew not listed '%1'", _crewtype] call errmsg; };

private _rank = "PRIVATE";
if(_foreachIndex < (count _ranks)) then { _rank = _ranks # _foreachIndex; };

[_crewtype,_rank,_skill] call _pushToPool;
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

printArray =
{
 params ["_arr"];
 diag_log "--- DUMPING ARRAY ---";

 { diag_log (str _x); } foreach _arr;

  diag_log "--- DUMPING ARRAY DONE ---";
};

getUnitEntryFromPool =
{
 params ["_manPool","_type","_kindFn",["_reqRank",-1],["_onlyCheck",false]];
 private _entry = [];
 private _highestRank = -1;
 private _selEntryIndex = -1;

 {
  private _rankId = (_x # MANP_RANK) call rankToNumber;

 if([(_x # MANP_TYPE),_type] call _kindFn && (_reqRank == -1 || (_rankId > _highestRank && _rankId <= _reqRank)) ) then
  {
   _highestRank = _rankId;
   _selEntryIndex = _foreachIndex;

   //break;
  };
 } foreach _manPool;

if(_selEntryIndex >= 0) then
{
 _entry = _manPool select _selEntryIndex;
 if(!_onlyCheck) then
 {
  _manPool deleteAt _selEntryIndex;
 };
};

if(count _entry == 0 && !_onlyCheck) then
{
 ["getUnitEntryFromPool failed %1 -- %2 <> %3",_type,_reqRank,_highestRank] call errmsg;
 //["%1", _kindFn ] call errmsg;

 [_manPool] call printArray;
};

 _entry
};

hasUnitEntryInPool =
{
 params ["_manPool","_type","_kindFn",["_reqRank",-1]];

 private _entry = [_manPool,_type,_kindFn, _reqRank, true] call getUnitEntryFromPool;

 count _entry > 0
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
  ["Invalid BG name '%1' - %2", _bgname, _side] call errmsg;
 };

 _ce
};

resetPool =
{
 selectableBgs = [];
};

addBattleGroupToPool =
{
 params ["_side","_bgname"];

 private _fpool = _side call getCurForce;
 _fpt = (_fpool # FORCE_BG_TYPES);
 _fpt pushbackUnique _bgname;

//diag_log format["------> %1 %2 %3", _side, _bgname, _fpool];
 

 private _manPool = _side call getManPool;

 private _ce = [_side,_bgname] call getBattleGroupCfg;

 //_skill = 0.3;

 private _units = getArray(_ce >> "units");
 {
  _rank = [_ce,_foreachIndex] call getRankFromCfg;
  _rankIndex = _rank call rankToNumber;
  
  _manSkill = 0.3 * _rankIndex + (random 0.2); // Lieutenant is highest rank... with little bit of random

  [_manPool,_x,_rank,_manSkill,_ce] call addUnitEntryToPool;

  //_skill = _skill - 0.1;
  //if(_skill < 0.1) then { _skill = 0.1; };
 } foreach _units;

};

retBattleGroupToPool =
{
 params ["_group"];

 private _side = side _group;

 private _manPool = _side call getManPool;

 {
  private _man = _x;

  [_manPool,typeof _man,rank _man,skill _man, _group getVariable "cfg"] call addUnitEntryToPool;

 } foreach ((units _group) select { alive _x });

 private _vehs = _group call getVehicles;

// Vehicles too
{
 _vehType = typeof _x;

 [_manPool,_vehType,"PRIVATE",0, _group getVariable "cfg"] call addUnitEntryToPool;

} foreach (_vehs select {alive _x});

};

retAllBattleGroupsToPool =
{
  params ["_side"];

  private _groups = _side call getOwnGroups;

 // Loop backwards to keep same order as when picked from the pool
 for "_i" from (count _groups - 1) to 0 step -1 do
 {
  private _group = _groups select _i;

  _group call retBattleGroupToPool;

  _group call deleteGroupInstantly;
 };
 
};

getBattleGroupDeployPos =
{
params ["_area","_size"];
_area params ["_pos","_range"];

private _npos = [];
for "_t" from 1 to 5 do
{
private _checkPos = [_pos,_size,_range,[_pos, _range, _range, 0, false]] call findSafePosVehicle;
if(count _checkPos > 0) then
{
 _npos = _checkPos;
 if(_t > 1) then { ["Deploy pos took %1 attembs", _t] call dbgmsg; };
 break;
};
};

if(count _npos > 0) then // If ok
{
_npos set [2,0];
};

_npos
};

createForce =
{
params ["_side","_name",["_rosterName",""],["_posMrk",""]];

private _icon = "uns_M113parts\army\1id_co.paa";

private _rosterCfg = configNull;

if(_rosterName != "") then
{

 _rosterCfg = missionconfigfile >> "ForceRosters" >> (_side call getSideStr) >> _rosterName;

 if(isnull _rosterCfg) exitWith { ["invalid roster name %1 '%2'",_side, _rosterName] call errmsg; };

 _icon = getText (_rosterCfg >> "icon");
};

if(_posMrk != "") then
{
 if(markerpos _posMrk isEqualTo [0,0,0]) then
 {
  ["Invalid marker '%1' in force '%2' creation", _posMrk, _name] call errmsg;
 };
 // Should maybe cancel creation
};

[_side,_name,_icon,_posMrk,_rosterCfg] call registerNewForce;
_force = allforces get _name;

//diag_log format["POOL123 %1", _fpool];

 if(_side == (call getPlayerSide)) then
 {
  curPlrForce = _force
 }
 else
 {
  curEnemyForce = _force;
 };



if(!isnull _rosterCfg) then
{

 diag_log "CREATING FORCE POOL";

 [_side,_rosterCfg] call createForceManPool;

};



};

createForceManPool =
{
 params ["_side","_forceClass"];

 private _forceList = getArray(_forceClass >> "battleGroups");

for "_i" from 0 to (count _forceList - 2) step 2 do
{
private _name = _forceList select _i;
private _count = _forceList select (_i + 1);

for "_n" from 0 to (_count - 1) do
{
diag_log format["Adding to pool '%1'", _name];
[_side, _name] call addBattleGroupToPool;
};

};

};

createBattleGroupFromPool =
{
 params ["_side","_bgname","_area"];

 private _manPool = _side call getManPool;

 if(count _manPool == 0) exitWith { ["Empty manpool %1",_side] call errmsg; };

 private _ce = [_side,_bgname] call getBattleGroupCfg;

 if(isnull _ce) exitWith { "Failed to get battlegroup cfg" call errmsg; };

 private _group = creategroup _side; // [_side,true];

diag_log format[">>> Unit created. cfg >>> %1 %2", _group, _ce];

 _group setVariable ["cfg",_ce];

_setupMan =
{
params ["_unit"];
_unit setRank (_entry # MANP_RANK);
_unit setSkill (_entry # MANP_SKILL);

_unit setVariable ["orgSkill", skill _unit]; // Needed later

if(side _unit == (call getPlayerSide)) then // Optimization
{
_unit addEventHandler ["FiredMan", unitFiring];
};

};

private _highestRank = 0;
_useRank =
{
 private _retRank = -1;

if(_highestRank < (count _ranks)) then
{
 _retRank = (_ranks # _highestRank) call rankToNumber;
 _highestRank = _highestRank + 1;
};

 _retRank
};

private _infPos = [];

 private _units = getArray(_ce >> "units");
 private _ranks = getArray(_ce >> "ranks");

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
 ["error finding vehicle attributes '%1' '%2'", _ue, (_vehEntry # MANP_TYPE)] call errmsg;
};

private _pos = [_area, _vattrs # VEH_ATTRS_SIZE] call getBattleGroupDeployPos;

if(count _pos == 0) then { ["No spawn pos found for vehicle (%1)",_vattrs] call errmsg; continue; };


_sveh = [_pos, 0, (_vehEntry # MANP_TYPE), _group] call BIS_fnc_spawnVehicle;
_sveh params ["_veh", "_crew", "_group"];

_veh setVariable ["utypeNumber", UTYPE_NUMBER_VEHICLE]; // Not really needed

_veh call noVeg; // No unsung vegetation

private _crewList = _vattrs # VEH_ATTRS_CREW;

if(count _crewList != count _crew) then
{
["Crew arrays size mismatch!"] call errmsg;
};

 // Take from pool and set skills, etc.
 {
 private _ce = _x;
 private _entry = [_manPool,_ce,isTankCrew, call _useRank] call getUnitEntryFromPool;

 if(count _entry == 0) exitWith { "Could not find crew from pool" call errmsg; };

 _cm = _crew # _foreachIndex;
 _cm call _setupMan;
 _cm setVariable ["utypeNumber", UTYPE_NUMBER_CREW];

 } foreach _crewList;
 
 }
 else
 {
  // Create infantry

  private _typeFn = isInfantry;
  if(_ue call isSniper) then // Sniper is special case
  {
   _typeFn = isSniper;
  };

  private _entry = [_manPool,_ue,_typeFn,call _useRank] call getUnitEntryFromPool;

if(count _entry == 0) exitWith 
{
 ["Failed to get infantry entry"] call errmsg;
};

// Get pos for infantry
if(count _infPos == 0) then
{
 _infPos = [_area, 0.4] call getBattleGroupDeployPos;

if(count _infPos == 0) then 
{
 //_area params ["_pos","_range"];
 //_infPos = _pos;
 "No spawn pos found for infantry" call errmsg; 
 continue; 
};

};

 // Set skills, etc
 _unit = _group createUnit [_entry # MANP_TYPE, _infPos, [], 0, "FORM"];
 _unit call _setupMan;
 _unit setVariable ["utypeNumber", UTYPE_NUMBER_INFANTRY];

if((typeof _unit) call isSniper) then
{
_unit setSkill 1;
};

 };

 } foreach _units;

 _as = _group call getGroupAverageSkill;
 _group setVariable ["expStr",_as call getExperienceStr];

 _group call registerBattleGroup;
};

getUnitTypeNumbers =
{
params ["_ue","_isFromPool"];

private _counts = [0,0,0];

 // vehicle
if(!(_ue iskindOf "man")) then
{
 _counts set [UTYPE_NUMBER_VEHICLE, (_counts # UTYPE_NUMBER_VEHICLE) + 1];

if(!_isFromPool) then // Only if counting from battlegroup config
{
private _vattrs = _ue call getVehicleAttrs;

private _crewList = _vattrs # VEH_ATTRS_CREW;

 _counts set [UTYPE_NUMBER_CREW, (_counts # UTYPE_NUMBER_CREW) + count _crewList];
};

}
else // infantry
{
 if(_ue call isTankCrew) then // Tank crew is special case
 {
  _counts set [UTYPE_NUMBER_CREW, (_counts # UTYPE_NUMBER_CREW) + 1];
 }
 else
 {
 _counts set [UTYPE_NUMBER_INFANTRY, (_counts # UTYPE_NUMBER_INFANTRY) + 1];
 };
};

_counts
};

countListTypeNumbers =
{
 params ["_units","_isFromPool"];

 private _counts = [0,0,0];

{
  private _ue = _x;

 if(_isFromPool) then
 {
  _ue = _ue # MANP_TYPE;
 };

 _cn = [_ue,_isFromPool] call getUnitTypeNumbers;
  _counts = [_counts,_cn] call addList;

} foreach _units;

 _counts
};

countBgPoolNeed =
{
 params ["_side","_bgname"];

 private _ce = [_side,_bgname] call getBattleGroupCfg;

private _counts = [0,0,0];

 private _units = getArray(_ce >> "units");
 _counts = [_units,false] call countListTypeNumbers;

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

addTypeToList =
{
params ["_list","_type"];

private _num = _list getOrDefault [_type,0];

_list set [_type, _num + 1];
};

getPoolUnitTypeCounts =
{
 params ["_pool"];

 private _list = createHashMap;

{

_type = _x # MANP_TYPE;

[_list,_type] call addTypeToList;

} foreach _pool;

 _list
};



