
/*
{
_deployDir = _x;

_vecFromCenter = [_attackDir + _deployDir, _areaSize # 0 - _deployAreaDepth ] call getvector;
_placeAreaRectPos = [_vecFromCenter,_areaPos] call addvector;

_mrk = createmarker [format["deploySide%1",_deployDir], _placeAreaRectPos];
_mrk setMarkerShape "RECTANGLE";
_mrk setMarkerColor "ColorBlack";
_mrk setMarkerSize [_areaSize # 0,_deployAreaDepth];
_mrk setMarkerDir _attackDir;

_angle = 0;
{
_x params ["_width","_depth"];

_pax = 0;
while { _pax < (_width * 2) } do
{

_vex = [_attackDir + 90 + _angle, _pax - (_width)  ] call getvector;
_vey = [_attackDir + _angle, _depth ] call getvector;
_ve = [_vex,_vey] call addvector;

_vf = [_ve,_vecFromCenter] call addvector;
_vf = [_areaPos,_vf] call addvector;

_vf set [2,0];
createSimpleObject ["Sign_Arrow_F",AGLToASL _vf,true];

_pax = _pax + 5;
};

_angle = _angle + 90;
} foreach [[_deployAreaWidth,_deployAreaDepth], [_deployAreaDepth,_deployAreaWidth], [_deployAreaWidth,_deployAreaDepth], [_deployAreaDepth,_deployAreaWidth]];

if(_foreachIndex == 0) then
{
deployAreaA = _mrk;
}
else
{
deployAreaB = _mrk;
};

} foreach [0,180];
*/

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