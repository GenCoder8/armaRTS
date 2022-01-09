



class ForceInfantry
{

class PlatoonHQ
{
 count = 1;
 maxDifAdd = 3;
};

class HeavyTeam
{
 count = 4;
 maxDifAdd = 3;
};

class LightTeam
{
 count = 4;
 maxDifAdd = 3;
};

class ReconTeam
{
 count = 2;
 maxDifAdd = 2;
};

class MachineGunTeam
{
 count = 4;
 maxDifAdd = 3;
};

class AntiTankTeam
{
 count = 4;
 maxDifAdd = 3;
};

class LightMortarTeam
{
 count = 2;
 maxDifAdd = 2;
};

class HeavyMortarTeam
{
 count = 2;
 maxDifAdd = 2;
};

class Sniper
{
 count = 3;
 maxDifAdd = 2;
};

};


class ForceMech : ForceInfantry
{

class AA1
{
 count = 2;
 maxDifAdd = 3;
};

class Car1
{
 count = 2;
 maxDifAdd = 4;
};

class Car2
{
 count = 2;
 maxDifAdd = 4;
};

};

class ForceArmor : ForceMech
{

class Armor1
{
 count = 2;
 maxDifAdd = 4;
};

class Armor2
{
count = 2;
maxDifAdd = 4;
};

};


#define SQUAD_RANKS  {"SERGEANT","CORPORAL"}
#define TEAM_RANKS {"SERGEANT","CORPORAL"}
#define SNIPER_RANK {"SERGEANT"}
#define ARMORED_RANKS {"SERGEANT","CORPORAL"}

