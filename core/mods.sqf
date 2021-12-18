
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

