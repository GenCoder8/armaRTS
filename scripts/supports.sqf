

#define ARTY_Z 50

callArtilleryBarrage =
{
 params["_side","_targetPos","_deployPos","_dirFromTarget"];

_p = _deployPos;

_p = _p getpos [3000,_dirFromTarget];
/*
_marker = createMarker [format["teeeeeeeeeeest%1",_p],_p];
_marker setMarkerShape "ICON";
_marker setMarkerType "flag_un";
_marker setMarkerColor "ColorWhite";
*/
_p set [2,ARTY_Z];

_arty = [];

for "_i" from 1 to 3 do
{

_p set [0, (_p # 0) + 7 ];
_a = [_p, 0, "Uns_M114_artillery", _side] call BIS_fnc_spawnVehicle;
_art = (_a # 0);



_dir = _art getDir _targetPos;

_art setdir _dir;

_art hideObject true;

_arty pushback _art;

};

addMissionEventHandler ["EachFrame",
{

_numAlive = 0;
{
_art = _x;
if(alive _art) then
{

_art setVelocity [0,0,0];
_p = getposATL _art;
_p set [2,ARTY_Z];
_art setposATL _p;

_numAlive = _numAlive + 1;
};

} foreach (_thisArgs # 0);

if(_numAlive == 0) then
{
removeMissionEventHandler ["EachFrame",_thisEventHandler];
};

},[_arty]];



{
sleep (random 3);
_art = _x;
_art doArtilleryFire [_targetPos, "uns_30Rnd_155mmHE", 5]; // Todo ammo type
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

_planeType = selectRandom ["uns_F4J_AGM","uns_A7N_AGM"];

private _casModule = "ModuleCas_F";

_casModule = "uns_ModuleCAS";

private _moduleGroup = createGroup [sideLogic,true];   
private _unit = _casModule createUnit [
 _spos,   
 _moduleGroup,   
 format["  
this setVariable ['vehicle','%1'];    
this setVariable ['type', 4];   
this setVariable ['BIS_fnc_initModules_disableAutoActivation', false, true];",_planeType]   
];

};



