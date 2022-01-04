
class RtsActionButtons
{

class MortarHE
{
 icon = "a3\modules_f_curator\data\portraitordnancemortar_ca.paa";
  // or "a3\ui_f\data\gui\cfg\communicationmenu\mortar_ca.paa"

 text = "Fire mortar HE";
 condition = "'HE' call conditionFireMission";
 action = "'HE' call actionFireMission";
 help = "Right click position to request fire mission";

};

class MortarSmoke : MortarHE
{
 text = "Fire mortar smoke";
 condition = "'Smoke' call conditionFireMission";
 action = "'Smoke' call actionFireMission";
};


class ThrowSmoke
{
 icon = "a3\modules_f_curator\data\portraitirgrenade_ca.paa";
 text = "Throw smoke";
 condition = "call conditionThrowSmoke";
 action = "call actionThrowSmoke";
 help = "Right click position to throw some at";
};


class SetFormationDir
{
 icon = "a3\ui_f\data\gui\cfg\cursors\rotate_gs.paa";
 text = "Set formation direction"; // todo msg Press ctrl and hold down right mouse button to set move waypoint with formation direction
 condition = "call canSetFormationDir";
 action = "call beginNewFormationDir";
 help = "Right click position to face to.";
};

/*
class SetGroupStanceDown
{
 icon = "a3\ui_f\data\igui\rscingameui\rscunitinfo\si_prone_down_ca.paa";//"a3\ui_f\data\igui\rscingameui\rscunitinfo\si_crouch_up_ca.paa";
 text = "Change group stance down";
 condition = "call canSetGroupStance";
 action = "-1 call changeGroupStance";
// help = "";
};

class SetGroupStanceUp : SetGroupStanceDown
{
 icon = "a3\ui_f\data\igui\rscingameui\rscunitinfo\si_stand_up_ca.paa";
 text = "Change group stance up";
 action = "1 call changeGroupStance";
};
*/

class SetGroupStanceProne
{
 icon = "a3\ui_f\data\igui\rscingameui\rscunitinfo\si_prone_ca.paa";
 text = "Change group stance to prone";
 condition = "'DOWN' call canSetGroupStanceTo";
 action = "'DOWN' call changeGroupStanceTo";
};

class SetGroupStanceCrouch
{
 icon = "a3\ui_f\data\igui\rscingameui\rscunitinfo\si_crouch_ca.paa";
 text = "Change group stance to crouch";
 condition = "'MIDDLE' call canSetGroupStanceTo";
 action = "'MIDDLE' call changeGroupStanceTo";
};

class SetGroupStanceStand
{
 icon = "a3\ui_f\data\igui\rscingameui\rscunitinfo\si_stand_ca.paa";
 text = "Change group stance to stand";
 condition = "'UP' call canSetGroupStanceTo";
 action = "'UP' call changeGroupStanceTo";
};

class SetGroupStanceAuto
{
 icon = "a3\ui_f\data\igui\rscingameui\rscunitinfo\si_crouch_up_ca.paa";
 text = "Change group stance to auto";
 condition = "'AUTO' call canSetGroupStanceTo";
 action = "'AUTO' call changeGroupStanceTo";
};




class CasSupport
{
 icon = "a3\ui_f\data\gui\cfg\communicationmenu\cas_ca.paa";
// "a3\modules_f_curator\data\portraitcasgun_ca.paa"
// "a3\modules_f_curator\data\portraitcasbomb_ca.paa"
// "a3\modules_f_curator\data\portraitcasmissile_ca.paa"
 text = "Call close air support";
 textAdd = "'cas' call getSupportLeftText";
 condition = "'cas' call playerHasSupport && call canDoMouseClickAction";
 action = "'cas' call beginMouseClickAction";
 help = "Left click position to call support";

 isIndependedAction = true;
};

class ArtillerySupport : CasSupport
{
 icon = "a3\ui_f\data\gui\cfg\communicationmenu\artillery_ca.paa";
 text = "Call artillery support";
 textAdd = "'artillery' call getSupportLeftText";
 condition = "'artillery' call playerHasSupport && call canDoMouseClickAction";
 action = "'artillery' call beginMouseClickAction";
};

};


// 