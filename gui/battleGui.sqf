#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"
#include "\a3\ui_f\hpp\definedikcodes.inc"

#include "gridDefines.h"

#include "..\main.h"

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



startBattleFieldZeus =
{

if(!canSuspend) exitwith { _this spawn startBattleFieldZeus; };

bpArgs = _this;

battleGuiReady = false;

// Can be here
call initMorale;

plrSupports = createHashMapFromArray [['cas',2],['artillery',2]];

numAiSupports = 2;


"Loading battlefield" call startRtsLoadScreen;


addMissionEventHandler ["EachFrame",
{
removeMissionEventHandler ["EachFrame",_thisEventHandler];


 bpArgs params ["_areaMarker","_attackDir"];

deployAreaMain = _areaMarker;

_areaPos = battleAreaPos; // markerPos _areaMarker;
_areaSize = battleAreaSize; // markerSize _areaMarker; // always BATTLE_AREA_SIZE


//systemchat format["bpArgs %1 -- %2 -- %3 %4", bpArgs,_areaPos, _areaMarker, _attackDir];

systemchat format["_areaSize %1", _areaSize];


_zg = creategroup (call getPlayerSide);


_zeus = _zg createUnit ["ModuleCurator_F", [0,0,0], [], 0, "NONE"];
plrZeus = _zeus;

_zeus synchronizeObjectsAdd [player];

/*
{
diag_log format[">> %1", _x];
} foreach (curatorAddons plrZeus);
*/
//removeAllCuratorAddons plrZeus;
//plrZeus addCuratorAddons ["a3_modules_f_curator_cas"];


//_zmCamArea = _zg createUnit ["ModuleCuratorAddCameraArea_F",_areaPos,[],0,"NONE"];
//_zeus synchronizeObjectsAdd [_zmCamArea];



_deployAreaPos = (call getPlayerSide) call getDeployArea;


_zeus addCuratorCameraArea [0,_areaPos,_areaSize # 0];


_zeus addCuratorEditingArea [0,_deployAreaPos,DEPLOY_AREA_SIZE];


//curatorCamera camSetTarget _deployAreaPos;
//curatorCamera camCommit 0;


[_deployAreaPos] spawn
{
params ["_deployAreaPos"];
sleep 0.5;
_cp = +_deployAreaPos;
_cp set [2,50];
curatorCamera setposATL _cp;
///curatorCamera setVectorDirAndUp [[0,0,-1], [0,1,0]];

};

systemchat format[" %1 .. %2 ", _areaPos,_areaSize # 0];

[_areaPos,_areaSize # 0] call initBattleField;


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


plrZeus addEventHandler ["CuratorObjectSelectionChanged", 
{
params ["_curator", "_entity"];

call cancelMouseClickAction;

newZeusSelect = true;
}];

plrZeus addEventHandler ["CuratorGroupSelectionChanged", 
{
params ["_curator", "_group"];

call cancelMouseClickAction;

newZeusSelect = true;
}];


plrZeus addeventhandler ["curatorWaypointPlaced",
{
params ["_curator", "_group", "_waypointID"];

if(curScreen != "battle") exitWith {};

private _wp = [_group,_waypointID];
private _wpos = waypointPosition _wp;



if(!(_group call isVehicleGroup)) then
{

_bldg = call getOnHoverHouse;

if(!isnull _bldg) then
{
 "manHouse" call setSpecialMove;
}
else // If not bldg then maybe cover
{

if(count movePoints == 0) then // Dont get this more than once
{
_cwpos = screenToWorld getMousePosition; // Same as in arrow displaying
_movePoints = [_cwpos] call getCoverMovePoints;

// systemchat format[">>> %1 %2", _wpos, count _movePoints ];

if(count _movePoints > 0) then
{
 "cover" call setSpecialMove;
 movePoints = _movePoints;
};
};

};

};


_moveGroup =
{
{
[_x,_waypointID] call moveBattleGroup;
} foreach _groups;
};


switch(specialMove) do
{
 case "setFormDir":
 {
  _wpos call setGroupFacing;
  deleteWaypoint _wp;
 };
 case "throwSmoke":
 {
  [_wpos] call anyoneThrowSmoke;
  deleteWaypoint _wp;
 };
 case "fireMission":
 {

[_group,fireMisType,_wpos] call beginArtillery;


_wp setwaypointtype "SCRIPTED";
_wp setwaypointscript getText(configfile >> "cfgWaypoints" >> "A3" >> "Artillery" >> "file");

 };

case "manHouse";
case "cover":
{
 // Always move, at first
 [_group,_waypointID] call moveBattleGroup;
};

case "": // Move
{

//systemchat "Default move";

 _wps = waypoints _group;

 // hint format["MOVING %1 %2 %3", (leader _group), stopped (leader _group),count _wps];

// Continue moving if first waypoints...
if(count _wps <= 2) then
{
 [_group,_waypointID] call moveBattleGroup;
};

};
};


if(isnull spesMoveHandle) then
{
spesMoveHandle = [_wpos] spawn onSpecialMove;
};

}];



movePoints = [];

specialMove = "";
spesMoveHandle = scriptNull;



setSpecialMove =
{
 params ["_moveName",["_override",false]];
 if(specialMove == "" || _override) then
 {
 specialMove = _moveName;
 };
};


onSpecialMove =
{
params ["_wpos"];

sleep 0.01; // Wait that all curatorWaypointPlaced has fired

curatorSelected params ["_units","_groups"];

if(call isInfantrySelected) then
{

// Get only infatry
private _inf = _units select { !(_x call inVehicle) };

switch(specialMove) do
{
 case "fireMission":
 {

 };
 case "manHouse":
 {

private _dir = formationDirection (leader (_groups # 0)); // Todo much better

[_inf,_wpos,15,_dir,true,100,100] call manBuildings;

 };
 case "cover":
 {

private _uIndex = 0;

{
private _covPos = _x;
//if(count _covPos > 0) then
//{
_covPosF = +_covPos;
//_covPosF set [2,0];

if(_uIndex < (count _inf)) then
{

private _u = _inf # _uIndex;

_u doMove _covPosF;

// _u setposATL _covPosF;

[_u,_covPosF] call applyStopSCript;

// systemchat format["Moving one! %1 %2 %3", _u, _uIndex, _covPosF];

_uIndex = _uIndex + 1;

};
//};
} foreach movePoints;

 };
};

};

 movePoints = [];

 spesMoveHandle = scriptNull;
 specialMove = "";
};


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





if(loadCovers) then
{

_tpos = markerpos "covtestarea";

if(_tpos isEqualTo [0,0,0]) then
{
[_areaPos, _areaSize # 0] call initCoverSystem;
}
else
{
[_tpos, 50] call initCoverSystem;
};

};

call openZeus;


battleGuiReady = true;
}];


 waituntil { battleGuiReady };
 call endRtsLoadScreen;

};

closeBattlefieldZeus =
{
 unassignCurator plrZeus;

 removeAllCuratorEditingAreas plrZeus;
 removeAllCuratorCameraAreas plrZeus;

 deleteVehicle plrZeus;

 call clearBattleField;
};

getDeployArea =
{
 params ["_side"];

 missionnamespace getVariable format["deployArea%1", _side]
};

wantedTestGroups = [];

placeTestGroup =
{
 params ["_groupName","_area"];

wantedTestGroups pushback [_groupName,_area];

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


darrow = createSimpleObject ["VR_3DSelector_01_default_F", [0,0,0], true];
hoverOnHouse = false;

getUsedCoverPoints =
{
 params ["_edgePoints","_cursorPos","_max"];


private _newList = [_edgePoints,[], { _x distance2D _cursorPos }, "ASCEND" ] call BIS_fnc_sortBy;


_newList select [0,_max]
};

getCoverMovePoints =
{
params ["_wpos"];

private _closestEdge = [_wpos] call getCoverForPosition;

if(count _closestEdge == 0) exitWith { [] };

private _sel = curatorSelected;
private _nearPoints = [_closestEdge,_wpos,{ !(_x call inVehicle) } count (_sel # 0)] call getUsedCoverPoints;

_nearPoints
};

carrows = [];

addMissionEventHandler ["EachFrame",
{

{ deleteVehicle _x; } foreach carrows;
carrows = [];

if(curScreen != "battle") exitWith {};

if(call isInfantrySelected && specialMove == "" && !rightMouseButtonDown) then // Only for inf
{

 _bldg = call getOnHoverHouse;

// systemchat format["_bldg %1", _bldg];

if(!isnull _bldg) then
{
 _p = getposATL _bldg;
 _p set [2, (_p # 2) + 8];
 darrow setposATL _p;

}
else
{
 darrow setposATL [0,0,0];



_wpos = screenToWorld getMousePosition;

_movePoints = [_wpos] call getCoverMovePoints;

/*
_closestEdge = [_wpos] call getCoverForPosition;

if(count _closestEdge > 0) then
{

_sel = curatorSelected;
_nearPoints = [_closestEdge,_wpos,count (_sel # 0)] call getUsedCoverPoints;
*/
{
  _p = _x;
//if(count _p > 0) then
//{
// _p set [2,1];

  _arrow = createSimpleObject ["Sign_Arrow_Blue_F", AglToASL _p,true];
  carrows pushback _arrow;

//};
} foreach _movePoints;
//};



};

};

/*
_p = (screenToWorld getMousePosition);

_objs = [_p,5] call getCoverObjects;

{
 _obj = _x;

 if((_obj distance2D coverAreaPos) < coverAreaSize) then
 {
  _obj call createCoverPointsForObj;
 };

} foreach _objs;


hintSilent format["_objs %1", count _objs];
*/

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

beginBattle =
{

 removeAllCuratorEditingAreas plrZeus;

// Disable zeus dragging
if(!debugMode) then
{
plrZeus addCuratorEditingArea [0,[0,0,0],10];
};

 //plrZeus removeCuratorEditableObjects [allunits, false];

 ["battle"] call openGameScreen;
};

activateBattleGui =
{

 // cutRsc["ComOverlay","PLAIN",0];

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


};


updateMoraleBar =
{
params ["_side","_progress"];
_bar = uinamespace getVariable [format["moraleBar%1", _side],controlNull ];

_bar progressSetPosition _progress;

_bar ctrlSetTooltip format["%1 Morale %2%3", (tolower str _side) call makeFirstLetterCapital, ceil (_progress * 100), "%" ];
};

with (uinamespace) do
{
battleButtonGroup = controlNull;
actionButtons = controlNull;
unitList = controlNull;
moraleDisp = controlNull;
};

setBattleGuiButtons =
{
 if(!canSuspend) exitWith { _this spawn setBattleGuiButtons; };

// Wait until battle groups are created
waituntil { deployDone };

 params ["_guiName"];

_display = displayNull;
waituntil { sleep 0.01; _display = finddisplay 312; !isnull _display };

with (uinamespace) do
{
if(!isnull battleButtonGroup) then
{
 ctrlDelete battleButtonGroup;
 ctrlDelete actionButtons;
};

ctrldelete unitList;

ctrlDelete moraleDisp;
};

actionButtons = []; // Always reset

#define ACTB_SIZE_Y 6
#define ACT_CGROUP_WIDTH 15

_buttonsY = 39 - ACTB_SIZE_Y;

_cg = _display ctrlCreate ["RtsControlsGroupNoScrollBars", -1];
_cg ctrlSetPosition ([ACT_CGROUP_WIDTH,_buttonsY,ACT_CGROUP_WIDTH,ACTB_SIZE_Y] call getGuiPos);
_cg ctrlCommit 0;

with (uinamespace) do
{
battleButtonGroup = _cg;
};

_ab = _display ctrlCreate ["RtsControlsGroupNoScrollBars", -1];
_ab ctrlSetPosition ([0,_buttonsY,ACT_CGROUP_WIDTH,ACTB_SIZE_Y] call getGuiPos);
_ab ctrlCommit 0;

with (uinamespace) do
{
actionButtons = _ab;
};

// The unit list size
#define UNIT_LIST_WIDTH  6.5
#define UNIT_LIST_HEIGHT  28



_ul = _display ctrlCreate ["RtsUnitList", -1];
_ul ctrlSetPosition ([0,0,UNIT_LIST_WIDTH*2,UNIT_LIST_HEIGHT] call getGuiPos);
_ul ctrlCommit 0;

with (uinamespace) do
{
unitList = _ul;
};

switch(_guiName) do
{

case "placement":
{

_bt = _display ctrlCreate ["RscButton", -1, _cg];
_bt ctrlSetText "Begin battle";
_bt ctrlSetPosition [0.0,0.0, 0.2,0.1];
_bt ctrlCommit 0;
_bt buttonSetAction format["[] spawn beginBattle"];


_ul call fillUnitList;

};

case "battle":
{

_img = _display ctrlCreate ["RtsPicture", -1, _cg];
//_img ctrlSetText "#(argb,8,8,3)color(1,0,0,1)﻿";
_img ctrlSetPosition ([0,0,ACT_CGROUP_WIDTH,ACTB_SIZE_Y,false] call getGuiPos);
_img ctrlCommit 0;

_img = _display ctrlCreate ["RtsPicture", -1, _ab];
//_img ctrlSetText "#(argb,8,8,3)color(1,0,0,1)﻿";
_img ctrlSetPosition ([0,0,ACT_CGROUP_WIDTH,ACTB_SIZE_Y,false] call getGuiPos);
_img ctrlCommit 0;


_moraleDisp = _display ctrlCreate ["RtsControlsGroupNoScrollBars", -1];
_moraleDisp ctrlSetPosition ([35,_buttonsY,15,ACTB_SIZE_Y] call getGuiPos);
_moraleDisp ctrlCommit 0;

with (uinamespace) do
{
moraleDisp = _moraleDisp;
};

_img = _display ctrlCreate ["RtsPicture", -1, _moraleDisp];
_img ctrlSetPosition ([0,0,5,5,false] call getGuiPos);
_img ctrlCommit 0;
_img ctrlSetTextColor [1, 0, 0, 1];


for "_i" from 0 to 1 do
{
_side = [east,west] select _i;
_sideStr = str _side;
_moraleBar = _display ctrlCreate ["RscProgress", -1, _moraleDisp];
_moraleBar ctrlSetPosition ([0, 0.5 + _i * 1.5 ,5,1,false] call getGuiPos);
_moraleBar progressSetPosition 0;
_moraleBar ctrlCommit 0;

uinamespace setVariable [format["moraleBar%1", _side], _moraleBar ];

[_side,1] call updateMoraleBar;

};



_ul call fillUnitList;

_buttonDefs = (missionConfigFile >> "RtsActionButtons");

selectCfgArray =
{
params ["_cfg","_cond"];
private _ret = [];
for "_i" from 0 to ( count _cfg - 1) do
{
 private _cfg = _cfg select _i;
 private _x = _cfg;
 if(_cfg call _cond) then
 {
  _ret pushback _cfg;
 };
};
 _ret
};

#define BUT_SIZE 0.1
#define NUM_IN_ROW 4


_createActButtons =
{
 params ["_contGroup","_buttonDefs"];


for "_i" from 0 to (count _buttonDefs - 1) do
{

_bd = (_buttonDefs select _i);

_bt = _display ctrlCreate ["RtsImgButton", -1, _contGroup];
_bt ctrlSetText (getText (_bd >> "icon"));

_bt ctrlSetPosition [0.0 + (BUT_SIZE * (_i % NUM_IN_ROW)), 0.0 + (BUT_SIZE * (floor(_i / NUM_IN_ROW))), BUT_SIZE, BUT_SIZE];
_bt ctrlCommit 0;

_h = getText (_bd >> "help");
if(_h != "") then { _h = format["hint '%1';",_h]; };

_bt buttonSetAction format["%1 %2",_h , (getText (_bd >> "action"))];


actionButtons pushback [_bt,_bd];

};

};


_groupActs = [_buttonDefs,{ getNumber(_x >> "isIndependedAction")==0 } ] call selectCfgArray;
[_cg, _groupActs ] call _createActButtons;

// hint format[" _buttonDefs %1 ", _arr];

_indpActs = [_buttonDefs,{ getNumber(_x >> "isIndependedAction")==1 } ] call selectCfgArray;
[_ab, _indpActs ] call _createActButtons;

};

};


// Create in unique way...
if(isnull (_display displayCtrl 7000)) then
{

// Todo size of this maybe little off
_img = _display ctrlCreate ["RtsPicture", 7000];
_img ctrlSetPosition ([47,25.5,22,12.5,true] call getGuiPos);
_img ctrlCommit 0;
_img ctrlShow false;

_text = _display ctrlCreate ["RscText", 1000];
_text = _display ctrlCreate ["RscText", 1001];


_gw = _display ctrlCreate ["GroupViewListbox", 1500];

//_gw ctrlSetPosition [0,0,0.1,0.1];
//_gw ctrlCommit 0;

//_display ctrlCreate ["RscButton", 12345];



// diag_log format ["_lb_lb_lb %1 -- %2", _display, _lb];

};

};


clearBattleguiButtons =
{
 // TODO
};