

isMortarGroup =
{
params ["_group"];

private _gcfg = _group getVariable ["cfg",configNull];
private _mortarType = getText(_gcfg >> "mortar");

(_mortarType != "")
};

isVehicleGroup =
{
params ["_group"];

private _gcfg = _group getVariable ["cfg",configNull];
private _units = getArray(_gcfg >> "units");

 !((_units # 0) iskindOf "Man")
};


initMortarGroup =
{
  params ["_group"];

 private _gcfg = _group getVariable ["cfg",configNull];
 if(isnull _gcfg) exitWith { "" };
 private _ammoTypes = getArray (_gcfg >> "ammo");

 private _mags = [];

 {
  private _mag = _x;

if(_mag != "") then
{
for "_i" from 1 to 2 do
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
 params ["_group","_mor","_magType","_targetPos"];

 {
  _mor removeMagazines _x;

 } foreach (magazines _mor);


 _useMag = [_group,_magType] call getMortarMag;


 _mags = _group getVariable ["mortarMags",[]];


 _magIndex = _mags find _useMag;
 if(_magIndex < 0) exitWith { "Could not get mortar magazine" call errmsg; };
 _mags deleteAt _magIndex;


 _mor addMagazine _useMag;

 _mor setVariable ["startingAmmo", _mor ammo currentMuzzle (gunner _mor)]; // To check if fired at all

/*
[_mor,_useMag] spawn
{
params ["_mor","_useMag"];
sleep 0.1;
_mor loadMagazine [[0], currentMuzzle (gunner _mor), _useMag];
reload (gunner _mor);
_b = _mor setWeaponReloadingTime [gunner _mor, currentMuzzle (gunner _mor), 0.01];
};


_isInRange = _targetPos inRangeOfArtillery [[_mor], _useMag];
hint format ["in range: %1", _isInRange];
*/
 // sleep 1;


// hint (str _b);

// reload _mor;

 _group setVariable ["mortarMags", _mags];

};

getMortarAmmoLeft =
{
 params ["_group"];

 private _mor = _group getVariable ["art", objnull];
 if(isnull _mor) exitWith { 0 };


 private _ammo = 0;

 private _cmags = magazinesAmmo _mor;
 if(count _cmags > 0) then
 {
 
 private _curMag = _cmags # 0; // currentMagazine ?
  _ammo = _ammo + (_curMag # 1);


 // Count only same mags as currently loaded one
 private _mags = _group getVariable ["mortarMags",[]];


 {
  if(_x == (_curMag # 0)) then
  {
   _ammo = _ammo + (getNumber (configfile >> "cfgMagazines" >> (_curMag # 0) >> "count"));
  };
 } foreach _mags; 

 };


 _ammo
};

getMortarAmmoInfo =
{
params ["_group"];

if(!(_group call isMortarGroup)) exitWith { "" };

private _text = "";

 private _gcfg = _group getVariable ["cfg",configNull];
 if(isnull _gcfg) exitWith { "" };

_text = getText(configfile >> "cfgVehicles" >> (getText (_gcfg >> "mortar")) >> "displayName") + " - ";


private _mor = _group getVariable ["art", objnull];
if(!isnull _mor && count (magazines _mor) > 0 ) then // Must have mag loaded for this
{
private _ammo = _group call getMortarAmmoLeft;
_text = _text + format ["%1 %2 rounds",_ammo,  (getText (configfile >> "cfgMagazines" >> (currentMagazine _mor) >> "displayName"))  ];
}
else
{

 private _mags = _group getVariable ["mortarMags",[]];
 private _hash = createHashMap;

  // Count mags
 {

  private _mname = _x; //(getNumber (configfile >> "cfgMagazines" >> _x >> "name"));

  private _entry = _hash getOrDefault [_mname, 0];
   
   _hash set [_mname, _entry + 1 ];
  
 } foreach _mags;

 _text = _text + " Ammo: ";
 {
  private _name = (getText (configfile >> "cfgMagazines" >> _x >> "displayName"));
  _text = _text + format["%1 x %2 ",_name, _y];
 } forEach _hash;

 //_text = format ["%1", _list  ];
};

_text
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
 params ["_group","_magType","_targetPos"];


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


[_group,_art,_magType,_targetPos] call setupMortar;


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

 _ammo = _art getVariable ["startingAmmo", 0];

 if(_ammo == (_art ammo currentMuzzle (gunner _art))) then
{
 hint "Mortar failed to fire"; // Todo msg
};

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
