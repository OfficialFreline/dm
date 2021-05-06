local PLAYER = FindMetaTable( 'Player' )

function PLAYER:Admin()
	return ( self:GetRank() == 'admin' )
end

if ( SERVER ) then
	util.AddNetworkString( 'DmAdminSetAdmin' )
	util.AddNetworkString( 'DmAdminRemoveAdmin' )
	util.AddNetworkString( 'DmAdminSetAdminMsg' )
	util.AddNetworkString( 'DmAdminRemoveAdminMsg' )
	util.AddNetworkString( 'DmAdminSetHP' )
	util.AddNetworkString( 'DmAdminSetHPMsg' )
	util.AddNetworkString( 'DMAdminSetScale' )
	util.AddNetworkString( 'DMAdminSetScaleMsg' )

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

			target:SetRank( 'admin' )
			target:DataSave()

			net.Start( 'DmAdminSetAdminMsg' )
				net.WriteEntity( pl )
				net.WriteEntity( target )
			net.Broadcast()
		end
	end )

	net.Receive( 'DmAdminRemoveAdmin', function( len, pl )
		if ( pl:Admin() ) then
			local target = net.ReadEntity()

			target:SetRank( 'user' )
			target:DataSave()

			net.Start( 'DmAdminRemoveAdminMsg' )
				net.WriteEntity( pl )
				net.WriteEntity( target )
			net.Broadcast()
		end
	end )

	net.Receive( 'DmAdminSetHP', function( len, pl )
		if ( pl:Admin() ) then
			local target = net.ReadEntity()
			local HP = net.ReadString()

			target:SetHealth( HP )

			net.Start( 'DmAdminSetHPMsg' )
				net.WriteEntity( pl )
				net.WriteEntity( target )
				net.WriteString( HP )
			net.Broadcast()
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

			net.Start( 'DMAdminSetScaleMsg' )
				net.WriteEntity( pl )
				net.WriteEntity( target )
				net.WriteFloat( scale )
			net.Broadcast()
		end
	end )
end

if ( CLIENT ) then
	local color_white = Color( 255, 255, 255 )

	net.Receive( 'DmAdminSetAdminMsg', function()
		local pl = net.ReadEntity()
		local target = net.ReadEntity()

		chat.AddText( Color( 202, 68, 68 ), '[', color_white, pl:GetNick(), Color( 202, 68, 68 ), '] ', color_white, 'Issued admin panel to player ', Color( 102, 95, 180 ), target:GetNick(), color_white, '.' )
		chat.PlaySound()
	end )

	net.Receive( 'DmAdminRemoveAdminMsg', function()
		local pl = net.ReadEntity()
		local target = net.ReadEntity()

		chat.AddText( Color( 202, 68, 68 ), '[', color_white, pl:GetNick(), Color( 202, 68, 68 ), '] ', color_white, 'Removed the admin panel from the player ', Color( 102, 95, 180 ), target:GetNick(), color_white, '.' )
		chat.PlaySound()
	end )

	net.Receive( 'DmAdminSetHPMsg', function()
		local pl = net.ReadEntity()
		local target = net.ReadEntity()
		local HP = net.ReadString()

		chat.AddText( Color( 202, 68, 68 ), '[', color_white, pl:GetNick(), Color( 202, 68, 68 ), '] ', color_white, 'Installed ', Color( 102, 95, 180 ), HP .. '%', color_white, ' health for the player ', Color( 102, 95, 180 ), target:GetNick(), color_white, '.' )
		chat.PlaySound()
	end )

	net.Receive( 'DMAdminSetScaleMsg', function()
		local pl = net.ReadEntity()
		local target = net.ReadEntity()
		local scale = net.ReadFloat()

		chat.AddText( Color( 202, 68, 68 ), '[', color_white, pl:GetNick(), Color( 202, 68, 68 ), '] ', color_white, 'Resized player ', Color( 102, 95, 180 ), target:GetNick(), color_white, ' to ', Color( 102, 95, 180 ), tostring( scale ), color_white, '.' )
		chat.PlaySound()
	end )
end
