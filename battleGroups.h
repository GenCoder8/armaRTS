

class RTSDefs
{
class TankCrews
{
 units[] = {"uns_US_2MI_DRV","uns_men_NVA_crew_driver"};
};

class Infantry
{
 units[] = {
 // West
 "uns_men_USMC_68_PL","uns_men_USMC_68_SL","uns_men_USMC_68_RF4","uns_men_USMC_68_RTO","uns_men_USMC_68_MED","uns_men_USMC_68_HMG","uns_men_USMC_68_GL","uns_men_USMC_68_DEM","uns_men_USMC_68_AT",
 "uns_men_USMC_68_AHMG","uns_men_USMC_68_RF2","uns_men_USMC_68_SCT","uns_men_USMC_68_ENG","uns_men_USMC_68_RF1","uns_men_USMC_68_RF3",

 // East
 "uns_men_NVA_65_COM", "uns_men_NVA_65_nco", "uns_men_NVA_65_RTO", "uns_men_NVA_65_AS8", "uns_men_NVA_65_MED", "uns_men_NVA_65_RF1", "uns_men_NVA_65_TRI", "uns_men_NVA_65_MTS", 
 "uns_men_NVA_65_AA", "uns_men_NVA_65_AT", "uns_men_NVA_65_SAP", "uns_men_NVA_65_HMG",
 "uns_men_NVA_65_off", "uns_men_NVA_65_AS3", "uns_men_NVA_65_AS4", "uns_men_NVA_65_AS6"

};
};



class Snipers
{
 units[] = {"uns_men_USMC_68_MRK","uns_men_NVA_65_MRK"};
};

};

#define SQUAD_RANKS  {"SERGEANT","CORPORAL"}
#define TEAM_RANKS {"SERGEANT","CORPORAL"}
#define SNIPER_RANK {"SERGEANT"}
#define ARMORED_RANKS {"SERGEANT","CORPORAL"}

class BattleGroups
{

class west
{

class Patton
{
 name = "M-48A3 Patton";
 ranks[] = ARMORED_RANKS;
 units[] = {"uns_m48a3"};
};

class Sheridan
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
};

};


class east
{

class TO55
{
 name = "TO-55";
 ranks[] = ARMORED_RANKS;
 units[] = {"uns_to55_nva"};
};

class T34
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
};

// a animate ["plants1",1];

};

};