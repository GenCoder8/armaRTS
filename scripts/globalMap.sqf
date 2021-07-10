#include "..\main.h"


getBattleLocations =
{
_battleLocations = allMapMarkers select { markerColor _x == BATTLE_LOC_COLOR };

private _locs = _battleLocations select { !(_x call isUserMarker) };


 _locs apply { [_x, _x find "vic" >= 0 , resistance ] }
};


// Save the battle map markers to list 
gmBattleLocations = call getBattleLocations;

 _blocs = gmBattleLocations;

 // Setup correct colors etc
 {
  _mrk = _x # BATTLELOC_MARKER;
  _mrk setMarkerAlpha BATTLE_LOC_ALPHA;
  _mrk setMarkerShape "ELLIPSE";
  _mrk setMarkerSize [BATTLE_AREA_SIZE,BATTLE_AREA_SIZE];

 } foreach _blocs;


battlelocConArrows = [];

initGlobalMap =
{

_battleLocations = gmBattleLocations;

systemchat format ["found %1 locations", count _battleLocations];

battlelocConnections = createHashMap;

_blMarkers = _battleLocations apply { _x # BATTLELOC_MARKER };

{
 _mrkName = _x # BATTLELOC_MARKER;
 _bl = getmarkerpos _mrkName;
 _other = _blMarkers - [_mrkName];

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

// systemchat format ["Connections: %1", count _connections];

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
battlelocConArrows pushback _mrk;

} foreach [_dir,_dir-180];

} foreach _connections;


} foreach _battleLocations;





solImgs = [
"uns_men_c\portrait\usarmy\port_soldier8.paa",
"uns_men_c\portrait\usarmy\port_soldier11.paa",
"uns_men_c\portrait\usarmy\port_army_1.paa",
"uns_men_c\portrait\usarmy\port_officer3.paa",
"uns_men_c\portrait\usarmy\port_officer5.paa",
"uns_men_c\portrait\usarmy\port_rto1.paa",
"uns_men_c\portrait\usarmy\port_soldier1.paa",
"uns_men_c\portrait\usarmy\port_soldier3.paa",
"uns_men_c\portrait\usarmy\port_soldier10.paa",
"uns_men_c\portrait\usarmy\port_soldier9.paa",
"uns_men_c\portrait\usarmy\port_soldier6.paa",
"uns_men_c\portrait\usarmy\port_rto2.paa"
];

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
