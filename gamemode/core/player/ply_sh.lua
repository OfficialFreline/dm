if ( CLIENT ) then
	CreateConVar( 'cl_playercolor', '0.24 0.34 0.41', { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, '' )
	CreateConVar( 'cl_weaponcolor', '0.30 1.80 2.10', { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, '' )
	CreateConVar( 'cl_playerskin', '0', { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, '' )
	CreateConVar( 'cl_playerbodygroups', '0', { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, '' )
end

player_manager.RegisterClass( 'dm_player', {
	DisplayName = 'DM Player Class',

	Spawn = function( self )
		local col = self.Player:GetInfo( 'cl_playercolor' )

		self.Player:SetPlayerColor( Vector( col ) )

		local col = self.Player:GetInfo( 'cl_weaponcolor' )

		self.Player:SetWeaponColor( Vector( col ) )
	end,

	SetModel = function( self )
		local cl_playermodel = self.Player:GetInfo( 'cl_playermodel' )
		local modelname = player_manager.TranslatePlayerModel( cl_playermodel )

		self.Player:SetModel( Model( modelname ) )

		local skin = self.Player:GetInfoNum( 'cl_playerskin', 0 )

		self.Player:SetSkin( skin )

		local groups = self.Player:GetInfo( 'cl_playerbodygroups' )

		if ( groups == nil ) then
			groups = ''
		end

		local groups = string.Explode( ' ', groups )

		for k = 0, self.Player:GetNumBodyGroups() - 1 do
			self.Player:SetBodygroup( k, tonumber( groups[ k + 1 ] ) or 0 )
		end
	end,

	TauntCam = TauntCamera(),

	CalcView = function( self, view )
		if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then
			return true
		end
	end,

	CreateMove = function( self, cmd )
		if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then
			return true
		end
	end,

	ShouldDrawLocal = function( self )
		if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then
			return true
		end
	end,

	JumpPower = DM.Config.JumpPower,
	DuckSpeed = DM.Config.DuckSpeed,
	WalkSpeed = DM.Config.WalkSpeed,
	RunSpeed = DM.Config.RunSpeed,
}, 'player_default' )

local PLAYER = FindMetaTable( 'Player' )

function PLAYER:DataSave()
	if ( not file.IsDir( 'dm', 'DATA' ) ) then 
		file.CreateDir( 'dm' ) 
	end

	local Data = { 
		name = self:GetNWString( 'ply_name' ),
		steamid64 = self:SteamID64(),
		rank = self:GetNWString( 'ply_rank' ),
		frags = self:GetNWInt( 'ply_frags' ),
		deaths = self:GetNWInt( 'ply_deaths' ),
	}

	file.Write( 'dm/' .. self:UniqueID() .. '.json', util.TableToJSON( Data ) )
end
