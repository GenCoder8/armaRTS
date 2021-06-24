#define GE_WIDTH  7
#define GE_HEIGHT 3



fillUnitList =
{
 params ["_ctrlGroup"];

 private _display = finddisplay 312;

 private _groups = (call getPlayerSide) call getOwnGroups;


{ ctrlDelete _x; } foreach (allControls _ctrlGroup);

_img = _display ctrlCreate ["RtsPicture", -1, _ctrlGroup];

_ctrlGroup setVariable ["background",_img];

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

_h = ctrlTextHeight _text;
_text ctrlSetPosition ([0+PADD, _ctrlsY+PADD, GE_WIDTH, ROW_HEIGHT ,false] call getGuiPos);
_text ctrlCommit 0;

_cont setVariable ["strengthText", _text];

[_cont,_group] call setStrengthText;

_ctrlsY = _ctrlsY + ROW_HEIGHT;

// Set background size
_bgr ctrlSetPosition ([0,0, GE_WIDTH+PADD*2, _ctrlsY+PADD*2 ,false] call getGuiPos);
_bgr ctrlCommit 0;

unitListGroups pushback [_cont,_group];
_con buttonSetAction format["(unitListGroups select %1) call onUnitListSelect", count unitListGroups - 1];

} foreach _groups;

call updateUnitListCtrls;

};

setStrengthText =
{
 params ["_cont","_group"];

 _text = _cont getVariable "strengthText";

 _text ctrlSetText format["%1", _group call getBattleGroupStrengthStr ];

};

updateUnitListCtrls =
{
 private _index = 0;

 {
  _x params ["_cont","_group"];

if( { alive _x} count (units _group) > 0 ) then
{

  _cont ctrlSetPosition ([0,(GE_HEIGHT + 0.05) * _index, GE_WIDTH, GE_HEIGHT ,false] call getGuiPos);
_cont ctrlCommit 0;

 _index = _index + 1;
}
else
{
 ctrlDelete _cont;
};

 } foreach unitListGroups;


_gpos = ([0,0,0,((_index + 1) * GE_HEIGHT )] call getGuiPos);

with (uinamespace) do
{

_ul = unitList;
_img = _ul getVariable "background";

_pos = ctrlPosition _ul;
_pos params ["","","_w","_h"];


// _ipos = ctrlPosition _img;

_img ctrlSetPosition [0,0,_w, _gpos # 3];
_img ctrlCommit 0;

};




};

onUnitListSelect =
{
 params ["_ctrl","_group"];

 systemchat (str _this);

_leader = leader _group;
 if(isnull _leader) exitWith {};

_cam = curatorcamera; 

_v = [nextBattleDir, 25] call getVector;
_cpos = [getpos _leader,_v] call addvector;

_cpos set [2,25];

_cam setposATL _cpos;


_cam camSetTarget _leader;
_cam camCommit 0;
_cam camSetTarget objnull;
_cam camCommit 0;

};

selectFromUnitList =
{
 
};

ulGetGroupEntry =
{
 params ["_group"];
 private _ret = [];

 { 
 if(_group == (_x # 1) ) exitWith { _ret = _x; };

} foreach unitListGroups;

_ret
};


addMissionEventHandler ["EntityKilled", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];

private _group = group _unit;
private _groups = (call getPlayerSide) call getOwnGroups;

if(!(_group in _groups)) exitWith {};

_entry = _group call ulGetGroupEntry;


_entry call setStrengthText; // Update just one


call updateUnitListCtrls; // Update all

}];


addMissionEventHandler ["GroupDeleted", {
 params ["_group"];


// hint format["DELETED %1", _group];

}];

