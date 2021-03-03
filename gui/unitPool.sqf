
#define UNITPOOLDLGID 12345577

createBgPanels = [];

createBGPanel =
{
 params ["_bgcfg","_ctrlgId","_px","_py"];

#define EPADD 0.01
#define LINEHEIGHT 0.03
#define LINEWIDTH 0.2 - (EPADD*2)
#define PANEL_PADD 0.04

_display = findDisplay UNITPOOLDLGID;

_ReservePoolArea = _display displayCtrl _ctrlgId;

_panelWidth = 0.2;
_panelHeight = (EPADD + LINEHEIGHT) * 2 + 0.1;

_cont = _display ctrlCreate ["RscControlsGroup", -1, _ReservePoolArea];
_cont ctrlSetPosition [_px * (0.2 + PANEL_PADD),_py * (_panelHeight + PANEL_PADD), _panelWidth, _panelHeight];
_cont ctrlCommit 0;

createBgPanels pushback _cont;

_bgr = _display ctrlCreate ["RscPicture", -1, _cont];
_bgr ctrlSetText format[RTSmainPath+"gui\bgPanel.jpg"];
_bgr ctrlSetPosition [0, 0, _panelWidth, _panelHeight];
_bgr ctrlCommit 0;


_selBut = _display ctrlCreate ["RtsButton", -1, _cont];
_selBut ctrlSetText format["%1", "Select"];
_selBut ctrlSetPosition [EPADD, EPADD, LINEWIDTH, LINEHEIGHT];
_selBut ctrlCommit 0;

//_selBut ctrlSetBackgroundColor  [0, 1, 0, 1];
//_selBut ctrlSetDisabledColor  [1, 0, 0, 1];
//_selBut ctrlSetForegroundColor  [1, 0, 0, 1];
//_selBut ctrlSetActiveColor [0, 0, 1, 1];


_selBut buttonSetAction format["[%1,%2] call selectReserveBG",_ctrlgId,numPoolPanels];

_text = _display ctrlCreate ["RscText", -1, _cont];
_text ctrlSetText format["%1", gettext (_bgcfg >> "name")];
_text ctrlSetPosition [EPADD, EPADD + LINEHEIGHT, LINEWIDTH, LINEHEIGHT];
_text ctrlCommit 0;

_units = getArray(_bgCfg >> "units");
_leadUnit = _units select 0;
_leadCfg = configfile >> "cfgVehicles" >> _leadUnit;

// systemchat format[">> %1 ", _leadCfg];

_typeText = "";
if(_leadUnit iskindof "man") then
{
 _typeText = format ["%1 soldiers", count _units];
}
else
{
  _typeText = format ["%1", getText(_leadCfg >> "displayname") ];
};


_text2 = _display ctrlCreate ["RscText", -1, _cont];
_text2 ctrlSetText format["%1", _typeText];
_text2 ctrlSetPosition [EPADD, EPADD + LINEHEIGHT * 2, LINEWIDTH, LINEHEIGHT];
_text2 ctrlCommit 0;

};

selectedBattleGroups = [];

createBgPoolPanels =
{
 params ["_init"];

{
 ctrlDelete _x;
} foreach createBgPanels;
createBgPanels = [];

_availBgs = missionconfigfile >> "BattleGroups" >> "west";

numPoolPanels = 0;

for "_i" from 0 to (count _availBgs - 1) do
{
 _bgCfg = _availBgs select _i;

 [_bgCfg,2301,0,numPoolPanels] call createBGPanel;

 numPoolPanels = numPoolPanels + 1;
};

numPoolPanels = 0;
for "_i" from 0 to (count selectedBattleGroups - 1) do
{
 _bgCfg = selectedBattleGroups select _i;

 [_bgCfg,2300,numPoolPanels % 3,floor(numPoolPanels / 3)] call createBGPanel;

 numPoolPanels = numPoolPanels + 1;
};

};

call createBgPoolPanels;

selectReserveBG =
{
 params ["_bgListId","_selBgIndex"];
 //hint (str _this);

 _bgCfg = configNull;

if(_bgListId == 2301) then
{
 _availBgs = missionconfigfile >> "BattleGroups" >> "west";
 _bgCfg = _availBgs select _selBgIndex;

 selectedBattleGroups pushback _bgCfg;

 call createBgPoolPanels;
}
else
{
 
 _bgCfg = selectedBattleGroups select _selBgIndex;
};

_display = findDisplay UNITPOOLDLGID;

_bgView = _display displayCtrl 1500;

lbClear _bgView;

 _units = getArray (_bgCfg >> "units");
 _ranks = getArray (_bgCfg >> "ranks");
{
_type = _x;
_unitCfg = configfile >> "CfgVehicles" >> _type;
_rank = [_bgCfg,_foreachIndex] call getRankFromCfg;

_rankIcon = (_rank call rankToNumber) call getRankIcon;
_name = getText (_unitCfg >> "displayName");

_rowIndex = _bgView lnbAddRow ["",_name];

_bgView lnbSetPicture [[_rowIndex, 0], _rankIcon];

} foreach _units;

};



