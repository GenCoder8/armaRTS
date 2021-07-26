
rtsSavegameold =
{
 profilenamespace setVariable ["rtsForces",allforces];

 profilenamespace setVariable ["gmPhase",gmPhase];

 profilenamespace setVariable ["gmCurBattleIndex",gmCurBattleIndex];

 profilenamespace setVariable ["gmBattleLocations",gmBattleLocations];

};

rtsLoadGameold =
{

call initCampaign;

// Array must be copied!

allforces = +(profilenamespace getVariable ["rtsForces",createHashmap]);

gmPhase = (profilenamespace getVariable "gmPhase");

gmCurBattleIndex = (profilenamespace getVariable "gmCurBattleIndex");

gmBattleLocations = +(profilenamespace getVariable "gmBattleLocations");

"globalmap" call openGameScreen;

switch(gmPhase) do
{
case "move":
{
false call beginGmMovePhase;
};
case "battles":
{
 gmBattles = call getGlobalBattles;
 call gmCheckRoundEnd;
};

};

};

