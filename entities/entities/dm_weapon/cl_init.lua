include( 'shared.lua' )

surface.CreateFont( 'EntFont', {
	size = 54,
	weight = 700,
	antialias = true,
	extended = true,
	font = 'Arial',
} )

local color_black = Color(0,0,0)
local color_white = Color(255,255,255)

local function drawEntText( pos, ang, text )
	cam.Start3D2D( pos, ang, 0.1 )
		draw.SimpleTextOutlined( text, 'EntFont', 0, -180, color_white, TEXT_ALIGN_CENTER, nil, 1, color_black )
	cam.End3D2D()
end

local ang = Angle( 0, 0, 90 )

function ENT:Draw()
	if ( LocalPlayer():GetPos():Distance( self:GetPos() ) > 1000 ) then
		return
	end

	ang.y = -180 * math.Remap( CurTime() % 3, 0, 3, 0, 1 )

	self:DrawModel()

	local pos = self:GetPos()
	local name = self:GetOverlayText()

	drawEntText( pos, ang, name )

	ang:RotateAroundAxis( ang:Right(), 180 )

	drawEntText( pos,ang, name ) -- For viewing from the other side
end
