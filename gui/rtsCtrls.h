
class RtsButton : RscButton
{
	colorBackground[] = 
	{
		0,
		1,
		0,
		1
	};
	colorBackgroundActive[] = 
	{
		0,
		1,
		0,
		1
	};
	colorFocused[] = 
	{
		0,
		1,
		0,
		1
	};
};

class RtsControlsGroupNoScrollBars: RscControlsGroup
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

class RtsPoolFont : RscText
{
 SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
};