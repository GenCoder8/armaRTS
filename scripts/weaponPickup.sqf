
getSpecialWeapons =
{

_group = group ldr;

{
_man = _x;

_itemType = (primaryWeapon _man) call BIS_fnc_itemType;
_itemType params ["_mainType","_childType"];

if(_childType == "MachineGun") then
{
};

systemchat format["%1 >> %2 %3", _x,_mainType,_childType];

} foreach (units _group);

};

findLooseWeapons =
{

_weapons = nearestObjects [getpos ldr, ["WeaponHolderSimulated","GroundWeaponHolder","Man"], 25];

{

if(_x iskindof "man" && alive _x) then { continue; }; 

systemchat format [">> %1 %2 %3", _x , typeof _x, getWeaponCargo _x ];

} foreach _weapons;

};

hasSpecialWeapon = 
{
 scopename "hasSW";
 params ["_man"];

 {
 private _weapon = _x;

 if(_weapon call isSpecialWeapon) then { true breakout "hasSW"; };

 } foreach [primaryWeapon _man, secondaryWeapon _man];

 false
};

isSpecialWeapon =
{
 params ["_weapon"];

_itemType = _weapon call BIS_fnc_itemType;
_itemType params ["_mainType","_childType"];

//systemchat format [">>>>> %1 %2 %3", _weapon, _itemType, (_childType == "RocketLauncher")];

 (_childType == "MachineGun") || (_childType == "RocketLauncher")
};

salvageWeapon =
{
 params ["_group","_fromMan","_weaponType"];

 // Must have delay or weapon holder wont exist
 sleep 1;


_getweaponHolder = objNull;
_getWeaponType = _weaponType;

// First check the man
_spesWeaps = (weapons _fromMan) select { _x call isSpecialWeapon };


// Check ground next
if(count _spesWeaps == 0) then
{

_weaponHolders = nearestObjects [_fromMan, ["WeaponHolderSimulated","GroundWeaponHolder"], 10];

if(count _weaponHolders == 0) exitWith {};

// We're looking only for special weapons
_spesWeapHolders = _weaponHolders select 
{
 _weaps = (getWeaponCargo _x) # 0;

 ({ _x call isSpecialWeapon } count _weaps) > 0
};

systemchat format ["_spesWeapHolders %1 ", _spesWeapHolders];

if(count _spesWeapHolders == 0) exitWith {};

_getweaponHolder = _spesWeapHolders # 0;

}
else
{
_getweaponHolder = _fromMan;
};

if(isnull _getweaponHolder) exitWith {};

systemchat format["WEAPON: %1 %2 ", _getWeaponType, getMagazineCargo _getweaponHolder];


missionNamespace setVariable [format["weaponRetrieved_%1", _getweaponHolder], false];

// Wait as long as there is someone able to get the weapon
while { !(missionNamespace getVariable format["weaponRetrieved_%1", _getweaponHolder]) } do
{

_candidates = (units _group) select { alive _x && canStand _x && !(_x call hasSpecialWeapon) };

if(count _candidates == 0) then { break; }; // No one left

_numRetrieving = {
_man = _x;
 
(_man getVariable ["salvaging",objNull]) == _getweaponHolder
} count _candidates;

// If no one retrieving send one
if(_numRetrieving == 0) then
{

{
private _man = _x;

//systemchat format ["))) %1 %2 ", _man, _man call hasSpecialWeapon ];

// Todo: could check closest first

if(isnull (_man getVariable ["salvaging",objNull])) then
{
 _man setVariable ["salvaging",_getweaponHolder];

  hint format["Getting weapon %1 %2 %3 %4", _man, (getposATL _getweaponHolder), _getWeaponType];


 [_man,_fromMan,_getweaponHolder,_getWeaponType] spawn
 {
  params ["_man","_fromMan","_getweaponHolder","_getWeaponType"];


  sleep 1;
  _man doMove (getposATL _getweaponHolder);

  _startTime = time;

  waitUntil { _man distance (getposATL _getweaponHolder) < 1.25 || !(alive _man) || (time - _startTime) > 60 };

  if(alive _man) then
  {
missionNamespace setVariable [format["weaponRetrieved_%1", _getweaponHolder], false];

[_fromMan,_man,_getWeaponType] call moveWeaponToMan;

// Delete weapon holders
if(typeof _getweaponHolder != "man") then
{
deleteVehicle _getweaponHolder;
};


  };

  _man setVariable ["salvaging",objNull];
 };

 break;
};

} foreach _candidates;

};

 sleep 3;
};

};

moveWeaponToMan =
{
 params ["_fromMan","_toMan","_weaponType"];

_weap = "";
 
if(_weaponType call isPrimaryWeapon) then
{
_weap = primaryWeapon _toMan;

}
else
{
_weap = secondaryWeapon _toMan;
};

systemchat format["_weap %1", _weap];

// First make some room for the new weapon
if(_weap != "") then
{
_magTypes = [_weap] call BIS_fnc_compatibleMagazines;

_mags = magazines _toMan;

{
_curMag = _x;
if((_magTypes findIf { _x == _curMag }) >= 0) then
{
 systemchat format["Removing mag..."];
 _toMan removeMagazine _x;
};
} foreach _mags;

_toMan removeWeapon _weap;
};


// Now give all weapon mags and weapon to _toMan
_magazinesAmmo = magazinesAmmo _fromMan;

_magTypes = [_weaponType] call BIS_fnc_compatibleMagazines;

{
 _x params ["_magName","_ammoCount"];

if((_magTypes findIf { _x == _magName }) >= 0) then
{
  systemchat format["Adding mag..."];

 _toMan addMagazine [_magName, _ammoCount];
 _fromMan removeMagazine _magName;
};

} foreach _magazinesAmmo;


_toMan addWeapon _weaponType;

_fromMan removeWeapon _weaponType;

};

isPrimaryWeapon =
{
 _this isKindOf ["Rifle", configFile >> "CfgWeapons"]
};

selectNewGroupLeader =
{
params ["_group"];

private _units = (units _group) select { alive _x };

private _sortedList = [_units, [], { rankId _x}, "DESCEND"] call BIS_fnc_sortBy;

private _newLeader = (_sortedList # 0);

if(leader _group != _newLeader) then
{
_group selectLeader _newLeader;
};

};

registerForWeaponSalvage =
{
 params ["_man"];

_man addEventHandler ["Killed", 
{
 _this spawn
 {
 params ["_man", "_killer", "_instigator", "_useEffects"];

 systemchat format ["Killed %1 - %2 %3", _man, primaryWeapon _man, secondaryWeapon _man];

 _group = group _man;

// Must have valid leader
if(!alive (leader _group)) then
{
 _group call selectNewGroupLeader; // Quickens leader select
};

// Make sure there is someone to pick the weapon up
if({ alive _x } count (units _group) == 0) exitWith {};

/*
waitUntil 
{
sleep 2;
alive (leader _group)
};*/

systemchat format ["ALIVE >> %1 %2", alive (leader _group), (leader _group)  ];

_weap = "";

if((primaryWeapon _man) call isSpecialWeapon) then
{
  _weap = (primaryWeapon _man);
};
if((secondaryWeapon _man) call isSpecialWeapon) then
{
 _weap = (secondaryWeapon _man);
};

if(_weap != "") then // Anything valuable to salvage?
{
 [_group, _man, _weap ] spawn salvageWeapon;
};

};

}];


};



