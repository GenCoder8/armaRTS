
#define SPACE_REQ_FOR_POINT 0.25
#define EXTRA_DIST_FROM_WALL 0.3
#define SPACE_BETWEEN_POINTS 0.25
#define COVER_HEIGHT_REQ  0.2
#define HOUSE_HOVER_CONTACT_NUM 0.8
#define EDGE_NEAR_START_DIST 5.5
#define GET_COVER_POS_AREA 40

// Optimizes
#define COVER_COLLIDE_DIST 20

/*
stone_Xm are stone walls
*/

excludeCover = ["light","powerline","lamp","FuelStation","fs_feed","fs_roof","gate","WaterTower","shed_small"];
includeCover = ["wall","city","watertank","tankrust","garbageContainer","fieldToilet","cargo","dp_transformer","mound","stone_8m","stone_4m"];


coverObjTypes = [];
coverObjsIncluded = [];
coverObjs = [];

initCoverSystem =
{
params ["_centerPos","_areaSize"];

coverAreaPos = _centerPos;
coverAreaSize = _areaSize;


coverObjTypes = createHashMap;

coverObjsIncluded = createHashMap;

coverObjs = createHashMap;

//_objs = [] call getCoverObjects;

private _objs = nearestObjects [coverAreaPos, [], coverAreaSize, true];


{
 _obj = _x;


_obj call registerCoverObj;
_obj call createCoverPointsForObj;

/*
if(DEBUG_COVERS) then
{
_size = _obj call getObjectSize;
_pos = getposASL _obj;

_pos set [2, (_pos # 2) + ((_size # 2)/2) + 1.5 ];

_arrow = createSimpleObject ["Sign_Arrow_F", _pos,false];
};*/

 //_obj hideObjectGlobal true;

} foreach _objs;

};

isObjExcluded =
{
 params ["_obj"];
 private _ok = true;
 private _names = [tolower (str _obj),(tolower (typeof _obj))];
{
 private _n = _x;
 if(( excludeCover findIf { (tolower _x) in _n }) >= 0) exitWith { _ok = false; };
} foreach _names;
 _ok
};

getCoverObjects =
{
 params ["_cPos","_cSize"];

if(count _this == 0) then
{
_cPos = coverAreaPos;
_cSize = coverAreaSize;
};

//private _objs = nearestObjects [_cPos, [], _cSize, true];
//private _foundObjs = _objs select { (str _x) in coverObjsIncluded };

private _foundObjs = [];

{

if(_y distance2D _cPos < _cSize) then
{
 _foundObjs pushback _y;
};

} foreach coverObjsIncluded;


/*
{
_b = (tolower (str _x)); 

(((_x call getObjVisibilityAboveGround) > 0.5) && ( (_x iskindof "building") || ( (includeCover findIf { (tolower _x) in _b }) >= 0)) && (_x call isObjExcluded))
};*/

_foundObjs
};

includeCheckCoverObject =
{
 params ["_obj"];
 private _b = (tolower (str _obj));

 if((((_x call getObjVisibilityAboveGround) > 0.5) && ( (_x iskindof "building") || ( (includeCover findIf { (tolower _x) in _b }) >= 0)) && (_x call isObjExcluded))) then
 { 
  coverObjsIncluded set [_b, _obj];
 };

};

getObjectCenter =
{
params ["_bldg"];

private _bbr = 0 boundingBoxReal _bldg;
private _p1 = _bbr select 0;
private _p2 = _bbr select 1;

private _cen = [(_p2 select 0) + (_p1 select 0), (_p2 select 1) + (_p1 select 1), 0 ];

private _wpos = _bldg modelToWorld _cen;

_wpos
};



