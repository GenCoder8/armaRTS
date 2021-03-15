

class RTSDefs
{
class TankCrews
{
 units[] = {"uns_US_2MI_DRV"};
};

class Infantry
{
 units[] = {"uns_men_USMC_68_PL","uns_men_USMC_68_SL","uns_men_USMC_68_RF4","uns_men_USMC_68_RTO","uns_men_USMC_68_MED","uns_men_USMC_68_HMG","uns_men_USMC_68_GL","uns_men_USMC_68_DEM","uns_men_USMC_68_AT",
 "uns_men_USMC_68_AHMG","uns_men_USMC_68_RF2","uns_men_USMC_68_SCT","uns_men_USMC_68_ENG","uns_men_USMC_68_RF1"};
};

class Snipers
{
 units[] = {"uns_men_USMC_68_MRK"};
};

};

#define BASIC_SQUAD_RANKS  {"SERGEANT","CORPORAL"}
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

class HeavyTeam
{
 name = "Heavy weapons squad";
 ranks[] = BASIC_SQUAD_RANKS;
  units[] = {"uns_men_USMC_68_RF2","uns_men_USMC_68_MED","uns_men_USMC_68_RTO","uns_men_USMC_68_GL","uns_men_USMC_68_RF4","uns_men_USMC_68_SCT","uns_men_USMC_68_RF2","uns_men_USMC_68_ENG","uns_men_USMC_68_AT"};
};

class LightTeam
{
 name = "Rifle squad";
 ranks[] = BASIC_SQUAD_RANKS;
  units[] = {"uns_men_USMC_68_PL","uns_men_USMC_68_SL","uns_men_USMC_68_MED","uns_men_USMC_68_RTO","uns_men_USMC_68_ENG","uns_men_USMC_68_RF2","uns_men_USMC_68_RF1"};
};

class ReconTeam
{
 name = "Recon team";
 ranks[] = BASIC_SQUAD_RANKS;
 units[] = {"uns_men_USMC_68_PL","uns_men_USMC_68_RF1","uns_men_USMC_68_RF2","uns_men_USMC_68_RF3","uns_men_USMC_68_AT"};
};

class PlatoonHQ
{
 name = "Platoon HQ";
 ranks[] = {"LIEUTENANT","SERGEANT","CORPORAL"};
 units[] = {"uns_men_USMC_68_RTO","uns_men_USMC_68_RF4","uns_men_USMC_68_SL","uns_men_USMC_68_PL"};
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


class Sniper
{
 name = "Sniper";
 ranks[] = SNIPER_RANK;
 units[] = {"uns_men_USMC_68_MRK"};
};

};

// a animate ["plants1",1];

};
