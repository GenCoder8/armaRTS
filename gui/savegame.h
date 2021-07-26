/* #Rosoxy
$[
	1.063,
	["savegame",[["safeZoneX","safeZoneY","0","0"],"(5 * 0.5 * pixelW * pixelGrid)","(5 * 0.5 * pixelH * pixelGrid)","UI_GRID"],0,0,0],
	[1500,"",[2,"",["20 * UI_GRID_W + UI_GRID_X","12 * UI_GRID_H + UI_GRID_Y","20.5 * UI_GRID_W","15.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["type = CT_LISTNBOX;","columns[] = SAVEFILE_COLUMNS;"]],
	[1400,"",[2,"Save file name",["21 * UI_GRID_W + UI_GRID_X","9 * UI_GRID_H + UI_GRID_Y","18.5 * UI_GRID_W","1 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"",[2,"save / load",["43 * UI_GRID_W + UI_GRID_X","15.5 * UI_GRID_H + UI_GRID_Y","6 * UI_GRID_W","2.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1601,"",[2,"Close",["43 * UI_GRID_W + UI_GRID_X","23.5 * UI_GRID_H + UI_GRID_Y","6 * UI_GRID_W","2.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |closedialog 0; call openMainMenu|;"]],
	[1602,"",[2,"Delete",["43 * UI_GRID_W + UI_GRID_X","19.5 * UI_GRID_H + UI_GRID_Y","6 * UI_GRID_W","2.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |call rtsDeleteGame|;"]]
]
*/







#define SAVEFILE_COLUMNS {0,0.5}

class SavegameDlg
{
 idd = SAVEGAMEDLGID;

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
	
	colorBackground[] = {0,0,1,1};
	
    };

class RscFrame_1800: RscFrame
{
	idc = 1800;
	x = 20 * UI_GRID_W + UI_GRID_X;
	y = 11.5 * UI_GRID_H + UI_GRID_Y;
	w = 21.5 * UI_GRID_W;
	h = 17 * UI_GRID_H;
};

 };
	
 class objects 
 {
 };
	
	
class controls 
{



////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by GC, v1.063, #Rosoxy)
////////////////////////////////////////////////////////

class RscListbox_1500: RscListbox
{
	type = CT_LISTNBOX;
	columns[] = SAVEFILE_COLUMNS;

	idc = 1500;
	x = 20 * UI_GRID_W + UI_GRID_X;
	y = 12 * UI_GRID_H + UI_GRID_Y;
	w = 20.5 * UI_GRID_W;
	h = 15.5 * UI_GRID_H;
};
class RscEdit_1400: RscEdit
{
	idc = 1400;
	text = "Save file name"; //--- ToDo: Localize;
	x = 21 * UI_GRID_W + UI_GRID_X;
	y = 9 * UI_GRID_H + UI_GRID_Y;
	w = 18.5 * UI_GRID_W;
	h = 1 * UI_GRID_H;
};
class RscButton_1600: RscButton
{
	idc = 1600;
	text = "save / load"; //--- ToDo: Localize;
	x = 43 * UI_GRID_W + UI_GRID_X;
	y = 15.5 * UI_GRID_H + UI_GRID_Y;
	w = 6 * UI_GRID_W;
	h = 2.5 * UI_GRID_H;
};
class RscButton_1601: RscButton
{
	action = "closedialog 0; call openMainMenu";

	idc = 1601;
	text = "Close"; //--- ToDo: Localize;
	x = 43 * UI_GRID_W + UI_GRID_X;
	y = 23.5 * UI_GRID_H + UI_GRID_Y;
	w = 6 * UI_GRID_W;
	h = 2.5 * UI_GRID_H;
};
class RscButton_1602: RscButton
{
	action = "call rtsDeleteGame";

	idc = 1602;
	text = "Delete"; //--- ToDo: Localize;
	x = 43 * UI_GRID_W + UI_GRID_X;
	y = 19.5 * UI_GRID_H + UI_GRID_Y;
	w = 6 * UI_GRID_W;
	h = 2.5 * UI_GRID_H;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////



};

};
