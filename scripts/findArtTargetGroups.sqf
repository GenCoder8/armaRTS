//#include "..\main.h"

// artillery targets finder script
// author GC

private ["_center","_radius","_friendlySide","_areas","_curArea","_acenter","_oldCenter","_dist","_newCenter","_nummen","_allchecked","_areaSize","_smallest","_num","_i","_a","_delIndex","_retAreas"];

#define TARGET_AREA_SIZE 75   // ideal target area size
#define FRIENDLY_RANGE 250    // how close friendlies are too close
#define MIN_TARGETS 1         // minimum targets for valid target area
#define DEBUG_TARGETS testmode

_center = +(_this select 0);
_radius = _this select 1;
_friendlySide = _this select 2;

if(count _center == 3) then
{
_center resize 2;
};

_areas = [];
_curArea = [];
_acenter = [0,0];
_areaSize = 0;

{ _x setVariable ["markedForArty",false,false]; } foreach allgroups;

_allchecked = false;
while {!_allchecked} do
{

private _units = [_friendlySide,_center, _radius] call getKnownGroups;
private _enemies = _units select { side _x != _friendlySide && _x call isValidGroup && !(_x call isAirGroup) && !(_x call isGroupOnWater) };
private _friendlies = allgroups select { side _x == _friendlySide && _x call isValidGroup && !(_x call isAirGroup) };


{
private _group = _x;
private _man = leader _group;
private _mpos = [(getpos _man) select 0,(getpos _man) select 1];
private _mdist = _center distance2D _mpos;
private _g = group _man;

if(side _group != _friendlySide && !(_group getVariable "markedForArty") && (_mdist <= _radius)) then
{
_oldCenter = _acenter;

if(count _curArea == 0) then
{
_curArea pushback _group;
_acenter = _mpos;
_group setVariable ["markedForArty",true,false];
_areaSize = 10;
}
else
{

_dist = _mpos distance2D _acenter;
// let this man increase the target area size if not too big size already
// and add the man to the list
if(_dist < TARGET_AREA_SIZE) then
{
if(_dist > _areaSize) then { _areaSize = _dist + 10; }; // area size check with small padding

_curArea pushback _group;
_group setVariable ["markedForArty",true,false];

_nummen = count _curArea;

_newCenter = [0,0];

{

_gpos = _x call getGroupPos;

if(isnil "_gpos") then { ["find arty targets: group pos nil (valid: %1)", _x call isValidGroup] call errmsg; }; // make sure

_newCenter = [[_gpos select 0,_gpos select 1] ,_newCenter] call BIS_fnc_vectorAdd;

} foreach _curArea;

_newCenter set[0, (_newCenter select 0) / _nummen ];
_newCenter set[1, (_newCenter select 1) / _nummen ];
_acenter = _newCenter;

};

};

// look up for friendlies nearby //
{
_eman = leader _x;
_empos = [(getpos _eman) select 0,(getpos _eman) select 1];
if(side _eman == _friendlySide) then
{
if((_empos distance2D _acenter) < (_areaSize + FRIENDLY_RANGE)) then
{
//player sidechat "one too close";
if(count _curArea > 0) then // remove added man
{
_lastIdx = count _curArea - 1;
(_curArea select _lastIdx) setVariable ["markedForArty",false,false]; 
_curArea resize _lastIdx;
_acenter = _oldCenter;
};
};
};
} foreach _friendlies;
////

};

} foreach _enemies;


if(count _curArea > 0) then
{
if(count _curArea >= MIN_TARGETS) then // enough targets for valid arty area?
{


_areas pushback [_acenter, _areaSize, count _curArea];

if(DEBUG_TARGETS) then
{
/*
diag_log format["-=Arty targets %1=-", count _curArea];
{
diag_log format["artyTarget: %1",_x];
} foreach _curArea;
*/
{
_marker = createMarker [format["TestTarget22_%1",_x],getpos (leader _x)];
_marker setMarkerShape "ICON";
_marker setMarkerType "hd_dot";
_marker setMarkerColor "ColorRed";
} foreach _curArea;
};

}
else // not enough targets
{

{
//_x setVariable ["markedForArty",false,false]; 
} foreach _curArea;

};

// reset
_curArea = [];
_areaSize = 0;

}
else
{
_allchecked = true;
};
};

_retAreas = [];


// sort from highest target count to smallest 
while {count _areas > 0} do
{
_smallest = 10000000;

_delIndex = -1;
for "_i" from 0 to (count _areas - 1) do
{
_a = _areas select _i;
_num = _a select 2;
if(_num <= _smallest) then
{
_smallest = _num;
_delIndex = _i;
};
};

if(_delIndex >= 0) then
{
_retAreas = [(_areas select _delIndex)] + _retAreas;
_areas deleteAt _delIndex;
};

};

//diag_log format[">> TEST >> %1 %2",_areas,_retAreas];

_retAreas

