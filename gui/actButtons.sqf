

isUsingActionButton =
{
 (call isMouseClickAction) || specialMove != ""
};


canSetFormationDir =
{
 (!call isUsingActionButton) && (call anythingSelected)
};

beginNewFormationDir =
{
 "setFormDir" call setSpecialMove;
};