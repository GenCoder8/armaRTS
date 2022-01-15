

class RTSDefsUnsung
{

class TankCrews
{
 units[] = {"uns_US_2MI_DRV","uns_men_NVA_crew_driver"};
};

class Snipers
{
 units[] = {"uns_men_USMC_68_MRK","uns_men_NVA_65_MRK"};
};

casPlanes[] = {"uns_F4J_AGM","uns_A7N_AGM"};

artyPiece = "Uns_M114_artillery";

solImgs[] = {
"uns_men_c\portrait\usarmy\port_soldier8.paa",
"uns_men_c\portrait\usarmy\port_soldier11.paa",
"uns_men_c\portrait\usarmy\port_army_1.paa",
"uns_men_c\portrait\usarmy\port_officer3.paa",
"uns_men_c\portrait\usarmy\port_officer5.paa",
"uns_men_c\portrait\usarmy\port_rto1.paa",
"uns_men_c\portrait\usarmy\port_soldier1.paa",
"uns_men_c\portrait\usarmy\port_soldier3.paa",
"uns_men_c\portrait\usarmy\port_soldier10.paa",
"uns_men_c\portrait\usarmy\port_soldier9.paa",
"uns_men_c\portrait\usarmy\port_soldier6.paa",
"uns_men_c\portrait\usarmy\port_rto2.paa"
};

};


