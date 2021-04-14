
#include "ctrlIds.h"

openCustomBattleDlg =
{
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


_maps lbSetCurSel 0;

_maps ctrlAddEventHandler ["LBSelChanged",
{
params ["_control", "_selectedIndex"];

hintSilent str _this;
}];


};


