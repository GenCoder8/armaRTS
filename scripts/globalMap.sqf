
initGlobalMap =
{
 _blocs = call getBattleLocations;
 {
  _x setMarkerAlpha 0.25;
 } foreach _blocs;
};

getBattleLocations =
{

_battleLocations = allMapMarkers select { markerColor _x == "ColorOrange" }; // TODO

_battleLocations
};
