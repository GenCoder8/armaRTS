#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"
#include "\a3\ui_f\hpp\definedikcodes.inc"

// Todo disable:
// _logic addeventhandler ["curatorObjectDoubleClicked",{(_this select 1) call bis_fnc_showCuratorAttributes;}];
// etc

/*
this addEventHandler ["CuratorGroupSelectionChanged", {
	params ["_curator", "_group"];
}];

*/


[] spawn
{

waitUntil { !isNull findDisplay 46 };


{
(findDisplay _x) displayRemoveAllEventHandlers "KeyDown";
} foreach [46];


{

findDisplay _x displayAddEventHandler ["KeyDown",
{
params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

private _handled = false;

// Can only open here, 312 takes close Y press
if(inputAction "CuratorInterface" > 0) then
{
// Allow open but not close
if(isnull (findDisplay 312)) then 
{
 systemchat format["zeus open... %1 %2 %3",_key, time, inputAction "CuratorInterface"];

 [] spawn onZeusOpen;
}
else
{
 // _handled = true; 
};

};

// systemchat format["_key %1 ",_key];

_handled
}];


} foreach [46]; //[0,12,46,312,313];

};


setGroupFacing =
{
 params ["_xPos","_yPos"];

_sel = curatorSelected # 1;
if(count _sel > 0) then
{

{
_group = _x;
_ldr = (leader _group);

if(alive _ldr) then
{



_wpos = [_xPos,_yPos]; // screenToWorld

systemchat format["_wpos %1", _wpos];

_dir = [getpos _ldr, _wpos] call getAngle;


_group setFormDir _dir;

 systemchat format["ROTATE %1", _dir];

dostop _ldr;
(units _group - [_ldr]) doFollow _ldr;


[_group,getpos _ldr] call groupLocationSet;

}
else
{
 systemchat "Ldr not alive";
};

} foreach _sel;

};

};

setGroupFacingNew =
{
 params ["_group","_angle"];

private _ldr = (leader _group);

if(alive _ldr) then
{

_group setFormDir _angle;

 systemchat format["ROTATE %1", _angle];

dostop _ldr;
(units _group - [_ldr]) doFollow _ldr;


[_group,getpos _ldr] call groupLocationSet;

}
else
{
 systemchat "Ldr not alive";
};

};

// curatorToggleCreate
// https://community.bistudio.com/wiki/inputAction/actions

lastViewedGroup = grpNull;
lastViewUpdate = 0;

ranksShort = ["Pvt","Cpl","Sgt","Lt","Cpt","Maj","Col"];

toRoundsText =
{
 params ["_ammoCount"];
 format["%1",_ammoCount]
};

activateBattleGui =
{
 cutRsc["ComOverlay","PLAIN",0];


 _overlay = uiNamespace getVariable ['ComOverlay', displayNull];

_groupView = _overlay displayCtrl 1500;

_pos = ctrlposition _groupView;
/*
_bg = _overlay ctrlCreate ["RscPicture", 7000];

 _bg ctrlSetText "#(argb,8,8,3)color(0,0.75,0,1)";

#define TITLE_HEIGHT 0.1

_bg ctrlSetPosition [_pos # 0, _pos # 1 - TITLE_HEIGHT, _pos # 2, _pos # 3 + TITLE_HEIGHT];
_bg ctrlCommit 0;
*/

};

