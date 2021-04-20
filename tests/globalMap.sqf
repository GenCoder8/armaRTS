RTSmainPath = "armaRTS.Altis\";



folderPrefix = "";
compileFile =
{
 params ["_path"];
 _path = folderPrefix + _path;
 private _code = compile preprocessFileLineNumbers _path;
 _code
};

_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };


/*
for "_i" from 0 to 1000 do
{

_v1 = [getdir player + 90, -100 + random 200 ] call getvector;
_v2 = [getdir player, -50 + random 100 ] call getvector;
_vf = [_v1,_v2] call addvector;
_vf = [getpos player,_vf] call addvector;

_mrk = createmarker [format["%1",random 1000], _vf];
_mrk setMarkerShape "icon";
_mrk setMarkerType "mil_dot";
_mrk setMarkerColor "ColorRed";

};
*/

sleep 0.1;

_battleLocations = allMapMarkers select { markerColor _x == "ColorOrange" }; // TODO

systemchat format ["found %1 locations", count _battleLocations];

{
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







_display = controlNull;

waituntil { _display = findDisplay 12; !isnull _display };

/*
_bt = _display ctrlCreate ["Rscbutton", -1, controlNull];
//_bt ctrlSetText format["unit.jpg"];
_bt ctrlSetText format["click"];
_bt ctrlsetTooltip "teeeeest";
_bt ctrlSetPosition [0.3, 0.3, 0.1, 0.1];
_bt ctrlCommit 0;

_bt buttonSetAction "hint 'test!'; ";

hint format["action! %1", _bt ];
*/

pos = getpos player;

pos set [1, (pos # 1) + 100];

#define FORCE_ICON_SIZE 128

#define FORCE_ICON 0
#define FORCE_POSMARKER  1

#define TEST_ICON_SIZE 10

findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", {
	_this select 0 drawIcon [
		getMissionPath "unit.jpg", // Custom images can also be used: getMissionPath "\myFolder\myIcon.paa"
		[1,1,1,1],
		pos,
		TEST_ICON_SIZE / ( (1 call scaleToMap)),
		TEST_ICON_SIZE / ( (1 call scaleToMap)),
		45,
		"Player Vehicle",
		1,
		0.03,
		"TahomaB",
		"right"
	];

{
	_this select 0 drawIcon [
		_y # FORCE_ICON,
		[1,1,1,1],
		markerpos (_y # FORCE_POSMARKER),
		(1 - (1 call scaleToMap)) * FORCE_ICON_SIZE,
		(1 - (1 call scaleToMap)) * FORCE_ICON_SIZE,
		0,
		"",
		1,
		0.03,
		"TahomaB",
		"right"
	];
} foreach allforces;

}];


allforces = createHashMap;

createNewForce =
{
params ["_name","_icon","_posmrk"];

allforces set [_name, [_icon,_posmrk ] ];
};

moveForceToBattlefield =
{
 params ["_forceName","_destMarker"];
 private _force = allforces get _forceName;

 _force set [FORCE_POSMARKER, _destMarker ];
};

["testers", "uns_M113parts\army\11acr_co.paa", "marker_17"  ] call createNewForce;

["testers2", "uns_M113parts\army\1acav_co.paa", "marker_18"  ] call createNewForce;


_defaultMainMapCtrl = (findDisplay 12 displayCtrl 51);
_defaultMainMapCtrl ctrlAddEventHandler ["MouseMoving","_this call mouseMoveUpdate; "];
_defaultMainMapCtrl ctrlAddEventHandler ["MouseButtonUp","_this call mouseButtonUp; "];

 

mouseMoveUpdate =
{
params ["_control", "_xPos", "_yPos", "_mouseOver"];

private _pos = _control ctrlMapScreenToWorld [_xPos,_yPos];

// ( (FORCE_ICON_SIZE/2) * (1 - (1 call scaleToMap))  )

if(_pos distance2D pos < (TEST_ICON_SIZE * 250 * ( (1 call scaleToMap))) ) then
{
 hint "Over!";
}
else
{
 hint "away";

if(([_pos] call isMouseOverForce) != "") then
{
 hintSilent "Over force";
};

};
 
};

mouseButtonUp =
{
params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

private _pos = _control ctrlMapScreenToWorld [_xPos,_yPos];


if(_button == 0) then
{

if(selectedForce == "") then
{
_overForce = ([_pos] call isMouseOverForce);
if(_overForce != "") then
{
selectedForce = _overForce;
hint "Force selected!";
};
}
else
{

_bf = [_pos] call isMouseOverBattlefield;
if(_bf != "") then
{
[selectedForce,_bf] call moveForceToBattlefield;
selectedForce = "";
hint "Moved to battlefield";
};

};

};

if(_button == 1) then
{
 selectedForce = "";
 hint "Deselect";
};

};

selectedForce = "";

isMouseOverForce =
{
 params ["_pos"];
 private _ret = "";

{

if(_pos distance2D (markerpos (_y # FORCE_POSMARKER)) < ((FORCE_ICON_SIZE * 2 * 10) * ( (1 call scaleToMap))) ) then
{
 _ret = _x;
};

} foreach allforces;

 _ret
};

isMouseOverBattlefield =
{
 params ["_pos"];
 private _ret = "";

_locs = call getBattleLocations;

{

if(_pos distance2D (getMarkerPos _x) < ((2000) * ( (1 call scaleToMap))) ) exitWith
{
 _ret = _x;
};

} foreach _locs;

_ret
};

scaleToMap =
{
params ["_dist"];

 //_map = (uiNamespace getVariable "_map");
private _scale = 1;//ctrlMapScale _map;
 
private _defaultMainMapCtrl = (findDisplay 12) displayCtrl 51;
_scale = ctrlMapScale _defaultMainMapCtrl;

systemchat format["scale is %1", _scale];
 
private _r = (_dist * _scale);
 
 _r
};


