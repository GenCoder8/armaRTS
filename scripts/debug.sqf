#include "..\main.h"


curDbgLevel = [0, DBGL_AICOM] call BIS_fnc_bitflagsSet;

dbgmsgl =
{
 params ["_msg","_level"];

 if([curDbgLevel, _level] call BIS_fnc_bitflagsCheck) then
{
 _msg call dbgmsg;
};

};