class BattleGroupsUnsung
{

class west
{

class Armor1
{
 name = "M-48A3 Patton";
 ranks[] = ARMORED_RANKS;
 units[] = {"uns_m48a3"};
};

class Armor2
{
 name = "M-551 Sheridan";
 ranks[] = ARMORED_RANKS;
 units[] = {"uns_m551"};
};

class APC1
{
 name = "M-113 (M2)";
 ranks[] = ARMORED_RANKS;
 units[] = {"uns_M113_M2"};
};

class AA1
{
 name = "M163 Vulcan ADS";
 ranks[] = ARMORED_RANKS;
 units[] = {"uns_m163"};
};

class Car1
{
 name = "M-151 MUTT";
 ranks[] = ARMORED_RANKS;
 units[] = {"uns_willysmg"};
};

class PlatoonHQ
{
 name = "Platoon HQ";
 ranks[] = {"LIEUTENANT","SERGEANT","CORPORAL"};
 units[] = {"uns_men_USMC_68_PL","uns_men_USMC_68_SL","uns_men_USMC_68_RTO","uns_men_USMC_68_RF4"};
 traits[] = {"Morale"};
 max = 1;
};

class HeavyTeam
{
 name = "Heavy weapons team";
 ranks[] = SQUAD_RANKS;
 units[] = {"uns_men_USMC_68_PL","uns_men_USMC_68_MED","uns_men_USMC_68_RTO","uns_men_USMC_68_GL","uns_men_USMC_68_RF4","uns_men_USMC_68_RF2","uns_men_USMC_68_AT"};
};

class LightTeam
{
 name = "Rifle team";
 ranks[] = SQUAD_RANKS;
 units[] = {"uns_men_USMC_68_PL","uns_men_USMC_68_SL","uns_men_USMC_68_MED","uns_men_USMC_68_RTO","uns_men_USMC_68_RF2","uns_men_USMC_68_RF1"};
};

class ReconTeam
{
 name = "Recon team";
 ranks[] = SQUAD_RANKS;
 units[] = {"uns_men_USMC_68_PL","uns_men_USMC_68_RF1","uns_men_USMC_68_RF2","uns_men_USMC_68_RF3","uns_men_USMC_68_AT"};
 traits[] = {"Recon"};
};

class MachineGunTeam
{
 name = "Machine gun team";
 ranks[] = TEAM_RANKS;
 units[] = {"uns_men_USMC_68_HMG","uns_men_USMC_68_AHMG","uns_men_USMC_68_RF2"};
};

class AntiTankTeam
{
 name = "Anti tank team";
 ranks[] = TEAM_RANKS;
 units[] = {"uns_men_USMC_68_AT","uns_men_USMC_68_RF1"};
};

class LightMortarTeam
{
 name = "Mortar team (Light)";
 ranks[] = TEAM_RANKS;
 units[] = {"uns_men_USMC_68_RF2","uns_men_USMC_68_RF1","uns_men_USMC_68_RF3"};
 mortar = "uns_M2_60mm_mortar";
 ammo[] = {"uns_8Rnd_60mmHE_M2","uns_8Rnd_60mmSMOKE_M2"};
};

class HeavyMortarTeam
{
 name = "Mortar team (Heavy)";
 ranks[] = TEAM_RANKS;
 units[] = {"uns_men_USMC_68_RF2","uns_men_USMC_68_RF1","uns_men_USMC_68_RF3"};
 mortar = "uns_M1_81mm_mortar";
 ammo[] = {"uns_8Rnd_81mmHE_M1","uns_8Rnd_81mmSMOKE_M1"};
};

/*
class TestMortarTeam
{
 name = "Test Mortar team";
 ranks[] = TEAM_RANKS;
 units[] = {"uns_men_USMC_68_RF2","uns_men_USMC_68_RF1","uns_men_USMC_68_RF3"};
 mortar = "B_Mortar_01_F";
 ammo[] = {"8Rnd_82mm_Mo_shells","8Rnd_82mm_Mo_shells"};
};*/

class Sniper
{
 name = "Sniper";
 ranks[] = SNIPER_RANK;
 units[] = {"uns_men_USMC_68_MRK"};
 traits[] = {"Sniper"};
};

};


class east
{

class Armor1
{
 name = "TO-55";
 ranks[] = ARMORED_RANKS;
 units[] = {"uns_to55_nva"};
};

class Armor2
{
 name = "T-34";
 ranks[] = ARMORED_RANKS;
 units[] = {"uns_t34_85_nva"};
};

class APC1
{
 name = "Type63";
 ranks[] = ARMORED_RANKS;
 units[] = {"uns_Type63_mg"};
};

class AA1
{
 name = "Zpu4";
 ranks[] = ARMORED_RANKS;
 units[] = {"uns_nvatruck_zpu"};
};

class Car1
{
 name = "Type 55 (PK)";
 ranks[] = ARMORED_RANKS;
 units[] = {"uns_Type55_LMG"};
};

class Car2
{
 name = "Type 55";
 ranks[] = ARMORED_RANKS;
 units[] = {"uns_Type55_patrol"};
};


class HeavyTeam
{
 name = "Heavy weapons team";
 ranks[] = SQUAD_RANKS;
 units[] = {"uns_men_NVA_65_COM", "uns_men_NVA_65_nco", "uns_men_NVA_65_RTO", "uns_men_NVA_65_AS8", "uns_men_NVA_65_MED", "uns_men_NVA_65_RF1", "uns_men_NVA_65_TRI", "uns_men_NVA_65_MTS", "uns_men_NVA_65_AA", "uns_men_NVA_65_AT", "uns_men_NVA_65_SAP" };
};

class LightTeam
{
 name = "Rifle team";
 ranks[] = SQUAD_RANKS;
 units[] = {"uns_men_NVA_65_off", "uns_men_NVA_65_RTO", "uns_men_NVA_65_MED", "uns_men_NVA_65_SAP", "uns_men_NVA_65_AS3", "uns_men_NVA_65_AS4", "uns_men_NVA_65_AS6", "uns_men_NVA_65_RF1"};
};

class MachineGunTeam
{
 name = "Machine gun team";
 ranks[] = TEAM_RANKS;
 units[] = {"uns_men_NVA_65_HMG","uns_men_NVA_65_RF1"};
};

class AntiTankTeam
{
 name = "Anti tank team";
 ranks[] = TEAM_RANKS;
 units[] = {"uns_men_NVA_65_AT","uns_men_NVA_65_RF1"};
};

class Sniper
{
 name = "Sniper";
 ranks[] = SNIPER_RANK;
 units[] = {"uns_men_NVA_65_MRK"};
 traits[] = {"Sniper"};
};

// a animate ["plants1",1];

};

};






class ForceRostersUnsung
{

 class west
 {

class Force1
{
 name = "The Avengers";
 icon = "\uns_M113parts\army\11acr_co.paa";
 playable = true;

class ForceGroups : ForceArmor
{


};

};

class Force2 : Force1
{
 name = "The Testers";
 icon = "\uns_M113parts\army\1id_co.paa";


class ForceGroups : ForceMech
{


};

};

 };


class east
{

class Force1
{
 name = "NVA";
 icon = "\uns_wheeled_e\zil157\decals\nva_ca.paa";
 playable = true;

class ForceGroups : ForceArmor
{


};

};

class Force2 : Force1
{
 name = "VC";
 icon = "\uns_t34_t55\flags\vc_flag.paa";

class ForceGroups : ForceMech
{


};
};

};

};

