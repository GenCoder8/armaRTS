
getRankIcon =
{
params ["_rank"];

private _icon = switch(_rank) do
{
 case 0: { "\a3\ui_f\data\gui\cfg\ranks\private_gs.paa" };
 case 1: { "\a3\ui_f\data\gui\cfg\ranks\corporal_gs.paa" };
 case 2: { "\a3\ui_f\data\gui\cfg\ranks\sergeant_gs.paa" };
 case 3: { "\a3\ui_f\data\gui\cfg\ranks\lieutenant_gs.paa" };
 case 4: { "\a3\ui_f\data\gui\cfg\ranks\captain_gs.paa" };
 case 5: { "\a3\ui_f\data\gui\cfg\ranks\major_gs.paa" };
 case 6: { "\a3\ui_f\data\gui\cfg\ranks\colonel_gs.paa" };
};

_icon
};

rankToNumber =
{
 params ["_rankName"];

 private _rankId = ["PRIVATE","CORPORAL","SERGEANT","LIEUTENANT","MAJOR","COLONEL"] find _rankName;

 _rankId
};

getRankFromCfg =
{
params ["_bgCfg","_index"];
private _rank = "PRIVATE";
private _ranks = getArray (_bgCfg >> "ranks");
if(_index < (count _ranks)) then
{
 _rank = _ranks select _index;
};
_rank
};
