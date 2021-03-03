
/* #Kegidy
$[
	1.063,
	["bgpool",[["safeZoneX","safeZoneY","0","0"],"(5 * 0.5 * pixelW * pixelGrid)","(5 * 0.5 * pixelH * pixelGrid)","UI_GRID"],0,0,0],
	[2300,"",[2,"",["22 * UI_GRID_W + UI_GRID_X","6 * UI_GRID_H + UI_GRID_Y","24.5 * UI_GRID_W","16 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1500,"",[2,"",["22 * UI_GRID_W + UI_GRID_X","23 * UI_GRID_H + UI_GRID_Y","24 * UI_GRID_W","9 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["type = CT_LISTNBOX;","columns[] = BG_VIEW_COLS;"]],
	[2301,"",[2,"",["2 * UI_GRID_W + UI_GRID_X","6 * UI_GRID_H + UI_GRID_Y","13 * UI_GRID_W","27 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/


#define BG_VIEW_COLS {0,0.5}

#define UNITPOOLDLGID 12345577

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
	x = 15 * UI_GRID_W + UI_GRID_X;
	y = 5.5 * UI_GRID_H + UI_GRID_Y;
	w = 33.5 * UI_GRID_W;
	h = 25 * UI_GRID_H;
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
// GUI EDITOR OUTPUT START (by GC, v1.063, #Kegidy)
////////////////////////////////////////////////////////

class RscControlsGroup_2300: RscControlsGroup
{
	idc = 2300;
	x = 22 * UI_GRID_W + UI_GRID_X;
	y = 6 * UI_GRID_H + UI_GRID_Y;
	w = 24.5 * UI_GRID_W;
	h = 16 * UI_GRID_H;
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
	y = 23 * UI_GRID_H + UI_GRID_Y;
	w = 24 * UI_GRID_W;
	h = 9 * UI_GRID_H;
};
class RscControlsGroup_2301: RscControlsGroup
{
	idc = 2301;
	x = 2 * UI_GRID_W + UI_GRID_X;
	y = 6 * UI_GRID_H + UI_GRID_Y;
	w = 13 * UI_GRID_W;
	h = 27 * UI_GRID_H;
	class Controls
	{
	};
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////




};

};