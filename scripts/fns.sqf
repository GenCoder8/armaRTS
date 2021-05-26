dbgmsg =
{
if(typename _this == "ARRAY") then
{
_this = format _this;
};
 systemchat format["DBG: %1",_this];
};

getObjectSize =
{
 private _veh = _this;
 private ["_bbr","_p1","_p2"]; 
 
 _bbr = boundingBoxReal _veh;
 _p1 = _bbr select 0;
 _p2 = _bbr select 1;

 // Width, Length, Height
 [abs ((_p2 select 0) - (_p1 select 0)), abs ((_p2 select 1) - (_p1 select 1)), abs ((_p2 select 2) - (_p1 select 2))]
};

isUserMarker =
{
(_this find "_USER_DEFINED") >= 0
};