local PANEL = {}

function PANEL:Init()
	self:SetFont( 'Button' )
	self:SetTextColor( DMColor.label_text )
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 8, 0, 0, w, h, self:IsDown() and Color(22, 160, 133) or self:IsHovered() and DMColor.button_hov or DMColor.button )
end

vgui.Register( 'dm_button', PANEL, 'DButton' )
