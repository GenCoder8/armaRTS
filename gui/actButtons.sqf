

isUsingActionButton =
{
 (call isMouseClickAction) || specialMove != ""
};


canSetFormationDir =
{
 (call anythingSelected)
};

beginNewFormationDir =
{
 "setFormDir" call setSpecialMove;
};

canSetGroupStance =
{
 (call anythingSelected)
};

changeGroupStance =
{
params ["_dir"];

private _groups = curatorSelected # 1;

_group = _groups # 0;


_curStance = toupper (unitPos (leader _group));

_stances = ["DOWN","MIDDLE","UP"];

_index = _stances find _curStance; // -1 if auto


_index = _index + _dir;

if(_index < 0) exitWith {};
if(_index >= (count _stances)) exitWith {};


_newStance = _stances # _index;

//hint format[" %1 %2 ",_newStance, _index ];

{

_x setUnitPos _newStance;

} foreach (call getSelectedInfantry);

};

getSelectedInfantry =
{
 (curatorSelected # 0) select { !(_x call inVehicle) }
};