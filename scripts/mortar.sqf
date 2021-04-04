

isMortarGroup =
{
params ["_group"];

private _gcfg = _group getVariable ["cfg",configNull];
private _mortarType = getText(_gcfg >> "mortar");

(_mortarType != "")
};


initMortarGroup =
{
  params ["_group"];

 private _gcfg = _group getVariable ["cfg",configNull];
 if(isnull _gcfg) exitWith { "" };
 private _ammoTypes = getArray (_gcfg >> "ammo");

 private _mags = [];

 {
  _mag = _x;

if(_mag != "") then
{
for "_i" from 0 to 2 do
{
  _mags pushback _mag;
};
};

 } foreach _ammoTypes;

 _group setVariable ["mortarMags", _mags ];
};

doesMortarHaveMag =
{
 params ["_group","_magType"];
 _mags = _group getVariable ["mortarMags",[]];
 _magName = ([_group,_magType] call getMortarMag);

 if(_magName == "") exitWith { false }; // If does not have _magType defined in config

 _magName in _mags
};

getMortarMag =
{
 params ["_group","_magType"];

 private _gcfg = _group getVariable ["cfg",configNull];
 if(isnull _gcfg) exitWith { "" };
 private _ammoTypes = getArray (_gcfg >> "ammo");

_useMag = _ammoTypes # 0;
if(_magType == "SMOKE") then
{
 _useMag = _ammoTypes # 1;
};

_useMag
};

setupMortar =
{
 params ["_group","_mor","_magType"];

 {
  _mor removeMagazines _x;

 } foreach (magazines _mor);


 _useMag = [_group,_magType] call getMortarMag;


 _mags = _group getVariable ["mortarMags",[]];
 _mags = _mags - [_useMag];

 
 _mor addMagazine _useMag;
 // sleep 1;
// _b = _mor setWeaponReloadingTime [gunner _mor, currentMuzzle (gunner _mor), 0.1];

// hint (str _b);

// reload _mor;

 _group setVariable ["mortarMags", _mags];

};


onArtilleryUsed = 
{
 params ["_art",["_start",false]];

  // Ned big delay for start (mag reloading)
 _art setVariable ["lastUsed", if(_start) then { time + 15 } else { time } ];

 systemchat format["Fired... %1", time];
};

isArtilleryFiring =
{
 params ["_group"];
 !isnull (_group getVariable ["art", objNull])
};


beginArtillery =
{
 params ["_group","_magType"];


private _gcfg = _group getVariable ["cfg",configNull];
private _mortarType = getText(_gcfg >> "mortar");

  // Has spawnable static weapon?
if(_mortarType == "") exitWith {};


private _pos = getposATL (leader _group);

private _art = _group getVariable ["art", objnull];

if(isnull _art) then
{
systemchat "New arty...";

//_sveh = [_pos, 0, "B_Mortar_01_F", _group] call BIS_fnc_spawnVehicle;
//_sveh params ["_veh", "_crew", "_group"];
//_art = _veh;

_art = _mortarType createVehicle _pos;

(leader _group) moveingunner _art;

_art setposATL _pos;




_group setVariable ["art", _art];


[_group,_art,_magType] call setupMortar;


_art addEventHandler ["Fired", 
{
params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

_unit call onArtilleryUsed;
}];

[_art,true] call onArtilleryUsed; // Need var to be ready

[_art] spawn
{
 params ["_art"];

 waituntil 
 { 
  sleep 2; 
  if(isnull _art) exitWith { true };

  (time - (_art getVariable "lastUsed")) > 5 
 };

if(!isnull _art) then
{
 systemchat "Cleaning up artillery";

 _art call exitStaticWeapon;
 };
};


}
else
{
 systemchat "Arty exists";
};

/*
 systemchat format["art %1", _art];

_art call onArtilleryUsed;

_targ = getmarkerpos "tr";
_targ set [2,0];

( _art) doArtilleryFire [_targ, "8Rnd_82mm_Mo_shells", 5];
*/

};




exitStaticWeapon =
{
 params ["_tur"];

 {
 moveout _x
 } foreach (crew _tur);

 deletevehicle _tur;

};

groupExitStaticWeapons =
{
 params ["_group"];

 private _vehs = _group call getVehicles;
 {
  if(_x iskindOf "StaticWeapon") then
{
 _x call exitStaticWeapon;
};

 } forEach _vehs;
};
