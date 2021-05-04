

isUsingActionButton =
{
 (call isMouseClickAction) || specialMove != ""
};


canSetFormationDir =
{
 (call anythingSelected)
};

beginNewFormationDir =
{
 "setFormDir" call setSpecialMove;
};