
#include "ctrlids.h"


#define RTS_SAVEGAME_VERSION 1


openSavegameMenu =
{
params ["_isSaving"];

if(!canSuspend) exitWith { _this spawn openSavegameMenu; };

sleep 0.0001; // Have to wait previous gui to close

isSavingGame = _isSaving;

createDialog "SavegameDlg";

_display = findDisplay SAVEGAMEDLGID;

if(isnull _display) exitwith { systemChat "no disp"; };

_actButton = _display displayctrl 1600;

if(_isSaving) then
{
 _actButton ctrlSetText "Save";
 _actButton buttonSetAction "(call getSaveName) call rtsSavegame";
}
else
{
 _actButton ctrlSetText "Load";
 _actButton buttonSetAction "(call getSaveName) call rtsLoadgame";
};


_actButton ctrlEnable false;
_delButton = _display displayctrl 1602;
_delButton ctrlEnable false;

_saveName = _display displayctrl 1400;
_saveName ctrlSetText "";
_saveName ctrlAddEventHandler ["KeyUp", onSavenameTyped];

_saveList = _display displayctrl 1500;
_saveList ctrlAddEventHandler ["LBSelChanged", onSavegameSelected];

savedGamesList = profilenamespace getVariable ["rtsSavedGames",createHashmap];

call fillSavegameList;


systemChat format["Test123 --> %1 %2 %3 %4", _display, _actButton, _isSaving,isSavingGame ];


};

closeSavegameMenu =
{
 closedialog 0;
};

getSaveName =
{
private _display = findDisplay SAVEGAMEDLGID;
private _saveName = _display displayctrl 1400;
ctrlText _saveName
};

fillSavegameList =
{
_display = findDisplay SAVEGAMEDLGID;

_saveList = _display displayctrl 1500;


lnbClear _saveList;

{
_y params ["_timestamp","_version","_data"];

(_timestamp apply {if (_x < 10) then {"0" + str _x} else {str _x}}) params ["_year","_month","_day","_hour","_minute"];


_saveList lnbAddRow [_x, format["%3.%2.%1 %4.%5",_year,_month,_day,_hour,_minute] ];

} foreach savedGamesList;

};

onSavegameSelected =
{
params ["_saveList", "_selectedIndex"];

private _selectedSave = _saveList lnbText [_selectedIndex,0];

private _display = findDisplay SAVEGAMEDLGID;

_saveName = _display displayctrl 1400;
_saveName ctrlSetText _selectedSave;

call toggleSavegameButtons;

};

rtsSavegame =
{
params ["_selectedSave"];

if(_selectedSave == "") exitWith { hint "Save game name can't be empty"; };

systemchat format["Saving to '%1'", _selectedSave];


_data = [true] call rtsSaveLoadData;

savedGamesList set [_selectedSave, [systemTime,RTS_SAVEGAME_VERSION,+_data]];

profilenamespace setVariable ["rtsSavedGames",savedGamesList];
saveprofilenamespace;

call fillSavegameList;
};


rtsLoadGame =
{
params ["_selectedSave"];

_saveData = savedGamesList getOrDefault [_selectedSave,[]];

if(count _saveData == 0) exitWith { hint "Error loading save"; };

_saveData params ["_timestamp","_version","_data"];

if(_version < RTS_SAVEGAME_VERSION) then
{
 hint "You are loading save game of older version the version might be incompatible with the current mission version";
 diag_log format ["Older savegame version loaded %1", _version];
};

//systemchat format["_data > %1",_data];

[false,+_data] call rtsSaveLoadData;

call closeSavegameMenu;

call onSavegameLoaded;


};

rtsSaveLoadData =
{
params ["_isSave",["_savedata",[]]];

if(!_isSave && count _savedata == 0) exitWith { systemChat "save data empty"; };


#define SL_VAR(var) if(_isSave) then { _savedata pushback var; } else { var = _savedata deleteat 0 };


SL_VAR(allforces)
SL_VAR(gmBattleLocations)
SL_VAR(vehicleAttributes) // must also
SL_VAR(gmPhase)
SL_VAR(gmCurBattleIndex)


_savedata
};


rtsDeleteGame =
{

//params ["_selectedSave"];
_selectedSave = (call getSaveName);

private _display = findDisplay SAVEGAMEDLGID;

savedGamesList deleteat _selectedSave;

// Also update
profilenamespace setVariable ["rtsSavedGames",savedGamesList];
saveprofilenamespace;

call fillSavegameList;

_saveList = _display displayctrl 1500;

_i = lnbCurSelRow _saveList;
[_saveList,_i] call onSavegameSelected;

/*
_size = lnbSize _saveList;
_size params ["_rows"];

_i = lnbCurSelRow _saveList;
if(_i >= _rows) then { _i = _rows - 1; };
if(_i < 0) exitWith {};

systemChat format["-- %1",_i];

_saveList lnbSetCurSelRow _i;
*/
};

toggleSavegameButtons =
{
_selectedSave = call getSaveName;

_isvalidSavename = _selectedSave in savedGamesList;

private _display = findDisplay SAVEGAMEDLGID;

_actButton = _display displayctrl 1600;
if(!isSavingGame) then // If loading
{
_actButton ctrlEnable _isvalidSavename;
}
else // If saving
{
_actButton ctrlEnable (_selectedSave != "");

};

_delButton = _display displayctrl 1602;
_delButton ctrlEnable _isvalidSavename;


};

onSavenameTyped =
{
params ["_saveName", "_key", "_shift", "_ctrl", "_alt"];

call toggleSavegameButtons;
};

onSavegameLoaded =
{

"globalmap" call openGameScreen;

switch(gmPhase) do
{
case "move":
{
false call beginGmMovePhase;
};
case "battles":
{
 gmBattles = call getGlobalBattles;
 call gmCheckRoundEnd;
};

};

};