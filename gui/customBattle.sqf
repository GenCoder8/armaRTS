
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

hintSilent str _this;

_marker = battleLocList # _selectedIndex;

_display = findDisplay CUSTOMBATTLEDLGID;
_map = _display displayCtrl 1200;
_map ctrlMapAnimAdd [cbMapSpeed, 0.2, getMarkerPos _marker];
ctrlMapAnimCommit _map;

}];

_maps lbSetCurSel 0;

cbMapSpeed = 1;



_forces = _display displayCtrl 2101;

_rosters = missionConfigFile >> "ForceRosters" >> (call getPlrSideStr);

for "_i" from 0 to (count _rosters - 1) do
{
_force = _rosters select _i;

_forces lbAdd format ["%1", configName _force];

};

_forces lbSetCurSel 0;

};

customBattleDone =
{
_display = findDisplay CUSTOMBATTLEDLGID;

_rosters = missionConfigFile >> "ForceRosters" >> (call getPlrSideStr);

_forces = _display displayCtrl 2101;

_rosIndex = lbcurSel _forces;

_rosClass = _rosters select _rosIndex;

[call getPlayerSide,_rosClass] call addForceToPool;

call openPoolDlg;

};
