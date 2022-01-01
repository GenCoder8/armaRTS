#include "..\main.h"


//hint format["action! %1", _bt ];

gmPhase = "move";
gmCurBattleIndex = 0;

uinamespace setVariable ["gmControls",[]];
uinamespace setVariable ["gmNextButtton",controlNull];



openGlobalMap =
{
 openMap [true, !debugMode];

call createReturnToMenuButton;

_display = findDisplay 12;

// Create global map controls
_ctrlg = _display ctrlCreate ["RscControlsGroup", -1, controlNull];
_ctrlg ctrlSetPosition ([36,23,15,15,false] call getGuiPos);
_ctrlg ctrlCommit 0;
_ctrlg ctrlShow false;

uiNamespace setVariable ["forceCtrlGroup", _ctrlg];


_img = _display ctrlCreate ["RscPicture", -1, _ctrlg];
_img ctrlSetText "#(argb,8,8,3)color(0,1,0,1)﻿";
_img ctrlSetPosition ([0,5,15,5,false] call getGuiPos);
_img ctrlCommit 0;

_txt = _display ctrlCreate ["RscTextMulti", -1, _ctrlg];
_txt ctrlSetText "";
_txt ctrlSetPosition ([0,5,15,5,false] call getGuiPos);
_txt ctrlCommit 0;

uiNamespace setVariable ["forceInfoCtrl", _txt];


_img = _display ctrlCreate ["RscPicture", -1, _ctrlg];
_img ctrlSetText "";
_img ctrlSetPosition ([7,0,5,5,false] call getGuiPos);
_img ctrlCommit 0;

uiNamespace setVariable ["forceImg", _img];


_bt = _display ctrlCreate ["Rscbutton", -1, _ctrlg];
_bt ctrlSetText format["X"];
_bt buttonSetAction "call onForceDeselect;";
//_bt ctrlsetTooltip "";
_bt ctrlSetPosition ([0,4,1,1,false] call getGuiPos);
_bt ctrlCommit 0;

uiNamespace setVariable ["forceDeselect", _bt];


_gpos = ([23,35,5,3] call getGuiPos);
_phaseTextPos = ([12,-5.5,15,1,false] call getGuiPos);

with uinamespace do
{

if(isnull gmNextButtton) then
{
_display = findDisplay 12;

_bt = _display ctrlCreate ["Rscbutton", -1, controlNull];
//_bt ctrlSetText format["unit.jpg"];
_bt ctrlSetText format[""];
_bt buttonSetAction "";
//_bt ctrlsetTooltip "";
_bt ctrlSetPosition _gpos;
_bt ctrlCommit 0;

gmNextButtton = _bt;

gmControls pushback gmNextButtton;


_txt = _display ctrlCreate ["RscText", -1, controlNull];
_txt ctrlSetText "";
_txt ctrlSetPosition _phaseTextPos;
_txt ctrlCommit 0;
_txt ctrlSetTextColor [1,0,0,1];
gmControls pushback _txt;
uiNamespace setVariable ["phaseText", _txt];

};


};


if(isCustomBattle) then { (uinamespace getVariable "gmNextButtton") ctrlShow false; };


};

closeGlobalMap =
{

with uinamespace do
{
 { ctrlDelete _x; } foreach gmControls;
 gmControls = [];
};

 // Delete connection markers
{ deletemarker _x; }  foreach battlelocConArrows;
battlelocConArrows = [];

 // Clear map gui
 //ctrlDelete (uiNamespace getVariable "forceImg");
 //ctrlDelete (uiNamespace getVariable "forceInfoCtrl");
 ctrlDelete (uiNamespace getVariable "forceCtrlGroup");
 //ctrlDelete (uiNamespace getVariable "forceDeselect");


uiNamespace setVariable ["gmNextButtton", controlNull];


openMap [false,false];

};

beginGmMovePhase =
{
params [["_resetMoves",true]];

gmPhase = "move";

if(_resetMoves) then
{
call resetForcesTurn;
};

 (uinamespace getVariable "phaseText") ctrlSetText "Move phase";
 (uinamespace getVariable "gmNextButtton") ctrlSetText "End round";
 (uinamespace getVariable "gmNextButtton") buttonSetAction " call beginGmBattlePhase ";
};

