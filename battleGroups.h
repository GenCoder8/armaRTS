

class RTSDefs
{
class TankCrews
{
 units[] = {"uns_US_2MI_DRV"};
};

class Infantry
{
 units[] = {"uns_men_USMC_68_PL","uns_men_USMC_68_RF4","uns_men_USMC_68_RTO","uns_men_USMC_68_MED","uns_men_USMC_68_HMG","uns_men_USMC_68_GL","uns_men_USMC_68_DEM","uns_men_USMC_68_AT"};
};

class Snipers
{
 units[] = {"uns_men_USMC_68_MRK"};
};

};

#define BASIC_SQUAD_RANKS  {"LIEUTENANT","SERGEANT","CORPORAL"}

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

class testteam
{
 name = "The testers";
 ranks[] = BASIC_SQUAD_RANKS;
 units[] = {"uns_men_USMC_68_PL","uns_men_USMC_68_RF4","uns_men_USMC_68_RTO","uns_men_USMC_68_MED","uns_men_USMC_68_HMG","uns_men_USMC_68_GL","uns_men_USMC_68_DEM","uns_men_USMC_68_AT"};
};

class theRollers
{
 name = "The Rollers";
 ranks[] = BASIC_SQUAD_RANKS;
 units[] = {"uns_men_USMC_68_PL","uns_men_USMC_68_RF4","uns_men_USMC_68_RTO","uns_men_USMC_68_MED","uns_men_USMC_68_HMG","uns_men_USMC_68_GL","uns_men_USMC_68_DEM","uns_men_USMC_68_AT"};
};

class fury
{
 name = "Fury";
 ranks[] = BASIC_SQUAD_RANKS;
 units[] = {"uns_men_USMC_68_PL","uns_men_USMC_68_RF4","uns_men_USMC_68_RTO","uns_men_USMC_68_MED","uns_men_USMC_68_HMG","uns_men_USMC_68_GL","uns_men_USMC_68_DEM","uns_men_USMC_68_AT"};
};

};

// a animate ["plants1",1];

};
