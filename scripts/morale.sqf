#include "..\main.h"

#define HIGHEST_RANK 4
#define MAX_EFFECT_DIST 100
#define MORALE_MULTIPLIER  0.5   // Best possible morale increase per group
#define MAX_COURAGE 0.95



addMissionEventHandler ["Draw3D", 
{

if(!(DBGL_MORA call isDebugLevel)) exitWith
{
 
removeMissionEventHandler ["Draw3D", _thisEventHandler];
};

{
_group = _x;


	drawIcon3D 
	[
		"",
		[0,0,1,1],
		getposAsl (leader _group),
		1,
		1,
		0,
		format["Morale: %1", _group getVariable ["fleeingValue","mor not set"] ],
		0,
		0.1,
		"PuristaMedium",
		"center",
		true
	];

} foreach allgroups;

}];



[] spawn
{
while { true } do
{

{
 _side = _x;
_sideGroups = allgroups select { side _x == _side && !isPlayer (leader _x) };

{
_group = _x;
_friendlies = _sideGroups - [_group];
_ldr = leader _group;

_totalEffect = 0;

{
 _friendly = _x;
 _fldr = (leader _friendly);
 _rankIndex = rankid _fldr;

 _rankEffect = _rankIndex / HIGHEST_RANK;

 _dist = (_fldr distance _ldr);
 _effectDist = 1;
 if(_dist > 0) then
 {
 _effectDist = MAX_EFFECT_DIST / _dist;
 }
 else
 {
  ["Invalid leaders? %1 <> %2", _fldr, _ldr] call dbgmsg;
 };

 if(_effectDist > 1) then { _effectDist = 1; };

 [DBGL_MORA,"e: %1 %2", _rankEffect, _effectDist ] call dbgmsgl;

 _finalEffect = _rankEffect * MORALE_MULTIPLIER * _effectDist;

 _totalEffect = _totalEffect + _finalEffect;

} foreach _friendlies;


[DBGL_MORA,"TOTAL EFFECT: %1 ", _totalEffect ] call dbgmsgl;

 _bm = _group getVariable ["baseMorale",BASE_MORALE];

_applyEffect = _bm + _totalEffect;
if(_applyEffect > MAX_COURAGE) then { _applyEffect = MAX_COURAGE; };

_group allowFleeing _applyEffect;

_group setVariable ["fleeingValue", _applyEffect ];

} foreach _sideGroups;

 sleep 1;

} foreach [east,west];

 sleep 5;
};

};


#define MORALE_LOS_MAN  0.015
#define MORALE_LOS_VEH  0.1   // only tanks atm
#define MORALE_GAIN_MUL 0.1

initMorale =
{
morales = createHashmapFromArray [["west",1],["east",1]];
};

changeSideMorale =
{
 params ["_side","_change"];

 private _sideStr = tolower (str _side);

 private _morale = morales getOrDefault [_sideStr,-1];
 if(_morale < 0) exitWith {};

 _morale = _morale + _change;

 if(_morale < 0) then { _morale = 0; };
 if(_morale > 1) then { _morale = 1; };

 morales set [_sideStr,_morale];

 [_side,_morale] call updateMoraleBar;

//systemchat format["Morale update: %1 %2", _side, _morale];

 if(_morale == 0) then
 {
  systemchat "Battle ended due to lack of morale";
  [_side,"morale"] call endBattle;
 }
 else
 {
  // This place is fine for this, make sure battle ends when no men are left
 if({ !isplayer _x && alive _x } count (units _side) == 0) then
 {
  systemchat "Battle ended because of no more men";
  [_side,"nomen"] call endBattle;
 };
 };

};

addMissionEventHandler ["EntityKilled", 
{
 params ["_unit", "_killer", "_instigator", "_useEffects"];

 if(isnull _instigator) exitWith {}; // roadkills are ignored for now

 _side = side (group _unit); // must get this way or CIV
 _sideStr = tolower (str _side);

 _kSide = side (group _instigator);

_moraleChange = 0;
if(_unit iskindof "man") then 
{
 _moraleChange = MORALE_LOS_MAN;
}
else // If veh
{
 _moraleChange = MORALE_LOS_VEH;
};

[_side,-_moraleChange] call changeSideMorale;

// Killer gain some morale
[_kSide,_moraleChange * MORALE_GAIN_MUL] call changeSideMorale;

}];
