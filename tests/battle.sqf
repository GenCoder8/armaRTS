RTSmainPath = "armaRTS.Altis\";


_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

// Radius
#define DEPLOY_AREA_SIZE 75
#define BATTLE_AREA_SIZE 255


beginBattlePlacement =
{
 params ["_areaMarker","_attackDir"];

deployAreaMain = _areaMarker;

_areaPos = markerPos _areaMarker;
_areaSize = markerSize _areaMarker;

_deployAreaDepth = 75;
_deployAreaWidth = _areaSize # 0;

/*
{
_deployDir = _x;

_vecFromCenter = [_attackDir + _deployDir, _areaSize # 0 - _deployAreaDepth ] call getvector;
_placeAreaRectPos = [_vecFromCenter,_areaPos] call addvector;

_mrk = createmarker [format["deploySide%1",_deployDir], _placeAreaRectPos];
_mrk setMarkerShape "RECTANGLE";
_mrk setMarkerColor "ColorBlack";
_mrk setMarkerSize [_areaSize # 0,_deployAreaDepth];
_mrk setMarkerDir _attackDir;

_angle = 0;
{
_x params ["_width","_depth"];

_pax = 0;
while { _pax < (_width * 2) } do
{

_vex = [_attackDir + 90 + _angle, _pax - (_width)  ] call getvector;
_vey = [_attackDir + _angle, _depth ] call getvector;
_ve = [_vex,_vey] call addvector;

_vf = [_ve,_vecFromCenter] call addvector;
_vf = [_areaPos,_vf] call addvector;

_vf set [2,0];
createSimpleObject ["Sign_Arrow_F",AGLToASL _vf,true];

_pax = _pax + 5;
};

_angle = _angle + 90;
} foreach [[_deployAreaWidth,_deployAreaDepth], [_deployAreaDepth,_deployAreaWidth], [_deployAreaWidth,_deployAreaDepth], [_deployAreaDepth,_deployAreaWidth]];

if(_foreachIndex == 0) then
{
deployAreaA = _mrk;
}
else
{
deployAreaB = _mrk;
};

} foreach [0,180];
*/

/*
for "_i" from 0 to 1000 do
{

_v1 = [_attackDir + 90, -_deployAreaWidth + random (_deployAreaWidth*2) ] call getvector;
_v2 = [_attackDir, -_deployAreaDepth + random (_deployAreaDepth*2) ] call getvector;
_vf = [_v1,_v2] call addvector;
_vf = [_vecFromCenter,_vf] call addvector;
_vf = [_areaPos,_vf] call addvector;

_mrk = createmarker [format["%1",random 1000], _vf];
_mrk setMarkerShape "icon";
_mrk setMarkerType "mil_dot";
_mrk setMarkerColor "ColorRed";

};*/




_zg = creategroup (call getPlayerSide);


_zeus = _zg createUnit ["ModuleCurator_F", [0,0,0], [], 0, "NONE"];
plrZeus = _zeus;

_zeus synchronizeObjectsAdd [player];
 

//_zmCamArea = _zg createUnit ["ModuleCuratorAddCameraArea_F",_areaPos,[],0,"NONE"]; 
//_zeus synchronizeObjectsAdd [_zmCamArea];

_deployAreaPos = [_areaPos,120] call getBattleDeployPos;


_zeus addCuratorCameraArea [0,_areaPos,_areaSize # 0];



_zeus addCuratorEditingArea [0,_deployAreaPos,75];


//_zeus setCuratorEditingAreaType true;

//_tg = [_deployAreaPos, side player, (configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfAssault")] call BIS_fnc_spawnGroup;

// ["testteam",call getPlayerSide,_deployAreaPos] call createBattleGroup;


[call getPlayerSide,"testteam"] call addBattleGroupToPool;
[call getPlayerSide,"testteam",_deployAreaPos] call createBattleGroupFromPool;




plrZeus addEventHandler ["CuratorWaypointPlaced", {
	params ["_curator", "_group", "_waypointID"];

 // man buildings
 [_group,false] call onNewMove;

 _wps = waypoints _group;

 // hint format["MOVING %1 %2 %3", (leader _group), stopped (leader _group),count _wps];

// Continue moving if first waypoints...
if(count _wps <= 2) then
{
 _ldr = (leader _group);

 _ldr doMove (waypointPosition [_group,_waypointID]);

 (units _group - [_ldr]) doFollow _ldr;
};

}];




};




getBattleDeployPos =
{
 params ["_areaPos","_attackDir"];

 private _vecFromCenter = [_attackDir, BATTLE_AREA_SIZE - DEPLOY_AREA_SIZE ] call getvector;
 private _pos = [_vecFromCenter,_areaPos] call addvector;

 _pos set [2,0];

 _pos
};

beginBattle =
{


//plrZeus allowCuratorLogicIgnoreAreas true;
 
//plrZeus removeCuratorEditingArea 0;

call activateBattleGui;
};





["marker_0",120] call beginBattlePlacement;

call beginBattle;
