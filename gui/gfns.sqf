#include "ctrlIds.h"

curScreen = "";

openGameScreen =
{
 params ["_screen"];


// Cleanup first
switch (curScreen) do
{
case "globalmap": { showMap false; call closeGlobalMap; };
case "customBattle": { closeDialog 0; };
case "poolSelect": { closeDialog 0; };
case "battle";
case "placement":
{

 cutRsc["default","PLAIN",0];

 if(_screen != "battle") then
 {
 call closeBattlefieldZeus;
 call clearBattlefieldLogic;
 };

 if(curScreen == "battle") then
 {
  call stopAiCom;
 };
};
};



 switch (_screen) do
 {
  case "globalmap": { call initGlobalMap;  openMap [true, false]; };
  case "customBattle": { call openCustomBattleDlg; };
  case "poolSelect": { call openPoolDlg; };
  case "placement": 
  {
   call beginBattlePlacement;
   call activateBattleGui;
   "placement" call setBattleGuiButtons;

   call setupBattlefieldLogic;
  };
  case "battle": 
  {
   removeAllCuratorAddons plrZeus;
   call activateBattleGui;
   "battle" call setBattleGuiButtons;
    
   
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