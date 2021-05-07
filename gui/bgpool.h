#include "ctrlIds.h"

/* #Zewure
$[
	1.063,
	["bgpool",[["safeZoneX","safeZoneY","0","0"],"(5 * 0.5 * pixelW * pixelGrid)","(5 * 0.5 * pixelH * pixelGrid)","UI_GRID"],0,0,0],
	[2300,"",[2,"",["17.5 * UI_GRID_W + UI_GRID_X","6.5 * UI_GRID_H + UI_GRID_Y","33.5 * UI_GRID_W","15.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1500,"",[2,"",["22 * UI_GRID_W + UI_GRID_X","22.5 * UI_GRID_H + UI_GRID_Y","24 * UI_GRID_W","10 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["type = CT_LISTNBOX;","columns[] = BG_VIEW_COLS;"]],
	[2301,"",[2,"",["1.5 * UI_GRID_W + UI_GRID_X","6 * UI_GRID_H + UI_GRID_Y","9 * UI_GRID_W","27 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"",[2,"Add",["11.5 * UI_GRID_W + UI_GRID_X","15.5 * UI_GRID_H + UI_GRID_Y","3.57 * UI_GRID_W","2.735 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |call poolAddReserveBG|;"]],
	[1601,"",[2,"Begin",["30.5 * UI_GRID_W + UI_GRID_X","34 * UI_GRID_H + UI_GRID_Y","7 * UI_GRID_W","2 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |[^placement^] call openGameScreen;|;"]]
]
*/










#define BG_VIEW_COLS {0,0.075,0.4,0.6}



class UnitPoolDlg
{
 idd = UNITPOOLDLGID;

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
// GUI EDITOR OUTPUT START (by GC, v1.063, #Zewure)
////////////////////////////////////////////////////////

class RscControlsGroup_2300: RscControlsGroup
{
	idc = 2300;
	x = 17.5 * UI_GRID_W + UI_GRID_X;
	y = 6.5 * UI_GRID_H + UI_GRID_Y;
	w = 33.5 * UI_GRID_W;
	h = 15.5 * UI_GRID_H;
	class Controls
	{
	};
};
class RscListbox_1500: RscListbox
{
	type = CT_LISTNBOX;
	columns[] = BG_VIEW_COLS;

	idc = 1500;
	x = 22 * UI_GRID_W + UI_GRID_X;
	y = 22.5 * UI_GRID_H + UI_GRID_Y;
	w = 24 * UI_GRID_W;
	h = 10 * UI_GRID_H;
};
class RscControlsGroup_2301: RscControlsGroup
{
	idc = 2301;
	x = 1.5 * UI_GRID_W + UI_GRID_X;
	y = 6 * UI_GRID_H + UI_GRID_Y;
	w = 9 * UI_GRID_W;
	h = 27 * UI_GRID_H;
	class Controls
	{
	};
};
class RscButton_1600: RscButton
{
	action = "call poolAddReserveBG";

	idc = 1600;
	text = "Add"; //--- ToDo: Localize;
	x = 11.5 * UI_GRID_W + UI_GRID_X;
	y = 15.5 * UI_GRID_H + UI_GRID_Y;
	w = 3.57 * UI_GRID_W;
	h = 2.735 * UI_GRID_H;
};
class RscButton_1601: RscButton
{
	action = "['placement'] call openGameScreen;";

	idc = 1601;
	text = "Begin"; //--- ToDo: Localize;
	x = 30.5 * UI_GRID_W + UI_GRID_X;
	y = 34 * UI_GRID_H + UI_GRID_Y;
	w = 7 * UI_GRID_W;
	h = 2 * UI_GRID_H;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////



};

};