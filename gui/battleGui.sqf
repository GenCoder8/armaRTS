#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"
#include "\a3\ui_f\hpp\definedikcodes.inc"

#include "gridDefines.h"

getGuiPos =
{
 params ["_x","_y","_w","_h",["_atGrid",true]];
 private _gx = 0;
 private _gy = 0;

if(_atGrid) then
{
 _gx = UI_GRID_X;
 _gy = UI_GRID_Y;
};

 [_x * UI_GRID_W + _gx, _y * UI_GRID_H + _gy, _w * UI_GRID_W, _h * UI_GRID_H]
};

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
_areaSize = markerSize _areaMarker; // TODO: BATTLE_AREA_SIZE



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

_deployAreaPos = missionnamespace getVariable format["deployArea%1", call getPlayerSide];


_zeus addCuratorCameraArea [0,_areaPos,_areaSize # 0];


_zeus addCuratorEditingArea [0,_deployAreaPos,DEPLOY_AREA_SIZE];



//_zeus setCuratorEditingAreaType true;

//_tg = [_deployAreaPos, side player, (configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfAssault")] call BIS_fnc_spawnGroup;

// ["testteam",call getPlayerSide,_deployAreaPos] call createBattleGroup;


//[call getPlayerSide,"HeavyTeam"] call addBattleGroupToPool;
//[call getPlayerSide,"HeavyTeam",_deployAreaPos] call createBattleGroupFromPool;

/*
private _npos = [_deployAreaPos,1,DEPLOY_AREA_SIZE,[_deployAreaPos, DEPLOY_AREA_SIZE, DEPLOY_AREA_SIZE, 0, true]] call findSafePosVehicle;

if(count _npos > 0) then // If ok
{
_npos set [2,0];
_fposRet = _npos;
*/

_area = [_deployAreaPos,DEPLOY_AREA_SIZE];

[call getPlayerSide,"LightMortarTeam"] call addBattleGroupToPool;
[call getPlayerSide,"LightMortarTeam",_area] call createBattleGroupFromPool;






/*
plrZeus addEventHandler ["CuratorWaypointEdited", {
	params ["_curator", "_waypoint"];

systemchat format["CHANGE! %1",time];
}];


plrZeus addEventHandler ["CuratorWaypointSelectionChanged", {
	params ["_curator", "_waypoint"];

systemchat format["SEL! %1",time];
}];




plrZeus addEventHandler ["CuratorGroupDoubleClicked", {
	params ["_curator", "_group"];

 true
}];
*/


plrZeus addEventHandler ["CuratorObjectSelectionChanged", {
	params ["_curator", "_entity"];

newZeusSelect = true;
}];

plrZeus addEventHandler ["CuratorGroupSelectionChanged", {
	params ["_curator", "_group"];

newZeusSelect = true;
}];


plrZeus addeventhandler ["curatorWaypointPlaced",
{
params ["_curator", "_group", "_waypointID"];

private _wp = [_group,_waypointID];
private _wpos = waypointPosition _wp;

switch (true) do
{
 case firemisDown: // Fire mission
 {

[_group,"HE"] call beginArtillery;


_wp = [_group,_waypointID];
_wp setwaypointtype "SCRIPTED";
_wp setwaypointscript getText(configfile >> "cfgWaypoints" >> "A3" >> "Artillery" >> "file");

 };

case hoverOnHouse:
{
[_group,_wpos,15,formationDirection (leader _group),true,100,100] call manBuildings;

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

 // Reset all
firemisDown = false;

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

conditionFireMission =
{
 // Must have selection
private _sel = curatorSelected # 1;

// todo doesMortarHaveMag

({ _x call isMortarGroup } count _sel) > 0
};

actionFireMission =
{
 firemisDown = true;
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


darrow = createSimpleObject ["VR_3DSelector_01_default_F", [0,0,0], true];
hoverOnHouse = false;

addMissionEventHandler ["EachFrame",
{
 _bldg = call getOnHoverHouse;

// systemchat format["_bldg %1", _bldg];

if(!isnull _bldg) then
{
 _p = getposATL _bldg;
 _p set [2, (_p # 2) + 8];
 darrow setposATL _p;

 hoverOnHouse = true;
}
else
{
 darrow setposATL [0,0,0];

 hoverOnHouse = false;
};

}];



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

actionButtons = [];



activateBattleGui =
{
 _display = displayNull;
 waituntil { sleep 0.01; _display = finddisplay 312; !isnull _display };

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

/*
	x = 47 * UI_GRID_W + UI_GRID_X;
	y = 25.5 * UI_GRID_H + UI_GRID_Y;
	w = 19 * UI_GRID_W;
	h = 12.5 * UI_GRID_H;
*/

_cg = _display ctrlCreate ["RscControlsGroup", -1];
_cg ctrlSetText "teeest";
_cg ctrlsetTooltip "teeest";
_cg ctrlSetPosition ([15,33,19,5] call getGuiPos);
_cg ctrlCommit 0;


_img = _display ctrlCreate ["RscPicture", -1, _cg];
_img ctrlSetText "#(argb,8,8,3)color(1,0,0,1)﻿";
_img ctrlSetPosition ([0,0,15,5,false] call getGuiPos);
_img ctrlCommit 0;



actionButtons = [];

_buttonDefs = missionConfigFile >> "RtsActionButtons";

#define BUT_SIZE 0.1
#define NUM_ROW 3

for "_i" from 0 to ( count _buttonDefs - 1) do 
{
_bd = _buttonDefs select _i;

_bt = _display ctrlCreate ["RscImgButton", -1, _cg];
_bt ctrlSetText (getText (_bd >> "icon"));
_bt ctrlsetTooltip (getText (_bd >> "text"));
_bt ctrlSetPosition [0.0 + (BUT_SIZE * _i), 0.0 + (BUT_SIZE * (floor(_i / NUM_ROW))), BUT_SIZE, BUT_SIZE];
_bt ctrlCommit 0;
_bt buttonSetAction format["hint '%1'; %2", getText (_bd >> "help"), (getText (_bd >> "action"))]; 


actionButtons pushback [_bt,_bd];

};

};

