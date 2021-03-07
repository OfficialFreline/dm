local color_white = Color( 255, 255, 255 )
local scrw, scrh = ScrW(), ScrH()
local draw_RoundedBox = draw.RoundedBox

hook.Add( 'RenderScene', 'Hud', function( pos )
	EyePos = pos
end )

hook.Add( 'PostPlayerDraw', 'Hud', function( ply )
	surface.SetFont( 'Hud.2' )

	local Distantion = ply:GetPos():Distance( EyePos )

	if ( Distantion > 350 or not ply:Alive() ) then
		return
	end

	local Bone = ply:LookupAttachment( 'anim_attachment_head' )

	if ( Bone == 0 ) then
		return
	end
			
	local Attach = ply:GetAttachment( Bone )
	local ColorAlpha = 255 * ( 1 - math.Clamp( ( Distantion - 250 ) * 0.01, 0, 1 ) )

	cam.Start3D2D( Attach.Pos + Vector( 0, 0, 15 ), Angle( 0, ( Attach.Pos - EyePos ):Angle().y - 90, 90 ), 0.05 )
		local TextNick = ply:Nick()

		draw.SimpleTextOutlined( TextNick, 'Hud.2', 0, 0, Color( 255, 255, 255, ColorAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0, ColorAlpha ) )	
	cam.End3D2D()
end )

function GM:HUDPaint()
	-- Death
	if ( not LocalPlayer():Alive() ) then
		return
	end
	
	surface.SetFont( 'Hud.1' )

	-- Health
	local text = LocalPlayer():Health() .. '%'

	draw.RectBlur( 30, scrh - 100, surface.GetTextSize( text ) + 22, 70 )

	draw.OutlinedBox( 30, scrh - 100, surface.GetTextSize( text ) + 22, 70, Color( 75, 75, 75, 205 ), Color( 0, 0, 0 ) )
	draw.SimpleText( text, 'Hud.1', 40, scrh - 96, Color( 255, 255, 255 ) )

	-- Ammo

	local Weapon = LocalPlayer():GetActiveWeapon()

	if ( IsValid( Weapon ) ) then
        local CountOne = Weapon:Clip1()
        local CountTwo = LocalPlayer():GetAmmoCount( Weapon:GetPrimaryAmmoType() )
        local CountOneMax = Weapon:GetMaxClip1()

        if ( CountOneMax > -1 ) then
			local text = CountOne .. '/' .. CountTwo
			local b = 96

	        if ( CountOne == 0 and CountTwo == 0 ) then
				text = 'Empty'

				b = 100
			end

			draw.RectBlur( scrw / 2 - surface.GetTextSize( text ) * 0.5 - 10, scrh - 100, surface.GetTextSize( text ) + 20, 70 )

			draw.OutlinedBox( scrw / 2 - surface.GetTextSize( text ) * 0.5 - 10, scrh - 100, surface.GetTextSize( text ) + 20, 70, Color( 75, 75, 75, 205 ), Color( 0, 0, 0 ), 1 )
			draw.SimpleText( text, 'Hud.1', scrw / 2 - surface.GetTextSize( text ) * 0.5, scrh - b, Color( 255, 255, 255 ) )
        end 
	end

	-- Crosshair
	draw_RoundedBox( 5, scrw * 0.5 - 4, scrh * 0.5 - 4, 8, 8, Color( 0, 0, 0, 200 ) )
	draw_RoundedBox( 5, scrw * 0.5 - 3, scrh * 0.5 - 3, 6, 6, Color( 255, 255, 255, 200 ) )
end

local DeleteHudElementsList = {
	[ 'CHudHealth' ] = true,
	[ 'CHudBattery' ] = true,
	[ 'CHudCrosshair' ] = true,
	[ 'CHudAmmo' ] = true,
	[ 'CHudSecondaryAmmo' ] = true,
}

hook.Add( 'HUDShouldDraw', 'Hud', function( name )
	if ( DeleteHudElementsList[ name ] ) then
		return false
	end
end )

hook.Add( 'HUDDrawTargetID', 'Hud', function( name )
	return false
end )
