

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

if(_index == -1) then
{
_index = 2;
if(_dir > 0) then { _index = 1; }; // Fix for auto and up dir
};

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

isInfantrySelected =
{
 private _groups = curatorSelected # 1;
 if(count _groups == 0) exitWith { false };

 ({!(_x call isVehicleGroup)} count _groups) > 0
};


conditionThrowSmoke =
{
 private _inf = call getSelectedInfantry;
 if(count _inf == 0) exitWith { false };

 
/// (_inf # 0) addMagazine "uns_m18red";

 private _th = [_inf] call getSmokeThrower;
 !isnull _th
};

actionThrowSmoke =
{
 "throwSmoke" call setSpecialMove;
};

anyoneThrowSmoke =
{
 params ["_targetPos"];
 private _inf = call getSelectedInfantry;


 private _th = [_inf] call getSmokeThrower;

 #define MAX_GRENADE_THROW_DIST 50

 _dist = _targetPos distance2D _th;
 if(_dist > MAX_GRENADE_THROW_DIST) then { _dist = MAX_GRENADE_THROW_DIST; };

 private _a = [getpos _th, _targetPos] call getAngle;
 private _vec = [_a,_dist] call getVector;

 private _tpos = [getpos _th,_vec] call addvector;
 _tpos set [2,0];

 [_th, _tpos ] spawn throwSmoke;
};
