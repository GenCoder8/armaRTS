
usedmod = "";

getUsedForceRosterCfg =
{
 private _ufr = missionconfigfile >> format["ForceRosters%1",usedmod];

 if(isnull _ufr) then
 {
  ["Invalid forceRoster class"] call errmsg;
 };

 _ufr
};

getUsedBattlegroupsCfg =
{
private _ubgs = missionconfigfile >> format["BattleGroups%1", usedmod];

 if(isnull _ubgs) then
 {
  ["Invalid battlegroups class"] call errmsg;
 };

 _ubgs
};

getBattleGroupList =
{
 params ["_side","_forceClass"];

 private _sideStr = str _side; // _forceClass call getClassSideStr;

 private _bgClasses = _forceClass >> "ForceGroups";
 private _battleGroupList = [];

diag_log format ["_bgClasses_bgClasses_bgClasses '%1'  %2 ", _bgClasses, count _bgClasses ];

private _sidesBgCfgs = (call getUsedBattlegroupsCfg) >> _sideStr;

for "_i" from 0 to (count _bgClasses - 1) step 1 do
{
 private _bgEntry = _bgClasses select _i;
 private _bgcount = getNumber (_bgEntry >> "count");



if(_bgcount > 0) then
{
/*
 // Does battle group exist for side?
 if(isnull(_sidesBgCfgs >> (configname _bgEntry))) then
 {
  diag_log format["skipped some '%1' %2 %3",_sideStr,_sidesBgCfgs, (configname _bgEntry)];
  continue;
 };*/

 _battleGroupList pushback (configname _bgEntry);
 _battleGroupList pushback _bgcount;
};

};

 _battleGroupList
};

getClassSideStr =
{
 params ["_class"];

 private _side = inheritsFrom _class;

 _sideStr = configname _side;

 _sideStr
};
