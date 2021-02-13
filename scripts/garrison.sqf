
isPosInsideBuilding =
{
 params ["_pos","_bldg"];
 
  _p1 = AGLToASL _pos;
  _height = (_p1 select 2) + 0.5;
  _numIntersect = 0;
  _dir = getdir _bldg;
  
  for "_i" from 0 to 3 do
  {
   _v = [_dir, 50] call getvector;
   _p2 = [_p1, _v] call addvector;
   
   _p1 set[2,_height];
   _p2 set[2,_height];
   
   //if(lineIntersects [_p1, _p2, player]) then
   
   _iobjs = lineIntersectsObjs [_p1, _p2, objnull, player, false, 0];
   
   {
    if(_x == _bldg) exitWith { _numIntersect = _numIntersect + 1; };
   } foreach _iobjs;

   _dir = _dir + 90;
  };
  
 _numIntersect == 4
};

isWindowPosition =
{
 params ["_pos","_bldg"];
 private _ret = false;
 
  _hitpoints = (configFile >> "CfgVehicles" >> (typeOf _bldg) >> "HitPoints");
  for "_h" from 0 to (count _hitpoints - 1) do
  {
   scopename "checkWindow";
   _hitp = _hitpoints select _h;
   if(isclass _hitp) then
   {
	if(getNumber(_hitp >> "armor") < 10) then
	{
	 _dee = _hitp >> "DestructionEffects";
	 if(count _dee > 0) then // Some houses without windows...
	 {
	 _brokenGlass = _dee select 0;
	 _selName = getText (_brokenGlass >> "position");
	 
	 _selPos = _bldg selectionPosition _selName;
	 _sWorldPos = _bldg modelToWorld _selPos;
	 
	 /*
	 _veh = createVehicle ["Sign_Sphere25cm_F", _sWorldPos, [], 0, "none"];
_veh setObjectTexture [0,'#(argb,8,8,3)color(0.7,0,0.1,1)'];
_veh setPosATL _sWorldPos;  
	 
	 systemchat format["window.... %1",_sWorldPos distance _pos];
	 */
	 
	 if((_sWorldPos distance _pos) < 2) then
	 {
	  _ret = true;
	  
	  breakout "checkWindow";
	 };
	 
	 };
	 
	 
	};
	
   };
  };
 _ret
};



#define GUN_HEIGHT 1.37
//#define LEG_DIST  0.75

#define LEG_DIST    1
#define REACH_DIST  1.25

//linesChecked = [];

