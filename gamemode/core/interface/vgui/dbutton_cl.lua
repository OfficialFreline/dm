local PANEL = {}

function PANEL:Paint( w, h )
	if ( self:IsHovered() ) then
		draw.RoundedBox( 4, 3, 3, w - 6, h - 6, Color( 115, 115, 115, 200 ) )
	else
		draw.RoundedBox( 4, 0, 0, w, h, Color( 115, 115, 115, 200 ) )
		draw.OutlinedBox( 3, 3, w - 6, h - 6, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 50 ) )
	end
end

vgui.Register( 'dm_button', PANEL, 'DButton' )
