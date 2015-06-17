private ["_unit", "_return"];

#define __ICE_gear_Rifleman 0
#define __ICE_gear_Grenadier 1
#define __ICE_gear_MG 2
#define __ICE_gear_Medic 3
#define __ICE_gear_CombatEngineer 4
#define __ICE_gear_LightAT 5
#define __ICE_gear_HeavyAT 6
#define __ICE_gear_AA 7
#define __ICE_gear_Marksman 8
#define __ICE_gear_Sniper 9
#define __ICE_gear_SL 10
#define __ICE_gear_Crewman 11
#define __ICE_gear_Pilot 12
#define __ICE_gear_Diver 13

_unit = _this;

_return = switch (_unit call ICE_fnc_gear_getCurrentRole) do {
 	case __ICE_gear_Rifleman: {"Rifleman"};
	case __ICE_gear_Grenadier: {"Grenadier"};
	case __ICE_gear_MG: {"Autorifleman"};
	case __ICE_gear_Medic: {"Medic"};
	case __ICE_gear_CombatEngineer: {"Engineer"};
	case __ICE_gear_LightAT: {"Rifleman AT"};
	case __ICE_gear_HeavyAT: {"Rifleman AT"};
	case __ICE_gear_AA: {"Rifleman AT"};
	case __ICE_gear_Marksman: {"Marksman"};
	case __ICE_gear_Sniper: {"Marksman"};
	case __ICE_gear_SL : {"SQL"};
	case __ICE_gear_Crewman : {"Rifleman"};
	case __ICE_gear_Pilot : {"Rifleman"};
	case __ICE_gear_Diver : {"Rifleman"};
	default {"Rifleman"};
};

_return