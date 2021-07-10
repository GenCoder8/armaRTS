
#include "..\main.h"


createGmPathfindingData =
{

pfNodes = [];
pfMapMarkerIds = createHashmap;


{
private _mrk = _x # BATTLELOC_MARKER;

pfNodes pushback [_forEachIndex, markerpos _mrk ];
pfMapMarkerIds set [_mrk, _forEachIndex];

} foreach gmBattleLocations;

pfConnections = [];

{
 _marker = _x;
 _curId = _marker call pfGetMarkerNodeId;
 _connections = _y;

if(_marker == "marker_17") then { continue; };

{
_omarker = _x;

if(_omarker == "marker_17") then { continue; };

_oId = _omarker call pfGetMarkerNodeId;

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

systemchat format ["Solution: %1", _solution ];

_solution
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






// call createGmPathfindingData; ["marker_9","marker_31"] call findPath