/* #Minisy
$[
	1.063,
	["groupview",[["safeZoneX","safeZoneY","0","0"],"(5 * 0.5 * pixelW * pixelGrid)","(5 * 0.5 * pixelH * pixelGrid)","UI_GRID"],0,0,0],
	[1500,"",[2,"",["47 * UI_GRID_W + UI_GRID_X","27.5 * UI_GRID_H + UI_GRID_Y","19 * UI_GRID_W","10 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["type = CT_LISTNBOX;","columns[] = GROUP_VIEW_COLS;"]],
	[1000,"",[2,"Group info",["47.5 * UI_GRID_W + UI_GRID_X","26 * UI_GRID_H + UI_GRID_Y","17.5 * UI_GRID_W","1 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/







// missionconfigfile >> "RscTitles" >> "ComOverlay"








class ControlsGroupNoScrollBars: RscControlsGroup
{
	idc = 2300;
	x = 0.5 * UI_GRID_W + UI_GRID_X;
	y = 11 * UI_GRID_H + UI_GRID_Y;
	w = 17 * UI_GRID_W;
	h = 9 * UI_GRID_H;
	class Controls
	{
	};
	
	class VScrollbar
	{
		color[] = 
		{
			1,
			1,
			1,
			0
		};
		width = 0.021;
		autoScrollEnabled = 1;
	};
	
	class HScrollbar
	{
		color[] = 
		{
			1,
			1,
			1,
			0
		};
		height = 0.028;
	};

	
};


#define  GROUP_VIEW_COLS {0,0.07, 0.45, 0.8, 0.9}


class ComOverlay
{
 titles[] = {};
 idd = 1357800;
 movingEnable = 0;
 duration = 99999999;   
 name = "ComOverlay";
  

onLoad = "uiNamespace setVariable ['ComOverlay', _this select 0];";
onUnload = "uiNamespace setVariable ['ComOverlay', displayNull];";

class controlsBackground 
{
class ComBg: RscPicture
{
	idc = 7000;
	text = "#(argb,8,8,3)color(0,0.75,0,1)";
	x = 47 * UI_GRID_W + UI_GRID_X;
	y = 25.5 * UI_GRID_H + UI_GRID_Y;
	w = 19 * UI_GRID_W;
	h = 12.5 * UI_GRID_H;
};
};

class controls 
{

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by GC, v1.063, #Minisy)
////////////////////////////////////////////////////////

class RscListbox_1500: RscListbox
{
	type = CT_LISTNBOX;
	columns[] = GROUP_VIEW_COLS;

	idc = 1500;
	x = 47 * UI_GRID_W + UI_GRID_X;
	y = 27.5 * UI_GRID_H + UI_GRID_Y;
	w = 19 * UI_GRID_W;
	h = 10 * UI_GRID_H;
};
class RscText_1000: RscText
{
	idc = 1000;
	text = "Group info"; //--- ToDo: Localize;
	x = 47.5 * UI_GRID_W + UI_GRID_X;
	y = 26 * UI_GRID_H + UI_GRID_Y;
	w = 17.5 * UI_GRID_W;
	h = 1 * UI_GRID_H;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////



};


};
