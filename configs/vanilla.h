

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
 units[] = {"B_Soldier_SL_F", "B_Soldier_F", "B_Soldier_TL_F", "B_Soldier_F", "B_Soldier_A_F", "B_medic_F"};
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
 name = "T-100 Varsuk";
 ranks[] = ARMORED_RANKS;
 units[] = {"O_MBT_02_cannon_F"};
};

class Armor2
{
 name = "BTR-K Kamysh";
 ranks[] = ARMORED_RANKS;
 units[] = {"O_APC_Tracked_02_cannon_F"};
};


class HeavyTeam
{
 name = "Heavy weapons team";
 ranks[] = SQUAD_RANKS;
 units[] = {"O_Soldier_SL_F", "O_Soldier_F", "O_Soldier_LAT_F", "O_Soldier_TL_F", "O_Soldier_A_F", "O_Soldier_F", "O_medic_F"};
};

class LightTeam
{
 name = "Rifle team";
 ranks[] = SQUAD_RANKS;
 units[] = {"O_Soldier_SL_F", "O_Soldier_F", "O_Soldier_TL_F", "O_Soldier_A_F", "O_medic_F"};
};

class MachineGunTeam
{
 name = "Machine gun team";
 ranks[] = TEAM_RANKS;
 units[] = {"O_Soldier_AR_F", "O_Soldier_F"};
};

class AntiTankTeam
{
 name = "Anti tank team";
 ranks[] = TEAM_RANKS;
 units[] = {"O_Soldier_LAT_F", "O_Soldier_F"};
};

class Sniper
{
 name = "Sniper";
 ranks[] = SNIPER_RANK;
 units[] = {"O_soldier_M_F"};
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

