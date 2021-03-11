#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"
#include "\a3\ui_f\hpp\definedikcodes.inc"



/*
this addEventHandler ["CuratorGroupSelectionChanged", {
	params ["_curator", "_group"];
}];

*/

onZeusOpen =
{

waitUntil { !isNull findDisplay 312 };
sleep 0.1;


_display = finddisplay 312;

if(isnil "zeusModded") then
{

{
with (uinamespace) do
{
_ctrl = _display displayctrl _x;
['toggleTree',[_ctrl] + [false],''] call RscDisplayCurator_script;
};

} foreach [IDC_RSCDISPLAYCURATOR_ADDBARTITLE,IDC_RSCDISPLAYCURATOR_MISSIONBARTITLE];

 // finddisplay 12 displayAddEventHandler ["MouseButtonUp", { true }];

_display displayAddEventHandler ["MouseButtonDown",
{
 params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

_handled = true;

if(_shift) then
{


_sel = curatorSelected # 1;
if(count _sel > 0) then
{

{
_group = _x;
_ldr = (leader _group);

if(alive _ldr) then
{

_wpos = screenToWorld [_xPos,_yPos];

_dir = [getpos _ldr, _wpos] call getAngle;


_group setFormDir _dir;

 systemchat format["ROTATE %1", _dir];

}
else
{
 systemchat "Ldr not alive";
};

} foreach _sel;

};
//_handled = true;
};

 _handled
}];

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

if(inputAction "CuratorInterface" > 0) then 
{
 systemchat format["zeus open... %1 %2 %3",_key, time, inputAction "CuratorInterface"];

 [] spawn onZeusOpen;
};

_handled
}];
} foreach [46]; //[0,12,46,312,313];

};

interceptZeusKeys =
{
(findDisplay 312) displayRemoveAllEventHandlers "KeyDown";

findDisplay 312 displayAddEventHandler ["KeyDown",
{
params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

private _handled = false;

if(_key in [DIK_E,DIK_R,DIK_BACKSLASH,DIK_TAB]) then 
{
 _handled = true;
};
/*
if(_key isEqualTo DIK_TAB) then 
{
 _handled = true;

 systemchat format["jeeee... %1 %2 %3",_key, time, inputAction "CuratorInterface"];

};*/

_handled
}];

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
