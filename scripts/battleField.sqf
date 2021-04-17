#include "..\main.h"

initBattleField =
{
 params ["_apos","_asize"];

_asize = _asize - 100;

_createVicLocMarker =
{
 params ["_mloc","_id"];
_marker = createmarker [format["vicLoc%1",_id], _mloc];
_marker setMarkerShape "ICON";
_marker setMarkerType VICLOC_MARKER_TYPE;
_marker setMarkerColor "ColorWhite";
};

for "_i" from 0 to 3 do
{

_vec = [_i * 90, _asize] call getVector;
_mloc = [_apos,_vec] call addvector;

[_mloc,_i] call _createVicLocMarker;

};

[_apos,100] call _createVicLocMarker;

};

getVicLocMarkers =
{
 private _mrks = allMapMarkers select { (getMarkerType _x) == VICLOC_MARKER_TYPE }
 _mrks select { !(_x call isUserMarker) }
};

clearBattleField =
{
 // Todo call this
_vicmarkers = call getVicLocMarkers;
{ deleteMarker _x; } foreach _vicmarkers;
};