
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
 params ["_forceClass"];

 private _bgClasses = _forceClass >> "battleGroups";
 private _battleGroupList = [];

for "_i" from 0 to (count _bgClasses - 1) step 1 do
{
 private _bgEntry = _bgClasses select _i;
 private _bgcount = getNumber (_bgEntry >> "count");

if(_bgcount > 0) then
{
 _battleGroupList pushback (configname _bgEntry);
 _battleGroupList pushback _bgcount;
};

};

 _battleGroupList
};