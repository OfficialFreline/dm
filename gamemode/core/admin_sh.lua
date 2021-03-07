local PLAYER = FindMetaTable( 'Player' )

function PLAYER:Admin()
	return self:GetNWString( 'ply_rank' ) == 'admin'
end

if ( SERVER ) then
	util.AddNetworkString( 'DmAdminSetAdmin' )
	util.AddNetworkString( 'DmAdminRemoveAdmin' )
	util.AddNetworkString( 'DmAdminSetAdminMsg' )
	util.AddNetworkString( 'DmAdminRemoveAdminMsg' )
	util.AddNetworkString( 'DmAdminSetHP' )
	util.AddNetworkString( 'DmAdminSetHPMsg' )
	util.AddNetworkString( 'DMAdminEditModel' )
	util.AddNetworkString( 'DMAdminEditModelMsg' )
	util.AddNetworkString( 'SpawnMenuGiveWeapon' )

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

			target:SetNWString( 'ply_rank', 'admin' )
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

			target:SetNWString( 'ply_rank', 'user' )
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

	net.Receive( 'DmAdminEditModel', function( len, pl )
		if ( pl:Admin() ) then
			local mdl = net.ReadString()
			local target = net.ReadEntity()

			target:SetModel( mdl )

			net.Start( 'DmAdminEditModelMsg' )
				net.WriteEntity( pl )
				net.WriteEntity( target )
				net.WriteString( mdl )
			net.Broadcast()
		end
	end )

	net.Receive( 'SpawnMenuGiveWeapon', function( len, pl )
		-- if ( pl:Admin() ) then
			local weapon = net.ReadString()

			pl:Give( weapon )
			pl:SelectWeapon( weapon )
		-- end
	end )
end

if ( CLIENT ) then
	net.Receive( 'DmAdminSetAdminMsg', function()
		local pl = net.ReadEntity()
		local target = net.ReadEntity()

		chat.AddText( Color( 202, 68, 68 ), '[', Color( 255, 255, 255 ), pl:GetNWString( 'ply_name' ), Color( 202, 68, 68 ), '] ', Color( 255, 255, 255 ), 'Issued admin panel to player ', Color( 102, 95, 180 ), target:GetNWString( 'ply_name' ), Color( 255, 255, 255 ), '.' )
		chat.PlaySound()
	end )

	net.Receive( 'DmAdminRemoveAdminMsg', function()
		local pl = net.ReadEntity()
		local target = net.ReadEntity()

		chat.AddText( Color( 202, 68, 68 ), '[', Color( 255, 255, 255 ), pl:GetNWString( 'ply_name' ), Color( 202, 68, 68 ), '] ', Color( 255, 255, 255 ), 'Removed the admin panel from the player ', Color( 102, 95, 180 ), target:GetNWString( 'ply_name' ), Color( 255, 255, 255 ), '.' )
		chat.PlaySound()
	end )

	net.Receive( 'DmAdminSetHPMsg', function()
		local pl = net.ReadEntity()
		local target = net.ReadEntity()
		local HP = net.ReadString()

		chat.AddText( Color( 202, 68, 68 ), '[', Color( 255, 255, 255 ), pl:GetNWString( 'ply_name' ), Color( 202, 68, 68 ), '] ', Color( 255, 255, 255 ), 'Installed ', Color( 102, 95, 180 ), HP .. '%', Color( 255, 255, 255 ), ' health for the player ', Color( 102, 95, 180 ), target:GetNWString( 'ply_name' ), Color( 255, 255, 255 ), '.' )
		chat.PlaySound()
	end )

	net.Receive( 'DmAdminEditModelMsg', function()
		local pl = net.ReadEntity()
		local target = net.ReadEntity()
		local mdl = net.ReadString()

		chat.AddText( Color( 202, 68, 68 ), '[', Color( 255, 255, 255 ), pl:GetNWString( 'ply_name' ), Color( 202, 68, 68 ), '] ', Color( 255, 255, 255 ), 'Changed the model for player ', Color( 102, 95, 180 ), target:GetNWString( 'ply_name' ), Color( 255, 255, 255 ), ' to ', Color( 102, 95, 180 ), mdl, Color( 255, 255, 255 ), '.' )
		chat.PlaySound()
	end )
end
