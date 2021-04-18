
#include "ctrlIds.h"

openCustomBattleDlg =
{
call initGlobalMap; // Maybe reloc

createDialog "CustomBattleDlg";

_display = findDisplay CUSTOMBATTLEDLGID;

_maps = _display displayCtrl 2100;

_blocs = call getBattleLocations;

battleLocList = [];

{
_marker = _x;

_locName = _marker splitString "_" joinString " ";

_maps lbAdd _locName;

 battleLocList pushback _marker;
} foreach _blocs;

cbMapSpeed = 0;

_maps ctrlAddEventHandler ["LBSelChanged",
{
params ["_control", "_selectedIndex"];


_marker = battleLocList # _selectedIndex;

_display = findDisplay CUSTOMBATTLEDLGID;
_map = _display displayCtrl 1200;
_map ctrlMapAnimAdd [cbMapSpeed, 0.2, getMarkerPos _marker];
ctrlMapAnimCommit _map;

nextBattleMap = _marker;

}];

_maps lbSetCurSel 0;

cbMapSpeed = 1;


_fillRosterLists =
{
params ["_side","_ctrlId"];

_forces = _display displayCtrl _ctrlId;

_rosters = missionConfigFile >> "ForceRosters" >> (str _side);

for "_i" from 0 to (count _rosters - 1) do
{
_force = _rosters select _i;

_forces lbAdd format ["%1", getText (_force >> "name")];

};

_forces lbSetCurSel 0;

};


[(call getPlayerSide),2101] call _fillRosterLists;
[(call getEnemySide),2102] call _fillRosterLists;


};

customBattleDone =
{
_display = findDisplay CUSTOMBATTLEDLGID;

plrClass = configNull;

_preparePool =
{
params ["_side","_ctrlId"];

diag_log format["Preparing battle pool %1", _side];

_rosters = missionConfigFile >> "ForceRosters" >> (str _side);

_forces = _display displayCtrl _ctrlId;

_rosIndex = lbcurSel _forces;

_rosClass = _rosters select _rosIndex;

[_side,_rosClass] call addForceToPool;

if(_side == (call getPlayerSide)) then
{
 plrClass = _rosClass;
};

};

[(call getPlayerSide),2101] call _preparePool;
[(call getEnemySide),2102] call _preparePool;

closeDialog 0;

call openPoolDlg;

plrClass call fillWithRandomBgs;

};



