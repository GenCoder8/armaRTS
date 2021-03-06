
#define GE_WIDTH  7
#define GE_HEIGHT 5



fillUnitList =
{
 params ["_ctrlGroup"];

 private _display = finddisplay 312;

 private _groups = (call getPlayerSide) call getOwnGroups;


{ ctrlDelete _x; } foreach (allControls _ctrlGroup);

_img = _display ctrlCreate ["RtsPicture", -1, _ctrlGroup];

_ctrlGroup setVariable ["background",_img];

unitListGroups = [];


{
private _group = _x;

private _bgcfg = _group getVariable ["cfg",confignull];

if(isnull _bgcfg) then { continue; };

_cont = _display ctrlCreate ["RtsControlsGroupNoScrollBars", -1, _ctrlGroup];

_conb = _display ctrlCreate ["RtsInvisibleButton", -1, _cont];


_conb setVariable ["group", _group];


_typeInfo = _bgcfg call getBattlegroupIcon;

_ctrlsY = 0;

#define ROW_HEIGHT 1
#define PADD 0.2

_bgr = _display ctrlCreate ["RscPicture", -1, _cont];
_bgr ctrlSetText format[RTSmainPath+"gui\bgPanel.jpg"];


_ico = _display ctrlCreate ["RscPicture", -1, _cont];
_ico ctrlSetText (_typeInfo # 1);
_ico ctrlSetPosition ([0+PADD+0.2,_ctrlsY+PADD, 1, ROW_HEIGHT ,false] call getGuiPos);
_ico ctrlCommit 0;

_text = _display ctrlCreate ["RtsPoolText", -1, _cont];
_text ctrlSetText format["%1", getText (_bgcfg >> "name")];
_h = ctrlTextHeight _text;
_text ctrlSetPosition ([1+PADD,_ctrlsY+PADD, GE_WIDTH, ROW_HEIGHT ,false] call getGuiPos);
_text ctrlCommit 0;

_ctrlsY = _ctrlsY + ROW_HEIGHT;

// Strength
_text = _display ctrlCreate ["RtsPoolText", -1, _cont];

_h = ctrlTextHeight _text;
_text ctrlSetPosition ([0+PADD, _ctrlsY+PADD, GE_WIDTH, ROW_HEIGHT ,false] call getGuiPos);
_text ctrlCommit 0;

_cont setVariable ["strengthText", _text];

[_cont,_group] call setStrengthText;

_ctrlsY = _ctrlsY + ROW_HEIGHT;


// Secondary Ammo

_secinfo = _group call getBattleGroupSecWeapInfo;

_wpic = _display ctrlCreate ["RscPicture", -1, _cont];
_wpic ctrlSetPosition ([0+PADD, _ctrlsY+PADD, 1, ROW_HEIGHT ,false] call getGuiPos);
_wpic ctrlCommit 0;
_wpic ctrlSetText (_secinfo # 0);
_wpic ctrlSetTooltip (_secinfo # 1); 

_cont setVariable ["apic", _wpic];

_text = _display ctrlCreate ["RtsPoolText", -1, _cont];
_h = ctrlTextHeight _text;
_text ctrlSetPosition ([1+PADD, _ctrlsY+PADD, GE_WIDTH, ROW_HEIGHT ,false] call getGuiPos);
_text ctrlCommit 0;

_cont setVariable ["ammoText", _text];

[_cont,_group] call setAmmoText;

_ctrlsY = _ctrlsY + ROW_HEIGHT;

ulContHeight = _ctrlsY + 0.3; // Plus some padd

// Set later
_cont ctrlSetPosition ([0,0, GE_WIDTH, ulContHeight ,false] call getGuiPos);
_cont ctrlCommit 0;

_conb ctrlSetPosition ([0,0, GE_WIDTH, ulContHeight ,false] call getGuiPos);
_conb ctrlCommit 0;

// Set background size
_bgr ctrlSetPosition ([0,0, GE_WIDTH, ulContHeight ,false] call getGuiPos);
_bgr ctrlCommit 0;


unitListGroups pushback [_cont,_group];
_conb buttonSetAction format["(unitListGroups select %1) call onUnitListSelect", count unitListGroups - 1];


} foreach _groups;

call updateUnitListCtrls;

};

setStrengthText =
{
 params ["_cont","_group"];

 _text = _cont getVariable "strengthText";

 _text ctrlSetText format["%1", _group call getBattleGroupStrengthStr ];

};

setAmmoText =
{
 params ["_cont","_group"];
 _text = _cont getVariable "ammoText";

 _text ctrlSetText format["%1", _group call getBattleGroupAmmoText ];
};

updateUnitListCtrls =
{
 private _index = 0;

{
 _x params ["_cont","_group"];

if( { alive _x} count (units _group) > 0 ) then
{
 // Big enough to have all the ctrls in it (Todo why 9 is good, why it effects both w & h?)
_cont ctrlSetPosition ([0,(ulContHeight + 0.05) * _index, 9, ulContHeight ,false] call getGuiPos);
_cont ctrlCommit 0;

 _index = _index + 1;
}
else
{
 ctrlDelete _cont;
};

} foreach unitListGroups;


_gpos = ([0,0,0,((_index + 0) * ulContHeight )] call getGuiPos);
// prev: _gpos = ([0,0,0,((_index + 1) * GE_HEIGHT )] call getGuiPos);

with (uinamespace) do
{

_ul = unitList;
_img = _ul getVariable "background";

_pos = ctrlPosition _ul;
_pos params ["","","_w","_h"];


// _ipos = ctrlPosition _img;

 // Set the green background , minus scroll bar width
_img ctrlSetPosition [0,0,_w-0.02, _gpos # 3];
_img ctrlCommit 0;

};


};

onUnitListSelect =
{
 params ["_cont","_group"];


 //private _display = finddisplay 312;

//ctrlSetFocus controlNull;

 //systemchat format["%1 -- %2 -- %3",(str _this), focusedCtrl _display,_cont];


//ctrlSetFocus (_cont getvariable "apic");


_leader = leader _group;
 if(isnull _leader) exitWith {};

_cam = curatorcamera; 

_v = [nextBattleDir, 25] call getVector;
_cpos = [getpos _leader,_v] call addvector;

_cpos set [2,25];

_cam setposATL _cpos;


_cam camSetTarget _leader;
_cam camCommit 0;
_cam camSetTarget objnull;
_cam camCommit 0;

};

selectFromUnitList =
{
 
};

ulGetGroupEntry =
{
 params ["_group"];
 private _ret = [];

 { 
 if(_group == (_x # 1) ) exitWith { _ret = _x; };

} foreach unitListGroups;

_ret
};


addMissionEventHandler ["EntityKilled", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];

private _group = group _unit;
private _groups = (call getPlayerSide) call getOwnGroups;

if(!(_group in _groups)) exitWith {};

_entry = _group call ulGetGroupEntry;


_entry call setStrengthText; // Update just one


call updateUnitListCtrls; // Update all

}];


unitFiring =
{
params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

_group = group _unit;


_entry = _group call ulGetGroupEntry;


_entry call setAmmoText;

};


addMissionEventHandler ["GroupDeleted", {
 params ["_group"];


// hint format["DELETED %1", _group];

}];

