

#define HIGHEST_RANK 4
#define MAX_EFFECT_DIST 100
#define MORALE_MULTIPLIER  0.25   // Best possible morale increase
#define MAX_COURAGE 0.95
/*
while { true } do
{

_side = west;

_friendlyGroups = allgroups select { side _x == _side && !isPlayer (leader _x) };

{
 _group = _x;
_friendlies = _friendlyGroups - [_group];
_ldr = leader _group;

_totalEffect = 0;

{
 _friendly = _x;
 _fldr = (leader _friendly);
 _rankIndex = rankid _fldr;

 _rankEffect = _rankIndex / HIGHEST_RANK;
 _effectDist = MAX_EFFECT_DIST / (_fldr distance _ldr);
 if(_effectDist > 1) then { _effectDist = 1; };

systemchat format["e: %1 %2", _rankEffect, _effectDist ];

 _finalEffect = _rankEffect * MORALE_MULTIPLIER * _effectDist;

 _totalEffect = _totalEffect + _finalEffect;

} foreach _friendlies;

systemchat format["TOTAL EFFECT: %1 ", _totalEffect ];

_applyEffect = 0.5 + _totalEffect;
if(_applyEffect > MAX_COURAGE) then { _applyEffect = MAX_COURAGE; };

_group allowFleeing _applyEffect;

} foreach [testg];

 sleep 3;
};*/

#define MORALE_LOS_MAN  0.025
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

 morales set [_sideStr,_morale];

 [_side,_morale] call updateMoraleBar;

//systemchat format["Morale update: %1 %2", _side, _morale];

 if(_morale == 0) then
 {
  systemchat "Battle ended due to lack of morale";
  call endBattle;
 }
 else
 {
  // This place is fine for this, make sure battle ends when no men are left
 if({ !isplayer _x && alive _x } count (units _side) == 0) then
 {
  systemchat "Battle ended because of no more men";
  call endBattle;
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
