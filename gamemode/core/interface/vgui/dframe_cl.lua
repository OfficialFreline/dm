local PANEL = {}

function PANEL:Paint( w, h )
	draw.Blur( self )
	draw.OutlinedBox( 0, 0, w, h, DMColor.frame_background, DMColor.frame_outlined ) -- Background
	draw.OutlinedBox( 0, 0, w, 24, DMColor.frame_bar, DMColor.frame_outlined ) -- Bar
end

vgui.Register( 'dm_frame', PANEL, 'DFrame' )
