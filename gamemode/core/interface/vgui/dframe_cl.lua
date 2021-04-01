local PANEL = {}

-- function PANEL:Init()
-- 	self.newTitle = vgui.Create( 'DLabel', self )
-- 	self.newTitle:SetText( '' )
-- end

-- function PANEL:SetNewTitle( name )
-- 	self.newTitle:SetText( name )
-- end

function PANEL:Paint( w, h )
	draw.Blur( self )
	draw.OutlinedBox( 0, 0, w, h, Color( 75, 75, 75, 245 ), Color( 0, 0, 0 ) ) -- Background
	draw.OutlinedBox( 0, 0, w, 24, Color( 125, 125, 125 ), Color( 0, 0, 0 ) ) -- Bar
end

-- function PANEL:PerformLayout()
-- 	surface.SetFont( 'Default' )

-- 	local s = surface.GetTextSize( self.newTitle:GetText() )

-- 	self.newTitle:SetSize( s, 24 )
-- 	self.newTitle:SetPos( self:GetWide() * 0.5 - self.newTitle:GetWide() * 0.5, 0 )
-- end

vgui.Register( 'dm_frame', PANEL, 'DFrame' )
