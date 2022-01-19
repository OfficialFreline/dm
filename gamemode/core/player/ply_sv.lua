local PLAYER = FindMetaTable( 'Player' )

function GM:PlayerInitialSpawn( ply )
	local Data = {}

	Data = ply:DataLoad()

	ply:SetNick( Data.name )
	ply:SetRank( Data.rank )
	ply:SetFrags( Data.frags )
	ply:SetDeaths( Data.deaths )

	ply:DataSave()

	player_manager.SetPlayerClass( ply, 'dm_player' )

	sendMsg( ply, Color(255,0,0), '! ', Color(255,255,255), 'To take the weapon press Q' )
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
		Data.name = self:Nick() or LANG.GetTranslation( 'unknown' )
		Data.steamid64 = self:SteamID64() or LANG.GetTranslation( 'unknown' )
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
