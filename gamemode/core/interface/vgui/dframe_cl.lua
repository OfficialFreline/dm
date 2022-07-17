local PANEL = {}
local color_white = Color(255,255,255)

function PANEL:Init()
	self:DockPadding( 6, 36, 6, 6 )
	self:ShowCloseButton( false )
	self:SetTitle( '' )

	self.Title = vgui.Create( 'DPanel', self )
	self.Title.text = 'Window'
	self.Title.Paint = function( self, w, h )
		draw.OutlinedBox( 0, 0, w, h, DMColor.frame_bar, DMColor.frame_outlined )
		draw.SimpleText( self.text, 'Frame', w * 0.5, h * 0.5, color_white, 1, 1 )
	end

	self.Close = vgui.Create( 'dm_button', self.Title )
	self.Close:SetText( '' )
	self.Close.DoClick = function()
		self:Remove()
	end
end

function PANEL:Paint( w, h )
	draw.Blur( self )
	draw.OutlinedBox( 0, 0, w, h, DMColor.frame_background, DMColor.frame_outlined )
end

function PANEL:PerformLayout( w, h )
	self.Title:SetSize( w, 30 )

	self.Close:Dock( RIGHT )
	self.Close:SetWide( 18 )
	self.Close:DockMargin( 0, 6, 6, 6 )
end

function PANEL:CloseButton( bool )
	self.Close:SetVisible( bool )
end

function PANEL:title( name )
	print(name)
	self.Title.text = name
end

vgui.Register( 'dm_frame', PANEL, 'DFrame' )
