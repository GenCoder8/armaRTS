

#define ARTY_Z 50

setObjAboveSurface =
{
 params ["_obj","_z"];

 private _p = getposATL _obj;

 _p set [2, _z];

 if(surfaceIsWater _p) then
 {
  _obj setPosASL _p;
 }
 else
 {
  _obj setPosATL _p;
 };

};

callArtilleryBarrage =
{
 params["_side","_targetPos","_deployPos","_dirFromTarget"];

_p = _deployPos;

_p = _p getposATL [3000,_dirFromTarget];
/*
_marker = createMarker [format["teeeeeeeeeeest%1",_p],_p];
_marker setMarkerShape "ICON";
_marker setMarkerType "flag_un";
_marker setMarkerColor "ColorWhite";
*/
_p set [2,100000]; // Create on high

_arty = [];

_artyType = getText ((call getRtsDefs) >> "artyPiece");

for "_i" from 1 to 3 do
{

_p set [0, (_p # 0) + 7 ];
_a = [_p, 0, _artyType, _side] call BIS_fnc_spawnVehicle;
_art = (_a # 0);

[_art,ARTY_Z] call setObjAboveSurface;

_dir = _art getDir _targetPos;

_art setdir _dir;

_art hideObject true;

_arty pushback _art;

};

// Keep arty in air
addMissionEventHandler ["EachFrame",
{

_numAlive = 0;
{
_art = _x;
if(alive _art) then
{

_art setVelocity [0,0,0];

[_art,ARTY_Z] call setObjAboveSurface;

_numAlive = _numAlive + 1;
};

} foreach (_thisArgs # 0);

if(_numAlive == 0) then
{
removeMissionEventHandler ["EachFrame",_thisEventHandler];
};

},[_arty]];


_artyAmmo = getText ((call getRtsDefs) >> "artyAmmo");

{
sleep (random 3);
_art = _x;
_art doArtilleryFire [_targetPos, _artyAmmo, 5];

/*systemchat format ["ARTY firing > %1 %2 %3 (%4)",_art, _art distance _targetPos, _artyAmmo,  
_targetPos inRangeOfArtillery [[_art], _artyAmmo]];*/

} foreach _arty;

_art = _arty # 0;
_art setVariable ["lastFired", time];

_art addEventHandler ["Fired", 
{
params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

_unit setVariable ["lastFired", time];

}];

waituntil { sleep 1; (time - (_art getVariable "lastFired")) > 10 };

//hint "Deleting...";

{
_art = _x;
{_art deleteVehicleCrew _x} forEach crew _art;
deleteVehicle _art;
} foreach _arty;

};

activateSupportArtillery =
{
 params ["_spos"];

 [call getPlayerSide,_spos,markerpos nextBattleMap,nextBattleDir] spawn callArtilleryBarrage;
};

activateSupportCas =
{

_planeType = selectRandom (getArray ((call getRtsDefs) >> "casPlanes"));

private _casModule = "ModuleCas_F";
private _casweapType = 1;

// Unsung has it's own CAS module
if(usedmod == "Unsung") then
{
_casModule = "uns_ModuleCAS";
_casweapType = 4;
};

private _moduleGroup = createGroup [sideLogic,true];   
private _unit = _casModule createUnit [
 _spos,   
 _moduleGroup,   
 format["  
this setVariable ['vehicle','%1'];    
this setVariable ['type', %2];   
this setVariable ['BIS_fnc_initModules_disableAutoActivation', false, true];",_planeType,_casweapType]   
];

};



