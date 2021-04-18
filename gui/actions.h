
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

class CasSupport
{
  icon = "a3\ui_f\data\gui\cfg\communicationmenu\cas_ca.paa";
// "a3\modules_f_curator\data\portraitcasgun_ca.paa"
// "a3\modules_f_curator\data\portraitcasbomb_ca.paa"
// "a3\modules_f_curator\data\portraitcasmissile_ca.paa"
 text = "Call cas";
 condition = "'cas' call playerHasSupport && call canDoMouseClickAction";
 action = "'cas' call beginMouseClickAction";
};

};