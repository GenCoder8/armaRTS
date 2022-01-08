
usedmod = "Vanilla";
usedDifficulty = 0;


hasMod =
{
 params ["_mod"];
 isClass (configfile >> "CfgPatches" >> _mod)
};

hasDLC =
{
 params ["_dlcId"];
 private _found = false;
 
 {
 
 if(_dlcId == _x) exitWith
 {
  _found = true;
 };
 
 } foreach (getDLCs 1);
_found
};

isModloaded =
{
 params ["_modCfg"];

 if( (configname _modCfg) == "Vanilla" ) exitWith { true };

 _dlcid = getNumber (_modCfg >> "DLCID");

 if( _dlcid > 0 ) exitWith { _dlcid call hasDLC };

 (getText (_modCfg >> "modName")) call hasMod
};



getAvailableModList =
{
private _modCfgs = missionconfigfile >> "SupportedMods";

private _list = [];

for "_i" from 0 to (count _modCfgs - 1) do
{
private _modCfg = _modCfgs select _i;

if(_modCfg call isModloaded) then
{
 _list pushback (configname _modCfg);
};

};

_list
};


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

getRtsDefs =
{
private _rtsDefs = missionconfigfile >> format["RTSDefs%1", usedmod];

 if(isnull _rtsDefs) then
 {
  ["Invalid rts defs class"] call errmsg;
 };

 _rtsDefs
};

getBattleGroupList =
{
 params ["_side","_forceClass"];

 private _sideStr = str _side; // _forceClass call getClassSideStr;

 private _bgClasses = configProperties [(_forceClass >> "ForceGroups"),"true",true];  // _forceClass >> "ForceGroups";
 private _battleGroupList = [];


private _sidesBgCfgs = (call getUsedBattlegroupsCfg) >> _sideStr;

private _difMultiplier = 0;
if((call getEnemySide) == _side) then // Only for player's enemy
{
_difMultiplier = usedDifficulty;
};

for "_i" from 0 to (count _bgClasses - 1) step 1 do
{
 private _bgEntry = _bgClasses select _i;
 private _bgcount = getNumber (_bgEntry >> "count");
 private _incPerLevel = getNumber (_bgEntry >> "perLevel");

 private _countAdd = round (_incPerLevel * _difMultiplier);

if(_bgcount > 0) then
{

 // Does battle group exist for side?
 if(isnull(_sidesBgCfgs >> (configname _bgEntry))) then
 {
  //diag_log format["skipped some '%1' %2 %3",_sideStr,_sidesBgCfgs, (configname _bgEntry)];
  continue;
 };

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
