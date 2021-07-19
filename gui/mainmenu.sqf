#include "ctrlids.h";

openMainMenu =
{
 createDialog "MainMenuDlg";

 _display = finddisplay MAINMENUID;

 // Disable main menu keys (No esc quit)
 _display displaySetEventHandler ["KeyDown", " true "];

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

// Better reset this
allforces = createHashMap;

isCustomBattle = false; 

call initGlobalMap;

[west,"usa1","USA1", "startWest" ] call createForce;
[west,"usa2","TestRosterWest", "marker_17_vic" ] call createForce;

[east,"nva1","NVA1", "startEast" ] call createForce;
[east,"nva2","NVA1", "marker_12" ] call createForce;

"globalmap" call openGameScreen;

call beginGmMovePhase;

};

createReturnToMenuButton =
{

_display = findDisplay 12;

if(isnull _display) exitWith { "Cant create return to menu button" call errmsg; };

_bt = _display ctrlCreate ["Rscbutton", -1, controlNull];
_bt ctrlSetText format["Return to menu"];
_bt buttonSetAction " ['mainMenu'] call openGameScreen; ";
//_bt ctrlsetTooltip "";
_bt ctrlSetPosition ([44.5,-4,7,2,false] call getGuiPos);
_bt ctrlCommit 0;

};

// Ending dlg code also in here

openEndingDlg =
{

createDialog "BattleEndingDlg";

_display = finddisplay RTSENDINGDLGID;
_display displaySetEventHandler ["KeyDown", " true "];


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
 ["mainMenu"] call openGameScreen;
};

};