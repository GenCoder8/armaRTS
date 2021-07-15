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

call initGlobalMap;

"globalmap" call openGameScreen;

call beginGmMovePhase;

};