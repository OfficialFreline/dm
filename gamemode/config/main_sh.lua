DM.Config = {}

local c = DM.Config

// Gamemode language. Available: en, ru (soon)
c.Language = 'en'

// Character parameters
c.JumpPower = 300
c.DuckSpeed = 0.5
c.WalkSpeed = 200
c.RunSpeed = 550

// Spawn positions for players (randomly)
c.SpawnPositionsList = {
	gm_construct = {
		Vector( -880, -958, -144 ),
		Vector( 578, -2229, -144 ),
		Vector( -4763, -959, 256 ),
		Vector( -3801, 5330, -96 ),
		Vector( 758, 4317, -32 ),
		Vector( 716, 725, -144 ),
		Vector( -1840, 2054, -9 ),
		Vector( 1076, 180, 64 ),
	},
}

// Weapons that are available for use
c.GreenWeapon = {
	'weapon_crowbar',
	'weapon_fists',
	'weapon_smg1',
	'weapon_medkit',
	'weapon_ar2',
	'weapon_frag',
	'weapon_pistol',
	'weapon_shotgun',
}

// The ratio of damage from falling
c.FallFactor = 5
