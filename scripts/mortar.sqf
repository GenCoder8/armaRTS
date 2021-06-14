

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
 private _maxAmmo = 0;

 {
  private _mag = _x;
  _maxAmmo = getNumber(configfile >> "CfgMagazines" >> _mag >> "count"); // Assumes all mags are same size

if(_mag != "") then
{
for "_i" from 1 to 2 do
{
  _mags pushback [_mag,_maxAmmo];
};
};

 } foreach _ammoTypes;

 diag_log format["MAGS: %1", _mags];

 _group setVariable ["mortarMags", _mags ];
 _group setVariable ["mortarMaxAmmo", _maxAmmo ];
};

doesMortarHaveMag =
{
 params ["_group","_fireType"];
 _mags = _group getVariable ["mortarMags",[]];
 _magName = ([_group,_fireType] call getMortarMagType);

 if(_magName == "") exitWith { false }; // If does not have _fireType defined in config

 private _index = [_group,_fireType] call getNextMagIndex;

 _index >= 0
};

getMortarMagType =
{
 params ["_group","_fireType"];

 private _gcfg = _group getVariable ["cfg",configNull];
 if(isnull _gcfg) exitWith { "" };
 private _ammoTypes = getArray (_gcfg >> "ammo");

_useMag = _ammoTypes # 0;
if(_fireType == "SMOKE") then
{
 _useMag = _ammoTypes # 1;
};

_useMag
};

getNextMagIndex = 
{
 params ["_group","_fireType"];
 private _magName = [_group,_fireType] call getMortarMagType;

 private _mags = _group getVariable "mortarMags";
 private _index = _mags findif { (_x # 0) == _magName };

 _index
};

getNextUsedMag =
{
 params ["_group","_fireType"];
 private _index = [_group,_fireType] call getNextMagIndex;

 if(_index < 0) exitWith { [] };

  private _mags = _group getVariable "mortarMags";

 _mags # _index
};

setupMortar =
{
 params ["_group","_mor","_magType","_targetPos"];

 {
  _mor removeMagazines _x;

 } foreach (magazines _mor);

_weap = currentweapon _mor;

_mor removeWeapon _weap;

 //_useMag = [_group,_magType] call getMortarMagType;

 _mor setVariable ["firingType", _magType];

 _nextMag = [_group,_magType] call getNextUsedMag;

 _mor addMagazine [_nextMag # 0, _nextMag # 1];

 _mor addweapon _weap;


 _mor setVariable ["startingAmmo", _mor ammo currentMuzzle (gunner _mor)]; // To check if fired at all

 _mor setVariable ["fireSucceed",false];

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



};

getMortarAmmoLeft =
{
 params ["_group","_fireType"];

 //private _mor = _group getVariable ["art", objnull];
 //if(isnull _mor) exitWith { 0 };


 private _ammo = 0;


 // Count only same mags as currently loaded one
 private _mags = _group getVariable ["mortarMags",[]];
 //private _fireType = _mor getVariable "firingType";

private _magType = [_group,_fireType] call getMortarMagType;

 {

  if((_x # 0) == _magType) then
  {
   _ammo = _ammo + (_x # 1);
  };
 } foreach _mags; 


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


{

private _ammo = [_group,_x] call getMortarAmmoLeft;

_text = _text + format ["%1 %2 ", _ammo, _x];

} foreach ["HE","Smoke"];

/*
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

  private _mname = _x # 0; //(getNumber (configfile >> "cfgMagazines" >> _x >> "name"));

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
*/
_text
};

onArtilleryUsed = 
{
 params ["_art",["_start",false]];

  // Ned big delay for start (mag reloading)
 _art setVariable ["lastUsed", if(_start) then { time + 10 } else { time + 5 } ];

 //systemchat format["Fired... %1", time];
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
//systemchat "New arty...";

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

_mor = _unit;

/*
if(!(_mor getVariable ["fireSucceed",false])) then
{
// Remove one mag
_group = group _gunner;
 _mags = _group getVariable ["mortarMags",[]];

_useMag = (magazines _mor) # 0; // Get the type of one and only mag

 _magIndex = _mags find _useMag;
 if(_magIndex < 0) exitWith { "Could not get mortar magazine" call errmsg; };
 _mags deleteAt _magIndex;
 _group setVariable ["mortarMags", _mags];

// systemchat format["MAG REMOVE %1 %2 %3", _group,  _magIndex, _useMag];
};*/

_group = group _gunner;
_fireType = _mor getVariable "firingType";
_nextMag = [_group,_fireType] call getNextUsedMag;
// Sub one
_nextMag set [1,(_nextMag # 1) - 1];
if((_nextMag # 1) <= 0) then
{
 private _index = [_group,_fireType] call getNextMagIndex;
 private _mags = _group getVariable ["mortarMags",[]];
 _mags deleteAt _index;
};

_mor setVariable ["fireSucceed",true];

_unit call onArtilleryUsed;
}];

[_art,true] call onArtilleryUsed; // Need var to be ready

[_art,_group] spawn
{
 params ["_art","_group"];

 waituntil 
 {
  sleep 2; 
  if(isnull _art) exitWith { true };

  (time - (_art getVariable "lastUsed")) > 0 
 };

if(!isnull _art) then
{

// Repack mags
private _mags = _group getVariable ["mortarMags",[]];
_mags = [_mags,  _group getVariable "mortarMaxAmmo" ] call packMags;
_group setVariable ["mortarMags",_mags];

 diag_log format["exit MAGS: %1", _mags];

// _ammo = _art getVariable ["startingAmmo", 0];


 systemchat format["Cleaning up artillery "];


if( !(_art getVariable ["fireSucceed",false]) ) then
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



packMags =
{
params ["_magArray","_max"];
private _totalAmmo = createHashmap;

{
 _x params ["_name","_count"];

 _c = _totalAmmo getorDefault [_name,0];

 _totalAmmo set [_name, _c + _count ];

} foreach _magArray;

//systemchat format ["%1",_totalAmmo];

private _ret = [];
{
_name = _x;
_count = _y;

while { _count > 0 } do
{
 _give = _max;
 if(_count < _give) then { _give = _count; };
 _ret pushback [_name,_give];

 _count = _count - _give;
};

} foreach _totalAmmo;

//systemchat format ["%1",_ret];

_ret
};


