/* #Mitiwy
$[
	1.063,
	["mainmenu",[["safeZoneX","safeZoneY","0","0"],"(5 * 0.5 * pixelW * pixelGrid)","(5 * 0.5 * pixelH * pixelGrid)","UI_GRID"],0,0,0],
	[1600,"",[2,"Exit",["30 * UI_GRID_W + UI_GRID_X","24.5 * UI_GRID_H + UI_GRID_Y","8.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |call rtsEndGame|;"]],
	[1601,"",[2,"Custom battle",["30 * UI_GRID_W + UI_GRID_X","13.5 * UI_GRID_H + UI_GRID_Y","8.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |call closeMainMenu;  [^customBattle^] call openGameScreen; |;"]],
	[1602,"",[2,"New campaign",["30 * UI_GRID_W + UI_GRID_X","9 * UI_GRID_H + UI_GRID_Y","8.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |false call startCampaign|;"]],
	[1603,"",[2,"Continue",["30 * UI_GRID_W + UI_GRID_X","18 * UI_GRID_H + UI_GRID_Y","8.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |  call closeMainMenu |;"]]
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
// GUI EDITOR OUTPUT START (by GC, v1.063, #Mitiwy)
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
	action = "call closeMainMenu;	['customBattle'] call openGameScreen; ";

	idc = 1601;
	text = "Custom battle"; //--- ToDo: Localize;
	x = 30 * UI_GRID_W + UI_GRID_X;
	y = 13.5 * UI_GRID_H + UI_GRID_Y;
	w = 8.5 * UI_GRID_W;
	h = 3 * UI_GRID_H;
};
class RscButton_1602: RscButton
{
	action = "false call startCampaign";

	idc = 1602;
	text = "New campaign"; //--- ToDo: Localize;
	x = 30 * UI_GRID_W + UI_GRID_X;
	y = 9 * UI_GRID_H + UI_GRID_Y;
	w = 8.5 * UI_GRID_W;
	h = 3 * UI_GRID_H;
};
class RscButton_1603: RscButton
{
	action = "	call closeMainMenu ";

	idc = 1603;
	text = "Continue"; //--- ToDo: Localize;
	x = 30 * UI_GRID_W + UI_GRID_X;
	y = 18 * UI_GRID_H + UI_GRID_Y;
	w = 8.5 * UI_GRID_W;
	h = 3 * UI_GRID_H;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////


};

};
