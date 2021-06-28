#include "..\main.h"

_display = controlNull;

waituntil { _display = findDisplay 12; !isnull _display };




//hint format["action! %1", _bt ];

gmPhase = "move";

gmControls = [];

with uinamespace do
{
gmNextButtton = nil;
};

beginGmMovePhase =
{
gmPhase = "move";

call resetForcesTurn;

_gpos = ([23,35,5,3] call getGuiPos);

with uinamespace do
{

if(isnil "gmNextButtton") then
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
};


gmControls pushback gmNextButtton;
};

 (uinamespace getVariable "gmNextButtton") ctrlSetText "End round";
 (uinamespace getVariable "gmNextButtton") buttonSetAction " call beginGmBattlePhase ";

};

beginGmBattlePhase =
{
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

 (uinamespace getVariable "gmNextButtton") ctrlSetText "To battle";
 (uinamespace getVariable "gmNextButtton") buttonSetAction " call gmBeginBattle ";

 }
 else
 {
 hint "End of battles";

 };

};

gmBeginBattle =
{
 _nextBattle = gmBattles # gmCurBattleIndex;
 _nextBattle params ["_placeMrk","_westForce","_eastForce"];

 hint format["Next battle %1 -- %2", _nextBattle # 0, markerpos ( _nextBattle # 0)];

 [_placeMrk,90] call setNextBattleArgs;

 ["poolSelect"] call openGameScreen;

 (_westForce # FORCE_ROSTER) call fillWithRandomBgs; // For player
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
 (uinamespace getVariable "gmNextButtton") ctrlSetText "Next round";
 (uinamespace getVariable "gmNextButtton") buttonSetAction " call beginGmMovePhase ";
}
else
{
 call gmSelectNextBattle;
};

};

pos = getpos player;

pos set [1, (pos # 1) + 100];




#define TEST_ICON_SIZE 10

findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", 
{
if(curScreen != "globalmap") exitWith {};

/*
if(curScreen != "globalmap") exitWith {};

	_this select 0 drawIcon [
		getMissionPath "unit.jpg", // Custom images can also be used: getMissionPath "\myFolder\myIcon.paa"
		[1,1,1,1],
		pos,
		TEST_ICON_SIZE / ( (1 call scaleToMap)),
		TEST_ICON_SIZE / ( (1 call scaleToMap)),
		45,
		"Player Vehicle",
		1,
		0.03,
		"TahomaB",
		"right"
	];
*/
 call renderForces;

}];




_defaultMainMapCtrl = (findDisplay 12 displayCtrl 51);
_defaultMainMapCtrl ctrlAddEventHandler ["MouseMoving"," _this call mouseMoveUpdate; "];
_defaultMainMapCtrl ctrlAddEventHandler ["MouseButtonUp"," _this call mouseButtonUp; "];


onForceDeselect =
{
 selectedForce = "";
 (uiNamespace getVariable "forceInfoCtrl") ctrlSetText "";

 (uiNamespace getVariable "forceCtrlGroup") ctrlShow false;
};

onForceSelect =
{
 (uiNamespace getVariable "forceImg") ctrlSetText (selectRandom solImgs);

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
 hintSilent "Over force";
};

//};

if(lastHighlight != "") then
{
lastHighlight setmarkeralpha BATTLE_LOC_ALPHA;
lastHighlight setMarkerColor BATTLE_LOC_COLOR;
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


if(_numEnemies > 0) then
{
 _bf setMarkerColor "ColorRed";
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

// If more than one then it's engagement
if(count (_floc call getForcesAtBattleLoc) == 1) then
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
 hint "No connection";
};

}
else
{
 hint "loc occupied";
};


}
else
{
 hint "No more turns left";
};

}
else
{
 hint "Cant leave engagement";
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
 selectedForce = _force;
 hint "Force selected!";
 _force call onForceSelect;
 };
}
else
{

_bf = [_pos] call hoverOnBattlefield;


if(_bf != "") then
{
[selectedForce,_bf] call moveForceToBattleloc;

call onForceDeselect;
hint "Moved to battlefield";
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

if(_pos distance2D (getMarkerPos _x) < ((2000) * ( (1 call scaleToMap))) ) exitWith
{
 _ret = _x;
};

} foreach _locs;

_ret
};