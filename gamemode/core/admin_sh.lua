local PLAYER = FindMetaTable( 'Player' )

function PLAYER:Admin()
	return self:GetRank() == 'admin'
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

			if ( not table.HasValue( DM.Config.GreenWeapon, weapon ) ) then
				pl:ChatPrint( 'This weapon cannot be given away.' )

				return
			end

			pl:Give( weapon )
			pl:SelectWeapon( weapon )
		-- end
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

	net.Receive( 'DmAdminEditModelMsg', function()
		local pl = net.ReadEntity()
		local target = net.ReadEntity()
		local mdl = net.ReadString()

		chat.AddText( Color( 202, 68, 68 ), '[', color_white, pl:GetNick(), Color( 202, 68, 68 ), '] ', color_white, 'Changed the model for player ', Color( 102, 95, 180 ), target:GetNick(), color_white, ' to ', Color( 102, 95, 180 ), mdl, color_white, '.' )
		chat.PlaySound()
	end )
end
