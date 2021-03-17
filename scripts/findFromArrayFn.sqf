private ["_arr","_find","_ret","_x","_s1","_keyidx"];

_arr = _this select 0;
_find = _this select 1;
_keyidx = 0;
if(count _this > 2) then {
_keyidx = _this select 2; };

if(typename _arr != "ARRAY") exitwith{ ["findFromArray(1): %1 %2",_arr,_find] call errmsg; };

if(isnil "_find") exitwith { ["nil variable in findFromArray. this: %1",_this] call errmsg; };

_ret = [];

{

if(typename _x != "ARRAY") then { ["findFromArray(2): %1/%2 %3/%4",_arr, typename _arr,_find, typeName _find] call errmsg; };

//["=== %1 '%2' '%3'",_x, _keyidx, _find] call dbgmsg;
//[">>> '%1' %2 %3",(_x select _keyidx),typename (_x select _keyidx),typename _find] call dbgmsg;

_s1 = _x select _keyidx;

if((typename _s1) != (typename _find)) exitwith { ["findFromArray(3): '%1' and '%2' are wrong type",_s1,_find] call errmsg; };

if(_s1 == _find) exitwith
{
//["ret %1",_forEachIndex] call dbgmsg;

_ret = [_x, _forEachIndex];
};


} foreach _arr;

_ret
