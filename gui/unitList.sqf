#define GE_WIDTH  7
#define GE_HEIGHT 3



fillUnitList =
{
 params ["_ctrlGroup"];

 private _display = finddisplay 312;

 private _groups = (call getPlayerSide) call getOwnGroups;


// allControls controlsGroup

//sleep 2;

{
diag_log format[">>> %1 %2 %3", _x, side _x, _x getVariable "cfg" ];
} foreach _groups;


diag_log format["----- %1 - %2", plrZeus, player];

{
diag_log format[">>> %1 %2 %3", _x, side _x, _x getVariable "cfg" ];
} foreach allgroups;


unitListGroups = [];

{
private _group = _x;

private _bgcfg = _group getVariable ["cfg",confignull];

if(isnull _bgcfg) then { continue; };

_cont = _display ctrlCreate ["RtsControlsGroupNoScrollBars", -1, _ctrlGroup];
_cont ctrlSetPosition ([0,0, GE_WIDTH, GE_HEIGHT ,false] call getGuiPos);
_cont ctrlCommit 0;

_con = _display ctrlCreate ["RtsInvisibleButton", -1, _cont];
// _con ctrlSetText format["%1",  ];
_con ctrlSetPosition ([0,0, GE_WIDTH, GE_HEIGHT ,false] call getGuiPos);
_con ctrlCommit 0;

_con setVariable ["group", _group];


_typeInfo = _bgcfg call getBattlegroupIcon;

_ctrlsY = 0;

#define ROW_HEIGHT 1
#define PADD 0.1

_bgr = _display ctrlCreate ["RscPicture", -1, _cont];
_bgr ctrlSetText format[RTSmainPath+"gui\bgPanel.jpg"];


_ico = _display ctrlCreate ["RscPicture", -1, _cont];
_ico ctrlSetText (_typeInfo # 1);
_ico ctrlSetPosition ([0+PADD+0.2,_ctrlsY+PADD, 1, ROW_HEIGHT ,false] call getGuiPos);
_ico ctrlCommit 0;

_text = _display ctrlCreate ["RtsPoolText", -1, _cont];
_text ctrlSetText format["%1", getText (_bgcfg >> "name")];
_h = ctrlTextHeight _text;
_text ctrlSetPosition ([1+PADD,_ctrlsY+PADD, GE_WIDTH, ROW_HEIGHT ,false] call getGuiPos);
_text ctrlCommit 0;

_ctrlsY = _ctrlsY + ROW_HEIGHT;

_text = _display ctrlCreate ["RtsPoolText", -1, _cont];
_text ctrlSetText format["%1", _group call getBattleGroupStrengthStr ];
_h = ctrlTextHeight _text;
_text ctrlSetPosition ([0+PADD, _ctrlsY+PADD, GE_WIDTH, ROW_HEIGHT ,false] call getGuiPos);
_text ctrlCommit 0;

_ctrlsY = _ctrlsY + ROW_HEIGHT;

// Set background size
_bgr ctrlSetPosition ([0,0, GE_WIDTH+PADD*2, _ctrlsY+PADD*2 ,false] call getGuiPos);
_bgr ctrlCommit 0;

unitListGroups pushback [_cont,_group];
_con buttonSetAction format["(unitListGroups select %1) call onUnitListSelect", count unitListGroups - 1];

} foreach _groups;

call updateUnitListCtrls;

};

updateUnitListCtrls =
{
 {
  _x params ["_cont","_group"];

  _cont ctrlSetPosition ([0,(GE_HEIGHT + 0.05) * _forEachIndex, GE_WIDTH, GE_HEIGHT ,false] call getGuiPos);
_cont ctrlCommit 0;

 } foreach unitListGroups;
};

onUnitListSelect =
{
 params ["_ctrl","_group"];
 hint (str _this);

_leader = leader _group;
 if(isnull _leader) exitWith {};

_cam = curatorcamera; 

_cam camSetTarget _leader;
_cam camCommit 0;
_cam camSetTarget objnull;
_cam camCommit 0;

// nextBattleDir

 /*
curatorcamera camPrepareTarget player; 
curatorcamera camCommitPrepared 0;  
curatorcamera camPrepareTarget objnull;
curatorcamera camCommitPrepared 0; 
*/
};

selectFromUnitList =
{

};