
#include "ctrlIds.h"

openCustomBattleDlg =
{
"globalmap" call openGameScreen;

createDialog "CustomBattleDlg";

_display = findDisplay CUSTOMBATTLEDLGID;

_maps = _display displayCtrl 2100;

_blocs = gmBattleLocations;

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

[_marker,floor (random 360)] call setNextBattleArgs;

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

_rosters = missionConfigFile >> "ForceRosters" >> (_side call getSideStr);

_forces = _display displayCtrl _ctrlId;

_rosIndex = lbcurSel _forces;

_rosClass = _rosters select _rosIndex;

[_side,configname _rosClass,configname _rosClass] call createForce; // Todo clean this up after battle

if(_side == (call getPlayerSide)) then
{
 plrClass = _rosClass; // Read in later
}
else
{
 // Get enemy troops rightaway
 enemySelectedBgs = [_side,_rosClass] call getBgSelectedList;
};

};

[(call getPlayerSide),2101] call _preparePool;
[(call getEnemySide),2102] call _preparePool;


["poolSelect"] call openGameScreen;

plrClass call fillWithRandomBgs;

};

setNextBattleArgs =
{
 params ["_locmarker","_attackDir"];

 nextBattleMap = _marker;
 nextBattleDir = _attackDir;
};

