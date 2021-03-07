addMissionEventHandler ["HCGroupSelectionChanged", {
	params ["_group", "_isSelected"];
hint "SEL";
}];

lastViewedGroup = grpNull;
lastViewUpdate = 0;

ranksShort = ["Pvt","Cpl","Sgt","Lt","Cpt","Maj","Col"];

toRoundsText =
{
 params ["_ammoCount"];
 format["%1",_ammoCount]
};

activateBattleGui =
{
 cutRsc["ComOverlay","PLAIN",0];

};

while { true } do
{
 _overlay = uiNamespace getVariable ['ComOverlay', displayNull];

 if(!isnull _overlay) then
 {

 _groupView = _overlay displayCtrl 1500;
 
_sel = curatorSelected # 1;

// hint format[">>> %1 ", curatorSelected];

if(count _sel > 0) then
{

_group = _sel select 0;

if(lastViewedGroup != _group || (time - lastViewUpdate) >= 1 ) then
{

lnbClear _groupView;

_mainVeh = objNull;
_vehs = _group call getVehicles;
_men = [];
if(count _vehs > 0) then
{
 _mainVeh = _vehs # 0;
 _men = crew _mainVeh;
}
else
{
 _men = units _group;
};

{
 _veh = _x;
 _vehCfg = configFile >> "CfgVehicles" >> (typeof _veh);
 _vehName = getText(_vehCfg >> "displayName");
 
 _cwp = currentWeapon _veh;
 _curweapName = gettext (configfile >> "cfgweapons" >> _cwp >> "displayName");
 _ammo = format["%1 rounds",_veh ammo _cwp];

 _groupView lnbAddRow ["", _vehName, _curweapName,"",_ammo];

// systemchat format ["_vehName_vehName %1",  _vehName];

} foreach _vehs;



{
_man = _x;
_row = (lnbSize _groupView) # 0;

 _rankStr = ranksShort select (rankId _man);

_mainWeapon = currentWeapon _man;

_allMags = magazinesAmmoFull _man;
_ammoCount = 0;
{ 
if(_x#0 == (currentMagazine _man)) then
{
_ammoCount = _ammoCount + (_x#1);
};
} foreach _allMags;


_ammo = _ammoCount call toRoundsText;


if(!isnull _mainVeh && _man in _mainVeh) then
{
 _tp = _mainVeh unitTurret _man;
 _mainWeapon = _mainVeh currentWeaponTurret _tp;
 _magazine = _mainVeh currentMagazineTurret _tp;

 _mags = _mainVeh magazinesTurret _tp;
 _ammoCount = _mainVeh magazineTurretAmmo [_magazine, _tp];

 _ammo = _ammoCount call toRoundsText;
};

_wcfg = configfile >> "cfgWeapons" >> _mainWeapon;
_weapName = getText(_wcfg >> "displayName");
_weapPic = getText(_wcfg >> "picture");


_groupView lnbAddRow [_rankStr, name _man, _weapName,"",_ammo];

_groupView lnbSetPicture [[_row, 3], _weapPic];

} foreach _men;

lastViewUpdate = time;
};

 _groupView ctrlShow true;
}
else
{
 _groupView ctrlShow false;
};

 };

 sleep 0.5;
};