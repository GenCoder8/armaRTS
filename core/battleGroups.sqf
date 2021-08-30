
#define SURRENDER_DIST 100

unitHighlights = [];

registerBattleGroup =
{
 params ["_group"];

 _bgSide = side _group;

if(_group call isMortarGroup) then
{
 _group call initMortarGroup;
};

// Player controls the behavior
if(_bgSide == (call getPlayerSide)) then
{
_group enableAttack false;
};


 private _gcfg = _group getVariable ["cfg",configNull];
 private _icon = _gcfg call getBattlegroupIcon;

 _group setVariable ["bgIcon", _icon ];

_group spawn
{
 params ["_group"];

while { !isnull _group } do
{
 _wps = waypoints _group;

if(count _wps > 0) then
{
 _lastWp = _wps select (count _wps - 1);


if(!(_group getVariable ["wpArrived",false])) then
{
if((waypointPosition _lastWp) distance2D (leader _group) < 10) then
{
  // hint "ARRIVED";

 _group setVariable ["wpArrived",true];

if(_group getVariable ["manBuildings",false]) then
{

[_group,(waypointPosition _lastWp)] call groupLocationSet;
};

};
};

};

 sleep 2;
};
};

_group spawn
{
 params ["_group"];

while { !isnull _group } do
{

 // Check for surrender
 private _didSurrender = false;
 {
 private _man = _x;
 if(!(_man call inVehicle)) then // Only for infantry using this instead of getGroupInfantry because we dont want parachuting guys
 {
 if(fleeing _man && !captive _man && alive _man) then
 {
  //if(([_group call getGroupPos,_side,200] call isEnemyNear)) then // Only surrender if enemies near
  //{
  private _ls = lifeState _man;
  if(!(_ls in ["INCAPACITATED","INJURED"])) then
  {
  private _ne = _man findNearestEnemy _man; 
  if(!isnull _ne) then
  {
   if(_ne distance _man < SURRENDER_DIST) then
   {
    _man call surrenderAI;
	_didSurrender = true;
   };
  };
  };
  //};
 };
 };
 } foreach (units _group);

 sleep 3;
};

};

// Reg player groups for zeus
if(_bgSide == (call getPlayerSide)) then
{
 plrZeus addCuratorEditableObjects [units _group, false];


};

};

onNewMove =
{
 params ["_group","_isAttack"];

 _group setVariable ["manBuildings",!_isAttack];

 _group setVariable ["wpArrived",false];

 // todo: _group enableAttack true;

 _group call resetUnitScripts;
};

groupLocationSet =
{
 params ["_group","_pos"];
 // Todo if leader not ok?
 //[_group,_pos,15,formationDirection (leader _group),true,100,100] call manBuildings;
};

getBattlegroupIcon =
{
 params ["_bgcfg"];

private _units = getArray(_bgCfg >> "units");
private _leadUnit = _units select 0;

 private _isMan = (_leadUnit iskindof "man");

 private _name = getText(_bgcfg >> "name");

 private _icon = switch (true) do
 {
  case ( !isnull(_bgCfg >> "mortar")  ): { ["Mortar","a3\ui_f\data\map\markers\nato\b_mortar"] };
  case ("Anti tank" in _name): { ["Anti tank",getMissionPath (RTSmainPath + "gui\images\b_at.paa")] };
  case ("Machine gun" in _name): { ["Machine gun",getMissionPath (RTSmainPath + "gui\images\b_mg.paa")] }; // hacky, todo
  case ("HQ" in _name): { ["Headquarters","a3\ui_f\data\map\markers\nato\b_hq.paa"] }; // hacky, todo
  case ("Recon" in _name): { ["Recon","a3\ui_f\data\map\markers\nato\b_recon.paa"] }; // hacky, todo
  case (_isMan && count _units <= 3): { ["Support","a3\ui_f\data\map\markers\nato\b_support.paa"] }; //  sniper....
  case _isMan: { ["Infantry","a3\ui_f\data\map\markers\nato\b_inf.paa"] };
  case ( _leadUnit iskindof "tank"): { ["Armor","a3\ui_f\data\map\markers\nato\b_armor.paa"] };
  case ( _leadUnit iskindof "truck_f"): { ["Truck","a3\ui_f\data\map\markers\nato\b_motor_inf.paa"] };
  case ( [_leadUnit,"APC"] call checkForvehType ): { ["APC","a3\ui_f\data\map\markers\nato\b_mech_inf.paa"] };
  default { ["Unknown bg type '%1'", configname _bgcfg ] call errmsg; ["","a3\ui_f\data\map\markers\nato\b_unknown"] };
 };

  _icon
};

getBattleGroupStrengthStr =
{
params ["_group"];

format[ "%1 men",  ({ alive _x } count (units _group))];

};

getBattleGroupSecWeapInfo =
{
 params ["_group"];


private _secPic = "";
private _secStr = "";

if(_group call isMortarGroup) then 
{
 //(_group call getMortarAmmoInfo)

private _gcfg = _group getVariable ["cfg",configNull];
private _mortarType = getText(_gcfg >> "mortar");
private _mcfg = configfile >> "CfgVehicles" >> _mortarType;
_secPic = getText (_mcfg >> "picture");
_secStr = getText (_mcfg >> "displayName");
}
else
{

_sec = "";

 {
  _man = _x;
  if(secondaryWeapon _man != "") then
{
 _sec = secondaryWeapon _man;
};
 } foreach (units _group select { alive _x });


if(_sec != "") then
{
 _secPic = gettext (configfile >> "cfgweapons" >> _sec >> "picture");
 _secStr = gettext (configfile >> "cfgweapons" >> _sec >> "displayName");

};

};



[_secPic,_secStr]
};

getBattleGroupPriWeapInfo =
{
 params ["_group"];

private _totalMags = 0;

{
private _man = _x;

if((_man call inVehicle) && !(_man call inVehShootingPos)) then { continue; };

private _mags = magazines _man;

private _magTypes = [primaryWeapon _man] call BIS_fnc_compatibleMagazines;

private _numMags = { _magName = _x; ((_magTypes findIf { _x == _magName }) >= 0)  } count _mags;

_totalMags = _totalMags + _numMags;

} foreach ((units _group) select { alive _x });

[str _totalMags,str _totalMags]
};

getBattleGroupAmmoText =
{
 params ["_group"];

if(_group call isMortarGroup) exitWith 
{
 ([_group,false] call getMortarAmmoInfo)
};


_sec = "";
_totalAmmo = 0;

 {
  _man = _x;
  if(secondaryWeapon _man != "") then
{
 _sec = secondaryWeapon _man;
 _totalAmmo = _totalAmmo + (_man ammo _sec);
};
 } foreach (units _group select { alive _x });


if(_sec != "") then
{
 _sec = format["%1", _totalAmmo];
};

_sec
};