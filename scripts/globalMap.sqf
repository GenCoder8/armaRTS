#include "..\main.h"

initGlobalMap =
{
 _blocs = call getBattleLocations;
 {
  _x setMarkerAlpha 0.25;
 } foreach _blocs;
};

getBattleLocations =
{

_battleLocations = allMapMarkers select { markerColor _x == BATTLE_LOC_COLOR };

_battleLocations select { !(_x call isUserMarker) }
};
