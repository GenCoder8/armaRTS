RTSmainPath = "armaRTS.Altis\";


_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };


beginBattlePlacement =
{
 params ["_areaMarker","_attackDir"];

deployAreaMain = _areaMarker;

_areaPos = markerPos _areaMarker;
_areaSize = markerSize _areaMarker;

_deployAreaDepth = 75;
_deployAreaWidth = _areaSize # 0;

{
_deployDir = _x;

_vecFromCenter = [_attackDir + _deployDir, _areaSize # 0 - _deployAreaDepth ] call getvector;
_placeAreaRectPos = [_vecFromCenter,_areaPos] call addvector;

_mrk = createmarker [format["deploySide%1",_deployDir], _placeAreaRectPos];
_mrk setMarkerShape "RECTANGLE";
_mrk setMarkerColor "ColorBlack";
_mrk setMarkerSize [_areaSize # 0,_deployAreaDepth];
_mrk setMarkerDir _attackDir;

if(_foreachIndex == 0) then
{
deployAreaA = _mrk;
}
else
{
deployAreaB = _mrk;
};

} foreach [0,180];

/*
for "_i" from 0 to 1000 do
{

_v1 = [_attackDir + 90, -_deployAreaWidth + random (_deployAreaWidth*2) ] call getvector;
_v2 = [_attackDir, -_deployAreaDepth + random (_deployAreaDepth*2) ] call getvector;
_vf = [_v1,_v2] call addvector;
_vf = [_vecFromCenter,_vf] call addvector;
_vf = [_areaPos,_vf] call addvector;

_mrk = createmarker [format["%1",random 1000], _vf];
_mrk setMarkerShape "icon";
_mrk setMarkerType "mil_dot";
_mrk setMarkerColor "ColorRed";

};*/


};


["marker_0",120] call beginBattlePlacement;
