util.AddNetworkString( 'PlayerChangeNick' )
util.AddNetworkString( 'PlayerCheckData' )

net.Receive( 'PlayerChangeNick', function( len, pl )
	local nick = net.ReadString()

	net.Start( 'PlayerChangeNickMsg' )
		net.WriteString( nick )
		net.WriteEntity( pl )
	net.Broadcast()

    pl:SetNWString( 'ply_name', nick )
end )

net.Receive( 'PlayerCheckData', function( len, pl )
	local Data = {}

	Data = pl:DataLoad()

	pl:SetNWString( 'ply_name', Data.name )
	pl:SetNWString( 'ply_rank', Data.rank )
	pl:SetNWInt( 'ply_frags', Data.frags )
	pl:SetNWInt( 'ply_deaths', Data.deaths )
end )

local PLAYER = FindMetaTable( 'Player' )

function GM:PlayerInitialSpawn( ply )
	local Data = {}

	Data = ply:DataLoad()

	ply:SetNWString( 'ply_name', Data.name )
	ply:SetNWString( 'ply_rank', Data.rank )
	ply:SetNWInt( 'ply_frags', Data.frags )
	ply:SetNWInt( 'ply_deaths', Data.deaths )

	ply:DataSave()

	player_manager.SetPlayerClass( ply, 'dm_player' )

	ply:ChatPrint( 'To take the weapon press Q' )
end

function GM:PlayerSpawn( ply )
	ply:SetupHands()

	if ( ply:Admin() ) then
 		ply:Give( 'weapon_physgun' )
	end

	ply:SetPos( table.Random( DM.Config.SpawnPositionsList ) )
	ply:SetModel( table.Random( DM.Config.ModelsTable ) )
end

hook.Add( 'PlayerDeath', 'ply_sv', function( victim, inflictor, attacker )
	if ( victim == attacker ) then
		victim:SetNWInt( 'ply_deaths', victim:GetNWInt( 'ply_deaths' ) + 1 )
	else
		victim:SetNWInt( 'ply_deaths', victim:GetNWInt( 'ply_deaths' ) + 1 )
		attacker:SetNWInt( 'ply_frags', attacker:GetNWInt( 'ply_frags' ) + 1 )
	end
end )

function PLAYER:DataLoad()
	local Data = {}

	if ( file.Exists( 'dm/' .. self:UniqueID() .. '.json', 'DATA' ) ) then
		Data = util.JSONToTable( file.Read( 'dm/' .. self:UniqueID() .. '.json', 'DATA' ) )

		return Data
	else
		self:DataSave()

		Data = util.JSONToTable( file.Read( 'dm/' .. self:UniqueID() .. '.json', 'DATA' ) )
		Data.name = self:Nick() or DM.Translate( 'Unknown', true )
		Data.steamid64 = self:SteamID64() or DM.Translate( 'Unknown', true )
		Data.rank = 'user'
		Data.frags = 0
		Data.deaths = 0

		self:DataSave()

		return Data
	end
end

hook.Add( 'PlayerDisconnected', 'ply_sv', function( ply )
	ply:DataSave()
end )

hook.Add( 'ShutDown', 'ply_sv', function()
	for k, v in pairs( player.GetAll() ) do
		v:DataSave()
	end
end )
