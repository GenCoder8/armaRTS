#include "..\main.h"

initGlobalMap =
{
 _blocs = gmBattleLocations;
 {
  _x setMarkerAlpha BATTLE_LOC_ALPHA;
  _x setMarkerShape "ELLIPSE";
 } foreach _blocs;


_battleLocations = gmBattleLocations;

systemchat format ["found %1 locations", count _battleLocations];

battlelocConnections = createHashMap;

{
 _mrkName = _x;
 _bl = getmarkerpos _x;
 _other = _battleLocations - [_x];

_other = _other apply { [_bl distance2D (getmarkerpos _x), _x] };
_other sort true;
 
 _connections = [];
 {
  _otherX = _x # 1;
  _otherBL = getmarkerpos _otherX;

  _dist = _bl distance2D _otherBL;
  
if(_dist < 5000) then
{
_connections pushback _otherX;
};
  
  if(count _connections >= 4) exitWith {};
  
 } foreach _other;

battlelocConnections set [_mrkName,_connections];

systemchat format ["Connections: %1", count _connections];

{
 _otherBL = getmarkerpos _x;
 _center = [_bl,_otherBL] call addvector;
 _center set [0, (_center # 0) / 2 ]; 
 _center set [1, (_center # 1) / 2 ];

 _dir = [_otherBL,_bl] call getAngle;

 _dist = (_bl distance2D _otherBL); // Get dist again


#define MIN_CON_ARROW_DIST 1700

{

_maxdist = 300;
if(_dist < MIN_CON_ARROW_DIST) then
{
 _maxdist = _maxdist - (MIN_CON_ARROW_DIST - _dist);
};

_vec = [_x,_maxdist] call getvector;
_apos = [_vec,_center] call addvector;

_mrk = createmarker [format["conCen_%1_%2",_apos,_dir], _apos];
_mrk setMarkerShape "icon";
_mrk setMarkerType "mil_arrow2";
_mrk setMarkerColor "ColorBlue";
_mrk setMarkerDir _x;
} foreach [_dir,_dir-180];

} foreach _connections;


} foreach _battleLocations;


with uinamespace do
{
gmControls = [];
};

};

closeGlobalMap =
{

with uinamespace do
{
 { ctrlDelete _x; } foreach gmControls;
 gmControls = [];
};

};

getBattleLocations =
{
_battleLocations = allMapMarkers select { markerColor _x == BATTLE_LOC_COLOR };

_battleLocations select { !(_x call isUserMarker) }
};

scaleToMap =
{
params ["_dist"];

 //_map = (uiNamespace getVariable "_map");
private _scale = 1;//ctrlMapScale _map;
 
private _defaultMainMapCtrl = (findDisplay 12) displayCtrl 51;
_scale = ctrlMapScale _defaultMainMapCtrl;

// systemchat format["scale is %1", _scale];
 
private _r = (_dist * _scale);
 
 _r
};
