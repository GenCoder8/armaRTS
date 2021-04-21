
#define FORCE_SIDE       0
#define FORCE_ICON       1
#define FORCE_POSMARKER  2

#define FORCE_ICON_SIZE 128

allforces = createHashMap;

createNewForce =
{
params ["_side","_name","_icon","_posmrk"];

allforces set [_name, [_side,_icon,_posmrk ] ];
};

getForcePosMarker =
{ 
 params ["_forceName"];

 private _force = allforces get _forceName;

 _force # FORCE_POSMARKER;
};

moveForceToBattleloc =
{
 params ["_forceName","_destMarker"];
 private _force = allforces get _forceName;

 _force set [FORCE_POSMARKER, _destMarker ];
};

getForcesAtBattleLoc =
{
 params ["_loc"];

private _list = [];
{

if((_y # FORCE_POSMARKER) == _loc) then
{
 _list pushback _y;
};

} foreach allforces;

// { (_x # FORCE_POSMARKER) == _loc} count allforces;


 _list
};

countForceFriendlies =
{
 params ["_forceName","_forces"];
 private _force = allforces get _forceName;

 {(_force # FORCE_SIDE) == (_x # FORCE_SIDE) } count _forces
};

getForceRenderPos =
{
 params ["_forceName"];
  private _force = allforces get _forceName;

 private _forces = (_force # FORCE_POSMARKER) call getForcesAtBattleLoc;

 private _renPos = markerpos (_force # FORCE_POSMARKER);

 if(count _forces > 1) then
 {
  private _dir = 1;
  if(_force # FORCE_SIDE == west) then { _dir = -1; };
  _renPos set [0, (_renPos # 0) + (250 * _dir)];
 };

 _renPos
};


getForceAtPos =
{
 params ["_pos"];
 private _ret = "";

{

if(_pos distance2D ( (_x call getForceRenderPos)) < ((FORCE_ICON_SIZE * 2 * 10) * ( (1 call scaleToMap))) ) then
{
 _ret = _x;
};

} foreach allforces;

 _ret
};

getForceInfo =
{
 params ["_forceName"];

 _forceName
};

renderForces =
{

{
	_this select 0 drawIcon [
		_y # FORCE_ICON,
		[1,1,1,1],
		_x call getForceRenderPos,
		(1 - (1 call scaleToMap)) * FORCE_ICON_SIZE,
		(1 - (1 call scaleToMap)) * FORCE_ICON_SIZE,
		0,
		"",
		1,
		0.03,
		"TahomaB",
		"right"
	];
} foreach allforces;

};