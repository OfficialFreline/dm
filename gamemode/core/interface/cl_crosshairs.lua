--[[
	In the future, a large crosshair customization system is planned.

	A great utility for creating your own crosshair online in the game + an already created list of crosshairs that are in the form of materials
]]--

hook.Add( 'HUDPaint', 'Cross', function()
	local cr = GetConVar( 'crosshair_dm' ):GetInt()

	if ( cr == 1 ) then
		draw.RoundedBox( 8, ScrW() * 0.5 - 2, ScrH() * 0.5 - 2, 4, 4, Color(0,0,0) )
		draw.RoundedBox( 8, ScrW() * 0.5 - 1, ScrH() * 0.5 - 1, 2, 2, Color(255,255,255) )
	elseif ( cr == 2 ) then
		draw.RoundedBox( 8, ScrW() * 0.5 - 14, ScrH() * 0.5 - 1, 10, 2, Color(255,255,255) ) -- left
		draw.RoundedBox( 8, ScrW() * 0.5 + 4, ScrH() * 0.5 - 1, 10, 2, Color(255,255,255) ) -- right
		draw.RoundedBox( 8, ScrW() * 0.5 - 1, ScrH() * 0.5 - 14, 2, 10, Color(255,255,255) ) -- top
		draw.RoundedBox( 8, ScrW() * 0.5 - 1, ScrH() * 0.5 + 4, 2, 10, Color(255,255,255) ) -- bottom
	end
end )

hook.Add( 'HUDShouldDraw', 'Cross', function( name )
	if ( name == 'CHudCrosshair' and GetConVar( 'crosshair_dm' ):GetInt() != 0 ) then
		return false
	end
end )
