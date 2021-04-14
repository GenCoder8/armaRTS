
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

};


