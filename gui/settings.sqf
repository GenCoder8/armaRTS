#include "ctrlids.h"


openSettingsMenu =
{
createDialog "SettingsDlg";

_display = findDisplay SETTINGSDLGID;
_modList = _display displayCtrl 2100;

_modCfgs = missionconfigfile >> "SupportedMods";

_selectIndex = -1;

_list = call getAvailableModList;

{
 _modName = _x;
 _idx = _modList lbAdd _modName;
_modList lbSetData [_idx, _modName];

if(usedMod == _modName) then
{
 _selectIndex = _forEachIndex;
};

} foreach _list;

if(_selectIndex < 0) then { _selectIndex = 0; };

_modList lbSetCurSel _selectIndex;


// Difficulty

_difficultyList = _display displayCtrl 2101;

_difficultyList lbAdd "Normal";
_difficultyList lbAdd "Hard";
_difficultyList lbAdd "Very Hard";
_difficultyList lbAdd "Extreme";

_difficultyList lbSetCurSel usedDifficulty;

};

closeSettingsMenu =
{

_display = findDisplay SETTINGSDLGID;
_modList = _display displayCtrl 2100;
_difficultyList = _display displayCtrl 2101;

_index = lbCurSel _modList;

if(_index < 0) exitWith {}; // Error

usedMod = _modList lbData _index;

_dindex = lbCurSel _difficultyList;

if(_dindex < 0) exitWith {}; // Error

usedDifficulty = _dindex;

profilenamespace setVariable ["aRtsModUsed", usedMod ];

profilenamespace setVariable ["aRtsDifficulty", usedDifficulty ];

closeDialog 0;

};



