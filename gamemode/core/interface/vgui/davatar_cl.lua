local color_white = Color(255,255,255)
local mat = Material( 'effects/flashlight001' )

local function MakeCirclePoly( _x, _y, _r, _points )
	local _u = ( _x + _r * 320 ) - _x
	local _v = ( _y + _r * 320 ) - _y
 
	local _slices = ( 2 * math.pi ) / _points
	local _poly = { }

	for i = 0, _points - 1 do
		local _angle = ( _slices * i ) % _points
		local x = _x + _r * math.cos( _angle )
		local y = _y + _r * math.sin( _angle )

		table.insert( _poly, { x = x, y = y, u = _u, v = _v } )
	end
 
	return _poly;
end

local PANEL = {}
 
function PANEL:Init()
	self.Avatar = vgui.Create( 'AvatarImage', self )
	self.Avatar:SetPaintedManually( true )

	self:OnSizeChanged( self:GetWide(), self:GetTall() )
end
 
function PANEL:PerformLayout()
	self:OnSizeChanged( self:GetWide(), self:GetTall() )
end
 
function PANEL:SetSteamID( id )
	self.Avatar:SetSteamID( id )
end
 
function PANEL:SetPlayer( ply )
	self.Avatar:SetPlayer( ply )
end
 
function PANEL:OnSizeChanged( w, h )
	self.Avatar:SetSize( self:GetWide(), self:GetTall() )

	self.points = math.Max( ( self:GetWide() * 0.25 ), 32 )
	self.poly = MakeCirclePoly( self:GetWide() * 0.5, self:GetTall() * 0.5, self:GetWide() * 0.5, self.points )
end
 
function PANEL:DrawMask( w, h )
	draw.NoTexture()

	surface.SetMaterial( mat )
	surface.SetDrawColor( color_white )
	surface.DrawPoly( self.poly )
end
 
function PANEL:Paint( w, h )
	render.ClearStencil()
	render.SetStencilEnable( true )

	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )
 
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilReferenceValue( 1 )
 
	self:DrawMask( w, h )
 
	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue( 1 )
 
	self.Avatar:SetPaintedManually( false )
	self.Avatar:PaintManual()
	self.Avatar:SetPaintedManually( true )
 
	render.SetStencilEnable( false )
	render.ClearStencil()
end
 
vgui.Register( 'dm_avatar', PANEL )
