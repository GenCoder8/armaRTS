
curMouseClickAction = "";

plrSupports = createHashMapFromArray [['cas',2]];



anythingSelected =
{
 private _ret = false;

 { 
  if(count _x > 0) then { _ret = true; break; };  
 } foreach curatorSelected;

 _ret
};



playerHasSupport =
{
 params ["_supName"];

 (plrSupports get _supName) > 0
};

playerUseSupport =
{
 params ["_supName"];

 systemchat "Sup used";

 plrSupports set [_supName, (plrSupports get _supName) - 1];
};


canDoMouseClickAction =
{
 (!call anythingSelected) && (!call isUsingActionButton)
};

beginMouseClickAction =
{
 params ["_type"];

 curMouseClickAction = _type;
};

doMouseClickAction =
{
 if(!call isMouseClickAction) exitWith {};

systemchat "Mouse click action!";

 curMouseClickAction call playerUseSupport;

 curMouseClickAction = "";
};

isMouseClickAction =
{
 curMouseClickAction != ""
};

cancelMouseClickAction =
{
 // systemchat "Action cancelled";
 curMouseClickAction = "";

 ["",true] call setSpecialMove;

 call deleteDirArrows;
};






conditionFireMission =
{
 params ["_fireType"];
 // Must have selection
private _sel = curatorSelected # 1;

private _ok = false;

if(({ _x call isMortarGroup && !(_x call isArtilleryFiring) } count _sel) > 0) then
{
if({ [_x,_fireType] call doesMortarHaveMag} count _sel > 0) then
{
 _ok = true;
};
};

_ok
};

actionFireMission =
{
 params ["_fireType"];
 "fireMission" call setSpecialMove;
 fireMisType = _fireType;
};

