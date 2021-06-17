
#define SPAWN_VEH_SPACE 11 // (10.3641 / 2) //HEMTT size

numdummyvehs = 0;

calcVehicleSize =
{
 params ["_type"];
 //private _veh = _type createvehiclelocal [numdummyvehs * -25,numdummyvehs * -25,0];
 
 _veh = createSimpleObject [_type, [numdummyvehs * -25,numdummyvehs * -25,0], true];
 //private _size2 = _sveh call getObjectSize;
 
 
 //player setpos [numdummyvehs * -25,numdummyvehs * -25,0];
 
 private _size = _veh call getObjectSize;
 
// ["SIZE COMP: %1 %2 == %3 -- %4", _type, _size, _size2, _size isEqualTo _size2] call dbgmsg;
 
 private _vehSize = ((_size select 0) / 2) max ((_size select 1) / 2);
 
 deletevehicle _veh;
 
 // systemchat (str _vehSize);
 
 numdummyvehs = numdummyvehs + 1;
 if(numdummyvehs > 10) then { numdummyvehs = 0; };
 
 _vehSize
};

getVehicleSize =
{
params ["_type"];
private _ret = 10;
private _arr = [vehSizes,_type,0] call findFromArray;


if(count _arr > 0) then
{
 _ret = (_arr select 0) select 1;
}
else
{
 ["Unknown veh type '%1' in getVehicleSize",_type] call errmsg;

};
_ret
};

getObjectSize =
{
 private _veh = _this;
 private ["_bbr","_p1","_p2"]; 
 
 _bbr = 0 boundingBoxReal _veh;
 _p1 = _bbr select 0;
 _p2 = _bbr select 1;

 // Width, Length, Height
 [abs ((_p2 select 0) - (_p1 select 0)), abs ((_p2 select 1) - (_p1 select 1)), abs ((_p2 select 2) - (_p1 select 2))]
};


checkBoundingCollide =
{
 params ["_nspos","_obj","_vehSize"];
 
  private _size = _obj call getObjectSize;
   
   //systemchat format ["_size %1", _size];
   
  private _dist = (_nspos distance2D _obj) - _vehSize;
   
  private _bsize = ((_size select 0) / 2) max ((_size select 1) / 2);
   
 (_dist < _bsize)
};



