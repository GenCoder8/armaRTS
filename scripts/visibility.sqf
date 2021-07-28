
#define KNOWS_ABOUT_REVEAL_VAL 1
#define KNOWS_ABOUT_UNREVEAL_VAL (4 - 0.01)
#define MAX_DIST_TO_ENEMY_REVEAL 250


getEnemySides =
{
 private _ret = switch(_this) do
 {
  case east: { [west,resistance] };
  case west: { [east,resistance] };
  case resistance: { [west,east] };
  case default { [] };
 };
 _ret
};

setUnitVisibility =
{
 params ["_man","_isVis"];
 _man setVariable ["isHidden",!_isVis];
 _man hideObjectGlobal  (!_isVis); 

 // Always reset
 _man setvariable ["isFiring", false];

 private _veh = vehicle _man;
 if(_veh != _man) then
 {
  if((_veh call isObjVisible) != _isVis) then
  {
   deleteVehicle (_man getvariable ["posDebug",objnull]); // Debug

   [_veh,_isVis] call setUnitVisibility;
  };
 };

};

isObjVisible =
{
 params ["_man"];
 !(_man getVariable ["isHidden",false])
};

initObjectVisibility =
{
 params ["_man"];
 [_man,false] call setUnitVisibility;


_man addEventHandler ["FiredMan", 
{
 params ["_man", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

 _man setvariable ["isFiring", true];

}];
};

/*
{
if(side _x != civilian ) then
{

 _x call initObjectVisibility;

};
} foreach allunits;
*/

lastLosTime = time;

#define LOS_STEP_REVEAL   0
#define LOS_STEP_UNREVEAL 1

curLosStep = LOS_STEP_REVEAL;

curLosSide = east;


addMissionEventHandler ["EachFrame",
{

if((time - lastLosTime) < 0.1) exitwith {};


switch(curLosStep) do
{
case LOS_STEP_REVEAL:
{

{
 private _friendlySide = _x;
 private _enemySides = _friendlySide call getEnemySides;

 private _enemies = allunits select { ( !(_x call isObjVisible) ) && (side _x) in _enemySides };
 
 private _friendlies = units _friendlySide;

// Loop enemies and make them visible
{
 private _enemy = _x;
 private _makeVisible = false;

// Debug arrow //
if(DBGL_VISI call isDebugLevel) then
{
_apos = getposATL _enemy;
_apos set [2,2.7];

_arrow = _enemy getvariable ["posDebug",objnull];
if(isnull _arrow) then
{
_arrow = createSimpleObject ["Sign_Arrow_Large_F", _apos,false];
_enemy setvariable ["posDebug",_arrow];
_enemy spawn // Clear dbg arrow
{ 
params ["_enemy"];
waituntil { sleep 1; (_enemy call isObjVisible) };
deleteVehicle (_enemy getvariable ["posDebug",objnull]);
};
};

_arrow setposATL _apos;
};
////

if((_friendlySide knowsAbout _enemy) >= KNOWS_ABOUT_UNREVEAL_VAL || (_enemy getvariable ["isFiring", false])) then
{
 _makeVisible = true;
}
else
{

{
 // scopename "checkManVis";
 private _man = _x;
 if(_enemy distance2D _man < MAX_DIST_TO_ENEMY_REVEAL) then
 {
 private _epos = (getposASL _enemy);
 _epos set [2, _epos # 2 + 0.8 ];
 if(([_man, "VIEW"] checkVisibility [eyePos _man, _epos]) > 0) then
 {
  _makeVisible = true;
 //systemchat format["LOS check %1 ", _enemy];
  break;
 };
 };
} foreach _friendlies;

};

if(_makeVisible) then
{
// player globalchat format["making visible %1",_enemy];
 [_enemy,true] call setUnitVisibility;
};

} foreach _enemies;

} foreach [curLosSide];

if(curLosSide == east) then // only east and west
{
 curLosSide = west;
}
else
{
curLosSide = east; // Reset
curLosStep = LOS_STEP_UNREVEAL;
};

};

case LOS_STEP_UNREVEAL:
{

{
_man = _x;
if( (side _man) in [east,west,resistance] && (_man call isObjVisible) ) then
{

 _eneSides = (side _man) call getEnemySides;

 _numKnowns = { 
//systemchat format[">> %1 %2", _x, (_x knowsAbout _man)]; 
(_x knowsAbout _man) > KNOWS_ABOUT_UNREVEAL_VAL 
} count _eneSides;

 private _nearEnemy = _man findNearestEnemy _man;

// systemchat format[">> %1 %2 %3 %4 ", side _man, _nearEnemy,  (west knowsAbout _man), _numKnowns];

_nearEnemies = (nearestObjects [_man, ["man"], MAX_DIST_TO_ENEMY_REVEAL]) select { side _x in _eneSides }; 

 //systemchat format[">> %1 %2 %3  ", side _man, _numKnowns, count _nearEnemies];


if(_numKnowns == 0 && count _nearEnemies == 0) then
{
 [_man,false] call setUnitVisibility;
}
else
{


};
};

} foreach (units curLosSide);


if(curLosSide == east) then // only east and west
{
 curLosSide = west;
}
else
{
curLosSide = east; // Reset
curLosStep = LOS_STEP_REVEAL; // Restart the loop
};




};

};

lastLosTime = time;
}];
