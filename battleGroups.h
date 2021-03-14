

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

#define BASIC_SQUAD_RANKS  {"LIEUTENANT","SERGEANT","CORPORAL"}
#define TEAM_RANKS {"SERGEANT","CORPORAL"}
#define SNIPER_RANK {"SERGEANT"}

class BattleGroups
{

class west
{

class mbt
{
 name = "Main battle tank";
 ranks[] = BASIC_SQUAD_RANKS;
 units[] = {"uns_m48a3"};
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
