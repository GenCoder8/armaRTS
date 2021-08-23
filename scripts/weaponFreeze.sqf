
freezeWeapon =
{
params ["_man"];

if(_man getVariable ["weaponJammed",false]) exitWith {};

_man setVariable ["weaponJammed",true];

private _stance = stance _man;
//private _upos = unitPos _man;
private _anim = "WeaponMagazineReloadStand";

_man disableAI "ANIM";

sleep 1.25;

// Don't allow standing and working with the weapon
if(_stance == "STAND") then
{
 //_man setUnitPos "MIDDLE";

_man playAction "Crouch";

 sleep 1;
};


_stance = stance _man;

if(_stance == "crouch") then {
_anim = "WeaponMagazineReloadKneel"; };

if(_stance == "prone") then {
_anim = "WeaponMagazineReloadProne"; };

private _freezeTime = time + 5 + random 15;

while { _freezeTime > time && alive _man } do
{
_man switchMove _anim;

 sleep 4;
};

_man enableAI "ANIM";
_man setVariable ["weaponJammed",false];
//_man setUnitPos _upos; // Set back to what it was

};

handleAiFire =
{
 params ["_man", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

// Exclude vehicle turret gunners
if((_man call inVehicle) && !(_man call inVehShootingPos)) exitWith {};


if((_man getVariable ["currentWeaponName", ""]) != _weapon) then
{

_itemType = _weapon call BIS_fnc_itemType;
_itemType params ["_mainType","_childType"];

_canJam = false;
_jamChange = 0;

{
 _x params ["_change","_weapTypes"];

 _canJam = [_childType,_weapTypes] call isStrInArray;
 if(_canJam) then
 {
  _jamChange = _change;
  break;
 };

} foreach [
[0.05,["AssaultRifle","Handgun","MachineGun","SubmachineGun"]],
[0.02,["Handgun","Rifle","SniperRifle","Shotgun"]]
];

_man setVariable ["currentWeaponName", _weapon];
_man setVariable ["currentWeaponStat", [_canJam,_jamChange] ];

};

(_man getVariable "currentWeaponStat") params ["_canJam","_jamChange"];

if(_canJam && random 1 < _jamChange) then
{
systemchat format["Freezing: %1 %2 %3", _childType, _canJam, _jamChange];

 _man spawn freezeWeapon;
};

};

registerForWeaponFreeze =
{
params ["_man"];

_man addEventHandler ["Fired", 
{
 _this call handleAiFire;
}];

};

