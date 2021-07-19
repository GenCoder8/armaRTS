
rtsSavegame =
{
 profilenamespace setVariable ["rtsForces",allforces];

 profilenamespace setVariable ["gmPhase",gmPhase];

 profilenamespace setVariable ["gmCurBattleIndex",gmCurBattleIndex];
};

rtsLoadGame =
{

call initCampaign;

allforces = profilenamespace getVariable ["rtsForces",createHashmap];

gmPhase = profilenamespace getVariable "gmPhase";

gmCurBattleIndex = profilenamespace getVariable "gmCurBattleIndex";

"globalmap" call openGameScreen;

switch(gmPhase) do
{
case "move":
{
call beginGmMovePhase;
};
case "battles":
{
 gmBattles = call getGlobalBattles;
 call gmCheckRoundEnd;
};

};

};
