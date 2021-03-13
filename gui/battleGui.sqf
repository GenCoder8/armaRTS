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

shiftDown = false;

onZeusOpen =
{

waitUntil { !isNull findDisplay 312 };

sleep 0.5;


_display = finddisplay 312;

if(isnil "zeusModded") then
{

//waituntil { _sb = missionnamespace getvariable ["RscDisplayCurator_sidebarShow",[false,false]]; ((_sb # 0) && (_sb # 1)) };


{
with (uinamespace) do
{
_ctrl = _display displayctrl _x;
_pc = ctrlParentControlsGroup _ctrl;
/*
hint format["PC: %1", _pc];
waituntil { ctrlenabled _ctrl && (ctrlfade _pc) <= 0 };
*/

['toggleTree',[_ctrl] + [false],''] call RscDisplayCurator_script;
};

} foreach [IDC_RSCDISPLAYCURATOR_ADDBARTITLE,IDC_RSCDISPLAYCURATOR_MISSIONBARTITLE];



_display displayAddEventHandler ["KeyUp", 
{
params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

//systemchat format["UP %1 %2", _key,_shift];

if(_shift) then
{
 shiftDown = false;
};

false
}];

_display displayAddEventHandler ["KeyDown", 
{
params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

// systemchat format["DOWN 777 %1 %2", _key,_shift];

if(_shift) then
{
 shiftDown = true;
};


false
}];



 // finddisplay 12 displayAddEventHandler ["MouseButtonUp", { true }];

// _display displayaddeventhandler ["mouseholding",{ systemchat format["TEST %1",time]; }];


/*
_display displayAddEventHandler ["MouseZChanged",{

 systemchat "TEST123";
}];*/

 zeusModded = true;
};

// Create button
_ctrl = _display displayctrl IDC_RSCDISPLAYCURATOR_ADDBAR;
_ctrl ctrlShow false;

// Edit button
_ctrl = _display displayctrl IDC_RSCDISPLAYCURATOR_MISSIONBAR;
_ctrl ctrlShow false;


 call interceptZeusKeys;




};


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

systemchat format["_key %1 ",_key];

_handled
}];


} foreach [46]; //[0,12,46,312,313];

};

interceptZeusKeys =
{
//(findDisplay 312) displayRemoveAllEventHandlers "KeyDown";

findDisplay 312 displayAddEventHandler ["KeyDown",
{
params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

private _handled = false;

// systemchat format["DOWN 123 %1 %2", _key,_shift];

if(_key in [DIK_E,DIK_R,DIK_BACKSLASH,DIK_TAB]) then 
{
 _handled = true;
};

if(_key isEqualTo DIK_TAB) then 
{
 _handled = true;

 //systemchat format["test.... %1 %2 %3",_key, time, inputAction "CuratorInterface"];

};


if(inputAction "CuratorInterface" > 0) then
{
 _handled = true;
};

_handled
}];

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

};
