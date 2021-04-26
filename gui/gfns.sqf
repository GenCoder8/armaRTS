#include "ctrlIds.h"

openGameScreen =
{
 params ["_screen"];

 switch (_screen) do
 {
  case "poolSelect": { call openPoolDlg; };
  default { ["Invalid screen name '%1'", _screen] call errmsg; };
 };

 curScreen = _screen;
};