
artyTargets = compile preprocessFileLineNumbers (RTSmainPath+"scripts\findArtTargetGroups.sqf");


isAirGroup =
{
 false
};

isGroupOnWater =
{
 false
};


getKnownGroups =
{
params ["_friendlySide","_center", "_radius"];

private _groups = allgroups select { side _x != _friendlySide };

private _targetGroups = _groups select 
{
//_friendlySide knowsAbout (leader _x) > 0

private _numKnown = {

_knows = _friendlySide knowsAbout _x;

_knows > 0

} count (units _x);

_numKnown > 0
};

_targetGroups
};

testarty =
{

hint "";

_targets = [markerpos "des",1000,west] call artyTargets;

if(count _targets == 0) exitwith { hint "No targets"; };

_firstTarget = _targets # 0;

_pos = _firstTarget # 0;

_mrk = createmarker [format["artyTarget_%1",_pos], _pos];
_mrk setMarkerShape "ICON";
_mrk setMarkerColor "ColorGreen";
_mrk setMarkerType "mil_destroy";

//_mrk setMarkerSize [DEPLOY_AREA_SIZE,DEPLOY_AREA_SIZE];
//_mrk setMarkerDir _daDir;

};



aiComUseArtillery =
{
params ["_side"];

if(numAiSupports <= 0) exitwith {};

_center = markerpos nextBattleMap;

_targets = [_center,3000,_side] call artyTargets;

if(count _targets > 0) then
{

_target = selectRandom _targets; // Totally random arty
_targetPos = _target # 0;

hint "Arty target found!";

// Show debug markers
if(debugMode) then
{
_mrk = createmarker [format["artyTarget_%1",_targetPos], _targetPos];
_mrk setMarkerShape "ICON";
_mrk setMarkerColor "ColorGreen";
_mrk setMarkerType "mil_destroy";
};

 // Copy from player support (callArtilleryBarrage)
[_side,_targetPos,markerpos nextBattleMap,nextBattleDir+180] spawn callArtilleryBarrage;

numAiSupports = numAiSupports - 1;
}
else
{
 // hint "No arty targets!";
};


};
