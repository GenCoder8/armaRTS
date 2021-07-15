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

isCustomBattle = false; 

call initGlobalMap;

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