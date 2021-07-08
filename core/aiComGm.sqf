
createGmPathfindingData =
{

pfNodes = [];
pfMapMarkerIds = createHashmap;


{

pfNodes pushback [_forEachIndex, markerpos _x ];
pfMapMarkerIds set [_x, _forEachIndex];

} foreach gmBattleLocations;

pfConnections = [];

{
 _marker = _x;
 _curId = _marker call pfGetMarkerNodeId;
 _connections = _y;

{
_omarker = _x;
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

};

// call createGmPathfindingData; ["marker_9","marker_17"] call findPath