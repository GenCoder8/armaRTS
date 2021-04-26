#include "ctrlIds.h"

curScreen = "";

openGameScreen =
{
 params ["_screen"];


// Cleanup first
switch (curScreen) do
{
case "customBattle": { closeDialog 0; };
case "poolSelect": { closeDialog 0; };
case "battle";
case "placement": 
{
 cutRsc["","PLAIN",0]; // Todo works?
};
};




 switch (_screen) do
 {
  case "customBattle": { call openCustomBattleDlg; };
  case "poolSelect": { call openPoolDlg; };
  case "placement": 
  { 
   call activateBattleGui; 
   "placement" call setBattleGuiButtons;
  };
  case "battle": 
  { 
   call activateBattleGui;  
   "battle" call setBattleGuiButtons; 
  };
  default { ["Invalid screen name '%1'", _screen] call errmsg; };
 };

 curScreen = _screen;
};