beginGmBattlePhase =
{
 call aiTurn; // Ais turn before round is ended

 gmPhase = "battles";

 gmBattles = call getGlobalBattles;
 gmCurBattleIndex = 0;

 call gmCheckRoundEnd;
};

gmSelectNextBattle =
{

 if(gmCurBattleIndex < (count gmBattles)) then
 {
  private _battle = gmBattles # gmCurBattleIndex;
  _battle params ["_loc","_force1","_force2"];

 private _map =  findDisplay 12 displayCtrl 51;
 _map ctrlMapAnimAdd [1, 0.05, getMarkerPos _loc];
 ctrlMapAnimCommit _map;
 
  (uinamespace getVariable "phaseText") ctrlSetText "Battle phase";
 (uinamespace getVariable "gmNextButtton") ctrlSetText "To battle";
 (uinamespace getVariable "gmNextButtton") buttonSetAction " call gmBeginBattle ";

 }
 else
 {
 [DBGL_GMGUI,"End of battles"] call dbgmsgl;
 };

};

gmBeginBattle =
{
 _nextBattle = gmBattles # gmCurBattleIndex;
 _nextBattle params ["_placeMrk","_westForce","_eastForce"];

 // hint format["Next battle %1 -- %2", _nextBattle # 0, markerpos ( _nextBattle # 0)];

 // Must set these for global map battles (Maybe for custombattle too?)
 if((_westForce # FORCE_SIDE) == (call getPlayerSide)) then
 {
  curPlrForce = _westForce;
  curEnemyForce = _eastForce;
 }
 else
 {
  curPlrForce = _eastForce;
  curEnemyForce = _westForce;
 };

 _bangle = [markerpos startMarkerWest,markerpos startMarkerEast] call getAngle;


 [_placeMrk,_bangle] call setNextBattleArgs;

 ["poolSelect"] call openGameScreen;

 [curPlrForce,curEnemyForce] call setForcesToPlayWith;
};

setForcesToPlayWith =
{
 params ["_plrForce","_enemyForce"];

 ([_plrForce] call getForceRoster) call fillWithRandomBgs; // For player

 enemySelectedBgs = [_enemyForce # FORCE_SIDE,([_enemyForce] call getForceRoster)] call getBgSelectedList;
};

endBattle =
{
 params [["_loser",west],["_reason","morale"]];

battleLoser = _loser;
battleEndReason = _reason;

if(!isCustomBattle) then
{
{
  _x call retAllBattleGroupsToPool;
} foreach [east,west];

_winnerForce = [];

// Delete depleted forces here (Should have returned to pool)
{
_force = _x;

if(!([_force] call isForceAlive)) then
{

if((_force # FORCE_SIDE) == (call getPlayerSide)) then
{
 hint "Your force was destroyed"; // Todo better msg to player
};
[_force] call deleteForce;

}
else
{

if(_loser == (_force # FORCE_SIDE)) then
{
_loc = [_force] call getForceFleeLocation;
if(_loc != "") then
{
 systemchat format["Fleeing to %1", _loc];
 [_force,_loc] call moveForceToBattleloc;
};
}
else // Winner here
{
 _winnerForce = _force;
};

};

} foreach [curPlrForce,curEnemyForce];

 // Do this last after fleeing
 [_winnerForce] call claimBattleVictoryLoc; // Capture (if not already owned)

};

["endingDlg"] call openGameScreen;

};

onBattleEnded =
{

 gmCurBattleIndex = gmCurBattleIndex + 1;

 systemchat format["gmCurBattleIndex %1", gmCurBattleIndex];

 call gmCheckRoundEnd;

};

gmCheckRoundEnd =
{

if(gmCurBattleIndex >= (count gmBattles) || (count gmBattles) == 0) then
{
 (uinamespace getVariable "phaseText") ctrlSetText "End of round";
 (uinamespace getVariable "gmNextButtton") ctrlSetText "Next round";
 (uinamespace getVariable "gmNextButtton") buttonSetAction "[] call beginGmMovePhase ";
}
else
{
 call gmSelectNextBattle;
};

};



getIconScale =
{
 (1 - (1 call scaleToMap)) * FORCE_ICON_SIZE
};


onForceDeselect =
{
 selectedForce = "";
 (uiNamespace getVariable "forceInfoCtrl") ctrlSetText "";

 (uiNamespace getVariable "forceCtrlGroup") ctrlShow false;

};

onForceSelect =
{
 params ["_force"];

 selectedForce = _force;

 _solImgs = getArray ((call getRtsDefs) >> "solImgs");

 if(count _solImgs > 0) then
 {
 (uiNamespace getVariable "forceImg") ctrlSetText (selectRandom _solImgs);
 };

 (uiNamespace getVariable "forceInfoCtrl") ctrlSetText (selectedForce call getForceInfo);

 (uiNamespace getVariable "forceCtrlGroup") ctrlShow true;

};

lastHighlight = "";

mouseMoveUpdate =
{
params ["_control", "_xPos", "_yPos", "_mouseOver"];

if(curScreen != "globalmap") exitWith {};
if(gmPhase != "move") exitWith {};

private _pos = _control ctrlMapScreenToWorld [_xPos,_yPos];

// ( (FORCE_ICON_SIZE/2) * (1 - (1 call scaleToMap))  )
/*
if(_pos distance2D pos < (TEST_ICON_SIZE * 250 * ( (1 call scaleToMap))) ) then
{
 hint "Over!";
}
else
{
 hint "away";
*/
if(([_pos, call getPlayerSide] call getForceAtPos) != "") then
{
 //hintSilent "Over force";
 //[DBGL_GMGUI,""] call dbgmsgl;
};

//};

if(lastHighlight != "") then
{
lastHighlight setmarkeralpha BATTLE_LOC_ALPHA;
lastHighlight setMarkerColor BATTLE_LOC_COLOR;
mouseOverLoc = "";
};

_highlightingSelection = false;

if(selectedForce != "") then
{
_bf = [_pos] call hoverOnBattlefield;

if(_bf != "") then
{
 //_curMrk = selectedForce call getForcePosMarker;
 //_cons = battlelocConnections get _curMrk;

_numEnemies = [call getEnemySide,_bf] call countSideForcesAtBattleLoc;

mouseOverLoc = "free";

if(_numEnemies > 0) then
{
 _bf setMarkerColor "ColorRed";
 mouseOverLoc = "enemy";
};

_bf setmarkeralpha 1;

lastHighlight = _bf;


};

}
else
{
 _hforce = [_pos] call hoverOnForce;
 if(_hforce != "") then
 {
 // if(_hforce call numForceMoves > 0) then
  //{
  _mrk = _hforce call getForcePosMarker;
  _mrk setmarkeralpha 1;
  lastForceHighlight = _mrk;
   _highlightingSelection = true;
 // };
 }
 else
 {
  
 };
};

if(selectedForce != "" || !_highlightingSelection) then
{
 lastForceHighlight setmarkeralpha BATTLE_LOC_ALPHA;
};

};

hoverOnForce =
{
params ["_pos"];

private _retForce = "";

_overForce = ([_pos, call getPlayerSide] call getForceAtPos);
if(_overForce != "") then
{

if(_overForce call isFriendlyForce) then
{

_retForce = _overForce;

}
else
{
 hint "Can't select enemy";
};

};
 _retForce
};

hoverOnBattlefield =
{
params ["_pos"];

private _retBf = "";

if(selectedForce == "") exitWith { "" };

private _bf = [_pos] call isMouseOverBattlefield;
if(_bf != "") then
{
 private _floc = (selectedForce call getForcePosMarker);

// If not engagement
if(!(_floc call isEngagementInLoc)) then
{

if(selectedForce call numForceMoves > 0) then
{

_forcesHere = _bf call getForcesAtBattleLoc;

//systemchat format[">> %1 - %2",selectedForce, [selectedForce,_forcesHere] call countForceFriendlies];

if([selectedForce,_forcesHere] call countForceFriendlies == 0) then
{
//systemchat "HERE";

_curLoc = selectedForce call getForcePosMarker;

_cons = battlelocConnections get _bf;



if(_cons find _curLoc >= 0) then
{

_retBf = _bf;

}
else
{
 [DBGL_GMGUI,"No connection"] call dbgmsgl;
};

}
else
{
 [DBGL_GMGUI,"loc occupied"] call dbgmsgl;
};


}
else
{
 [DBGL_GMGUI,"No more turns left"] call dbgmsgl;
};

}
else
{
 [DBGL_GMGUI,"Cant leave engagement"] call dbgmsgl;
};

};

 _retBf
};

mouseButtonUp =
{
params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

if(curScreen != "globalmap") exitWith {};
if(gmPhase != "move") exitWith {};

private _pos = _control ctrlMapScreenToWorld [_xPos,_yPos];


if(_button == 0) then
{

if(selectedForce == "") then
{
 _force = [_pos] call hoverOnForce;
 if(_force != "") then
 {
 [DBGL_GMGUI,"Force selected!"] call dbgmsgl;
 [_force] call onForceSelect;
 };
}
else
{

_bf = [_pos] call hoverOnBattlefield;


if(_bf != "") then
{
[selectedForce,_bf] call moveForceToBattleloc;

call onForceDeselect;

[DBGL_GMGUI,"Moved to battlefield"] call dbgmsgl;
};

};

};
/*
if(_button == 1) then
{
 selectedForce = "";
 hint "Deselect";
};*/

};

selectedForce = "";


isMouseOverBattlefield =
{
 params ["_pos"];
 private _ret = "";

_locs = gmBattleLocations;

{
private _mrk = _x # BATTLELOC_MARKER;
if(_pos distance2D (getMarkerPos _mrk) < ((2000) * ( (1 call scaleToMap))) ) exitWith
{
 _ret = _mrk;
};

} foreach _locs;

_ret
};





_display = controlNull;

waituntil { _display = findDisplay 12; !isnull _display };


#define TEST_ICON_SIZE 10

findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", 
{
params ["_mapCtrl"];

if(curScreen != "globalmap") exitWith {};

// private _is = call getIconScale;

private _meterInScreen = (_mapCtrl ctrlMapWorldToScreen [1, 0]) # 0 - (_mapCtrl ctrlMapWorldToScreen [0, 0]) # 0;


[BATTLE_AREA_SIZE,BATTLE_AREA_SIZE] apply {_x * _meterInScreen * 640 * 2} params ["_iconWidth", "_iconHeigth"];



{

if(_x # BATTLELOC_ISVICLOC) then
{
 _mrk = _x # BATTLELOC_MARKER;
 _side = _x # BATTLELOC_OWNER;

#define BL_SCALE 1

_color = [1,1,1,1];
if(_side == west) then { _color = [0,0,1,1]; };
if(_side == east) then { _color = [1,0,0,1]; };

	_mapCtrl drawIcon [
		getMissionPath RTSmainPath + ("gui\images\fromUnsung\starLG.paa"),
		_color,
		markerpos _mrk,
		_iconWidth,
		_iconHeigth,
		0,
		"",
		1,
		0.03,
		"TahomaB",
		"right"
	];

};

} foreach gmBattleLocations;


_mapCtrl call renderForces;

if(selectedForce != "") then
{
_pmrk = selectedForce call getForcePosMarker;

	_mapCtrl drawIcon [
		"a3\ui_f\data\map\groupicons\selector_selectable_ca.paa",
		[1,1,1,1],
		markerpos _pmrk,
		_iconWidth,
		_iconHeigth,
		0,
		"",
		1,
		0.03,
		"TahomaB",
		"right"
	];



if(mouseOverLoc != "") then
{

 _icon = "a3\ui_f\data\map\groupicons\selector_selected_ca.paa";
if(mouseOverLoc == "enemy") then
{
 _icon = "a3\ui_f\data\map\groupicons\selector_selectedmission_ca.paa";
};

	_mapCtrl drawIcon [
		_icon,
		[1,1,1,1],
		markerpos lastHighlight,
		_iconWidth,
		_iconHeigth,
		0,
		"",
		1,
		0.03,
		"TahomaB",
		"right"
	];

};

};

// "a3\ui_f\data\map\groupicons\selector_selectedmission_ca.paa"

// "a3\ui_f_curator\data\cfgwrapperui\cursors\curatorselect_ca.paa"
// "a3\ui_f\data\igui\cfg\cursors\selectover_ca.paa"
// "a3\ui_f\data\map\groupicons\selector_selectable_ca.paa"


}];




_defaultMainMapCtrl = (findDisplay 12 displayCtrl 51);
_defaultMainMapCtrl ctrlAddEventHandler ["MouseMoving"," _this call mouseMoveUpdate; "];
_defaultMainMapCtrl ctrlAddEventHandler ["MouseButtonUp"," _this call mouseButtonUp; "];

