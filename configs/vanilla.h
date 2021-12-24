

class RTSDefsVanilla
{

class TankCrews
{
 units[] = {"B_crew_F"};
};

class Snipers
{
 units[] = {"B_soldier_M_F"};
};

};


class BattleGroupsVanilla
{

class west
{

class Armor1
{
 name = "M2A1 Slammer";
 ranks[] = ARMORED_RANKS;
 units[] = {"B_MBT_01_cannon_F"};
};

class Armor2 : Armor1
{
 name = "AMV-7 Marshall";
 units[] = {"B_APC_Wheeled_01_cannon_F"};
};

class PlatoonHQ
{
 name = "Platoon HQ";
 ranks[] = {"LIEUTENANT","SERGEANT","CORPORAL"};
 units[] = {"B_Soldier_SL_F","B_Soldier_TL_F","B_Soldier_F","B_Soldier_F"};
 traits[] = {"Morale"};
 max = 1;
};

class HeavyTeam
{
 name = "Heavy weapons team";
 ranks[] = SQUAD_RANKS;
 units[] = { "B_Soldier_SL_F", "B_Soldier_F", "B_soldier_LAT_F", "B_Soldier_TL_F", "B_Soldier_GL_F", "B_Soldier_A_F", "B_medic_F" };
};

class LightTeam
{
 name = "Rifle team";
 ranks[] = SQUAD_RANKS;
 units[] = {"B_Soldier_SL_F", "B_Soldier_F", "B_Soldier_TL_F", "B_soldier_AR_F", "B_Soldier_A_F", "B_medic_F"};
};

class ReconTeam
{
 name = "Recon team";
 ranks[] = SQUAD_RANKS;
 units[] = {"B_recon_TL_F", "B_recon_medic_F", "B_recon_LAT_F", "B_recon_JTAC_F", "B_recon_exp_F"};
 traits[] = {"Recon"};
};

class MachineGunTeam
{
 name = "Machine gun team";
 ranks[] = TEAM_RANKS;
 units[] = {"B_soldier_AR_F", "B_Soldier_A_F", "B_Soldier_F"};
};

class AntiTankTeam
{
 name = "Anti tank team";
 ranks[] = TEAM_RANKS;
 units[] = {"B_soldier_AT_F", "B_Soldier_F"};
};

class LightMortarTeam
{
 name = "Mortar team (Light)";
 ranks[] = TEAM_RANKS;
 units[] = {"B_Soldier_F","B_Soldier_F","B_Soldier_F"};
 mortar = "B_Mortar_01_F";
 ammo[] = {"8Rnd_82mm_Mo_shells","8Rnd_82mm_Mo_Smoke_white"};
};

/*
class HeavyMortarTeam
{
 name = "Mortar team (Heavy)";
 ranks[] = TEAM_RANKS;
 units[] = {"","",""};
 mortar = "";
 ammo[] = {"",""};
};
*/

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
 units[] = {"B_soldier_M_F"};
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






class ForceRostersVanilla
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
