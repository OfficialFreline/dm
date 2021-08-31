local function give_swep( ply, wepname )
	if ( not IsValid( ply ) ) then
        return
    end

	if ( wepname == nil ) then
        return
    end

	if ( not table.HasValue( DM.Config.GreenWeapon, wepname ) ) then
        if ( list.Get( 'Weapon' )[ wepname ] and not ply:Admin() ) then
            ply:ChatPrint( 'This weapon can only be issued by the admin.' )
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
