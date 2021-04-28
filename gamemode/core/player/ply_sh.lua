if ( CLIENT ) then
	CreateConVar( 'cl_playercolor', '0.24 0.34 0.41', { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, '' )
	CreateConVar( 'dm_weaponcolor', '0.30 1.80 2.10', { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, '' )
end

player_manager.RegisterClass( 'dm_player', {
	DisplayName = 'DM Player Class',

	Spawn = function( self )
		local col = self.Player:GetInfo( 'cl_playercolor' )

		self.Player:SetPlayerColor( Vector( col ) )

		local col = self.Player:GetInfo( 'dm_weaponcolor' )

		self.Player:SetWeaponColor( Vector( col ) )
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

function PLAYER:GetNick()
	return self:GetNWString( 'ply_name' )
end

function PLAYER:GetRank()
	return self:GetNWString( 'ply_rank' )
end

function PLAYER:GetFrags()
	return self:GetNWInt( 'ply_frags' ) or 0
end

function PLAYER:GetDeaths()
	return self:GetNWInt( 'ply_deaths' ) or 0
end

function PLAYER:SetNick( name )
	return self:SetNWString( 'ply_name', name )
end

function PLAYER:SetRank( rank )
	return self:SetNWString( 'ply_rank', rank )
end

function PLAYER:SetFrags( frags )
	return self:SetNWInt( 'ply_frags', frags )
end

function PLAYER:SetDeaths( deaths )
	return self:SetNWInt( 'ply_deaths', deaths )
end

function PLAYER:DataSave()
	if ( not file.IsDir( 'dm', 'DATA' ) ) then 
		file.CreateDir( 'dm' ) 
	end

	local Data = { 
		name = self:GetNick(),
		steamid64 = self:SteamID64(),
		rank = self:GetRank(),
		frags = self:GetFrags(),
		deaths = self:GetDeaths(),
	}

	file.Write( 'dm/' .. self:UniqueID() .. '.json', util.TableToJSON( Data ) )
end
