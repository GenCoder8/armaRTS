

class RTSDefsVanilla
{

class TankCrews
{
 units[] = {"B_crew_F","O_crew_F"};
};

class Snipers
{
 units[] = {"B_soldier_M_F","O_soldier_M_F"};
};

casPlanes[] = {"B_Plane_CAS_01_dynamicLoadout_F","B_Plane_Fighter_01_F"};

artyPiece = "B_MBT_01_arty_F";
artyAmmo = "2Rnd_155mm_Mo_Cluster";

solImgs[] = {

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

class APC1
{
 name = "AMV-7 Marshall";
 ranks[] = ARMORED_RANKS;
 units[] = {"B_APC_Wheeled_01_cannon_F"};
};

class AA1
{
 name = "IFV-6a Cheetah";
 ranks[] = ARMORED_RANKS;
 units[] = {"B_APC_Tracked_01_AA_F"};
};

class Car1
{
 name = "Hunter HMG";
 ranks[] = ARMORED_RANKS;
 units[] = {"B_MRAP_01_hmg_F"};
};

class Car2
{
 name = "Hunter GMG";
 ranks[] = ARMORED_RANKS;
 units[] = {"B_MRAP_01_gmg_F"};
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

class APC1
{
 name = "BTR-K Kamysh";
 ranks[] = ARMORED_RANKS;
 units[] = {"O_APC_Tracked_02_cannon_F"};
};

class AA1
{
 name = "ZSU-39 Tigris";
 ranks[] = ARMORED_RANKS;
 units[] = {"O_APC_Tracked_02_AA_F"};
};

class Car1
{
 name = "Ifrit HMG";
 ranks[] = ARMORED_RANKS;
 units[] = {"O_MRAP_02_hmg_F"};
};

class Car2
{
 name = "Ifrit GMG";
 ranks[] = ARMORED_RANKS;
 units[] = {"O_MRAP_02_gmg_F"};
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

class ReconTeam
{
 name = "Recon team";
 ranks[] = SQUAD_RANKS;
 units[] = {"O_recon_TL_F", "O_recon_medic_F", "O_recon_LAT_F", "O_recon_JTAC_F", "O_recon_exp_F"};
 traits[] = {"Recon"};
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

class LightMortarTeam
{
 name = "Mortar team (Light)";
 ranks[] = TEAM_RANKS;
 units[] = {"O_Soldier_F","O_Soldier_F","O_Soldier_F"};
 mortar = "O_Mortar_01_F";
 ammo[] = {"8Rnd_82mm_Mo_shells","8Rnd_82mm_Mo_Smoke_white"};
};

class Sniper
{
 name = "Sniper";
 ranks[] = SNIPER_RANK;
 units[] = {"O_soldier_M_F"};
 traits[] = {"Sniper"};
};

};

};






class ForceRostersVanilla
{

 class west
 {

class Force1
{
 name = "The Avengers";
 icon = "gui\images\fromUnsung\11acr_co.paa";
 playable = true;

class ForceGroups : ForceArmor
{


};

};

class Force2 : Force1
{
 name = "The Testers";
 icon = "gui\images\fromUnsung\1id_co.paa";

class ForceGroups : ForceMech
{


};

};

 };


class east
{

class Force1
{
 name = "CSAT Armor";
 icon = "\A3\ui_f\data\map\markers\flags\CSAT_ca.paa";
 playable = true;

class ForceGroups : ForceArmor
{



};

};

class Force2 : Force1
{
 name = "CSAT Mech";

class ForceGroups : ForceMech
{


};
};

};

};

