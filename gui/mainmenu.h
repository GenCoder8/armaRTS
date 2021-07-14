/* #Likuda
$[
	1.063,
	["mainmenu",[["safeZoneX","safeZoneY","0","0"],"(5 * 0.5 * pixelW * pixelGrid)","(5 * 0.5 * pixelH * pixelGrid)","UI_GRID"],0,0,0],
	[1600,"",[2,"Exit",["30 * UI_GRID_W + UI_GRID_X","24.5 * UI_GRID_H + UI_GRID_Y","8.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |call rtsEndGame|;"]],
	[1601,"",[2,"Custom battle",["30 * UI_GRID_W + UI_GRID_X","13 * UI_GRID_H + UI_GRID_Y","8.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |  [^customBattle^] call openGameScreen; |;"]],
	[1602,"",[2,"test",["30 * UI_GRID_W + UI_GRID_X","17 * UI_GRID_H + UI_GRID_Y","8.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/




class MainMenuDlg
{
 idd = MAINMENUID;

 movingEnable = false;
 
 //onUnload = "";

 class controlsBackground 
 {
 
 	class Background: IGUIBack
    {
	idc = 3700;

	x = 16 * UI_GRID_W + UI_GRID_X;
	y = 6 * UI_GRID_H + UI_GRID_Y;
	w = 36 * UI_GRID_W;
	h = 27 * UI_GRID_H;

	moving = false;
	
	colorBackground[] = {0,0,0,1};
	
    };
 
 };
	
 class objects 
 {
 };
	
	
class controls 
{


////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by GC, v1.063, #Likuda)
////////////////////////////////////////////////////////

class RscButton_1600: RscButton
{
	action = "call rtsEndGame";

	idc = 1600;
	text = "Exit"; //--- ToDo: Localize;
	x = 30 * UI_GRID_W + UI_GRID_X;
	y = 24.5 * UI_GRID_H + UI_GRID_Y;
	w = 8.5 * UI_GRID_W;
	h = 3 * UI_GRID_H;
};
class RscButton_1601: RscButton
{
	action = "	['customBattle'] call openGameScreen; ";

	idc = 1601;
	text = "Custom battle"; //--- ToDo: Localize;
	x = 30 * UI_GRID_W + UI_GRID_X;
	y = 13 * UI_GRID_H + UI_GRID_Y;
	w = 8.5 * UI_GRID_W;
	h = 3 * UI_GRID_H;
};
class RscButton_1602: RscButton
{
	idc = 1602;
	text = "test"; //--- ToDo: Localize;
	x = 30 * UI_GRID_W + UI_GRID_X;
	y = 17 * UI_GRID_H + UI_GRID_Y;
	w = 8.5 * UI_GRID_W;
	h = 3 * UI_GRID_H;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////


};

};
