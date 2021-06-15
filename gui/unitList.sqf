#define GE_WIDTH  6
#define GE_HEIGHT 3



fillUnitList =
{
 params ["_ctrlGroup"];

 private _display = finddisplay 312;

 private _groups = (call getPlayerSide) call getOwnGroups;

hint (str _groups);

// allControls controlsGroup



unitListGroups = [];

{
_group = _x;

_con = _display ctrlCreate ["RtsInvisibleButton", -1, _ctrlGroup];
_con ctrlSetText format["%1", _group];
_con ctrlSetPosition ([0,0, GE_WIDTH, GE_HEIGHT ,false] call getGuiPos);
_con ctrlCommit 0;

_con setVariable ["group", _group];

unitListGroups pushback [_con,_group];
_con buttonSetAction format["(unitListGroups select %1) call onUnitListSelect", count unitListGroups - 1];

} foreach _groups;

call updateUnitListCtrls;

};

updateUnitListCtrls =
{
 {
  _x params ["_con","_group"];

  _con ctrlSetPosition ([0,(GE_HEIGHT + 0.05) * _forEachIndex, GE_WIDTH, GE_HEIGHT ,false] call getGuiPos);
_con ctrlCommit 0;

 } foreach unitListGroups;
};

onUnitListSelect =
{
 hint (str _this);
};

selectFromUnitList =
{

};