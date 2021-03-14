
#define SURRENDER_DIST 100

unitHighlights = [];

registerBattleGroup =
{
 params ["_group"];

 _bgSide = side _group;

/*
 _highlighted = [];
 {


 if(vehicle _x != _x) then
 {
  _highlighted pushbackUnique (vehicle _x);
 };

 _highlighted pushbackUnique _x;

 } foreach units _group;

 unitHighlights = unitHighlights + _highlighted;
*/


_group spawn
{
 params ["_group"];

while { !isnull _group } do
{
 _wps = waypoints _group;

if(count _wps > 0) then
{
 _lastWp = _wps select (count _wps - 1);


if(!(_group getVariable ["wpArrived",false])) then
{
if((waypointPosition _lastWp) distance2D (leader _group) < 10) then
{
  // hint "ARRIVED";

 _group setVariable ["wpArrived",true];

if(_group getVariable ["manBuildings",false]) then
{

[_group,(waypointPosition _lastWp)] call groupLocationSet;
};

};
};

};

 sleep 2;
};
};

_group spawn
{
 params ["_group"];

while { !isnull _group } do
{

 // Check for surrender
 private _didSurrender = false;
 {
 private _man = _x;
 if(!(_man call inVehicle)) then // Only for infantry using this instead of getGroupInfantry because we dont want parachuting guys
 {
 if(fleeing _man && !captive _man && alive _man) then
 {
  //if(([_group call getGroupPos,_side,200] call isEnemyNear)) then // Only surrender if enemies near
  //{
  private _ls = lifeState _man;
  if(!(_ls in ["INCAPACITATED","INJURED"])) then
  {
  private _ne = _man findNearestEnemy _man; 
  if(!isnull _ne) then
  {
   if(_ne distance _man < SURRENDER_DIST) then
   {
    _man call surrenderAI;
	_didSurrender = true;
   };
  };
  };
  //};
 };
 };
 } foreach (units _group);

 sleep 3;
};

};

// Reg player groups for zeus
if(_bgSide == (call getPlayerSide)) then
{
 plrZeus addCuratorEditableObjects [units _group, false];


};

};

onNewMove =
{
 params ["_group","_isAttack"];

 _group setVariable ["manBuildings",!_isAttack]; 

 _group setVariable ["wpArrived",false];

 // todo: _group enableAttack true;

 _group call resetUnitScripts;
};

groupLocationSet =
{
 params ["_group","_pos"];
 // Todo if leader not ok?
 [_group,_pos,15,formationDirection (leader _group),true,100,100] call manBuildings;
};
