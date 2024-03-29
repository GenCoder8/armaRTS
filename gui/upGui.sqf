
#include "ctrlIds.h"

#include "..\main.h"

createdBgPanels = [];

selectedBattleGroups = [];
enemySelectedBgs = [];

manpoolSelLeft = [0,0,0]; // just to avoid error

#define BGPOOLID 2301

openPoolDlg =
{
selectedBattleGroups = [];

createDialog "UnitPoolDlg";

_display = finddisplay UNITPOOLDLGID;
_display call disableDlgEscaping;

selectableBgs = ([curPlrForce] call getForceBgTypes);


call createBgPoolPanels;

};

createBGPanel =
{
 params ["_bgcfg","_ctrlgId","_px","_py",["_active",true]];

#define EPADD 0.01
#define LINEHEIGHT 0.03
#define LINEWIDTH 0.2 - (EPADD*2)
#define PANEL_PADD 0.04

#define DEL_BUTTON_WIDTH 0.025

_display = findDisplay UNITPOOLDLGID;

_ReservePoolArea = _display displayCtrl _ctrlgId;

_panelWidth = 0.2;
_panelHeight = (EPADD + LINEHEIGHT) * 3 + 0.1;

_cont = _display ctrlCreate ["RtsControlsGroupNoScrollBars", -1, _ReservePoolArea];
_cont ctrlSetPosition [_px * (0.2 + PANEL_PADD),_py * (_panelHeight + PANEL_PADD), _panelWidth, _panelHeight];
_cont ctrlCommit 0;

createdBgPanels pushback _cont;

_bgr = _display ctrlCreate ["RscPicture", -1, _cont];
_bgr ctrlSetText format[RTSmainPath+"gui\bgPanel.jpg"];
_bgr ctrlSetPosition [0, 0, _panelWidth, _panelHeight];
_bgr ctrlCommit 0;


_selButtonWidth = LINEWIDTH - 0.004;

_contHeight = EPADD + 0.005;

if(_ctrlgId != BGPOOLID) then
{
 _selButtonWidth = _selButtonWidth - DEL_BUTTON_WIDTH;

_delBut = _display ctrlCreate ["RtsButton", -1, _cont];
_delBut ctrlSetText format["%1", "X"];
_delBut ctrlSetPosition [EPADD + _selButtonWidth, _contHeight, DEL_BUTTON_WIDTH, LINEHEIGHT];
_delBut ctrlCommit 0;

_delBut buttonSetAction format["[%1,%2] call poolDeleteSelectedBG",_ctrlgId,numPoolPanels];

};


_selBut = _display ctrlCreate ["RtsButton", -1, _cont];
_selBut ctrlSetText format["%1", "Select"];
_selBut ctrlSetPosition [EPADD, _contHeight, _selButtonWidth, LINEHEIGHT];
_selBut ctrlCommit 0;

_selBut buttonSetAction format["[%1,%2] call poolSelectBG",_ctrlgId,numPoolPanels];

_selBut ctrlEnable _active;


_contHeight = _contHeight + LINEHEIGHT;


_typeInfo = _bgcfg call getBattlegroupIcon;

_units = getArray(_bgCfg >> "units");
_leadUnit = _units select 0;
_leadCfg = configfile >> "cfgVehicles" >> _leadUnit;

_typeText = "";
_vehText = "";
if(_leadUnit iskindof "man") then
{
 _typeText = gettext (_bgcfg >> "name");
 _vehText = format ["%1 soldiers", count _units];
}
else
{
 _typeText = _typeInfo # 0;
 _vehText = format ["%1", getText(_leadCfg >> "displayname") ];
};


_bgr = _display ctrlCreate ["RscPicture", -1, _cont];
_bgr ctrlSetText (_typeInfo # 1);
_bgr ctrlSetPosition [EPADD, _contHeight, LINEHEIGHT*2, LINEHEIGHT *2];
_bgr ctrlCommit 0;

_contHeight = _contHeight + LINEHEIGHT * 1.75;

_text = _display ctrlCreate ["RtsPoolText", -1, _cont];
_text ctrlSetText format["%1", _typeText];
_h = ctrlTextHeight _text;
_text ctrlSetPosition [EPADD, _contHeight, LINEWIDTH, _h];
_text ctrlCommit 0;

// _text ctrlSetTooltip gettext (_bgcfg >> "name");


_contHeight = _contHeight + _h;



// systemchat format[">> %1 ", _leadCfg];



_text2 = _display ctrlCreate ["RtsPoolText", -1, _cont];
_text2 ctrlSetText format["%1", _vehText];
_h = ctrlTextHeight _text2;
_text2 ctrlSetPosition [EPADD, _contHeight, LINEWIDTH, _h];
_text2 ctrlCommit 0;

_contHeight = _contHeight + _h;


_text3 = _display ctrlCreate ["RtsPoolText", -1, _cont];
_text3 ctrlSetText format["%1",_bgcfg call getTraitDescs];
_h = ctrlTextHeight _text3;
_text3 ctrlSetPosition [EPADD, _contHeight, LINEWIDTH, _h];
_text3 ctrlCommit 0;

/*
_text3 = _display ctrlCreate ["RscText", -1, _cont];
_text3 ctrlSetText format["%1", call getExperienceStr];
_text3 ctrlSetPosition [EPADD, EPADD + LINEHEIGHT * 3, LINEWIDTH, LINEHEIGHT];
_text3 ctrlCommit 0;
*/

};


canBgBeSelected =
{
 params ["_side","_bgName","_selectedBgs",["_retLeft",false]];

if((count _selectedBgs) >= (_side call getMaxBgsForSide)) exitwith { false };

private _neededMen = [0,0,0];
private _usedPoolTypes = createHashMap;

for "_i" from 0 to (count _selectedBgs - 1) do
{
 private _obgCfg = _selectedBgs select _i;

 private _cn = [_side,(configname _obgCfg)] call countBgPoolNeed;
 _neededMen = [_neededMen,_cn] call addList;

private _units = getArray(_obgCfg >> "units");
{
_u = _x;
[_usedPoolTypes,_u] call addTypeToList;

// Must also check crew
if(!(_u iskindof "Man")) then
{
 private _vattrs = _u call getVehicleAttrs;

 private _crewList = _vattrs # VEH_ATTRS_CREW;
 {
  [_usedPoolTypes,_u] call addTypeToList;
} foreach _crewList;

};

} foreach _units;

};

private _bgCfg = (call getUsedBattlegroupsCfg) >> (_side call getSideStr) >> _bgName;

// diag_log format["TESTING123 %1 %2 %3 %4",(call getUsedBattlegroupsCfg) , (_side call getSideStr) , _bgName, _bgCfg ];

private _mpool = _side call getManPool;
private _poolCounts = [_mpool,true] call countListTypeNumbers;

private _poolTypes = [_mpool] call getPoolUnitTypeCounts;

private _poolLeftTypes = [_poolCounts,_neededMen] call subList;

// diag_log format[">>>>>>> %1 %2 %3",_side, _mpool,  _poolTypes ];

// systemchat format[">> %1", _poolLeftTypes];


 private _cn = [_side,_bgName] call countBgPoolNeed;
 private _left = [+_poolLeftTypes,_cn] call subList;


if(_retLeft) then
{
 manpoolSelLeft = +_left;

 //systemchat format["_>>>>>>>>>>>>>>>> %1", _retLeft];
};
 
private _notEnough = false;
if((_left findIf { _x < 0}) >= 0 ) then // Anything depleted?
{
 _notEnough = true;

 systemchat format["not enough: %1 - %2 - %3",_bgName,_poolLeftTypes,_left];
};


// Check that there is enough vehicles in the pool
private _units = getArray(_bgCfg >> "units");
{
 private _utype = _x;
if(!(_utype iskindof "Man") || _utype call isSniper) then // Type requirement - only for vehicles OR snipers
{
 private _leftInPool = (_poolTypes getOrDefault [_utype,0]) - (_usedPoolTypes getOrDefault [_utype,0]);

// diag_log format["%1 -- %2 - %3",_utype, (_poolTypes get _utype) , (_usedPoolTypes getOrDefault [_utype,0])];

if(_leftInPool <= 0) then
{
_notEnough = true;
break;
};
};

// Check if vehicle has crew in the pool
if(!(_utype iskindof "Man")) then
{
 private _vattrs = _utype call getVehicleAttrs;
 private _crewList = _vattrs # VEH_ATTRS_CREW;

 private _crewLeftInPool = 1;

 {
   private _crewType = _x;
   _crewLeftInPool = (_poolTypes getOrDefault [_crewType,0]) - (_usedPoolTypes getOrDefault [_crewType,0]);

   if(_crewLeftInPool < 0) then { break; };

 } foreach _crewList;

if(_crewLeftInPool <= 0) then
{
_notEnough = true;
break;
};

};

} foreach _units;


// Some bgroups have max select at a time
 private _numSelected = { _x == _bgCfg } count _selectedBgs;

 private _haveMax = getNumber (_bgCfg >> "max");
 if(_haveMax > 0) then // Is value set?
 {
  if(_numSelected >= _haveMax) then
  {
   _notEnough = true;
  };
 };


 !_notEnough
};

createBgPoolPanels =
{
 params ["_init"];

call poolDeselectBG;

{
 ctrlDelete _x;
} foreach createdBgPanels;
createdBgPanels = [];


// Create selected battle groups
numPoolPanels = 0;
for "_i" from 0 to (count selectedBattleGroups - 1) do
{
 _bgCfg = selectedBattleGroups select _i;

 [_bgCfg,2300,numPoolPanels % 4,floor(numPoolPanels / 4)] call createBGPanel;

 numPoolPanels = numPoolPanels + 1;

};


_availBgs = selectableBgs;


// Create battle groups pool
numPoolPanels = 0;
for "_i" from 0 to (count _availBgs - 1) do
{
 _bgName = _availBgs select _i;
 _bgCfg = (call getUsedBattlegroupsCfg) >> (call getPlrSideStr) >> _bgName;

private _canSel = false;

if([(call getPlayerSide),_bgName,selectedBattleGroups,true] call canBgBeSelected) then
{
 _canSel = true;
};

 [_bgCfg,2301,0,numPoolPanels,_canSel] call createBGPanel;

 numPoolPanels = numPoolPanels + 1;
};

_display = findDisplay UNITPOOLDLGID;
_ctrlMpl = _display displayCtrl 1000;
_ctrlMpl ctrlSetText format["Left in pool: infantry %1 vehicles %2 crew %3", manpoolSelLeft # UTYPE_NUMBER_INFANTRY, manpoolSelLeft # UTYPE_NUMBER_VEHICLE, manpoolSelLeft # UTYPE_NUMBER_CREW];

};

selectedReserveBG = configNull;

poolSelectBG =
{
 params ["_bgListId","_selBgIndex"];
 //hint (str _this);

 call poolDeselectBG;

 _bgCfg = configNull;

if(_bgListId == 2301) then
{
 _availBgs = selectableBgs;
 _bgName = _availBgs select _selBgIndex;

 _bgCfg = (call getUsedBattlegroupsCfg) >> (call getPlrSideStr) >> _bgName;

 selectedReserveBG = _bgCfg;

 ctrlShow [1600, true];
}
else
{
 
 _bgCfg = selectedBattleGroups select _selBgIndex;
};

_display = findDisplay UNITPOOLDLGID;
_bgView = _display displayCtrl 1500;
lbClear _bgView;

_getWeapPic =
{
 params ["_wcfg"];
 if(isnull _wcfg) exitwith { "" };

 private _weapPic = getText(_wcfg >> "picture");

 _weapPic

 //getText (_wcfg >> "displayName");
};

 _units = getArray (_bgCfg >> "units");
 _ranks = getArray (_bgCfg >> "ranks");

private _funit = (_units # 0);

if(!(_funit isKindOf "man")) then
{
 private _vattr = _funit call getVehicleAttrs;
 _units = [_funit] + _vattr # 1;
};

{
_type = _x;
_unitCfg = configfile >> "CfgVehicles" >> _type;
_rank = [_bgCfg,_foreachIndex] call getRankFromCfg;

_weapons = getArray(_unitCfg >> "weapons");

_priWeap = configNull;
_secWeap = configNull;

// Only for men atm
if((_type isKindOf "man")) then
{
{
 private _wcfg = configfile >> "CfgWeapons" >> _x;
 private _type = getNumber(_wcfg >> "type");
 if(_type == 1) then
 {
  _priWeap = _wcfg;
 };
 if(_type == 4) then
 {
  _secWeap = _wcfg;
 };
} foreach _weapons;

};

_rankIcon = (_rank call rankToNumber) call getRankIcon;
_name = getText (_unitCfg >> "displayName");


_rowIndex = _bgView lnbAddRow ["",_name, "", ""];

_bgView lnbSetPicture [[_rowIndex, 0], _rankIcon];

 _bgView lnbSetPicture [[_rowIndex, 2], _priWeap call _getWeapPic];
 _bgView lnbSetPicture [[_rowIndex, 3], _secWeap call _getWeapPic];

} foreach _units;

};

poolDeleteSelectedBG =
{
 params ["_bgListId","_selBgIndex"];

 selectedBattleGroups deleteAt _selBgIndex;

call createBgPoolPanels;

 call poolDeselectBG;

};

poolAddReserveBG =
{

 selectedBattleGroups pushback selectedReserveBG;

 call createBgPoolPanels;

};

poolDeselectBG =
{
_display = findDisplay UNITPOOLDLGID;
_bgView = _display displayCtrl 1500;
lbClear _bgView;

ctrlShow [1600, false];

selectedReserveBG = configNull;

};

fillWithRandomBgs =
{
 params ["_rosClass"];

 selectedBattleGroups = [(call getPlayerSide),_rosClass] call getBgSelectedList;

 call createBgPoolPanels;
};

// Creates the battle group list
getBgSelectedList =
{
 params ["_side","_rosClass"];

private _bgsList = [_side,_rosClass] call getBattleGroupList;

private _list = [];

_leftToPlace = (_side call getMaxBgsForSide);
for "_i" from 0 to 50 do // Todo maybe reconsider the attemb count
{
 private _bgName = selectRandomWeighted _bgsList;

if(isnil "_bgName") exitwith {};
 
if([_side,_bgName,_list] call canBgBeSelected) then
{
 private _bgCfg = (call getUsedBattlegroupsCfg) >> (_side call getSideStr) >> _bgName;
 _list pushback _bgCfg;
 _leftToPlace = _leftToPlace - 1;
 if(_leftToPlace == 0) then { break; };
};

};

if(_leftToPlace != 0) then
{
 ["Unable to fill list with bgs %1 %2",_side,_leftToPlace] call dbgmsg; // Not error if force pool small
};

 _list
};

beginBattlePlacement =
{
if(!canSuspend) exitwith { _this spawn beginBattlePlacement; };

deployDone = false;


[nextBattleMap,nextBattleDir] call startBattleFieldZeus;

waituntil { battleGuiReady && !loadScreenStarted };


"Deploying troops" call startRtsLoadScreen;




addMissionEventHandler ["EachFrame",
{
removeMissionEventHandler ["EachFrame",_thisEventHandler];

_sideArr = [];

if(count curPlrForce > 0 && count selectedBattleGroups > 0) then
{
 _sideArr pushback [call getPlayerSide,[selectedBattleGroups] call sortBgs];
};

if(count curEnemyForce > 0 && count enemySelectedBgs > 0) then
{
 _sideArr pushback [call getEnemySide,[enemySelectedBgs] call sortBgs];
};

//diag_log format["---------- POOL -----------"];

//[(call getPlayerSide) call getManPool] call printArray;

diag_log "--- East ---";

//[(call getEnemySide) call getManPool] call printArray;

// Place all troops
{
 _x params ["_side","_selList"];

_deployAreaPos = _side call getDeployArea;
_area = [_deployAreaPos,deployAreaSize];

diag_log format["--------- Begin Creating %1 forces --------- ",_side];

{
 diag_log format["----- Creating bg: %1", configname _x];

 [_side,configname _x,_area] call createBattleGroupFromPool;

} foreach _selList;

diag_log format["---------  Done Creating %1 forces --------- ",_side];

} foreach _sideArr;

if(count wantedTestGroups > 0) then
{
 diag_log "Placing test groups";


{
 _x params ["_groupName","_area"];

[call getPlayerSide,_groupName] call addBattleGroupToPool;
[call getPlayerSide,_groupName,_area] call createBattleGroupFromPool;

} foreach wantedTestGroups;

};

deployDone = true;
}];


waituntil { deployDone };

call endRtsLoadScreen;


};

sortBgs =
{
params ["_bgList"];

private _ret = [_bgList, [], 
{
private _bgCfg = _x;

private _hiRank = getArray (_bgCfg >> "ranks") # 0;

(_hiRank call rankToNumber)

}, "DESCEND"] call BIS_fnc_sortBy;

_ret
};


checkForvehType =
{
params ["_vehType","_find"];
private _base = (configFile >> "CfgVehicles" >> _vehType);
private _ret = false;

while { !isnull _base } do
{

 if((toupper (configname _base)) find _find >= 0) exitwith { _ret = true; };

_base = inheritsFrom _base;

 //systemchat format[">> %1", configname _base ];
};

_ret
};


getMaxBgsForSide =
{
 params ["_side"];

 private _max = MAX_SELECTED_BGS;

_eside = call getEnemySide;

if(_side == _eside) then // For enemy
{
 _max = _max + (3 * usedDifficulty);
};

_max
};


tt =
{
 _r = [selectedBattleGroups] call sortBgs;

{
 diag_log format["%1 <-> %2", configname _x, configname(_r # _foreachIndex) ];
} foreach selectedBattleGroups;

};