
#include "..\main.h"


createGmPathfindingData =
{
params ["_aiForce"];

pfNodes = [];
pfMapMarkerIds = createHashmap;


{
private _mrk = _x # BATTLELOC_MARKER;

pfNodes pushback [_forEachIndex, markerpos _mrk ];
pfMapMarkerIds set [_mrk, _forEachIndex];

} foreach gmBattleLocations;

pfConnections = [];

{
 private _marker = _x;
 private _curId = _marker call pfGetMarkerNodeId;
 private _connections = _y;

 if(!([_aiForce,_marker] call pfCanForceMoveToLoc)) then { continue; };

{
private _omarker = _x;

 if(!([_aiForce,_omarker] call pfCanForceMoveToLoc)) then { continue; };

private _oId = _omarker call pfGetMarkerNodeId;

pfConnections pushback [_curId,_oId];

} foreach _connections;

} foreach battlelocConnections;

systemchat format ["Nodes: %1 Cons: %2", count pfNodes, count pfConnections];

};

pfGetMarkerNodeId =
{
 params ["_marker"];
 private _ret = -1;

 _ret = pfMapMarkerIds getOrDefault [_marker, -1];

 _ret
};

pfGetMarkerById =
{
 params ["_nodeId"];
 private _ret = "";

{
 if(_y == _nodeId) exitWith { _ret  = _x; };
} foreach pfMapMarkerIds;

_ret
};

findPath =
{
 params["_start","_end"];
 _sid = _start call pfGetMarkerNodeId;
 if(_sid < 0) exitWith { ["Invalid pf start '%1'",_start ] call errmsg; };
 _eid = _end call pfGetMarkerNodeId;
 if(_eid < 0) exitWith { ["Invalid pf end '%1'",_end] call errmsg; };

_solution = [_sid,_eid,+pfNodes,+pfConnections] call shortPathDijkstra;


_solution
};

// Used for AI
pfCanForceMoveToLoc =
{
 params ["_force","_locMarker"];

 private _side = _force # FORCE_SIDE;

// ([_side,_locMarker] call countSideForcesAtBattleLoc) == 0

 private _forces = _locMarker call getForcesAtBattleLoc;

 // No friendly forces in tile, then can move
 ({ (_x # FORCE_SIDE) == _side && (_x # FORCE_ID) != (_force # FORCE_ID) } count _forces) == 0
};

getStartLoc =
{
 params ["_side"];

private _startLoc = _side call getStartMarker;

if(count _startLoc == 0) exitWith { ["start loc not set for '%1'",_side] call errmsg; "" };

// Can start only from empty places
private _blocs = gmBattleLocations select { count( _x call getForcesAtBattleLoc) == 0 };

private _nearest = [_blocs,{ markerpos (_x # BATTLELOC_MARKER) }, markerpos _startLoc] call getNearest;

if(count _nearest == 0) exitWith { "Failed to get starting location" call errmsg; "" };

(_nearest # BATTLELOC_MARKER)
};

getStartMarker =
{
 params ["_side"];
private _startLoc = call compile format["startMarker%1",_side];
if(isnil "_startLoc") exitWith { [] };
_startLoc
};

aiTurn =
{
 _bvlocs = gmBattleLocations select { _x # BATTLELOC_ISVICLOC };

{
 private _aiforce = _y;
 private _forceName = _x;
 _side = _aiforce # FORCE_SIDE;
 _curLocMrk = _aiforce # FORCE_POSMARKER;
 if(_side == (call getplayerSide)) then { continue; };
 
 // Can't move if in engagement
 if(_curLocMrk call isEngagementInLoc) then { continue; };

 _capLocs = _bvlocs select { _x # BATTLELOC_OWNER != _side };

if(count _capLocs > 0) then // If none uncaptured vic locs are found then the game is won
{
// Try enemy locs first then owned
for "_i" from 0 to 1 do
{

private _nearLoc = [_capLocs, { markerpos (_x # BATTLELOC_MARKER) }, markerpos _curLocMrk ] call getNearest;

 _clMarker = _nearLoc # BATTLELOC_MARKER;

 [_aiforce] call createGmPathfindingData;

 _start = _aiforce # FORCE_POSMARKER;
 _path = [_start,_clMarker] call findPath;

//diag_log format ["Solution: %1 => %2", _forceName, _path ];


 if(count _path > 1) then // Should be two, first is current pos
 {
  _nodeMarker = (_path # 1) call pfGetMarkerById;
   [_aiforce,_nodeMarker] call moveForceToBattleloc;

//diag_log format ["FromTo: %1 == %2 => %3", _forceName, _curLocMrk, _nodeMarker ];

   break; // Found move point
 }
 else
 {
// Go defend somewhere if cant reach 
 _capLocs = _bvlocs select { _x # BATTLELOC_OWNER == _side };
 if(count _capLocs == 0) then { break; };
 };

};

};

} foreach allforces;

};

testGmAICap =
{
 //_forces = [allforces, { _x # FORCE_SIDE == east } ] call hashmapSelect;



sleep 1.5;

while { true } do
{


 call aiTurn;


 sleep 2;
};

 // systemchat format["Running PF for %1", _tf];


};





testGmAI =
{
 _forces = [allforces, { _x # FORCE_SIDE == east } ] call hashmapSelect;

 _tf = _forces # 0;

 // systemchat format["Running PF for %1", _tf];

 call createGmPathfindingData; 


 _start = _tf # FORCE_POSMARKER;
 
 _path = [_start,"marker_31"] call findPath;

 {
  _nodeMarker = _x call pfGetMarkerById;

  _tf set [FORCE_POSMARKER, _nodeMarker ];

  sleep 1.5;
 } foreach _path;
 
 systemchat "DONE PATHING";
};

// Used by player forces too
getForceFleeLocation =
{
params ["_force"];

private _startMarker = [_force # FORCE_SIDE] call getStartMarker;

private _curLoc = _force # FORCE_POSMARKER;

private _connections = battlelocConnections get _curLoc;

private _freeLocs = _connections select { [_force,_x] call pfCanForceMoveToLoc };

if(count _freeLocs == 0) exitWith { "" };

private _nearest = [_freeLocs, {markerpos _x}, markerpos _startMarker ] call getNearest;

_nearest
};

// call createGmPathfindingData; ["marker_9","marker_31"] call findPath