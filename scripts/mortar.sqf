




onArtilleryUsed = 
{
 params ["_art"];

 _art setVariable ["lastUsed", time];

 systemchat format["Fired... %1", time];
};




beginArtillery =
{
 params ["_group"];

private _pos = getposATL (leader _group);

private _art = _group getVariable ["art", objnull];

if(isnull _art) then
{
systemchat "New arty...";

//_sveh = [_pos, 0, "B_Mortar_01_F", _group] call BIS_fnc_spawnVehicle;
//_sveh params ["_veh", "_crew", "_group"];
//_art = _veh;

_art = "B_Mortar_01_F" createVehicle _pos;

(leader _group) moveingunner _art;

_art setposATL _pos;




_group setVariable ["art", _art];


_art addEventHandler ["Fired", 
{
params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

_unit call onArtilleryUsed;
}];

_art call onArtilleryUsed; // Need var to be ready

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