checkWindowLine =
{
 params ["_start","_dir","_maxLength"];
 
 private _clear = false;
 
 private _vec =  [_dir,_maxLength] call getVector;
 private _end = [_vec,_start] call addVector;

 _end set [2,_start # 2];
 
 
 _s = ATLToASL _start;
 _e = ATLToASL _end;
 if(!(lineintersects [_s,_e,objNull,objNull])) then
 {
  _clear = true;
 };
 
 _vec = [_dir,REACH_DIST] call getVector;
 private _e2 = [_vec,_s] call addVector;
 
 _s set[2, (_s # 2) - LEG_DIST];
 _e2 set[2, (_s # 2) ];
 if(!(lineintersects [_s,_e2,objNull,objNull])) then
 {
  _clear = false;
 };
 
//linesChecked pushback [_start,_end,_clear];
//linesChecked pushback [ASLToATL _s,ASLToATL _e2,_clear];

_clear
};


isOpenWindowPosition =
{
params ["_bpos","_bldg"];

private _startDir = getdir _bldg;
private _bLength = (_bsize # 0) max (_bsize # 1);

private _spos = +_bpos;
_spos set [2,(_spos # 2) + GUN_HEIGHT];
 
private  _clear = false;
for "_d" from _startDir to (360 + _startDir) step 90 do
{
 scopename "cangles";
 _clear =  [_spos,_d,_bLength / 2] call checkWindowLine;
 
 if(_clear) then
 {
  breakout "cangles";
 };
 
};

_clear
};


#define GUARD_RELEASE_TIME_MIN  (60 * 2)
#define GUARD_RELEASE_TIME_RAND (60 * 5)


standOnGuard =
{
 params ["_man","_dir",["_mustStand",true]];
 
 if(_man call isOnGuard) exitWith {};
 
  dostop _man;
  
 //_man setUnitPos "UP";
 
 _man setDir _dir;
 
// [_man, "STAND_IA", "ASIS"] call BIS_fnc_ambientAnimCombat; 

_man disableAI "PATH"; 

if(_mustStand) then
{
_man setUnitPos "UP";
};

 _man setVariable ["onGuard",true];
 _man setVariable ["guardEngageTime", time + GUARD_RELEASE_TIME_MIN + (random GUARD_RELEASE_TIME_RAND) ];
};

releaseGuard =
{
 params ["_man"];
 
 if(!(_man call isOnGuard)) exitWith {};
 
 if(_man call inVehicle) then
 {
  if((vehicle _man) call isStaticWeapon) then
  {
  
   unassignVehicle _man;
   moveOut _man;
  
  };
 };
 
 _man enableAI "PATH"; 
 _man setUnitPos "AUTO";
 
 /*if(!isnil "BIS_fnc_ambientAnim__terminate") then // Maybe that animation is not set in case the man is supposed to be a static gun gunner
 {
  _man call BIS_fnc_ambientAnim__terminate;
  _man setUnitPos "AUTO";
 };*/
 
 _man setVariable ["onGuard",false];
};



manBuildings =
{
 params ["_group","_aroundPos","_distance","_onlyOneBldg","_maxMenUsed","_maxMenBldg"];
 
 private _side = side _group;
 
/// _group enableAttack false;
//private _units = (_group call getGroupInfantry) select { !(_x call isOnGuard) }; // (units _group) select { _x == (vehicle _x) && alive _x };

//if(count _units == 0) exitWith {}; // All vehicles or something

_bldgs = nearestObjects [_aroundPos, ["house"], _distance];

_usedPositions = [];


_numBuildings = count _bldgs;
_firstBldgIndex = floor (random _numBuildings);
_rbi = _firstBldgIndex;
_lastBuilding = false;

if(_numBuildings == 0) exitWith {};

["MANNING! %1: %2 %3", _numBuildings,_maxMenUsed,_maxMenBldg] call dbgmsg;

_goodPositions = [];

	
private _numMenPlaced = 0;

while { !_lastBuilding && _numMenPlaced < _maxMenUsed } do
{
 scopename "placeUnits";

_bldg = objNull;
 
if(_onlyOneBldg) then
{
 _bldg = _bldgs select 0;
 _lastBuilding = true;
}
else
{
 _bldg = _bldgs select _rbi;
 
 _rbi = _rbi + 1;
 if(_rbi >= _numBuildings) then { _rbi = 0; };
 if(_rbi == _firstBldgIndex) then
 {
  _lastBuilding = true;
 };
};

 _allPositions = _bldg buildingPos -1;
 _exit = _bldg buildingExit 0;
 if(count _allPositions > 0 && !(_exit isEqualTo [0,0,0])) then
 {
 //systemchat format["Looping %1 -- %2", _bldg, count _bpositions];
 
 _bsize = _bldg call getObjectSize;
 _numInThisBldg = 0;

_shouldUsePos =
{
 params ["_pos"];
 ([_pos,_bldg] call isWindowPosition) || ([_pos,_bldg] call isOpenWindowPosition)
};

_bestPositions = _allPositions select { [_x] call _shouldUsePos };
_secondaryPositions = _allPositions select { !([_x] call _shouldUsePos) };

{
  _bpositions = _x;
  _bIndex = _forEachIndex;

  _numPositions = count _bpositions;

if(_numPositions > 0) then
{
   _startBposIndex = floor (random _numPositions);
   _ri = _startBposIndex;
   _last = false;
   while { !_last } do
   {
    scopename "placeInbuilding";
	
	_thisPosIndex = _ri;
	
	// systemchat format["Checking pos %1/%2 %3 %4", _numPositions, _thisPosIndex, _startBposIndex,_last];
   
   _used = false;
   
   {
    _x params ["_selbldg","_selBindex","_selPosIndex"];
    if(_selbldg == _bldg && _selBindex == _bIndex && _selPosIndex == _thisPosIndex) exitWith {
	 _used = true;
	};
   } foreach _usedPositions;
   
   if(!_used) then
   {
   
   private _bpos = _bpositions select _thisPosIndex;
   private _bdir = [getpos _bldg,_bpos] call getAngle;

   _goodPositions pushback [_bpos,_bdir];

   // Valid pos or not consider used
   _usedPositions pushbackUnique [_bldg,_bIndex,_thisPosIndex];

   };

	_ri = _ri + 1;
	if(_ri >= _numPositions) then { _ri = 0; };

	if(_ri == _startBposIndex) then
	{
	 _last = true;
	};
   };

};
} foreach [_bestPositions,_secondaryPositions];
   
};
};

//["_numMenPlaced: %1", _numMenPlaced] call dbgmsg;


_group enableAttack false; // <------------------------------------ 

_useAngleFirst = 90;
_selectPosFirst = {
params ["_bpos","_bposDir"];

(abs ([_bposDir,_useAngleFirst] call angleDist)) <= 90
};

// hint format["pos: %1", _goodPositions];

//_sortedPositions = [_goodPositions, [], { _x call _selectPosFirst }, "ASCEND"] call BIS_fnc_sortBy;

_sf = _goodPositions select { _x call _selectPosFirst };
//_se = _goodPositions select { !(_x call _selectPosFirst) };
_se = [];

_sortedPositions = _sf + _se;

_units = units _group;
{

private _u = _x;
if(_forEachIndex >= (count _sortedPositions) || _forEachIndex >= (count _sf) ) exitWith {};

private _goodPos = _sortedPositions select _forEachIndex;
_goodPos params ["_bpos","_bposDir"];

diag_log format["--> %1 %2",_forEachIndex, _bposDir];

 _u doMove _bpos;
     
 //private _dir = [getpos _bldg,_bpos] call getAngle;
 _watchPos = [_bposDir,25] call getvector;
 _watchPos = [_bpos,_watchPos] call addvector;
 _u doWatch _watchPos;

 _numInThisBldg = _numInThisBldg + 1;
 _numMenPlaced = _numMenPlaced + 1;

[_u,_bpos] spawn
{
 params ["_u","_bpos"];
 waituntil { sleep 1; _u distance _bpos < 1 };
 dostop _u;
};

} foreach _units;
	
};