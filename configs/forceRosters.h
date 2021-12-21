

class ForceRosters
{

 class west
 {

class USA1
{
 name = "The Avengers";
 icon = "uns_M113parts\army\11acr_co.paa";
 playable = true;

class BattleGroups : DefaultBattleGroups
{
};

battleGroups[] = 
{
"Patton",2,
"Sheridan",2,

"PlatoonHQ",1,
"HeavyTeam",3,
"LightTeam",3,
"ReconTeam",2,
"MachineGunTeam",3,
"AntiTankTeam",3,
"LightMortarTeam",2,
"HeavyMortarTeam",2,
"Sniper",3

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

battleGroups[] = 
{
 "TO55", 5,
 "HeavyTeam", 10,
 "LightTeam", 10
};

};

class VC1
{
 name = "VC";
 icon = "uns_t34_t55\flags\vc_flag.paa";

battleGroups[] = 
{
 "TO55", 5,
 "HeavyTeam", 5
};
};

};

};