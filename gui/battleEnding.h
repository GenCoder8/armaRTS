/* #Hulico
$[
	1.063,
	["endingDlg",[["safeZoneX","safeZoneY","0","0"],"(5 * 0.5 * pixelW * pixelGrid)","(5 * 0.5 * pixelH * pixelGrid)","UI_GRID"],0,0,0],
	[1000,"EndingText  : RtsBattleEndText",[2,"Victory / Defeat",["26.5 * UI_GRID_W + UI_GRID_X","8 * UI_GRID_H + UI_GRID_Y","15.5 * UI_GRID_W","3 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"",[2,"Close",["30 * UI_GRID_W + UI_GRID_X","25.5 * UI_GRID_H + UI_GRID_Y","8 * UI_GRID_W","2.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],["action = |call closeEndingDlg|;"]],
	[1100,"",[2,"Reason for ending",["28 * UI_GRID_W + UI_GRID_X","16.5 * UI_GRID_H + UI_GRID_Y","13 * UI_GRID_W","5.5 * UI_GRID_H"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/



class BattleEndingDlg
{
 idd = RTSENDINGDLGID;

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
// GUI EDITOR OUTPUT START (by GC, v1.063, #Hulico)
////////////////////////////////////////////////////////

class EndingText  : RtsBattleEndText
{
	idc = 1000;
	text = "Victory / Defeat"; //--- ToDo: Localize;
	x = 26.5 * UI_GRID_W + UI_GRID_X;
	y = 8 * UI_GRID_H + UI_GRID_Y;
	w = 15.5 * UI_GRID_W;
	h = 3 * UI_GRID_H;
};
class RscButton_1600: RscButton
{
	action = "call closeEndingDlg";

	idc = 1600;
	text = "Close"; //--- ToDo: Localize;
	x = 30 * UI_GRID_W + UI_GRID_X;
	y = 25.5 * UI_GRID_H + UI_GRID_Y;
	w = 8 * UI_GRID_W;
	h = 2.5 * UI_GRID_H;
};
class RscStructuredText_1100: RscStructuredText
{
	idc = 1100;
	text = "Reason for ending"; //--- ToDo: Localize;
	x = 28 * UI_GRID_W + UI_GRID_X;
	y = 16.5 * UI_GRID_H + UI_GRID_Y;
	w = 13 * UI_GRID_W;
	h = 5.5 * UI_GRID_H;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////



};

};