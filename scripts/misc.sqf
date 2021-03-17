
// No veg on unsung tanks
noVeg =
{
 params ["_veh"];

for "_i" from 0 to 3 do
{
 _num = _i;
 if(_i == 0) then { _num = ""; };
 _veh animate [format["plants%1",_num],1];
};

};

