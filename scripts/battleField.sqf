#include "..\main.h"

viclocMarkers = [];


initBattleField =
{
 params ["_apos","_asize"];

_asize = _asize - BATTKE_VICLOC_FROM_EDGE;


_createVicLocMarker =
{
 params ["_mloc","_id"];

if(surfaceIsWater _mloc) exitWith
{
 // Skip water pos
};

_marker = createmarker [format["vicLoc%1",_id], _mloc];
_marker setMarkerShape "ICON";
_marker setMarkerType VICLOC_MARKER_TYPE;
_marker setMarkerColor "ColorWhite";

viclocMarkers pushback _marker;
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
 //private _mrks = allMapMarkers select { (getMarkerType _x) == VICLOC_MARKER_TYPE };
 //_mrks select { !(_x call isUserMarker) }
 viclocMarkers
};

clearBattleField =
{

_vicmarkers = call getVicLocMarkers;
{ deleteMarker _x; } foreach _vicmarkers;

{ deleteMarker _x; } foreach battlelocConArrows;


viclocMarkers = [];
};

getSideFlags =
{
params ["_side"];
private _ret = switch(_side) do
{
case east: { ["flag_CSAT","a3\data_f\flags\flag_csat_co.paa"] };
case west: { ["flag_NATO","a3\data_f\flags\flag_nato_co.paa"] };
default { ["flag_un","a3\data_f\flags\flag_uno_co.paa"] };
};
_ret
};

addMissionEventHandler ["Draw3D",
{

if(curScreen == "battle" || curScreen == "placement") then
{

 {
  _marker = _x # VICLOC_MARKER;
  _pos = _x # VICLOC_POS;
  _pos set [2, 0];
  _sf = (_x # VICLOC_OWNER) call getSideFlags;

 drawIcon3D [_sf # 1, [1,1,1,1], _pos, 1, 1, 0, "", false];

 } foreach victoryLocations;


private _groups = (call getPlayerSide) call getOwnGroups;

{
 private _group = _x;
 private _gcfg = _group getVariable ["cfg",configNull];
 private _icon = _gcfg call getBattlegroupIcon;

 private _unit = vehicle (leader _group);

_apos = aslToatl (aimPos _unit);

_apos set [2, _apos # 2 + 5];


#define IS 1.4
drawIcon3D [_icon # 1, [1,1,1,1], _apos, IS, IS, 0, "", false];

} foreach _groups;



};

}];