getObjVisibilityAboveGround =
{
 params ["_obj"];

 private _wpos = _obj modelToWorld [0,0,0];

 private _bbr = boundingBoxReal _obj;
 private _elevation = _wpos # 2; 

 private _height = abs (((_bbr select 1) # 2) - ((_bbr select 0) # 2));

 private _aboveGround = _elevation + (_height / 2); 

_aboveGround
};

rotate = 
{
private ["_ox","_oy","_d","_cx","_cy","_f","_ret","_yf","_xf","_origin"];

_origin = _this select 1;
_xf = 0;
_yf = 0;

if(typename _origin == "ARRAY") then
{
_xf = _origin select 0;
_yf = _origin select 1;
}
else
{
_xf = _origin;
_yf = _origin;
};

_ox = ((_this select 0) select 0) - _xf;
_oy = ((_this select 0) select 1) - _yf;
_d = _this select 2;

_cx = ((cos _d)*_ox + (sin _d)*_oy);
_cy = ((cos _d)*_oy - (sin _d)*_ox);

_ret = [_cx+_xf,_cy+_yf,0];
_ret
};

/*
getCoverObjects =
{
private _objs = nearestObjects [player, ["Land_VR_Block_05_F","BagFence_base_F"], 30];
_objs
};*/


getCoverObjType =
{
  params ["_obj"];

  ((str _obj) select [((str _obj) find ":") + 2,1000])
};

registerCoverObj =
{
 params ["_obj"];

_obj call includeCheckCoverObject; // Create include list also in here

private _edges = coverObjTypes getOrDefault [_obj call getCoverObjType,[]];

if(count _edges > 0) exitWith {}; // Already registered

private _size = _obj call getObjectSize;

private _cen = getposATL _obj;


private _edges = [];


for "_i" from 0 to 3 do
{
 private _sidePositions = [];

 private _angle = (90 * _i);
 private _depth = _size # 0;
 private _length = _size # 1;

 if(_i == 1 || _i == 3) then { _depth = _size # 1; _length = _size # 0; };
 _depth = _depth / 2;

 _depth = _depth + (EXTRA_DIST_FROM_WALL + SPACE_REQ_FOR_POINT); // Distance from wall

 // systemchat format["%1) %2 -- %3",_i, _size, _length ];

 private _vec = [_angle, _depth] call getVector;

 _edgePoint = _vec; // [_cen,_vec] call addvector;

 //_edgePoint set [2,0];
 //_arrow = createSimpleObject ["Sign_Arrow_F", ATLToASL _edgePoint,false];

 #define LENGTH_CUT 0.2
 private _step = LENGTH_CUT;
 _length = _length - (LENGTH_CUT * 2);
 while { _step < _length } do
 {
  private _vec = [_angle - 90, -_length/2 + _step] call getVector;
  _sideStep = [_edgePoint,_vec] call addvector;

 _sideStep set [2,0];
 //_arrow = createSimpleObject ["Sign_Arrow_Blue_F", ATLToASL _sideStep,false];

 _sidePositions pushback _sideStep;

  _step = _step + (SPACE_BETWEEN_POINTS + SPACE_REQ_FOR_POINT);
 };

 _edges pushback _sidePositions;

};

//_obj setVariable ["cover", _edges];

coverObjTypes set [_obj call getCoverObjType, _edges];

};

createCoverPointsForObj =
{
 params ["_obj",["_checkExisting",false]];

 private _edges = coverObjTypes getOrDefault [_obj call getCoverObjType,[]];
 if(count _edges == 0) exitWith { }; // systemchat format["ERROR no cover points"]; 

 private _prevEdges = [];
 if(_checkExisting) then
 {
  _prevEdges = coverObjs getOrDefault [(str _obj),[]];
 };
 if(count _prevEdges > 0) exitWith {}; // Already created

// systemchat format["Creating rotated edges %1 -- %2",_obj, time];

  private _rotEdges = +_edges;

  private _angle = getDir _obj;
  private _pos = getPos _obj;
  private _size = _obj call getObjectSize;
  private _sizeRad = ((_size # 0) max (_size # 1)) / 2;

  private _rotateAngle = _angle + 90;

  private _edgeAngle = _angle + 90;
 {
  
  private _edgePoints = _x;
  {
   private _rotPoint = [_x,[0,0],_rotateAngle] call rotate;
   _rotPoint = [_rotPoint, _pos] call addVector;
   
// Check if far from the wall
_rotPoint set [2, COVER_HEIGHT_REQ];
_v = [_edgeAngle - 180, _sizeRad] call getVector;
_closePoint = [_rotPoint, _v] call addVector;
_closePoint set [2, COVER_HEIGHT_REQ];

_intersections = lineIntersectsSurfaces [AglToAsl _rotPoint, AglToAsl _closePoint, objNull, objNull, true, 1];

private _okPos = false;

if(count _intersections > 0) then
{
 (_intersections # 0) params ["_intPos","_sNorm","_iObj"];

if(_iObj == _obj) then
{

_okPos = true; // Must have line contact with _obj to be valid cover

private _d = (_intPos distance2D _rotPoint);

if( _d > 0.75 && _d < _sizeRad ) then // Dist untested
{

/*
// Debug
diag_log format[">>>>>>>>>>>>> %1 -- %2 %3 ", (_intersections # 0), _size ];

_arrow = createSimpleObject ["Sign_Arrow_Cyan_F", _intPos,true];
*/

// little off from the wall
_v = [_edgeAngle, EXTRA_DIST_FROM_WALL] call getVector;
_intPos = _intPos vectorAdd _v;


_rotPoint = aslToAgl _intPos;
 
};

_rotPoint set [2,0];

//if(count (_rotPoint isFlatEmpty  [SPACE_REQ_FOR_POINT, -1, -1, -1, -1, false, _obj]) == 0) then
if([_rotPoint,_obj] call isPositionBlocked) then
{
 _okPos = false;
};

};

};


if(!_okPos) then
{
 _rotPoint = [];
};


   _edgePoints set [_forEachIndex, _rotPoint];
  } foreach _edgePoints;

  _edgeAngle = _edgeAngle + 90;
 } foreach _rotEdges;
   

// _obj setVariable ["coverRotated",_rotEdges];

coverObjs set [str _obj, _rotEdges];

};


isPositionBlocked =
{
 params ["_checkPos","_exclude"];
 private _objs = [_checkPos,COVER_COLLIDE_DIST] call getCoverObjects;
 private _closest = _objs select { _x != _exclude }; // _x distance2D _checkPos < 20 &&
 private _ret = false;

 private _spaceReq = SPACE_REQ_FOR_POINT / 2;

{
 private _obj = _x;
 private _size = _obj call getObjectSize;

if(_checkPos inArea [getposATL _obj, (_size # 0) / 2 + _spaceReq, (_size # 1) / 2 + _spaceReq, getdir _obj, true, -1]) then
{
 _ret = true;
 break;
};

} foreach _closest;

 _ret
};





getCoverForPosition =
{
 params ["_wpos"];

if(!loadCovers) exitWith { [] };

private _objs = [_wpos,GET_COVER_POS_AREA] call getCoverObjects;

private _closestDist = EDGE_NEAR_START_DIST;
private _closestEdge = [];

{
 private _obj = _x;

 //_rotEdges = _obj getVariable ["coverRotated",[]];

 private _rotEdges = coverObjs getOrDefault [(str _obj),[]];

 if(count _rotEdges > 0) then // When testing cover obj list may change
{

 {
  private _edgePoints = _x;
  {
   private _point = _x;


if(count _point > 0) then
{
 private _dist = _point distance _wpos;


if(_dist < _closestDist) then
{

 _closestDist = _dist;
 _closestEdge = _edgePoints;
};
};

  } foreach _edgePoints;
 } foreach _rotEdges;
};
} foreach _objs;


 _closestEdge
};

/*
[] spawn
{

 _p = getmarkerpos "tm";
 _p set [2,0];
 _arrow = createSimpleObject ["Sign_Arrow_Blue_F", AglToASL _p ,false];

_angle = 0;

while { true } do
{
 _rot = [_p,getpos player,_angle] call rotate;

 _rot set [2,0];
 _arrow setposASL (AglToASL _rot);

 _angle = _angle + 5;
 sleep 0.1;
};

};*/





//lineIntersectsSurfaces [(getposatl curatorCamera), _tpos, player, chopper, true, -1];



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
 _surfPos = aslToAgl _ipos;
};
} foreach _intersections;

if(count _surfPos == 0) exitWith { objNull }; // No surface?

_surfPos set [2,0];
//_bldg = nearestBuilding _surfPos;

_bldgs = nearestObjects [_surfPos, ["house"], 40, true];

if(count _bldgs == 0) exitWith { objNull };

_bldg = _bldgs # 0;

_size = _bldg call getObjectSize;

private _ret = objNull;

private _wpos = _bldg call getObjectCenter; //  modelToWorld (getCenterOfMass _bldg); // _bldg modelToWorld [0,0,0]; // getposATL _bldg

if(_surfPos inArea [_wpos, (_size # 0) / 2 * HOUSE_HOVER_CONTACT_NUM, (_size # 1) / 2 * HOUSE_HOVER_CONTACT_NUM, getdir _bldg, true, -1]) then
{
 _ret = _bldg;
};

_ret
};


/*
[] spawn
{

while { true } do
{
 
 _apos = getposATL ar;
 _size = sb call getObjectSize;

if(_apos inArea [getposATL sb, (_size # 0) / 2, (_size # 1) / 2, getdir sb, true, -1]) then
{
 hint "Blocked";
}
else
{
 hint "Free";
};
 
 sleep 0.25;
};

};*/

