

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
_txt ctrlSetText "";
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

onForceSelect =
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

if(_overForce call isFriendlyForce) then
{

selectedForce = _overForce;
hint "Force selected!";

selectedForce call onForceSelect;

}
else
{
 hint "Can't select enemy";
};

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