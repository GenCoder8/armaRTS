RTSmainPath = "armaRTS.Altis\";


_w = execvm (RTSmainPath+"load.sqf");
waituntil { scriptdone _w };

debugMode = true;

// setGroupIconsSelectable true;


beginBattle =
{


//plrZeus allowCuratorLogicIgnoreAreas true;
 
//plrZeus removeCuratorEditingArea 0;

call activateBattleGui;
};





["marker_0",120] call beginBattlePlacement;

call beginBattle;
