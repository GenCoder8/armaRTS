
// _nearLocs = nearestLocations [[worldsize/2,worldsize/2], ["Airport","NameCityCapital","nameCity","NameVillage","NameLocal"], 2000];

#define VICLOC_MARKER_TYPE "mil_flag"

victoryLocations = [];

startPosWest = -1;
startPosEast = -1;

#define VICLOC_ID       0
#define VICLOC_POS      1
#define VICLOC_NAME     2
#define VICLOC_OWNER    3
#define VICLOC_MARKER   4

#define VICINITY_DIST 75

aiNumAttackLocations = 2;

// Start the com

setupBattleLocation =
{

_vicmarkers = allMapMarkers select { (getMarkerType _x) == VICLOC_MARKER_TYPE };

{
_marker = _x;
_lIndex = _foreachindex;
_lpos = getmarkerPos _marker;

// _marker = createMarker [format["VL_%1",_lpos],_lpos];
_marker setMarkerShape "ICON";
_marker setMarkerType "flag_un";
_marker setMarkerColor "ColorWhite";

_lside = civilian;

/*
if(startPosWest < 0) then
{
 _lside = west;
 startPosWest = _lIndex;
}
else
{
if(startPosEast < 0) then
{
 _lside = east;
 startPosEast = _lIndex;
};
};*/

[_marker,_lside] call updateVictoryLocMarker;

_vlId = count victoryLocations;

victoryLocations pushback [_vlId,_lpos,markerText _marker,_lside,_marker];

} foreach _vicmarkers;


// Capture vic loc logic 


[] spawn
{

while { true } do
{


_side = west;
_ownGroups = _side call getOwnGroups;

hint format["num own groups: %1", count _ownGroups ];

{
scopename "handlePlace";
_place = _x;

if(_x # VICLOC_OWNER != _side) then
{

{
_group = _x;
_near = [(_group call getGroupPos)] call getNearVictoryLoc;

if(count _near > 0) then
{
// Capture
if([_near,_place] call isSameLoc) then
{
systemchat format["PLACE CAPTURED '%1'", _place # VICLOC_NAME];

_place set[VICLOC_OWNER, _side];

[_place # VICLOC_MARKER,_side] call updateVictoryLocMarker;


breakTo "handlePlace";
};
};

} foreach _ownGroups;


};



} foreach victoryLocations;

 sleep 2;
};

};


};

updateVictoryLocMarker =
{
 params ["_marker","_side"];

 _mtype = switch(_side) do
 {
  case east: { "flag_CSAT" };
  case west: { "flag_NATO" };
  default { "flag_un" };
 };
 _marker setMarkerType _mtype;
};

getGroupTargetLoc =
{
params ["_group"];
private _wps = waypoints _group;
if(count _wps == 0) exitwith { getpos leader _group; };

waypointPosition (_wps select (count _wps - 1))
};

moveGroup =
{
params ["_group","_pos"];
_group call deleteWaypoints;

diag_log format ["--> (%1) (%2)", _group, _pos];

_wp =_group addWaypoint [_pos, 0];
};

deleteWaypoints =
{
params ["_group"];

for "_i" from (count (waypoints _group) - 1) to 0 step -1 do
{
deleteWaypoint [_group, _i];
};

};

isVictoryLocPos =
{
 params ["_pos"];
 private _ret = false;

{
 private _place = _x;

if(_pos distance2D (_place # VICLOC_POS) < VICINITY_DIST) exitwith
{
 _ret = true;
};

} foreach victoryLocations;

 _ret
};

getNearVictoryLoc =
{
 params ["_pos",["_maxDist",VICINITY_DIST],["_getSide",[]]];

 private _ret = [];
 private _shortest = 1000000;

 {
  private _place = _x;
  private _dist = _pos distance2D (_place # VICLOC_POS);

if( _dist < _maxDist && _dist < _shortest && (count _getSide == 0 || (_place # VICLOC_OWNER) in _getSide)) then 
{
 _ret = _place;
 _shortest = _dist;
};

 } foreach victoryLocations;

_ret
};

getGroupPos = 
{
 params ["_group"];
 (getpos leader _group)
};


getOwnGroups =
{
 params ["_side"];
 private _ownGroups = allgroups select { side _x == _side && !(player in (units _x)) };
 _ownGroups
};

isSameLoc =
{
 (_this#0#VICLOC_POS) distance2D (_this#1#VICLOC_POS) < VICINITY_DIST
};



startAiCom =
{

[] spawn
{

while { true } do
{

_side = west;
_enemySide = east;

_ownGroups = _side call getOwnGroups;
{ _x setVariable ["isFree",false]; } foreach _ownGroups;

_freeGroups = [];

_getFreeGroups = 
{
_freeGroups = _ownGroups select { (_x getVariable ["isFree",false]) || !([(_x call getGroupTargetLoc)] call isVictoryLocPos) };
};

call _getFreeGroups;

_ownPlaces = victoryLocations select { _x # VICLOC_OWNER == _side };
_enemyPlaces = victoryLocations select { _x # VICLOC_OWNER != _side };

systemchat format ["NUM GROUPS total: %1 free: %2", count _ownGroups, count _freeGroups];

// Defending //

{
_place = _x;

call _getFreeGroups;

_defenders = _ownGroups select { ((_x call getGroupTargetLoc) distance2D (_place # VICLOC_POS)) < VICINITY_DIST };

// systemchat format ["_defenders %1", count _defenders ];

if(count _defenders == 0) then
{
if(count _freeGroups > 0 ) then
{
 _group = selectRandom _freeGroups;
 [_group,(_place # VICLOC_POS)] call moveGroup;

 systemchat format ["ASSIGN ONE TO DEFEND %1",_group];

};
}
else
{

if(count _defenders > 1) then
{
systemchat format ["EXES DEFENDERS"];

// Free the extra defenders
for "_i" from 1 to (count _defenders - 1) do
{

 _group = _defenders # _i; // Todo random groups
 _group setVariable ["isFree",true];

 systemchat format ["FREEING ONE DEFENDER %1",_group];
};
};

};



} foreach _ownPlaces;

// Attacking //

_stuck = 20;

while { _stuck > 0 } do
{
_stuck = _stuck - 1;

call _getFreeGroups;

if(count _freeGroups == 0) then { break; };

_attackLocs = [];

_validAttSides = [_enemySide,civilian];

_useGroups = _freeGroups; // [0, ceil((count _freeGroups) / 2)];

diag_log format["_freeGroups %1", _freeGroups];

diag_log format ["--- Looping attackers --- %1 - %2 -- %3", count _freeGroups, count _useGroups, _useGroups ];

if(count _useGroups > 0) then
{

{
 _group = _x;

 _near = [(_group call getGroupTargetLoc),VICINITY_DIST,_validAttSides] call getNearVictoryLoc;

diag_log format["near: %1 -- %2 ", _group, count _near];

if(count _near > 0) then // Own group attacking here?
{

//if(_near # VICLOC_OWNER != _side) then
//{
 private _arr = [_attackLocs, _near # VICLOC_ID, 0] call findFromArray;
 
 if(count _arr > 0) then
 {
  _arr params ["_entry","_eIndex"];
  _entry set [2 , (_entry # 2) + 1 ];

  diag_log format[">>>>> Adding to att loc %1 -- %2", _near # VICLOC_ID, (_entry # 2)];
 }
 else
 {
 _attackLocs pushback [_near # VICLOC_ID,_near,1];

  diag_log format[">>>>> New att loc %1", _near # VICLOC_ID];
  diag_log format["%1", _attackLocs];
 };

//};

};

} foreach _ownGroups;


_attackNowLoc = [];


// Reduce att locs if few enemy places (Allow many att places at start but few in end game
_numPlacesToAttack = (count _enemyPlaces) - 1;
if(aiNumAttackLocations > _numPlacesToAttack) then
{
 aiNumAttackLocations = _numPlacesToAttack;
 if(aiNumAttackLocations < 1) then
 {
  aiNumAttackLocations = 1;
 };
 diag_log format["AI NOW ATTACKING %1 LOCATIONS", aiNumAttackLocations ];
};


// Already attacking somewhere?
if(count _attackLocs >= aiNumAttackLocations) then
{
 _attackNowLoc = selectRandom _attackLocs # 1; // Get one place
 diag_log format["Attacking 1: %1", _attackNowLoc];
}
else
{

// New attack loc, near the center of free friendly forces


_center = [0,0];
{
 _gp = _x call getGroupPos;
 _center set[0,_center#0 + _gp#0];
 _center set[1,_center#1 + _gp#1];

} foreach _useGroups;

_center set[0, _center#0 / (count _useGroups) ];
_center set[1, _center#1 / (count _useGroups) ];


_attackNowLoc = [_center,5000,_validAttSides] call getNearVictoryLoc; // Todo dist

diag_log format["Attacking 2: %1", _attackNowLoc];

diag_log format["attack center: %1 %2 %3",_center,_validAttSides,_attackNowLoc];

// systemchat format["_center %1 %2",_center,_attackNowLoc];

};



// systemchat format["ATTACKING AT %1 (%2)" ];


if(count _attackNowLoc > 0) then
{
{
_group = _x;

 diag_log format["SENDING ONE TO ATTACK %1 %2 -- %3 %4", _group, side _group, _attackNowLoc # VICLOC_ID, _attackNowLoc];

 [_group,_attackNowLoc # VICLOC_POS] call moveGroup;
} foreach _useGroups;
};

};
};

if(_stuck <= 0) then
{
 diag_log "AI ATTACKING STUCK";
};

 sleep 5;
};

};

};



