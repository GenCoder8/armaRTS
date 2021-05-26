#include "..\main.h"


curDbgLevel = [0, DBGL_AICOM] call BIS_fnc_bitflagsSet;

dbgmsgl =
{
 private _args = _this;

 private _level = _args # 0;

if([curDbgLevel, _level] call BIS_fnc_bitflagsCheck) then
{

_msg = _args select [1, count _args - 1];


 _msg call dbgmsg;
};

};