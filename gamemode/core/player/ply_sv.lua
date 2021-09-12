util.AddNetworkString( 'PlayerChangeNick' )
util.AddNetworkString( 'PlayerCheckData' )

net.Receive( 'PlayerChangeNick', function( len, pl )
	local nick = net.ReadString()
	
	sendMsgAll( Color( 15, 170, 235 ), pl:GetNick(), color_white, ' changed his nickname to ', Color( 70, 162, 112 ), nick, color_white, '.' )

	pl:SetNick( nick )
end )

net.Receive( 'PlayerCheckData', function( len, pl )
	local Data = {}

	Data = pl:DataLoad()

	pl:SetNick( Data.name )
	pl:SetRank( Data.rank )
	pl:SetFrags( Data.frags )
	pl:SetDeaths( Data.deaths )
	pl:SetModel( Data.model )
end )

local PLAYER = FindMetaTable( 'Player' )

function GM:PlayerInitialSpawn( ply )
	local Data = {}

	Data = ply:DataLoad()

	ply:SetNick( Data.name )
	ply:SetRank( Data.rank )
	ply:SetFrags( Data.frags )
	ply:SetDeaths( Data.deaths )
	ply:SetModel( Data.model )

	ply:DataSave()

	player_manager.SetPlayerClass( ply, 'dm_player' )

	ply:ChatPrint( 'To take the weapon press Q' )
end

function GM:PlayerSpawn( ply )
	ply:SetupHands()

	local map_Table = DM.Config.SpawnPositionsList[ game.GetMap() ] 

	if ( map_Table ) then
		local map = table.Random( DM.Config.SpawnPositionsList[ game.GetMap() ] )

		ply:SetPos( map )
	end
end

hook.Add( 'PlayerDeath', 'ply_sv', function( victim, inflictor, attacker )
	if ( victim == attacker ) then
		victim:SetDeaths( victim:GetDeaths() + 1 )
	elseif ( not attacker:IsWorld() ) then
		victim:SetDeaths( victim:GetDeaths() + 1 )
		attacker:SetFrags( attacker:GetFrags() + 1 )
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
		Data.model = 'models/player/alyx.mdl'

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
