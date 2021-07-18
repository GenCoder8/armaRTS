#include "ctrlIds.h"

curScreen = "";

isCustomBattle = false;

openGameScreen =
{
 params ["_screen"];

diag_log format["Opening screen '%1' from '%2'", _screen,curScreen];

// Cleanup first
switch (curScreen) do
{
case "mainMenu": { call closeMainMenu; };
case "globalmap": { call closeGlobalMap; };
case "customBattle": { closeDialog 0; };
case "poolSelect": { closeDialog 0; };
/*
case "battle";
case "placement":
{

 cutRsc["default","PLAIN",0];

 if(_screen != "battle") then // Going anywhere else than battle (could be placement...)
 {
  call closeBattlefieldZeus;
  call clearBattlefieldLogic;
  call clearBattleguiButtons;
 };

 if(curScreen == "battle") then
 {
  call stopAiCom;
 };
};
*/
};


 if(curScreen == "placement" || curScreen == "battle") then
 {
  cutRsc["default","PLAIN",0];

 if(_screen != "battle") then // Going anywhere else than battle (could be placement...)
 {
  call closeBattlefieldZeus;
  call clearBattlefieldLogic;
  call clearBattleguiButtons;
 };
 };


 if(curScreen == "battle") then
 {
  call stopAiCom;
 };

 // Open new screen
 switch (_screen) do
 {
  case "mainMenu": { call openMainMenu; };
  case "endingDlg": { call openEndingDlg; };
  case "globalmap": { call openGlobalMap; };
  case "customBattle": { isCustomBattle = true; call openCustomBattleDlg; };
  case "poolSelect": { call openPoolDlg; };
  case "placement": 
  {
   call beginBattlePlacement;
   call activateBattleGui;

   // Have to wait the battle is setup because of eachframe runs
   [] spawn setupBattlefieldLogic;
   "placement" spawn setBattleGuiButtons;
  };
  case "battle": 
  {
   removeAllCuratorAddons plrZeus;
   call activateBattleGui;
   "battle" spawn setBattleGuiButtons;
    
   
   [(call getEnemySide), call getPlayerSide] call startAiCom;

  };
  default { ["Invalid screen name '%1'", _screen] call errmsg; };
 };

 curScreen = _screen;
};

loadScreenStarted = false;
startRtsLoadScreen =
{
 params ["_text"];
 if(loadScreenStarted) exitWith {};

 //startLoadingScreen ["Loading..........","TestloadingScreen"];

 createDialog "RtsLoadingScreen";
_display = findDisplay RTSLOADINGSCREENID;
_textCtrl = _display displayCtrl 1000;
_textCtrl ctrlSetText format ["%1...", _text]; 

 loadScreenStarted = true;

 sleep 0.1; // Give time to start
};

nextLoadBar =
{
 params ["_progress"];

 //progressLoadingScreen _progress;

};

endRtsLoadScreen =
{


 if(loadScreenStarted) then
 {

  closeDialog 0;
 };

 loadScreenStarted = false;
};