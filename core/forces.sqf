#include "..\main.h"


allforces = createHashMap;
numForcesCreated = 0;

registerNewForce =
{
params ["_side","_name","_icon","_posmrk","_usedroster"];

allforces set [_name, [numForcesCreated,_side,_icon,_posmrk, 1, [], [], _usedroster ] ];

numForcesCreated = numForcesCreated + 1;
};

isFriendlyForce =
{
 params ["_forceName"];
 private _force = allforces get _forceName;

 (_force # FORCE_SIDE) == (call getPlayerSide)
};

getForcePosMarker =
{
 params ["_forceName"];

 private _force = allforces get _forceName;

 _force # FORCE_POSMARKER;
};

numForceMoves =
{
 params ["_forceName"];

 private _force = allforces get _forceName;

 _force # FORCE_NUM_MOVES;
};

moveForceToBattleloc =
{
 params ["_forceName","_destMarker"];
 private _force = allforces get _forceName;

 [_force,_destMarker] call setForceNewBattleLoc;

};

setForceNewBattleLoc =
{
 params ["_force","_destMarker"];

 private _bloc = _destMarker call getBattleLoc;

 _bloc set [BATTLELOC_OWNER, _force # FORCE_SIDE]; // Always update

 _force set [FORCE_POSMARKER, _destMarker ];


 _force set [FORCE_NUM_MOVES, (_force # FORCE_NUM_MOVES) - 1];

};

getForcesAtBattleLoc =
{
 params ["_loc"];

private _list = [];
{

if((_y # FORCE_POSMARKER) == _loc) then
{
 _list pushback _y;
};

} foreach allforces;

// { (_x # FORCE_POSMARKER) == _loc} count allforces;


 _list
};

isEngagementInLoc =
{
 params ["_locMarker"];
 count (_locMarker call getForcesAtBattleLoc) > 1
};

countSideForcesAtBattleLoc =
{
 params ["_side","_loc"];

 private _forces = _loc call getForcesAtBattleLoc;

 { (_x # FORCE_SIDE) == _side } count _forces
};

getGlobalBattles =
{
 private _battles = [];

 private _westForces = [];

 _westForces = [allforces,{ ((_x # FORCE_SIDE) == west) }] call hashmapSelect; // from west perspective

 {
  private _force = _x;
  private _opp = [allforces, { ((_x # FORCE_SIDE) != (_force # FORCE_SIDE)) } ] call hashmapSelect;
  
  {
   if((_force # FORCE_POSMARKER) == (_x # FORCE_POSMARKER)) then
   {
    _battles pushback [(_force # FORCE_POSMARKER), _force, _x];
   };
  } foreach _opp;

 } foreach _westForces;

 _battles
};

hashmapSelect =
{
 params ["_map","_code"];
 private _ret = [];

 {
  private _x = _y;
  if(call _code) then
  {
   _ret pushback _y;
  };
 } foreach _map;
 _ret
};

countForceFriendlies =
{
 params ["_forceName","_forces"];
 private _force = allforces get _forceName;

 {(_force # FORCE_SIDE) == (_x # FORCE_SIDE) } count _forces
};

getForceRenderPos =
{
 params ["_forceName"];
  private _force = allforces get _forceName;

 private _forces = (_force # FORCE_POSMARKER) call getForcesAtBattleLoc;

 private _renPos = markerpos (_force # FORCE_POSMARKER);

 if(count _forces > 1) then
 {
  private _dir = 1;
  if(_force # FORCE_SIDE == west) then { _dir = -1; };
  _renPos set [0, (_renPos # 0) + (250 * _dir)];
 };

 _renPos
};


getForceAtPos =
{
 params ["_pos","_selSide"];
 private _ret = "";

{

if( _selSide == (_y # FORCE_SIDE) && _pos distance2D ( (_x call getForceRenderPos)) < ((FORCE_ICON_SIZE * 2 * 10) * ( (1 call scaleToMap))) ) then
{
 _ret = _x;
};

} foreach allforces;

 _ret
};

getForceInfo =
{
 params ["_forceName"];
 private _force = allforces get _forceName;

 //private _types = [[_force] call getForcePool] call getPoolUnitTypeCounts;

private _mpool = [_force] call getForcePool;
private _poolCounts = [_mpool,true] call countListTypeNumbers;

 //hint (str _mpool);

 private _info = _forceName;

 _info = _info + format["\n%1 men\n%2 armor", _poolCounts # UTYPE_NUMBER_INFANTRY,_poolCounts # UTYPE_NUMBER_VEHICLE ];

 _info = _info + format["\nMoves:%1",_force # FORCE_NUM_MOVES];
 

 _info
};

renderForces =
{
 params ["_mapCtrl"];

{
	_mapCtrl drawIcon [
		_y # FORCE_ICON,
		[1,1,1,1],
		_x call getForceRenderPos,
		(1 - (1 call scaleToMap)) * FORCE_ICON_SIZE,
		(1 - (1 call scaleToMap)) * FORCE_ICON_SIZE,
		0,
		"",
		1,
		0.03,
		"TahomaB",
		"right"
	];
} foreach allforces;

};

resetForcesTurn =
{

{
 _y set [FORCE_NUM_MOVES,1];
} foreach allforces;

};