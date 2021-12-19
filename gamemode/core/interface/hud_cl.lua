local color_white = Color( 255, 255, 255 )
local color_black = Color( 0, 0, 0 )
local scrw, scrh = ScrW(), ScrH()
local draw_RoundedBox = draw.RoundedBox

hook.Add( 'RenderScene', 'Hud', function( pos )
	EyePos = pos
end )

hook.Add( 'PostPlayerDraw', 'Hud', function( ply )
	if ( not LocalPlayer():Alive() ) then
		return
	end

	local Distantion = ply:GetPos():Distance( EyePos )

	if ( Distantion > 550 or not ply:Alive() ) then
		return
	end

	local Bone = ply:LookupAttachment( 'anim_attachment_head' )

	if ( Bone == 0 ) then
		return
	end
			
	local Attach = ply:GetAttachment( Bone )
	local ColorAlpha = 255 * ( 1 - math.Clamp( ( Distantion - 450 ) * 0.01, 0, 1 ) )
	local TextNick = ply:GetNick()

	cam.Start3D2D( Attach.Pos + Vector( 0, 0, 15 ), Angle( 0, ( Attach.Pos - EyePos ):Angle().y - 90, 90 ), 0.05 )
		draw.SimpleTextOutlined( TextNick, 'Hud.2', 0, 0, Color( 255, 255, 255, ColorAlpha ), 1, 1, 2, Color( 80, 80, 80, ColorAlpha ) )

		-- if ( ply:IsSpeaking() ) then
		-- 	draw.RoundedBox( 100, -32, -32 * 4, 64, 64, color_white )
		-- end
	cam.End3D2D()
end )

function GM:HUDPaint()
	-- Checking to disable hud
	if ( not GetConVar( 'cl_drawhud' ):GetBool() ) then
		return
	end

	-- Effect at low HP
	local health = LocalPlayer():Health()

	if ( health <= 40 ) then
		if ( health <= 30 ) then
			local blurmul = 0
			local cutoff = 50

			if ( health <= 20 ) then
				cutoff = 120
			end

			if( health <= 10 ) then
				cutoff = 200
			end	

			blurmul = 1 - math.Clamp( health / cutoff, 0, 1 )

			DrawMotionBlur( 0.15 * blurmul, 0.955 * blurmul, 0.07 * blurmul )
		end

		surface.SetDrawColor( 0, 0, 0, 160 * ( 1 - math.Clamp( health * 0.02, 0, 1 ) ) )
		surface.DrawRect( 0, 0, scrw, scrh )
	end

	-- Death
	if ( not LocalPlayer():Alive() ) then
		// Who wants to - will use
		-- draw.SimpleTextOutlined( LANG.GetTranslation( 'player_death' ), 'Hud.Death', scrw * 0.5, scrh * 0.5, color_white, 1, 1, 1, color_black )

		return
	end
	
	surface.SetFont( 'Hud.1' )

	-- Health
	local siz = scrw * 0.15
	local s = 30
	local tall = 10

	draw.RoundedBox( 4, 24 + s, scrh - tall - 26 + 2, siz + 2, tall - 2, DMColor.frame_outlined )
	draw.RoundedBox( 4, 25 + s, scrh - tall - 25 + 2, siz, tall - 4, DMColor.frame_background )

	draw.RoundedBox( 4, 24, scrh - tall - 26, 27, tall + 2, DMColor.frame_outlined )
	draw.RoundedBox( 4, 25, scrh - tall - 25, 25, tall, Color(241, 196, 15), DMColor.frame_outlined )

	draw.RoundedBox( 4, 24 + s, scrh - tall - 26, math.Clamp( health, 0, 100 ) * siz * 0.01 + 2, tall + 2, DMColor.frame_outlined )
	draw.RoundedBox( 4, 25 + s, scrh - tall - 25, math.Clamp( health, 0, 100 ) * siz * 0.01, tall, Color(255,91,91) )

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
				text = LANG.GetTranslation( 'empty' )

				b = 100
			end

			draw.SimpleText( text, 'Hud.1', 25, scrh - tall - 62, color_white )
		end 
	end
end

local DeleteHudElementsList = {
	[ 'CHudHealth' ] = true,
	[ 'CHudBattery' ] = true,
	[ 'CHudAmmo' ] = true,
	[ 'CHudSecondaryAmmo' ] = true,
	[ 'CHudDamageIndicator' ] = true,
}

hook.Add( 'HUDShouldDraw', 'Hud', function( name )
	if ( DeleteHudElementsList[ name ] ) then
		return false
	end
end )

hook.Add( 'HUDDrawTargetID', 'Hud', function( name )
	return false
end )
