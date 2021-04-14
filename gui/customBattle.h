

/* #Cutazi
$[
	1.063,
	["cusbattle",[["safeZoneX","safeZoneY","0","0"],"(5 * 0.5 * pixelW * pixelGrid)","(5 * 0.5 * pixelH * pixelGrid)","UI_GRID"],0,0,0],
	[2100,"",[2,"",["23 * UI_GRID_W + UI_GRID_X","9 * UI_GRID_H + UI_GRID_Y","22 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"",[2,"Start",["29 * UI_GRID_W + UI_GRID_X","26.5 * UI_GRID_H + UI_GRID_Y","9.5 * UI_GRID_W","2.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
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
// GUI EDITOR OUTPUT START (by GC, v1.063, #Cutazi)
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
	idc = 1600;
	text = "Start"; //--- ToDo: Localize;
	x = 29 * UI_GRID_W + UI_GRID_X;
	y = 26.5 * UI_GRID_H + UI_GRID_Y;
	w = 9.5 * UI_GRID_W;
	h = 2.5 * UI_GRID_H;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////



};

};

