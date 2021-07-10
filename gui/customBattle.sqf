
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
_marker = _x # BATTLELOC_MARKER;

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

 if(testCfgs || (getNumber (_force >> "playable") == 1)) then
 {
_forces lbAdd format ["%1", getText (_force >> "name")];
_forces lbSetData [lbSize _forces - 1, configname _force];
 };

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


_rosName = _forces lbData _rosIndex;

//_rosName = _forces lbText _rosIndex;

//_rosClass = _rosters select _rosIndex;

_rosClass = _rosters >> _rosName;


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

#include "..\main.h"

setNextBattleArgs =
{
 params ["_locmarker","_attackDir"];


deployAreaSize = DEPLOY_AREA_SIZE;


 nextBattleMap = _locmarker;
 nextBattleDir = _attackDir;

battleAreaPos = markerPos _locmarker;
battleAreaSize = markerSize _locmarker;


_daDir = 120;
{
 _side = _x;
 _deployAreaPos = [battleAreaPos,_daDir] call getBattleDeployPos;

 missionnamespace setVariable [format["deployArea%1", _side], _deployAreaPos];

/*
_mrk = createmarker [format["deploySide%1",_side], _deployAreaPos];
_mrk setMarkerShape "RECTANGLE";
_mrk setMarkerColor "ColorGreen";
_mrk setMarkerSize [DEPLOY_AREA_SIZE,DEPLOY_AREA_SIZE];
_mrk setMarkerDir _daDir;
*/

 _daDir = _daDir + 180;
} foreach [west,east];

};

