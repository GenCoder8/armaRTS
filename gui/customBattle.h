

/* #Bulywi
$[
	1.063,
	["cusbattle",[["safeZoneX","safeZoneY","0","0"],"(5 * 0.5 * pixelW * pixelGrid)","(5 * 0.5 * pixelH * pixelGrid)","UI_GRID"],0,0,0],
	[2100,"",[2,"",["23 * UI_GRID_W + UI_GRID_X","9 * UI_GRID_H + UI_GRID_Y","22 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"",[2,"Start",["29 * UI_GRID_W + UI_GRID_X","28.5 * UI_GRID_H + UI_GRID_Y","9.5 * UI_GRID_W","2.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |call customBattleDone|;"]],
	[1200,"cbLocMap : RscMapControl",[2,"#(argb,8,8,3)color(1,1,1,1)",["27 * UI_GRID_W + UI_GRID_X","14 * UI_GRID_H + UI_GRID_Y","14 * UI_GRID_W","9.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[2101,"",[2,"",["16.5 * UI_GRID_W + UI_GRID_X","25 * UI_GRID_H + UI_GRID_Y","16.5 * UI_GRID_W","2.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[2102,"",[2,"",["35 * UI_GRID_W + UI_GRID_X","25 * UI_GRID_H + UI_GRID_Y","15.5 * UI_GRID_W","2.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1000,"",[2,"VS",["33.25 * UI_GRID_W + UI_GRID_X","25.3 * UI_GRID_H + UI_GRID_Y","1.5 * UI_GRID_W","1.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/




class CustomBattleDlg
{
 idd = CUSTOMBATTLEDLGID;

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
// GUI EDITOR OUTPUT START (by GC, v1.063, #Bulywi)
////////////////////////////////////////////////////////

class RscCombo_2100: RscCombo
{
	idc = 2100;
	x = 23 * UI_GRID_W + UI_GRID_X;
	y = 9 * UI_GRID_H + UI_GRID_Y;
	w = 22 * UI_GRID_W;
	h = 3 * UI_GRID_H;
};
class RscButton_1600: RscButton
{
	action = "call customBattleDone";

	idc = 1600;
	text = "Start"; //--- ToDo: Localize;
	x = 29 * UI_GRID_W + UI_GRID_X;
	y = 28.5 * UI_GRID_H + UI_GRID_Y;
	w = 9.5 * UI_GRID_W;
	h = 2.5 * UI_GRID_H;
};
class cbLocMap : RscMapControl
{
	idc = 1200;
	text = "#(argb,8,8,3)color(1,1,1,1)";
	x = 27 * UI_GRID_W + UI_GRID_X;
	y = 14 * UI_GRID_H + UI_GRID_Y;
	w = 14 * UI_GRID_W;
	h = 9.5 * UI_GRID_H;
};
class RscCombo_2101: RscCombo
{
	idc = 2101;
	x = 16.5 * UI_GRID_W + UI_GRID_X;
	y = 25 * UI_GRID_H + UI_GRID_Y;
	w = 16.5 * UI_GRID_W;
	h = 2.5 * UI_GRID_H;
};
class RscCombo_2102: RscCombo
{
	idc = 2102;
	x = 35 * UI_GRID_W + UI_GRID_X;
	y = 25 * UI_GRID_H + UI_GRID_Y;
	w = 15.5 * UI_GRID_W;
	h = 2.5 * UI_GRID_H;
};
class RscText_1000: RscText
{
	idc = 1000;
	text = "VS"; //--- ToDo: Localize;
	x = 33.25 * UI_GRID_W + UI_GRID_X;
	y = 25.3 * UI_GRID_H + UI_GRID_Y;
	w = 1.5 * UI_GRID_W;
	h = 1.5 * UI_GRID_H;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////




};

};

