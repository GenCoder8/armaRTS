
newZeusSelect = false;

addMissionEventHandler ["EachFrame",
{

 _overlay = uiNamespace getVariable ['ComOverlay', displayNull];

 if(!isnull _overlay) then
 {

if(newZeusSelect || (time - lastViewUpdate) >= 1 ) then
{
_groupView = _overlay displayCtrl 1500;


_viewUnits = [];
_selGroup = grpNull;

_selGroups = curatorSelected # 1; // get groups
_selUnits = curatorSelected # 0;

if(count _selGroups > 0) then
{
 _selGroup = _selGroups # 0;
 _viewUnits = units _selGroup;
}
else
{
 if(count _selUnits > 0) then
 {
 _viewUnits = _selUnits;
 _selGroup = group (_viewUnits # 0);
 };
};

// hint format[">>> %1 ", curatorSelected];



_groupInfo = _overlay displayCtrl 1000;
_bg = _overlay displayCtrl 7000;

private _bgcfg = _selGroup getVariable ["cfg",configNull];
if(!isnull _bgcfg) then
{
_groupInfo ctrlSetText format ["%1 (%2)", getText (_bgcfg >> "name"), _selGroup getVariable "expStr" ];
 _bg ctrlShow true;

_groupView ctrlShow true;
}
else
{
_groupInfo ctrlSetText "";

 _bg ctrlShow false;

 _groupView ctrlShow false; // Not really needed
};

lnbClear _groupView;

_mainVeh = objNull;
_vehs = [_viewUnits] call getVehicles;
_vehs = _vehs select { !(_x iskindof "StaticWeapon") };
_men = [];
if(count _vehs > 0) then
{
 _mainVeh = _vehs # 0;
 _men = crew _mainVeh;
}
else
{
 _men = _viewUnits;
};

_men = _men select { alive _x && side _x in [east,west] };

{
 _veh = _x;
 _vehCfg = configFile >> "CfgVehicles" >> (typeof _veh);
 _vehName = getText(_vehCfg >> "displayName");
 
 _cwp = currentWeapon _veh;
 _curweapName = gettext (configfile >> "cfgweapons" >> _cwp >> "displayName");
 _ammo = format["%1 rounds",_veh ammo _cwp];

 //_groupView lnbAddRow ["", _vehName, "","",""];

// systemchat format ["_vehName_vehName %1",  _vehName];

} foreach _vehs;


{
_man = _x;
_row = (lnbSize _groupView) # 0;

// diag_log format[" %1 %2 ", _man, rankId _man];

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

// Static weapons override
if(isnull _mainVeh && _man call inVehicle) then
{
 _mainVeh = vehicle _man;
};

if(!isnull _mainVeh && _man in _mainVeh) then
{
 _tp = _mainVeh unitTurret _man;
 _mainWeapon = _mainVeh currentWeaponTurret _tp;
 _magazine = _mainVeh currentMagazineTurret _tp;

 _mags = _mainVeh magazinesTurret _tp;
 _ammoCount = _mainVeh magazineTurretAmmo [_magazine, _tp];

_ammo = "";
if(_ammoCount > 0) then
{
 _ammo = _ammoCount call toRoundsText;
};

// For mortars (static weapons) we override the ammo here
if((_mainVeh iskindof "StaticWeapon")) then
{
 _ammo = "";
 _ammoCount = (_selGroup call getMortarAmmoLeft);
 if(_ammoCount > 0 ) then 
{
_ammo = _ammoCount call toRoundsText;
};
};

};

_wcfg = configfile >> "cfgWeapons" >> _mainWeapon;
_weapName = getText(_wcfg >> "displayName");
_weapPic = getText(_wcfg >> "picture");


_groupView lnbAddRow [_rankStr, name _man, _weapName,"",_ammo];

_groupView lnbSetPicture [[_row, 3], _weapPic];

} foreach _men;



_staticGunInfo = _overlay displayCtrl 1001;

_staticGunInfo ctrlSetText (_selGroup call getMortarAmmoInfo);




// Set the Y and height of all group panel ctrls
_ctrlPos = ctrlPosition _bg;

_gvSize = lnbSize _groupView;


_gvHeight = (_gvSize # 0) * (ctrlFontHeight _groupView) + 0.02;

_panelHeight = _gvHeight + 0.125;

_panelStartY = safeZoneH + safeZoneY - _panelHeight;

_bg ctrlSetPosition [_ctrlPos # 0,_panelStartY,_ctrlPos # 2, _panelHeight];
_bg ctrlcommit 0;

_listCurHeight = 0;

#define PTEXT_HEIGHT 0.07

_giPos = ctrlPosition _groupInfo;
_groupInfo ctrlSetPosition [_giPos # 0,_panelStartY,_giPos # 2, PTEXT_HEIGHT];
_groupInfo ctrlcommit 0;

_listCurHeight = _listCurHeight + PTEXT_HEIGHT;

_gvPos = ctrlPosition _groupView;
_groupView ctrlSetPosition [_gvPos # 0,_panelStartY + _listCurHeight,_gvPos # 2, _gvHeight];
_groupView ctrlcommit 0;

_listCurHeight = _listCurHeight + _gvHeight;

_sgiPos = ctrlPosition _staticGunInfo;
//_sgiPos set [1, (_ctrlPos # 1) + _panelHeight - 0.05 ];
_sgiPos set [1, _panelStartY + _listCurHeight ];
_staticGunInfo ctrlSetPosition _sgiPos;
_staticGunInfo ctrlcommit 0;

//hintsilent format["%1 %2", _selGroup call getMortarAmmoLeft, time];


{
 _x params ["_but","_bDef"];

 if(!call isUsingActionButton && call compile (getText (_bDef >> "condition"))) then
 {
  _but ctrlEnable true;
  _but ctrlSetTextColor [1, 1, 1, 1];
 }
 else
 {
  _but ctrlEnable false; 
  _but ctrlSetTextColor [1, 1, 1, 0.5];
 };

 _text = (getText (_bDef >> "text"));
 _textAdd = (getText (_bDef >> "textAdd"));
 if(_textAdd != "") then { _text = _text + ". " + (call compile _textAdd); };

 _but ctrlsetTooltip _text;

} foreach actionButtons;




lastViewUpdate = time;
};


/*
}
else
{
 _groupView ctrlShow false;
};*/

 };


}];