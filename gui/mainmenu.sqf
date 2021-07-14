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
 
 endMission "END1";

 //forceEnd;
};