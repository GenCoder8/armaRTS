

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

class USA1
{
 name = "The Avengers";
 icon = "uns_M113parts\army\11acr_co.paa";
 playable = true;

class ForceGroups : DefaultForceGroups
{


};

};

class TestRosterWest : USA1
{
 name = "The Testers";
 icon = "uns_M113parts\army\1id_co.paa";
};

 };


class east
{

class NVA1
{
 name = "NVA";
 icon = "uns_wheeled_e\zil157\decals\nva_ca.paa";
 playable = true;

class ForceGroups : DefaultForceGroups
{

class Armor1
{
count = 5;
};

class HeavyTeam
{
count = 10;
};

class LightTeam
{
count = 10;
};

};

};

class VC1
{
 name = "VC";
 icon = "uns_t34_t55\flags\vc_flag.paa";

class ForceGroups : DefaultForceGroups
{
class Armor1
{
count = 5;
};
class HeavyTeam
{
count = 5;
};

};
};

};

};

