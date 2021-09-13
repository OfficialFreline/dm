local PLAYER = FindMetaTable( 'Player' )

function PLAYER:Admin()
	return ( self:GetRank() == 'admin' or self:IsSuperAdmin() )
end

if ( SERVER ) then
	local color_white = Color( 255, 255, 255 )

	util.AddNetworkString( 'DmAdminSetAdmin' )
	util.AddNetworkString( 'DmAdminRemoveAdmin' )
	util.AddNetworkString( 'DmAdminSetHP' )
	util.AddNetworkString( 'DMAdminSetScale' )

	function GM:PlayerNoClip( ply, desiredState )
		if ( desiredState == false ) then
			return true
		elseif ( ply:Admin() ) then
			return true
		end
	end

	function GM:PhysgunPickup( ply, ent )
		if ( ply:Admin() ) then
			return true
		end
	end

	net.Receive( 'DmAdminSetAdmin', function( len, pl )
		if ( pl:Admin() ) then
			local target = net.ReadEntity()

			RunConsoleCommand( 'dm_setrank', target:SteamID64(), 'admin' )

			sendMsgAll( Color( 202, 68, 68 ), '[', color_white, pl:GetNick(), Color( 202, 68, 68 ), '] ', color_white, 'Issued the admin status for the player ', Color( 102, 95, 180 ), target:GetNick(), color_white, '.' )
		end
	end )

	net.Receive( 'DmAdminRemoveAdmin', function( len, pl )
		if ( pl:Admin() ) then
			local target = net.ReadEntity()

			RunConsoleCommand( 'dm_setrank', target:SteamID64(), 'user' )

			sendMsgAll( Color( 202, 68, 68 ), '[', color_white, pl:GetNick(), Color( 202, 68, 68 ), '] ', color_white, 'Removed the admin status of the player ', Color( 102, 95, 180 ), target:GetNick(), color_white, '.' )
		end
	end )

	net.Receive( 'DmAdminSetHP', function( len, pl )
		if ( pl:Admin() ) then
			local target = net.ReadEntity()
			local HP = net.ReadString()

			target:SetHealth( HP )

			sendMsgAll( Color( 202, 68, 68 ), '[', color_white, pl:GetNick(), Color( 202, 68, 68 ), '] ', color_white, 'Installed ', Color( 102, 95, 180 ), HP .. '%', color_white, ' health for the player ', Color( 102, 95, 180 ), target:GetNick(), color_white, '.' )
		end
	end )

	net.Receive( 'DMAdminSetScale', function( len, pl )
		if ( pl:Admin() ) then
			local scale = net.ReadFloat()
			local target = net.ReadEntity()
			local target_scale = target:GetModelScale()

			target:SetModelScale( target_scale * scale, 0 )
			target:SetViewOffset( Vector( 0, 0, 64 ) * scale )
			target:SetViewOffsetDucked( Vector( 0, 0, 28 ) * scale )

			sendMsgAll( Color( 202, 68, 68 ), '[', color_white, pl:GetNick(), Color( 202, 68, 68 ), '] ', color_white, 'Resized player ', Color( 102, 95, 180 ), target:GetNick(), color_white, ' to ', Color( 102, 95, 180 ), scale, color_white, '.' )
		end
	end )
end
