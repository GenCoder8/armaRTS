/* #Dukoki
$[
	1.063,
	["mainmenu",[["safeZoneX","safeZoneY","0","0"],"(5 * 0.5 * pixelW * pixelGrid)","(5 * 0.5 * pixelH * pixelGrid)","UI_GRID"],0,0,0],
	[1600,"",[2,"Exit",["30 * UI_GRID_W + UI_GRID_X","28.5 * UI_GRID_H + UI_GRID_Y","8.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Exit mission","-1"],["action = |call rtsEndGame|;"]],
	[1601,"",[2,"Custom battle",["30 * UI_GRID_W + UI_GRID_X","19.5 * UI_GRID_H + UI_GRID_Y","8.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |call closeMainMenu;  [^customBattle^] call openGameScreen; |;"]],
	[1602,"",[2,"New campaign",["30 * UI_GRID_W + UI_GRID_X","7.5 * UI_GRID_H + UI_GRID_Y","8.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |call closeMainMenu; false call startCampaign|;"]],
	[1603,"",[2,"Continue",["30 * UI_GRID_W + UI_GRID_X","24.5 * UI_GRID_H + UI_GRID_Y","8.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Continue the game","-1"],["action = | call closeMainMenu |;"]],
	[1604,"",[2,"Load",["30 * UI_GRID_W + UI_GRID_X","15.5 * UI_GRID_H + UI_GRID_Y","8.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |call closeMainMenu; false call openSavegameMenu|;"]],
	[1605,"",[2,"Save",["30 * UI_GRID_W + UI_GRID_X","11.5 * UI_GRID_H + UI_GRID_Y","8.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |call closeMainMenu; true call openSavegameMenu|;"]],
	[1000,"",[2,"Version: 00",["46.5 * UI_GRID_W + UI_GRID_X","31 * UI_GRID_H + UI_GRID_Y","4.5 * UI_GRID_W","1.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
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
// GUI EDITOR OUTPUT START (by GC, v1.063, #Dukoki)
////////////////////////////////////////////////////////

class RscButton_1600: RscButton
{
	action = "call rtsEndGame";

	idc = 1600;
	text = "Exit"; //--- ToDo: Localize;
	x = 30 * UI_GRID_W + UI_GRID_X;
	y = 28.5 * UI_GRID_H + UI_GRID_Y;
	w = 8.5 * UI_GRID_W;
	h = 3 * UI_GRID_H;
	tooltip = "Exit mission"; //--- ToDo: Localize;
};
class RscButton_1601: RscButton
{
	action = "call closeMainMenu;	['customBattle'] call openGameScreen; ";

	idc = 1601;
	text = "Custom battle"; //--- ToDo: Localize;
	x = 30 * UI_GRID_W + UI_GRID_X;
	y = 19.5 * UI_GRID_H + UI_GRID_Y;
	w = 8.5 * UI_GRID_W;
	h = 3 * UI_GRID_H;
};
class RscButton_1602: RscButton
{
	action = "call closeMainMenu; false call startCampaign";

	idc = 1602;
	text = "New campaign"; //--- ToDo: Localize;
	x = 30 * UI_GRID_W + UI_GRID_X;
	y = 7.5 * UI_GRID_H + UI_GRID_Y;
	w = 8.5 * UI_GRID_W;
	h = 3 * UI_GRID_H;
};
class RscButton_1603: RscButton
{
	action = " call closeMainMenu ";

	idc = 1603;
	text = "Continue"; //--- ToDo: Localize;
	x = 30 * UI_GRID_W + UI_GRID_X;
	y = 24.5 * UI_GRID_H + UI_GRID_Y;
	w = 8.5 * UI_GRID_W;
	h = 3 * UI_GRID_H;
	tooltip = "Continue the game"; //--- ToDo: Localize;
};
class RscButton_1604: RscButton
{
	action = "call closeMainMenu; false call openSavegameMenu";

	idc = 1604;
	text = "Load"; //--- ToDo: Localize;
	x = 30 * UI_GRID_W + UI_GRID_X;
	y = 15.5 * UI_GRID_H + UI_GRID_Y;
	w = 8.5 * UI_GRID_W;
	h = 3 * UI_GRID_H;
};
class RscButton_1605: RscButton
{
	action = "call closeMainMenu; true call openSavegameMenu";

	idc = 1605;
	text = "Save"; //--- ToDo: Localize;
	x = 30 * UI_GRID_W + UI_GRID_X;
	y = 11.5 * UI_GRID_H + UI_GRID_Y;
	w = 8.5 * UI_GRID_W;
	h = 3 * UI_GRID_H;
};
class RscText_1000: RscText
{
	idc = 1000;
	text = "Version: 00"; //--- ToDo: Localize;
	x = 46.5 * UI_GRID_W + UI_GRID_X;
	y = 31 * UI_GRID_H + UI_GRID_Y;
	w = 4.5 * UI_GRID_W;
	h = 1.5 * UI_GRID_H;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////




};

};
