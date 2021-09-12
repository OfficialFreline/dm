local PANEL = {}

function PANEL:Init()
	self.VBar:SetWide( 12 )
	self.VBar:SetHideButtons( true )
	self.VBar.Paint = nil
	self.VBar.btnGrip.Paint = function( self, w, h )
		draw.RoundedBox( 0, 4, 4, w - 8, h - 8, self.Depressed and DMColor.sp_hov or DMColor.sp )
	end
end

vgui.Register( 'dm_scrollpanel', PANEL, 'DScrollPanel' )
