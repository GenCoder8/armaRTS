
getGrenadeMuzzle =
{
params ["_mag"];
_mag = tolower _mag;

_throws = configfile >> "CfgWeapons" >> "Throw";
private _ret = "";

for "_i" from 0 to (count _throws - 1) do
{
 _th = _throws select _i;
 if(!isclass _th) then { continue; };

 _mags = getArray(_th >> "magazines");

if(_mags findIf { (tolower _x) == _mag } >= 0 ) then
{
 _ret = configname _th;
};

};

_ret
};

getSmokeGrenades =
{
params ["_man"];

private _mags = magazines _man;

private _listSmokes = [];
{
private _grecfg = configfile >> "CfgMagazines" >> _x;

private _dname = tolower gettext(_grecfg >> "displayName");

if("smoke" in _dname) then
{
 _listSmokes pushback _x;
};


} foreach _mags;


_listSmokes
};

throwSmoke =
{
params ["_man","_targetPos"];
_nades = _man call getSmokeGrenades;

diag_log format[">>>>>>>>>>>>>>>>> %1 %2", _man,_nades];

_nmag = _nades # 0;

_muzzle = _nmag call getGrenadeMuzzle;
if(_muzzle == "") exitWith { ["Error finding grenade muzzle '%1'", _nmag] call errmsg; };


_man setVariable ["throwingGrenade", _nmag ];
_man setVariable ["targetPos", _targetPos ];

_man addEventHandler ["Fired", 
{
params ["_man", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

if((_man getVariable "throwingGrenade") != _magazine) exitWith {};

_man removeEventHandler ["Fired", _thisEventHandler];

[_projectile, _man getVariable "targetPos"] spawn
{
params ["_projectile","_targetPos"];
_projectile setposATL [0,0,100000];
//sleep 1;
_targetPos set [2,20]; // Fall so dont go inside buildings
_projectile setposATL _targetPos;
};

}];


_man lookAt _targetPos;

sleep 2;

_man forceWeaponFire [_muzzle,_muzzle];


};

getSmokeThrower =
{
 params ["_men"];
 private _ret = objNull;

 {

 private _nades = _x call getSmokeGrenades;
 if(count _nades > 0) exitWith
{
 _ret = _x;
};

 } foreach _men;

 _ret
};