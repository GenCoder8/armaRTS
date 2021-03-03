
RTSmainPath = "armaRTS.Altis\";

_w = execvm (RTSmainPath+"bgFns.sqf");
waituntil { scriptdone _w };

errmsg =
{
private "_print";
_print = "";

if((typename  _this) == "ARRAY") then {
_print = format _this;}
else {
_print = _this;
};

_print = "RTS ERROR: " + _print;

player globalchat _print;
//_print remoteExecCall ["printError"]; 

diag_log _print;
};

_w = execvm (RTSmainPath+"bgPool.sqf");
waituntil { scriptdone _w };

[manPoolWest,"testteam"] call addBattleGroupToPool;
[manPoolWest,"testteam"] call addBattleGroupToPool;
[manPoolWest,"mbt"] call addBattleGroupToPool;


//[manPoolWest,"testteam"] call createBattleGroupFromPool;

//[manPoolWest,"mbt"] call createBattleGroupFromPool;


sleep 0.1;
createDialog "UnitPoolDlg";
_w = execvm (RTSmainPath+"gui\unitPool.sqf");
waituntil { scriptdone _w };


