dbgmsg =
{
if(!rtsDebugMode) exitWith {};

if(typename _this == "ARRAY") then
{
_this = format _this;
};
 systemchat format["DBG: %1",_this];
};

getObjectSize =
{
 private _veh = _this;
 private ["_bbr","_p1","_p2"]; 
 
 _bbr = boundingBoxReal _veh;
 _p1 = _bbr select 0;
 _p2 = _bbr select 1;

 // Width, Length, Height
 [abs ((_p2 select 0) - (_p1 select 0)), abs ((_p2 select 1) - (_p1 select 1)), abs ((_p2 select 2) - (_p1 select 2))]
};

isUserMarker =
{
(_this find "_USER_DEFINED") >= 0
};

isValidMarker =
{
 params ["_marker"];

 !(markerpos _marker isEqualTo [0,0,0])
};

getNearest =
{
 params ["_array","_arCode","_pos"];
 private _closestDist = 10000000;
 private _nearest = [];
 
 //["getNearest %1 %2 %3", _array,_arCode,_pos] call dbgmsg;
 
 {
  private _aelement = call _arCode;
  
  if(isnil "_aelement") then { ["getNearest NIL %1 %2 %3", _array,_arCode,_pos] call errmsg; };
  
  private _dist = _aelement distance2D _pos;
  
  if(_dist < _closestDist) then
  {
   _closestDist = _dist;
   _nearest = _x;
  };
 } foreach _array;
 
 _nearest
};


isPosGround =
{
 scopename "ipg";
 params ["_around","_areaSize"];
 private _ret = true;
 
 for "_depth" from 1 to _areaSize step 10 do
 {
 for "_d" from 0 to 360 step 45 do
 {
  private _vec = [_d,_depth] call getVector;
  private _checkpos = [_around,_vec] call addVector;
  
  if(surfaceIsWater _checkpos) then
  {
   _ret = false;
   breakTo "ipg";
  };
 };
 };
 _ret
};


seekGround =
{
 scopename "seekGround";
 params ["_pos","_areaSize"];
 private _ret = [];
 private _closestDist = 1000000;
 
for "_d" from 0 to 360 step 22.5 do 
{
 
 _groundFound = false;
 _groundStartPos = [];
 _cdist = 1000000;
 
#define RSTEP 10
 
 for "_s" from 0 to 250 step RSTEP do
 {
 scopename "testsg";
 
 _reachDist = _s * RSTEP;
 
  _vec = [_d,_reachDist] call getVector;
  
  _spos = [_pos,_vec] call addVector;
  
  
  if(!_groundFound) then
  {
   _cdist = _reachDist;
   if(_reachDist >= _closestDist) then
   {
    breakout "testsg";
   };
  };
 
  if([_spos,_areaSize] call isPosGround) then // Ground found
  {
   if(!_groundFound) then
   {
   _groundFound = true;
   _groundStartPos = _spos;
   }
   else
   {
   _dist = _groundStartPos distance2D _spos;
   
   if(_dist >= (_areaSize )) then
   {

	
	_vec = [_d,_dist / 2] call getVector;
	_cenpos = [_groundStartPos,_vec] call addVector;
	

	
   _ret = _cenpos;
   _closestDist = _cdist;
   
   breakout "testsg";
   
   };
   
   };
  }
  else
  {
   _groundFound = false;
  };
 
 };
 
};

if(count _ret > 0) then
{
//[_ret,"closest","ColorYellow"] call createDebugMarker;
};

_ret
};

makeFirstLetterCapital =
{

_strend = _str select [1, count _str];
_firstLetter = _str select [0, 1];

 ((toupper _firstLetter) + _strend)
};

