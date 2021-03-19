RTSmainPath = "armaRTS.Altis\";


_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

debugMode = true;



sleep 0.1;




[] spawn
{
 while { true } do
{
{
 _group = _x;
 _ldr = leader _group;
if(!isplayer _ldr) then
{

if(isnull (_group getVariable ["arrow",objNull])) then
{
 _arrow = createSimpleObject ["Sign_Arrow_Blue_F", getposASL _ldr,false];
 _group setVariable ["arrow",_arrow];

 _arrow setObjectScale 5;


_mrk = createmarker [format["%1",random 100000], getposASL _ldr];
_mrk setMarkerShape "icon";
_mrk setMarkerType "mil_dot";
_mrk setMarkerColor "ColorRed";

 _group setVariable ["marker",_mrk];
};

_arrow = _group getVariable ["arrow",objNull];
_mrk =  _group getVariable "marker";
_mrk setMarkerPos (getposATL _ldr);

 _p = getposATL _ldr;
 _p set [2, _p # 2 + 5];
 _arrow setposATL _p;
};

} foreach allgroups;

 sleep 2;
};
};


call setupBattleLocation;
call startAiCom;