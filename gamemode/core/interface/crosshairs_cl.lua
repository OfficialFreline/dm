local scrw, scrh = ScrW(), ScrH()
local color_white = Color(255,255,255)
local color_black = Color(0,0,0)

hook.Add( 'HUDPaint', 'Cross', function()
	local cr = GetConVar( 'crosshair_dm' ):GetInt()

	if ( cr == 1 ) then
		draw.RoundedBox( 8, scrw * 0.5 - 2, scrh * 0.5 - 2, 4, 4, color_black )
		draw.RoundedBox( 8, scrw * 0.5 - 1, scrh * 0.5 - 1, 2, 2, color_white )
	elseif ( cr == 2 ) then
		draw.RoundedBox( 8, scrw * 0.5 - 14, scrh * 0.5 - 1, 10, 2, color_white ) -- left
		draw.RoundedBox( 8, scrw * 0.5 + 4, scrh * 0.5 - 1, 10, 2, color_white ) -- right
		draw.RoundedBox( 8, scrw * 0.5 - 1, scrh * 0.5 - 14, 2, 10, color_white ) -- top
		draw.RoundedBox( 8, scrw * 0.5 - 1, scrh * 0.5 + 4, 2, 10, color_white ) -- bottom
	end
end )

hook.Add( 'HUDShouldDraw', 'Cross', function( name )
	if ( name == 'CHudCrosshair' and GetConVar( 'crosshair_dm' ):GetInt() != 0 ) then
		return false
	end
end )
