local color_white = Color(255,255,255)

local function give_swep( ply, wepname )
	if ( not IsValid( ply ) ) then
		return
	end

	if ( wepname == nil ) then
		return
	end

	if ( not table.HasValue( DM.Config.GreenWeapon, wepname ) ) then
		if ( list.Get( 'Weapon' )[ wepname ] and not ply:Admin() ) then
			ply:SendLua( 'notification.AddLegacy( "This weapon does not enter into the list of available (only for admins)", NOTIFY_ERROR, 2.5 )' )
			ply:EmitSound( 'buttons/blip1.wav' )
			
			return
		end
	end

	ply:Give( wepname )
	ply:SelectWeapon( wepname )
end

concommand.Add( 'dm_giveswep', function( ply, cmd, args )
	local weapon = args[ 1 ]

	give_swep( ply, weapon )
end )

local function change_model( ply, mdlname )
	if ( not IsValid( ply ) ) then
		return
	end

	if ( mdlname == nil ) then
		return
	end

	if ( not player_manager.TranslateToPlayerModelName( mdlname ) ) then
		return
	end

	ply:SetModel( mdlname )
end

concommand.Add( 'dm_changemdl', function( ply, cmd, args )
	local model = args[ 1 ]

	change_model( ply, model )
end )

local function drop_swep( ply, wepname )
	if ( not IsValid( ply ) ) then
		return
	end

	if ( wepname == nil ) then
		return
	end

	local weapon = ply:GetWeapon( wepname )

	if ( weapon == NULL ) then
		return
	end

	ply:SelectWeapon( weapon )
	ply:DoAnimationEvent( ACT_GMOD_GESTURE_ITEM_DROP )

	local primAmmo = ply:GetAmmoCount( weapon:GetPrimaryAmmoType() )
	local model = ( weapon:GetModel() == 'models/weapons/v_physcannon.mdl' and 'models/weapons/w_physics.mdl' ) or weapon:GetModel()

	model = util.IsValidModel( model ) and model or 'models/hunter/blocks/cube025x025x025.mdl'

	local ent = ents.Create( 'dm_weapon' )
	ent:SetPos( ply:GetShootPos() + ply:GetAimVector() * 30 )
	ent:SetModel( model )
	ent:SetSkin( weapon:GetSkin() or 0 )
	ent:SetWeaponClass( weapon:GetClass() )
	ent:SetPlayer( ply )
	ent:SetOverlayText( wepname )
	ent.nodupe = true
	ent.clip1 = weapon:Clip1()
	ent.clip2 = weapon:Clip2()
	ent.ammoadd = primAmmo

	ply:RemoveAmmo( primAmmo, weapon:GetPrimaryAmmoType() )
	ply:RemoveAmmo( ply:GetAmmoCount( weapon:GetSecondaryAmmoType() ), weapon:GetSecondaryAmmoType() )

	ent:Spawn()

	weapon:Remove()
end

concommand.Add( 'dm_dropswep', function( ply, cmd, args )
	local weapon = args[ 1 ]

	drop_swep( ply, weapon )
end )

local function setRank( ply, user, namerank )
	if ( not ply:IsPlayer() or ply:Admin() ) then
		local comp

		for l, p in pairs( player.GetAll() ) do
			if ( p:SteamID64() == user ) then
				comp = p
			end
		end

		if ( comp:IsPlayer() ) then
			comp:SetRank( namerank )
			comp:DataSave()

			sendMsgAll( Color(15,170,235), comp:GetNick(), color_white, ' received the rank ', Color(80,200,140), namerank, color_white, '.' )
		end
	end
end

concommand.Add( 'dm_setrank', function( ply, cmd, args )
	local steamid64 = args[ 1 ]
	local rank = args[ 2 ]

	setRank( ply, steamid64, rank )
end )

local function setNick( ply, nick )
	sendMsgAll( Color(15, 170, 235), ply:GetNick(), color_white, ' changed his nickname to ', Color(90,200,140), nick, color_white, '.' )

	ply:SetNick( nick )
end

concommand.Add( 'dm_setnick', function( ply, cmd, args )
	local text = args[ 1 ]

	if ( string.len( text ) < 3 or string.len( text ) > 20 ) then
		sendMsg( ply, color_white, 'Your nick is too ', Color(255,252,96), ( string.len( text ) < 3 and 'short' ) or 'long', color_white, '.' )

		return
	end

	setNick( ply, text )
end )

concommand.Add( 'dm_checkdata', function( ply, cmd, args )
	if ( not ply:IsPlayer() ) then
		return
	end

	local Data = {}

	Data = ply:DataLoad()

	ply:SetNick( Data.name )
	ply:SetRank( Data.rank )
	ply:SetFrags( Data.frags )
	ply:SetDeaths( Data.deaths )
	ply:SetModel( Data.model )

	sendMsg( ply, color_white, 'Your details have been updated!' )
end )

local function setHP( ply, user, health )
	if ( not ply:IsPlayer() or ply:Admin() ) then
		local comp

		for l, p in pairs( player.GetAll() ) do
			if ( p:SteamID64() == user ) then
				comp = p
			end
		end

		if ( comp:IsPlayer() ) then
			comp:SetHealth( health )

			sendMsgAll( Color(202, 68, 68), '[', color_white, ply:GetNick(), Color(202, 68, 68), '] ', color_white, 'Installed ', Color(102, 95, 180), tonumber( health ) .. '%', color_white, ' health for the player ', Color(102, 95, 180), comp:GetNick(), color_white, '.' )
		end
	end
end

concommand.Add( 'dm_sethp', function( ply, cmd, args )
	local steamid64 = args[ 1 ]
	local hp = args[ 2 ]

	setHP( ply, steamid64, hp )
end )
