

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

setGroupStance =
{
private _groups = curatorSelected # 1;

_group = _groups # 0;


_curStance = toupper (unitPos (leader _group));

_stances = ["DOWN","MIDDLE","UP"];

_index = _stances find _curStance; // -1 if auto


_index = _index + 1;
if(_index >= (count _stances)) then { _index = 0; };

_newStance = _stances # _index;

//hint format[" %1 %2 ",_newStance, _index ];

{

if(!(_x call inVehicle)) then
{
_x setUnitPos _newStance;
};

} foreach (curatorSelected # 0);

};