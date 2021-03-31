#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"
#include "\a3\ui_f\hpp\definedikcodes.inc"

// Todo disable:
// _logic addeventhandler ["curatorObjectDoubleClicked",{(_this select 1) call bis_fnc_showCuratorAttributes;}];
// etc

/*
this addEventHandler ["CuratorGroupSelectionChanged", {
	params ["_curator", "_group"];
}];

*/
// Radius
#define DEPLOY_AREA_SIZE 75
#define BATTLE_AREA_SIZE 255


beginBattlePlacement =
{
 params ["_areaMarker","_attackDir"];

deployAreaMain = _areaMarker;

_areaPos = markerPos _areaMarker;
_areaSize = markerSize _areaMarker;



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

_daDir = 120;
{
 _side = _x;
 _deployAreaPos = [_areaPos,_daDir] call getBattleDeployPos;

 missionnamespace setVariable [format["deployArea%1", _side], _deployAreaPos];

_mrk = createmarker [format["deploySide%1",_side], _deployAreaPos];
_mrk setMarkerShape "RECTANGLE";
_mrk setMarkerColor "ColorGreen";
_mrk setMarkerSize [DEPLOY_AREA_SIZE,DEPLOY_AREA_SIZE];
_mrk setMarkerDir _daDir; 

 _daDir = _daDir + 180;
} foreach [west,east];

_deployAreaPos = missionnamespace getVariable format["deployArea%1", west];


_zeus addCuratorCameraArea [0,_areaPos,_areaSize # 0];


_zeus addCuratorEditingArea [0,_deployAreaPos,75];



//_zeus setCuratorEditingAreaType true;

//_tg = [_deployAreaPos, side player, (configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfAssault")] call BIS_fnc_spawnGroup;

// ["testteam",call getPlayerSide,_deployAreaPos] call createBattleGroup;


//[call getPlayerSide,"HeavyTeam"] call addBattleGroupToPool;
//[call getPlayerSide,"HeavyTeam",_deployAreaPos] call createBattleGroupFromPool;

[call getPlayerSide,"LightMortarTeam"] call addBattleGroupToPool;
[call getPlayerSide,"LightMortarTeam",_deployAreaPos] call createBattleGroupFromPool;



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

_group call beginArtillery;


_wp = [_group,_waypointID];
_wp setwaypointtype "SCRIPTED";
_wp setwaypointscript getText(configfile >> "cfgWaypoints" >> "A3" >> "Artillery" >> "file");

 };

 /* old
case shiftDown: // Group facing
 {

_wp = [_group,_waypointID];

(waypointPosition _wp) call setGroupFacing;

deleteWaypoint _wp;

 };*/

default // Move
{

 _wps = waypoints _group;

 // hint format["MOVING %1 %2 %3", (leader _group), stopped (leader _group),count _wps];

// Continue moving if first waypoints...
if(count _wps <= 2) then
{
 [_group,_waypointID] call moveBattleGroup;
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

call openZeus;

};



getBattleDeployPos =
{
 params ["_areaPos","_attackDir"];

 private _vecFromCenter = [_attackDir, BATTLE_AREA_SIZE - DEPLOY_AREA_SIZE ] call getvector;
 private _pos = [_vecFromCenter,_areaPos] call addvector;

 _pos set [2,0];

 _pos
};



moveBattleGroup =
{
 params ["_group","_waypointID"];

 // man buildings
 [_group,false] call onNewMove;

 private _ldr = (leader _group);

 _ldr doMove (waypointPosition [_group,_waypointID]);

 (units _group - [_ldr]) doFollow _ldr;
};




[] spawn
{

waitUntil { !isNull findDisplay 46 };


{
(findDisplay _x) displayRemoveAllEventHandlers "KeyDown";
} foreach [46];


{

findDisplay _x displayAddEventHandler ["KeyDown",
{
params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

private _handled = false;

// Can only open here, 312 takes close Y press
if(inputAction "CuratorInterface" > 0) then
{
// Allow open but not close
if(isnull (findDisplay 312)) then 
{
 systemchat format["zeus open... %1 %2 %3",_key, time, inputAction "CuratorInterface"];

 [] spawn onZeusOpen;
}
else
{
 // _handled = true; 
};

};

// systemchat format["_key %1 ",_key];

_handled
}];


} foreach [46]; //[0,12,46,312,313];

};


setGroupFacing =
{
 params ["_xPos","_yPos"];

_sel = curatorSelected # 1;
if(count _sel > 0) then
{

{
_group = _x;
_ldr = (leader _group);

if(alive _ldr) then
{



_wpos = [_xPos,_yPos]; // screenToWorld

systemchat format["_wpos %1", _wpos];

_dir = [getpos _ldr, _wpos] call getAngle;


_group setFormDir _dir;

 systemchat format["ROTATE %1", _dir];

dostop _ldr;
(units _group - [_ldr]) doFollow _ldr;


[_group,getpos _ldr] call groupLocationSet;

}
else
{
 systemchat "Ldr not alive";
};

} foreach _sel;

};

};

setGroupFacingNew =
{
 params ["_group","_angle"];

private _ldr = (leader _group);

if(alive _ldr) then
{

_group setFormDir _angle;

 systemchat format["ROTATE %1", _angle];

dostop _ldr;
(units _group - [_ldr]) doFollow _ldr;


[_group,getpos _ldr] call groupLocationSet;

}
else
{
 systemchat "Ldr not alive";
};

};

// curatorToggleCreate
// https://community.bistudio.com/wiki/inputAction/actions

lastViewedGroup = grpNull;
lastViewUpdate = 0;

ranksShort = ["Pvt","Cpl","Sgt","Lt","Cpt","Maj","Col"];

toRoundsText =
{
 params ["_ammoCount"];
 format["%1",_ammoCount]
};

activateBattleGui =
{
 cutRsc["ComOverlay","PLAIN",0];


 _overlay = uiNamespace getVariable ['ComOverlay', displayNull];

_groupView = _overlay displayCtrl 1500;

_pos = ctrlposition _groupView;
/*
_bg = _overlay ctrlCreate ["RscPicture", 7000];

 _bg ctrlSetText "#(argb,8,8,3)color(0,0.75,0,1)";

#define TITLE_HEIGHT 0.1

_bg ctrlSetPosition [_pos # 0, _pos # 1 - TITLE_HEIGHT, _pos # 2, _pos # 3 + TITLE_HEIGHT];
_bg ctrlCommit 0;
*/

};

