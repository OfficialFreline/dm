local PANEL = {}

function PANEL:Paint( w, h )
	if ( self:IsHovered() ) then
		draw.RoundedBox( 4, 3, 3, w - 6, h - 6, Color( 115, 115, 115, 200 ) )
	else
		draw.OutlinedBox( 3, 3, w - 6, h - 6, Color( 0, 0, 0, 0 ), Color( 255, 255, 255, 50 ) )
	end
end

vgui.Register( 'dm_button', PANEL, 'DButton' )
