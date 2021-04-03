


getOnHoverHouse =
{
_p = (getposatl curatorCamera);
_p2 = (screenToWorld getMousePosition);

_vec = _p2 vectorDiff _p;
_nmv = vectorNormalized _vec;
_vchange = _nmv vectorMultiply 100;

//hintsilent (str _vec);

_tar = _p2 vectorAdd _vchange;
_from = _p;

_intersections = lineIntersectsSurfaces [aglToASL _from, aglToASL _tar, player, objNull, true, -1];

_surfPos = [];
{
 _x params ["_ipos","_norm","_obj"];

if(isnull _obj) exitWith
{
 _surfPos = _ipos;
};
} foreach _intersections;

if(count _surfPos == 0) exitWith { objNull }; // No surface?

_surfPos set [2,0];
//_bldg = nearestBuilding _surfPos;

_bldgs = nearestObjects [_surfPos, ["house"], 50];

if(count _bldgs == 0) exitWith { objNull };

_bldg = _bldgs # 0;

_size = _bldg call getObjectSize;

private _ret = objNull;

if(_surfPos inArea [getposATL _bldg, (_size # 0) / 4, (_size # 1) / 4, getdir _bldg, true, -1]) then
{
 _ret = _bldg;
};
_ret
};

