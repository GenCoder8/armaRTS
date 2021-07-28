#include "..\main.h"



//curDbgLevel = [0, DBGL_AICOM] call BIS_fnc_bitflagsSet;

setDebugFlags =
{
 params ["_flags"];
 curDbgLevel = [0, _flags] call BIS_fnc_bitflagsSet;
};

// Init
if(rtsDebugMode) then
{
 65535 call setDebugFlags;
}
else
{
 DBGL_NONE call setDebugFlags;
};

// [flagset, flag] call BIS_fnc_bitflagsUnset

isDebugLevel =
{
params ["_level"];
([curDbgLevel, _level] call BIS_fnc_bitflagsCheck)
};

dbgmsgl =
{
 private _args = _this;

 private _level = _args # 0;

if(_level call isDebugLevel) then
{

// Rest are the msg/parameters
_msg = _args select [1, count _args - 1];


 _msg call dbgmsg;
};

};

dbgmsg =
{
if(!rtsDebugMode) exitWith {};

if(typename _this == "ARRAY") then
{
_this = format _this;
};
 systemchat format["DBG: %1",_this];
};

