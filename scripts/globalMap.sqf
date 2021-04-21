#include "..\main.h"

initGlobalMap =
{
 _blocs = call getBattleLocations;
 {
  _x setMarkerAlpha 0.3;
  _x setMarkerShape "ELLIPSE";
 } foreach _blocs;
};

getBattleLocations =
{
_battleLocations = allMapMarkers select { markerColor _x == BATTLE_LOC_COLOR };

_battleLocations select { !(_x call isUserMarker) }
};
