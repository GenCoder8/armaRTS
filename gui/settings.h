
/* #Wepaju
$[
	1.063,
	["settingMenu",[["safezoneX","safezoneY","0","0"],"2.5 * pixelW * pixelGrid","2.5 * pixelH * pixelGrid","UI_GRID"],0,0,0],
	[2100,"",[2,"",["29 * UI_GRID_W + UI_GRID_X","11.5 * UI_GRID_H + UI_GRID_Y","10 * UI_GRID_W","2.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"",[2,"Ok",["29.5 * UI_GRID_W + UI_GRID_X","24 * UI_GRID_H + UI_GRID_Y","9 * UI_GRID_W","2.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |call closeSettingsMenu|;"]],
	[1000,"",[2,"Mod used:",["23 * UI_GRID_W + UI_GRID_X","11.74 * UI_GRID_H + UI_GRID_Y","5 * UI_GRID_W","2 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[2101,"",[2,"",["29 * UI_GRID_W + UI_GRID_X","17 * UI_GRID_H + UI_GRID_Y","10 * UI_GRID_W","2.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1001,"",[2,"Difficulty:",["23 * UI_GRID_W + UI_GRID_X","17 * UI_GRID_H + UI_GRID_Y","5 * UI_GRID_W","2.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/



class SettingsDlg
{
 idd = SETTINGSDLGID;

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
// GUI EDITOR OUTPUT START (by GC, v1.063, #Wepaju)
////////////////////////////////////////////////////////

class RscCombo_2100: RscCombo
{
	idc = 2100;
	x = 29 * UI_GRID_W + UI_GRID_X;
	y = 11.5 * UI_GRID_H + UI_GRID_Y;
	w = 10 * UI_GRID_W;
	h = 2.5 * UI_GRID_H;
};
class RscButton_1600: RscButton
{
	action = "call closeSettingsMenu";

	idc = 1600;
	text = "Ok"; //--- ToDo: Localize;
	x = 29.5 * UI_GRID_W + UI_GRID_X;
	y = 24 * UI_GRID_H + UI_GRID_Y;
	w = 9 * UI_GRID_W;
	h = 2.5 * UI_GRID_H;
};
class RscText_1000: RscText
{
	idc = 1000;
	text = "Mod used:"; //--- ToDo: Localize;
	x = 23 * UI_GRID_W + UI_GRID_X;
	y = 11.74 * UI_GRID_H + UI_GRID_Y;
	w = 5 * UI_GRID_W;
	h = 2 * UI_GRID_H;
};
class RscCombo_2101: RscCombo
{
	idc = 2101;
	x = 29 * UI_GRID_W + UI_GRID_X;
	y = 17 * UI_GRID_H + UI_GRID_Y;
	w = 10 * UI_GRID_W;
	h = 2.5 * UI_GRID_H;
};
class RscText_1001: RscText
{
	idc = 1001;
	text = "Difficulty:"; //--- ToDo: Localize;
	x = 23 * UI_GRID_W + UI_GRID_X;
	y = 17 * UI_GRID_H + UI_GRID_Y;
	w = 5 * UI_GRID_W;
	h = 2.5 * UI_GRID_H;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////




};

};