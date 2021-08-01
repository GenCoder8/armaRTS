
traitRecon =
{
 params ["_man"];

_man setUnitTrait ["loadCoef", 0.2];
_man spawn { params ["_man"]; sleep 1; _man setfatigue 0; }; // Need delay

};

traitSniper =
{
 params ["_man"];

_man setskill 1;

};

applyGroupTraits =
{
params ["_man","_bgcfg"];

private _traits = getArray(_bgcfg >> "traits");

{
 private _traitName = _x;

 private _traitCls = missionConfigFile >> "BattleGroupTraits" >> _traitName;

 private _tfn = getText (_traitCls >> "fn");

 _man call (missionnamespace getVariable [_tfn,{}]);

} foreach _traits;


};

getTraitDescs = 
{
params ["_bgcfg"];

private _traits = getArray(_bgcfg >> "traits");

private _ret = "";

{
 private _traitName = _x;

 private _traitCls = missionConfigFile >> "BattleGroupTraits" >> _traitName;

 _ret = _ret + getText (_traitCls >> "description");

} foreach _traits;

_ret
};