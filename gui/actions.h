
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
 icon = "a3\modules_f_curator\data\portraitirgrenade_ca.paa"
 text = "Throw smoke";
 condition = "call conditionThrowSmoke";
 action = "call actionThrowSmoke";
 help = "Right click position to throw some at";
};


class SetFormationDir
{
 icon = "a3\ui_f\data\gui\cfg\cursors\rotate_gs.paa";
 test = "Set formation direction";
 condition = "call canSetFormationDir";
 action = "call beginNewFormationDir";
 help = "Right click position to face to";
};


class SetGroupStanceDown
{
 icon = "a3\ui_f\data\igui\rscingameui\rscunitinfo\si_prone_down_ca.paa";//"a3\ui_f\data\igui\rscingameui\rscunitinfo\si_crouch_up_ca.paa";
 test = "Change group stance down";
 condition = "call canSetGroupStance";
 action = "-1 call changeGroupStance";
// help = "";
};

class SetGroupStanceUp : SetGroupStanceDown
{
 icon = "a3\ui_f\data\igui\rscingameui\rscunitinfo\si_stand_up_ca.paa";
 test = "Change group stance up";
 action = "1 call changeGroupStance";
};



class CasSupport
{
 icon = "a3\ui_f\data\gui\cfg\communicationmenu\cas_ca.paa";
// "a3\modules_f_curator\data\portraitcasgun_ca.paa"
// "a3\modules_f_curator\data\portraitcasbomb_ca.paa"
// "a3\modules_f_curator\data\portraitcasmissile_ca.paa"
 text = "Call close air support";
 condition = "'cas' call playerHasSupport && call canDoMouseClickAction";
 action = "'cas' call beginMouseClickAction";
 help = "Left click position to call support";

 isIndependedAction = true;
};


};


// 