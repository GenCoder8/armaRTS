RTSmainPath = "armaRTS.Altis\";

#include "..\main.h"


folderPrefix = "";
compileFile =
{
 params ["_path"];
 _path = folderPrefix + _path;
 private _code = compile preprocessFileLineNumbers _path;
 _code
};

_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

loadCovers = false;


debugMode = true;


/*
for "_i" from 0 to 1000 do
{

_v1 = [getdir player + 90, -100 + random 200 ] call getvector;
_v2 = [getdir player, -50 + random 100 ] call getvector;
_vf = [_v1,_v2] call addvector;
_vf = [getpos player,_vf] call addvector;

_mrk = createmarker [format["%1",random 1000], _vf];
_mrk setMarkerShape "icon";
_mrk setMarkerType "mil_dot";
_mrk setMarkerColor "ColorRed";

};
*/

sleep 0.1;



true call startCampaign;

[west,"Tester1","Force1", "marker_17" ] call createForce;
[west,"testers2","Force2", "startWest" ] call createForce;

[east,"testersE","Force1", "marker_18" ] call createForce;

DBGL_NONE call setDebugFlags;