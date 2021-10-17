local PLAYER = FindMetaTable( 'Player' )

function PLAYER:Admin()
	return ( self:GetRank() == 'admin' or self:IsSuperAdmin() )
end

if ( SERVER ) then
	local color_white = Color(255, 255, 255)

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

	net.Receive( 'DMAdminSetScale', function( len, pl )
		if ( pl:Admin() ) then
			local scale = net.ReadFloat()
			local target = net.ReadEntity()
			local target_scale = target:GetModelScale()

			target:SetModelScale( target_scale * scale, 0 )
			target:SetViewOffset( Vector( 0, 0, 64 ) * scale )
			target:SetViewOffsetDucked( Vector( 0, 0, 28 ) * scale )

			sendMsgAll( Color(202, 68, 68), '[', color_white, pl:GetNick(), Color(202, 68, 68), '] ', color_white, 'Resized player ', Color(102, 95, 180), target:GetNick(), color_white, ' to ', Color(102, 95, 180), tostring( scale ), color_white, '.' )
		end
	end )
end