findSafePosVehicle =
{
 params ["_pos",["_vehSize",SPAWN_VEH_SPACE],["_maxSearchDist",750],["_inArea",[]],["_notOnRoad",false],["_blacklist",[]]];
 
 private _circleBl = [];
 
 private _args = [_pos, 0, 50, _vehSize , 0, 0.5, 0, []];
 
 private _nspos = [];
 
 #define RADIUS_STEP_SIZE 20
 #define POS_SEARCH_ATTEMBS (ceil (_maxSearchDist / RADIUS_STEP_SIZE))
 
 _dbgTime = time;
 
 for "_i" from 1 to POS_SEARCH_ATTEMBS do
 {
  scopename "lookpos";
  
   // padd so pos doesnt get skipped because it goes over the edge
  #define SEARCH_PADD 20
  private _s = RADIUS_STEP_SIZE * (_i - 1) - SEARCH_PADD;
   if(_s < 0) then { _s = 0; };
  _args set[1, _s];
  _args set[2, RADIUS_STEP_SIZE * _i + SEARCH_PADD];
  
  for "_a" from 1 to 4 do
  {
  _args set[7, _circleBl + _blacklist];
  
  _nspos = _args call BIS_fnc_findSafePos;
  
  if(count _nspos > 0) then
  {
   _circleBl pushback [_nspos, _vehSize];

   // _nspos set[2,0];
   
   _cpos = _nspos;
   _nspos = [];

 if(count _inArea > 0) then
 {
 if(!(_cpos inArea _inArea)) then { breakto "lookpos"; };
 };
   
  // _eobjs = nearestObjects [_nspos, ["Car", "Motorcycle","Truck","Tank"], SPAWN_VEH_SPACE * 2];
 // _eobjs = _nspos nearEntities [["Car", "Motorcycle","Truck","Tank"], 30];
 
 if(_notOnRoad && isOnRoad _cpos) then { breakto "lookpos"; };
 
  // Get's houses too
  _eobjs = _cpos nearObjects 50;
 //_eobjs = nearestObjects [_cpos, [], 50, true];

  _eobjs = _eobjs select { _x call isValidCollider };

  //_eobjs = _nspos nearEntities SPACE;
  _c = { !(_x isKindOf "Man") && [_cpos,_x,_vehSize] call checkBoundingCollide } count _eobjs;
  
{

//diag_log format[">>>111>>> '%1' %2 %3 (%4 %5)",_x, typeof _x,side _x, _x iskindof "building", _x iskindof "house"];

} foreach _eobjs;

//diag_log format["TEEEEEST %1",{(str _x) find "NOID" == -1 } count _eobjs];
  
  if(_c > 0) then { breakto "lookpos"; };
  
  
  _trees = nearestTerrainObjects [_cpos, ["TREE","SMALL TREE"], _vehSize + 0.5];
  if(count _trees > 0) then { breakto "lookpos"; };
  
  // HIDE = rocks
  _to = nearestTerrainObjects [_cpos, ["HIDE","ROCK","ROCKS", "WALL","FENCE" ], 50];

  _toCol = { [_cpos,_x,_vehSize] call checkBoundingCollide } count _to;
  
  if(_toCol > 0) then { breakto "lookpos"; };
  
  /*
  _houses = nearestObjects [_cpos, ["house"], 50, true]; // "building",

 _houses = _houses select { _x call isValidCollider };
{

diag_log format[">>>222>>> '%1' %2 %3 (%4 %5)",_x, typeof _x,side _x, _x iskindof "building", _x iskindof "house"];

} foreach _houses;

  
  {
   if([_cpos,_x,_vehSize] call checkBoundingCollide) then { breakto "lookpos"; };
   
  } foreach _houses;
*/

  // Valid pos found
  _nspos = _cpos;
  
  //systemchat format ["Pos found at %1 attemb", _i];
  
  breakout "lookpos";

   
  };
  };
  
  _circleBl = [];
 };
 
 if((time - _dbgTime) > 5) then
 {
  //["find spawn pos slow! %1 %2", (time - _dbgTime), count _nspos > 0] call dbgmsg;
 };
 
 _nspos
};

isValidCollider =
{
 params ["_obj"];
 private _os = tolower (str _obj);

 side _obj != sideLogic && _os find "powerline_01_wire" == -1 && _os find "noid" == -1
 && !(_obj iskindof "insect") // can be too if plr on ground
 && _os find "highvoltagecolumnwire" == -1 && _os find "light" == -1  
};


#define SEARCH_SPACE_STEP_SIZE 25

findFreePosInArea =
{
scopename "findFreePos";
params ["_cenPos","_radiusX","_radiusY","_size"];

_mdir = 0;

private _fposRet = [];

_posFound = false;
_stepY = 0;
while { !_posFound && (abs _stepY) < _radiusY } do
{
 _vecY = [_mdir,_stepY] call getVector;

_step = 0;
while { !_posFound && (abs _step) < _radiusX } do
{
private _vec = [_mdir + 90,_step] call getVector;
private _vec = [_vecY,_vec] call addvector;
private _checkPos = [_cenPos,_vec] call addvector;

_mrk = createMarker [format["DbgMrk_%1",random 100000], _checkPos];
_mrk setMarkercolor "ColorRed";
_mrk setMarkerShape "ICON";
_mrk setMarkerType "hd_dot";


private _npos = [_checkPos,_size,100,[_checkPos, _radiusX/2, _radiusY/2, _mdir, false]] call findSafePosVehicle;

if(count _npos > 0) then // If ok
{
_npos set [2,0];
_fposRet = _npos;

_posFound = true; // Not used...

breakto "findFreePos";
};

 if(_step >= 0) then { _step = _step + SEARCH_SPACE_STEP_SIZE; };
 _step = _step * -1;
};

 if(_stepY >= 0) then { _stepY = _stepY + SEARCH_SPACE_STEP_SIZE; };
 _stepY = _stepY * -1;
};

 _fposRet
};