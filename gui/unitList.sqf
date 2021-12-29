#include "..\main.h"

#define GE_WIDTH  6
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

_cont setVariable ["cbut", _conb];


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

_text = _display ctrlCreate ["RtsUnitListText", -1, _cont];
_text ctrlSetText format["%1", getText (_bgcfg >> "name")];
_h = ctrlTextHeight _text;
_text ctrlSetPosition ([1+PADD,_ctrlsY+PADD, GE_WIDTH, ROW_HEIGHT ,false] call getGuiPos);
_text ctrlCommit 0;

_ctrlsY = _ctrlsY + ROW_HEIGHT;

// Strength
_text = _display ctrlCreate ["RtsUnitListText", -1, _cont];

_h = ctrlTextHeight _text;
_text ctrlSetPosition ([0+PADD, _ctrlsY+PADD, GE_WIDTH, ROW_HEIGHT ,false] call getGuiPos);
_text ctrlCommit 0;

_cont setVariable ["strengthText", _text];

[_cont,_group] call setStrengthText;

_ctrlsY = _ctrlsY + ROW_HEIGHT;


// Secondary Ammo

//_secinfo = _group call getBattleGroupSecWeapInfo;

_wpic = _display ctrlCreate ["RscStructuredText", -1, _cont];
_wpic ctrlSetPosition ([0+PADD, _ctrlsY+PADD, 5, ROW_HEIGHT ,false] call getGuiPos);
_wpic ctrlCommit 0;
//_wpic ctrlSetText (_secinfo # 0);
//_wpic ctrlSetTooltip (_secinfo # 1); 

_cont setVariable ["apic", _wpic];
/*
_text = _display ctrlCreate ["RtsUnitListText", -1, _cont];
_h = ctrlTextHeight _text;
_text ctrlSetPosition ([1+PADD, _ctrlsY+PADD, GE_WIDTH, ROW_HEIGHT ,false] call getGuiPos);
_text ctrlCommit 0;

_cont setVariable ["ammoText", _text];
*/
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
 //_text = _cont getVariable "ammoText";

// _text ctrlSetText format["%1", _group call getBattleGroupSecWeapAmmoText ];

private _priinfo = "";
private _secinfo = "";

private _ldr = leader _group;
if(isnull _ldr && count (units _group) > 0) then
{
 _ldr = (units _group) # 0;
};

if(isnull _ldr) exitWith {}; // Error

private _veh = vehicle _ldr;

//assignedVehicleRole
// In case vehicle crew
if(_ldr call invehicle && (commander _veh == _ldr || driver _veh == _ldr || gunner _veh == _ldr)) then
{
 _ammos = _veh call getTankAmmoCounts;

 _ammos params ["_ammoLeft","_ammoMax"];


 _ammoColor = "";
 _ammoText = "";

_getAmmoTypeStatus =
{
 params ["_ammoType"];

 _al = _ammoLeft get _ammoType;
 _am = _ammoMax get _ammoType;

 _ammoLeftPcto = 0;

 if(_am > 0) then
 {
 _ammoLeftPcto = _al / _am;
 };


 _ammoStatusState = 2;

 if(_ammoLeftPcto < 0.25) then
 {
 _ammoStatusState = 1;
 };

 if(_ammoLeftPcto <= 0) then
 {
  _ammoStatusState = 0;
 };

 (ammoStateVars # _ammoStatusState) params ["_ammoText","_ammoColor"];
};
 
"shotShell" call _getAmmoTypeStatus;

_priinfo = ["a3\ui_f\data\gui\rsc\rscdisplayarsenal\cargomag_ca.paa","",_ammoColor];

"shotBullet" call _getAmmoTypeStatus;

_secinfo = ["a3\ui_f\data\gui\rsc\rscdisplayarsenal\cargomag_ca.paa","",_ammoColor];

}
else
{

_priinfo = _group call getBattleGroupPriWeapInfo;
_secinfo = _group call getBattleGroupSecWeapInfo;

};




_wpic = _cont getVariable "apic";

_priText = format["<img size='1' image='%1' color='#%2' />", _priinfo # 0,_priinfo # 2];

_secText = format["<img size='1' image='%1' color='#%2' />", _secinfo # 0,_secinfo # 2];

_wpic ctrlSetStructuredText parseText (_priText + _secText);

// _wpic ctrlSetTooltip (str (_secinfo # 0));

_conb = _cont getVariable "cbut";


_conb ctrlSetTooltip format ["Primary weapon "];


};

updateUnitListCtrls =
{
 private _index = 0;

_ul = uinamespace getvariable "unitList";
_ulpos = ctrlPosition _ul;
_ulpos params ["","","_ulw","_ulh"];

_numBgsAtColumn = ceil (MAX_SELECTED_BGS / 2);
_bgX = 0;
_bgY = 0;


{
 _x params ["_cont","_group"];

if( { alive _x} count (units _group) > 0 ) then
{
 // Big enough to have all the ctrls in it (Todo why 9 is good, why it effects both w & h?)
 // todo width from UNIT_LIST_WIDTH 
_cont ctrlSetPosition ([_bgX * 6,(ulContHeight + 0.05) * _bgY, 9, ulContHeight ,false] call getGuiPos);
_cont ctrlCommit 0;

}
else
{
 ctrlDelete _cont;
};


_bgY = _bgY + 1;

if(_bgY >= _numBgsAtColumn) then
{
 _bgY = 0;
 _bgX = _bgX + 1;
};

} foreach unitListGroups;


_gpos = ([0,0,0,((_numBgsAtColumn + 0) * ulContHeight )] call getGuiPos);
// prev: _gpos = ([0,0,0,((_index + 1) * GE_HEIGHT )] call getGuiPos);

with (uinamespace) do
{

//_ul = unitList;
_img = _ul getVariable "background";


 // Set the green background , minus scroll bar width
_img ctrlSetPosition [0,0,_ulw-0.02, _gpos # 3 + 0.02];
_img ctrlCommit 0;

};


};

onUnitListSelect =
{
 params ["_cont","_group"];
/*
[] spawn
{
 private _display = finddisplay 312;

 _ctrl = _display displayCtrl 7777;

 ctrlSetFocus _ctrl;

 systemchat format["%1 -- %2 -- %3",_display, focusedCtrl _display,_ctrl];

};*/

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

