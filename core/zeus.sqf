#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"
#include "\a3\ui_f\hpp\definedikcodes.inc"


shiftDown = false;
firemisDown = false;

openZeus =
{

[] spawn
{

waituntil 
{
sleep 0.01;
openCuratorInterface;

!isnull (findDisplay 312) 
};
 
 [] spawn onZeusOpen;
};

};

onZeusOpen =
{

waitUntil { !isNull findDisplay 312 };

//sleep 0.5;


_display = finddisplay 312;


(finddisplay 312) displaySetEventHandler ["KeyDown", " _this call rtsGameInput "];



if(isnil "zeusModded") then
{

//waituntil { _sb = missionnamespace getvariable ["RscDisplayCurator_sidebarShow",[false,false]]; ((_sb # 0) && (_sb # 1)) };


//waitUntil { ctrlShown (_display displayctrl IDC_RSCDISPLAYCURATOR_ADDBAR)  };

/*
_ctrl = _display displayctrl IDC_RSCDISPLAYCURATOR_ADDBARTITLE;
_ctrl2 = _display displayctrl IDC_RSCDISPLAYCURATOR_ADDBAR;

_ctrlGroupIDC = IDC_RSCDISPLAYCURATOR_ADD;
_ctrlGroup = _display displayctrl _ctrlGroupIDC;

systemchat format [">> %1 %2 %3 %4 %5 %6",ctrlenabled _ctrl, ctrlenabled _ctrlGroup, ctrlshown _ctrl, ctrlshown _ctrlGroup ];
*/

sleep 0.1;

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

/*
waituntil { sleep 0.1;
_sidebarShow = missionnamespace getvariable ["RscDisplayCurator_sidebarShow",123];  _sidebarShow isNotEqualTo 123 };

systemchat "ttt";

{
with (uinamespace) do
{
_ctrl = _display displayctrl _x;
 ['toggleTree',[_ctrl] + [false],''] call RscDisplayCurator_script;
};

} foreach [IDC_RSCDISPLAYCURATOR_ADDBARTITLE,IDC_RSCDISPLAYCURATOR_MISSIONBARTITLE];


_sidebarShow = missionnamespace getvariable ["RscDisplayCurator_sidebarShow",123];

systemchat format [">> (%1)", _sidebarShow];

*/



// Create button
_ctrl = _display displayctrl IDC_RSCDISPLAYCURATOR_ADDBAR;
_ctrl ctrlShow false;

// Edit button
_ctrl = _display displayctrl IDC_RSCDISPLAYCURATOR_MISSIONBAR;
_ctrl ctrlShow false;


/*
[] spawn
{
sleep 2;

_display = finddisplay 312;
{
_ctrl = _display displayctrl _x;

systemchat format["Hmm %1", _ctrl];

_ctrl ctrlRemoveAllEventHandlers "MouseMoving";
_ctrl ctrlRemoveAllEventHandlers "mouseholding";
_ctrl ctrlRemoveAllEventHandlers "MouseButtonDown";
} foreach [IDC_RSCDISPLAYCURATOR_MOUSEAREA,IDC_RSCDISPLAYCURATOR_MISSION];
};
*/


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
/*
if(_key == FIRE_MISSION_KEY) then
{
 firemisDown = true;
};*/

if(_shift) then
{
 shiftDown = true;
};


false
}];


_display displayAddEventHandler ["MouseButtonUp",
{
 params ["_displayorcontrol", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];


if(_button == 0) then
{
 [(screenToWorld [_xPos,_yPos])] call doMouseClickAction;
};

 true
}];


rightMouseButtonDown = false;
facingArrow = objnull;
facingExtraArrows = [];

_display displayAddEventHandler ["MouseButtonDown",
{
 params ["_displayorcontrol", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

 _handled = false;

if(_button == 1 && _ctrl) then
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


if((rightMouseButtonDown || (specialMove == "setFormDir")) && isnull facingArrow) then
{
 //systemchat "DOWN!";

_sel = curatorSelected # 1;
if(count _sel > 0) then
{
 //systemchat format["READ: %1,%2",_xPos,_yPos];

 rightMouseHoldPos = screenToWorld [_xPos,_yPos];
 //rightMouseHoldPos set [2,1];

 if(specialMove == "setFormDir") then
 {
  rightMouseHoldPos = getpos leader (_sel # 0); // Todo better
 };

 facingArrow = createSimpleObject ["Sign_Arrow_Direction_Blue_F", AGLToASL rightMouseHoldPos,false];
 
 facingArrow setObjectScale 5;

 camLastDir = vectorDir curatorCamera;

 for "_i" from 0 to 5 do
 {
  _arr = createSimpleObject ["Sign_Arrow_Direction_Blue_F", AGLToASL rightMouseHoldPos,false];
  facingExtraArrows pushback _arr;
 };

};
};

 //params ["_display", "_xPos", "_yPos"];
if(!isnull facingArrow) then
{

 _cpos = screenToWorld [_xPos,_yPos];
 
 _angle = [rightMouseHoldPos,_cpos] call getAngle;
  facingArrow setdir _angle;
  facingArrow setObjectScale 5;

 _cen = 1;
 _dir = 1;
 {
  _arr = _x;
  _v = [_angle - 90 * _dir,_cen * 5] call getVector;
  _p = [rightMouseHoldPos,_v] call addVector;
  _p set [2,0];

  _arr setposATL _p;
  _arr setdir _angle;
  _arr setObjectScale 3;

   _dir = _dir * -1;

   if(_dir == 1) then { _cen = _cen + 1;};

 } foreach facingExtraArrows;


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
 //systemchat "UP!";

if(_button == 1) then
{
 rightMouseButtonDown = false;
}; 

if(!isnull facingArrow) then // Dragging for dir?
{
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
};


_handled = true;
};

// Always delete in here because zeus doesn't regognize group deselecting
call deleteDirArrows;

 _handled
}];


deleteDirArrows =
{


if(!isnull facingArrow) then
{
deletevehicle facingArrow;
facingArrow = objNull;

{ deletevehicle _x } foreach facingExtraArrows;
facingExtraArrows = [];

};

};


camLastDir = vectorDir curatorCamera;

addMissionEventHandler ["EachFrame",
{

if(!isnull facingArrow) then
{

 //curatorCamera camSetDir camLastDir;
 //curatorCamera camCommit 0;

 //curatorCamera setPos [position player select 0,position player select 1,30];
 curatorCamera setVectorDirAndUp [camLastDir,[0,0,1]];


};

}];






// _display displayaddeventhandler ["mouseholding",{ systemchat format["TEST %1",time]; }];


/*
_display displayAddEventHandler ["MouseZChanged",{

 systemchat "TEST123";
}];*/



["object",["Curator","UnitPos"]] call setZeusFeatures;
["group",["Curator","SpeedMode","Formation","UnitPos"]] call setZeusFeatures;


 call interceptZeusKeys;




 zeusModded = true;
};



};

setZeusFeatures =
{
 params ["_type","_features"];
 plrZeus setvariable ["BIS_fnc_curatorAttributes" + _type, _features ];
};

interceptZeusKeys =
{
//(findDisplay 312) displayRemoveAllEventHandlers "KeyDown";

findDisplay 312 displayAddEventHandler ["KeyDown",
{
params ["_display", "_key", "_shift", "_ctrl", "_alt"];

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


