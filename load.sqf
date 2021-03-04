
_w = execvm (RTSmainPath+"bgFns.sqf");
waituntil { scriptdone _w };


_w = execvm (RTSmainPath+"bgPool.sqf");
waituntil { scriptdone _w };


_w = execvm (RTSmainPath+"gui\unitPool.sqf");
waituntil { scriptdone _w };

