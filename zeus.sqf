#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"
#include "\a3\ui_f\hpp\definedikcodes.inc"

// Radius
#define DEPLOY_AREA_SIZE 75
#define BATTLE_AREA_SIZE 255

shiftDown = false;
firemisDown = false;

onZeusOpen =
{

waitUntil { !isNull findDisplay 312 };

sleep 0.5;


_display = finddisplay 312;

if(isnil "zeusModded") then
{

//waituntil { _sb = missionnamespace getvariable ["RscDisplayCurator_sidebarShow",[false,false]]; ((_sb # 0) && (_sb # 1)) };


{
with (uinamespace) do
{
_ctrl = _display displayctrl _x;
_pc = ctrlParentControlsGroup _ctrl;

/*
hint format["PC: %1", _pc];
waituntil { ctrlenabled _ctrl && (ctrlfade _pc) <= 0 };
*/

 ['toggleTree',[_ctrl] + [false],''] call RscDisplayCurator_script;
};

} foreach [IDC_RSCDISPLAYCURATOR_ADDBARTITLE,IDC_RSCDISPLAYCURATOR_MISSIONBARTITLE];


#define FIRE_MISSION_KEY DIK_V

_display displayAddEventHandler ["KeyUp", 
{
params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

//systemchat format["UP %1 %2", _key,_shift];

if(_key == FIRE_MISSION_KEY) then
{
 firemisDown = false;
};

if(_shift) then
{
 shiftDown = false;
};

false
}];

_display displayAddEventHandler ["KeyDown", 
{
params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

// systemchat format["DOWN 777 %1 %2", _key,_shift];

if(_key == FIRE_MISSION_KEY) then
{
 firemisDown = true;
};

if(_shift) then
{
 shiftDown = true;
};


false
}];

 rightMouseButtonDown = false;
facingArrow = objnull;

_display displayAddEventHandler ["MouseButtonDown",
{
 params ["_displayorcontrol", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

 _handled = false;

if(_button == 1) then
{
 rightMouseButtonDown = true;
}; 

 _handled
}];

_display displayAddEventHandler ["MouseMoving",
{
  _handled = false;

 // Only this works in here
 getMousePosition params ["_xPos", "_yPos"];


if(rightMouseButtonDown && isnull facingArrow) then
{
 systemchat "DOWN!";

_sel = curatorSelected # 1;
if(count _sel > 0) then
{

 systemchat format["READ: %1,%2",_xPos,_yPos];

 rightMouseHoldPos = screenToWorld [_xPos,_yPos];
 //rightMouseHoldPos set [2,1];


 facingArrow = createSimpleObject ["Sign_Arrow_Direction_Blue_F", AGLToASL  rightMouseHoldPos,false];
 
 facingArrow setObjectScale 5;


};
};

 //params ["_display", "_xPos", "_yPos"];
if(!isnull facingArrow) then
{

 _cpos = screenToWorld [_xPos,_yPos];
 
 _angle = [rightMouseHoldPos,_cpos] call getAngle;
  facingArrow setdir _angle;
  facingArrow setObjectScale 5;

 _handled = true;
};

_handled
}];

_display displayAddEventHandler ["MouseButtonUp",
{
 params ["_displayorcontrol", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

_handled = false;

if(_button == 1) then
{
 systemchat "UP!";

if(_button == 1) then
{
 rightMouseButtonDown = false;
}; 


_sel = curatorSelected # 1;
if(count _sel > 0) then
{
 _rightMouseHoldPosNow = screenToWorld [_xPos,_yPos];

 _angle = [rightMouseHoldPos,_rightMouseHoldPosNow] call getAngle;

  systemchat format["ANGLE: %1",_angle];

 // _angle call setGroupFacingNew;

{
 _group = _x;
// _group call deleteWaypoints;



 _wp = _group addwaypoint [rightMouseHoldPos,0];
 _wp setWaypointType "MOVE";
 _wp setWaypointStatements ["true", format["[group this,%1] call setGroupFacingNew;",_angle]];

  [_group,_wp#1] call moveBattleGroup;

} foreach _sel;

};

// Always delete in here
if(!isnull facingArrow) then
{
deletevehicle facingArrow;
facingArrow = objNull;

_handled = true;
};

};

 _handled
}];

 // finddisplay 12 displayAddEventHandler ["MouseButtonUp", { true }];

// _display displayaddeventhandler ["mouseholding",{ systemchat format["TEST %1",time]; }];


/*
_display displayAddEventHandler ["MouseZChanged",{

 systemchat "TEST123";
}];*/

 zeusModded = true;
};

/*
// Create button
_ctrl = _display displayctrl IDC_RSCDISPLAYCURATOR_ADDBAR;
_ctrl ctrlShow false;

// Edit button
_ctrl = _display displayctrl IDC_RSCDISPLAYCURATOR_MISSIONBAR;
_ctrl ctrlShow false;
*/

 call interceptZeusKeys;




};


interceptZeusKeys =
{
//(findDisplay 312) displayRemoveAllEventHandlers "KeyDown";

findDisplay 312 displayAddEventHandler ["KeyDown",
{
params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

private _handled = false;

// systemchat format["DOWN 123 %1 %2", _key,_shift];

if(_key in [DIK_E,DIK_R,DIK_BACKSLASH,DIK_TAB]) then 
{
 _handled = true;
};

if(_key isEqualTo DIK_TAB) then 
{
 _handled = true;

 //systemchat format["test.... %1 %2 %3",_key, time, inputAction "CuratorInterface"];

};


if(inputAction "CuratorInterface" > 0) then
{
 _handled = true;
};

_handled
}];

};


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

moveBattleGroup =
{
 params ["_group","_waypointID"];

 // man buildings
 [_group,false] call onNewMove;

 private _ldr = (leader _group);

 _ldr doMove (waypointPosition [_group,_waypointID]);

 (units _group - [_ldr]) doFollow _ldr;
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

 [] spawn
{
 sleep 0.5; 
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
