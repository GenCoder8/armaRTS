
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





_zg = creategroup (call getPlayerSide);


_zeus = _zg createUnit ["ModuleCurator_F", [0,0,0], [], 0, "NONE"];
plrZeus = _zeus;

_zeus synchronizeObjectsAdd [player];
/*
{
diag_log format[">> %1", _x];
} foreach (curatorAddons plrZeus);
*/
removeAllCuratorAddons plrZeus;
plrZeus addCuratorAddons ["a3_modules_f_curator_cas"];
 

//_zmCamArea = _zg createUnit ["ModuleCuratorAddCameraArea_F",_areaPos,[],0,"NONE"]; 
//_zeus synchronizeObjectsAdd [_zmCamArea];

_deployAreaPos = [_areaPos,120] call getBattleDeployPos;


_zeus addCuratorCameraArea [0,_areaPos,_areaSize # 0];



_zeus addCuratorEditingArea [0,_deployAreaPos,75];



//_zeus setCuratorEditingAreaType true;

//_tg = [_deployAreaPos, side player, (configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfAssault")] call BIS_fnc_spawnGroup;

// ["testteam",call getPlayerSide,_deployAreaPos] call createBattleGroup;


[call getPlayerSide,"HeavyTeam"] call addBattleGroupToPool;
[call getPlayerSide,"HeavyTeam",_deployAreaPos] call createBattleGroupFromPool;



/*
plrZeus addEventHandler ["CuratorWaypointEdited", {
	params ["_curator", "_waypoint"];

systemchat format["CHANGE! %1",time];
}];


plrZeus addEventHandler ["CuratorWaypointSelectionChanged", {
	params ["_curator", "_waypoint"];

systemchat format["SEL! %1",time];
}];

plrZeus addEventHandler ["CuratorObjectSelectionChanged", {
	params ["_curator", "_entity"];

newZeusSelect = true;
}];

plrZeus addEventHandler ["CuratorGroupSelectionChanged", {
	params ["_curator", "_group"];

newZeusSelect = true;
}];


plrZeus addEventHandler ["CuratorGroupDoubleClicked", {
	params ["_curator", "_group"];

 true
}];
*/

plrZeus addeventhandler ["curatorWaypointPlaced",
{
params ["_curator", "_group", "_waypointID"];


switch (true) do
{
 case firemisDown: // Fire mission
 {

_wp = [_group,_waypointID];
_wp setwaypointtype "SCRIPTED";
_wp setwaypointscript getText(configfile >> "cfgWaypoints" >> "A3" >> "Artillery" >> "file");

 };
 case shiftDown: // Group facing
 {

_wp = [_group,_waypointID];

(waypointPosition _wp) call setGroupFacing;

deleteWaypoint _wp;

 };
 default // Move
{

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

};
};


}];


/*
addMissionEventHandler ["GroupIconOverEnter", {
	params [
		"_is3D", "_group", "_waypointId",
		"_posX", "_posY",
		"_shift", "_control", "_alt"
	];

 systemchat "GroupIconOverEnter";
}];
*/

 [] spawn
{
 sleep 0.1; 
 openCuratorInterface;
 [] spawn onZeusOpen;
};

};




getBattleDeployPos =
{
 params ["_areaPos","_attackDir"];

 private _vecFromCenter = [_attackDir, BATTLE_AREA_SIZE - DEPLOY_AREA_SIZE ] call getvector;
 private _pos = [_vecFromCenter,_areaPos] call addvector;

 _pos set [2,0];

 _pos
};
