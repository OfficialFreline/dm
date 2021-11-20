local PANEL = {}

function PANEL:Init()
	self:SetFont( 'Button' )
	self:SetTextColor( DMColor.label_text )
end

function PANEL:Paint( w, h )
	local r = self:IsDown() and 1 or 0

	draw.RoundedBox( 8, r, r, w - r * 2, h - r * 2, ( self:IsDown() or self.Depr ) and Color(22, 160, 133) or self:IsHovered() and DMColor.button_hov or DMColor.button )
end

vgui.Register( 'dm_button', PANEL, 'DButton' )
