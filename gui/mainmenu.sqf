#include "\a3\ui_f\hpp\definedikcodes.inc"
#include "ctrlids.h"

openMainMenu =
{
 createDialog "MainMenuDlg";

 _display = finddisplay MAINMENUID;

 // Disable main menu keys (No esc quit)
 _display call disableDlgEscaping;

};

closeMainMenu =
{
 closedialog 0;
};

rtsEndGame =
{
 endMission "END1";
};

startCampaign =
{
params [["_customForces",false]];

call initCampaign;

if(!_customForces) then
{
[west,"usa1","USA1", "startWest" ] call createForce;
[west,"usa2","TestRosterWest", "marker_17_vic" ] call createForce;

[east,"nva1","NVA1", "startEast" ] call createForce;
[east,"nva2","NVA1", "marker_12" ] call createForce;
};

"globalmap" call openGameScreen;

[] call beginGmMovePhase;

};

initCampaign =
{
isCustomBattle = false; 

// Better reset this
allforces = createHashMap;

call initGlobalMap;

};

createReturnToMenuButton =
{

_display = findDisplay 12;

if(isnull _display) exitWith { "Cant create return to menu button" call errmsg; };

_bt = _display ctrlCreate ["Rscbutton", -1, controlNull];
_bt ctrlSetText format["Return to menu"];
_bt buttonSetAction " call openMainMenu ";
//_bt ctrlsetTooltip "";
_bt ctrlSetPosition ([44.5,-4,7,2,false] call getGuiPos);
_bt ctrlCommit 0;

};

// Ending dlg code also in here

openEndingDlg =
{

createDialog "BattleEndingDlg";

_display = finddisplay RTSENDINGDLGID;
_display call disableDlgEscaping;


_outcome = _display displayCtrl 1000;
_reason = _display displayCtrl 1100;

if(battleLoser == (call getPlayerSide)) then
{
_outcome ctrlSetText "Defeat";
_outcome ctrlSetTextColor [1,0,0,1];
}
else
{
_outcome ctrlSetText "Victory!";
_outcome ctrlSetTextColor [0,1,0,1];
};

_reason ctrlSetStructuredText parseText format["%1", ["Battle ended because there is no more men left","Battle ended because morale broke"] select (battleEndReason == "morale") ];

};

closeEndingDlg =
{
 closedialog 0;

// Determine where to go next
if(!isCustomBattle) then
{
 ["globalmap"] call openGameScreen;

 call onBattleEnded;
}
else
{
 call openMainMenu;
};

};

disableDlgEscaping =
{
 params ["_display"];
 _display displaySetEventHandler ["KeyDown", " true "];
};

rtsGameInput =
{
params ["_display", "_key", "_shift", "_ctrl", "_alt"];

systemchat format["input %1 %2",_key, time];

private _handled = false;

if(_key == DIK_ESCAPE) then
{
 call openMainMenu;
 _handled = true;
};

 _handled
};

