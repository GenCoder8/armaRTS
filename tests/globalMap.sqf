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

call initGlobalMap;

_battleLocations = call getBattleLocations;

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

 call renderForces;

}];


[west,"testers", "uns_M113parts\army\11acr_co.paa", "marker_17"  ] call createNewForce;

[east,"testers2", "uns_M113parts\army\1acav_co.paa", "marker_18"  ] call createNewForce;


_defaultMainMapCtrl = (findDisplay 12 displayCtrl 51);
_defaultMainMapCtrl ctrlAddEventHandler ["MouseMoving"," _this call mouseMoveUpdate; "];
_defaultMainMapCtrl ctrlAddEventHandler ["MouseButtonUp"," _this call mouseButtonUp; "];



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



_ctrlg = _display ctrlCreate ["RscControlsGroup", -1, controlNull];
_ctrlg ctrlSetPosition ([36,23,15,15,false] call getGuiPos);
_ctrlg ctrlCommit 0;
_ctrlg ctrlShow false;

uiNamespace setVariable ["forceCtrlGroup", _ctrlg];


_img = _display ctrlCreate ["RscPicture", -1, _ctrlg];
_img ctrlSetText "#(argb,8,8,3)color(0,1,0,1)﻿";
_img ctrlSetPosition ([0,5,15,5,false] call getGuiPos);
_img ctrlCommit 0;

_txt = _display ctrlCreate ["RscTextMulti", -1, _ctrlg];
_txt ctrlSetText "teeest"  + endl + "jeee";
_txt ctrlSetPosition ([0,5,15,5,false] call getGuiPos);
_txt ctrlCommit 0;

uiNamespace setVariable ["forceInfoCtrl", _txt];


_img = _display ctrlCreate ["RscPicture", -1, _ctrlg];
_img ctrlSetText "uns_men_c\portrait\usarmy\port_soldier1.paa";
_img ctrlSetPosition ([7,0,5,5,false] call getGuiPos);
_img ctrlCommit 0;

uiNamespace setVariable ["forceImg", _img];

onForceDeselect =
{
 selectedForce = "";
 (uiNamespace getVariable "forceInfoCtrl") ctrlSetText "";

 (uiNamespace getVariable "forceCtrlGroup") ctrlShow false;
};

onForceSelectd =
{

(uiNamespace getVariable "forceImg") ctrlSetText (selectRandom solImgs);

(uiNamespace getVariable "forceInfoCtrl") ctrlSetText (selectedForce call getForceInfo);

  (uiNamespace getVariable "forceCtrlGroup") ctrlShow true;
};

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

if(([_pos] call getForceAtPos) != "") then
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
_overForce = ([_pos] call getForceAtPos);
if(_overForce != "") then
{
selectedForce = _overForce;
hint "Force selected!";

selectedForce call onForceSelectd;


};
}
else
{

_bf = [_pos] call isMouseOverBattlefield;
if(_bf != "") then
{

_forcesHere = _bf call getForcesAtBattleLoc;

if([selectedForce,_forcesHere] call countForceFriendlies == 0) then
{

_curLoc = selectedForce call getForcePosMarker;

_cons = battlelocConnections get _bf;

if(_cons find _curLoc >= 0) then
{

[selectedForce,_bf] call moveForceToBattleloc;

call onForceDeselect;
hint "Moved to battlefield";

}
else
{
 hint "No connection";
};

}
else
{
 hint "loc occupied";
};


};

};

};
/*
if(_button == 1) then
{
 selectedForce = "";
 hint "Deselect";
};*/

};

selectedForce = "";


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


