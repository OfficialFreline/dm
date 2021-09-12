local length = 0.5
local ease = 0.25
local amount = 55

local function sign( num )
	return num > 0
end

local function getBiggerPos( signOld, signNew, old, new )
	if ( signOld != signNew ) then
		return new
	end

	if ( signNew ) then
		return math.max( old, new )
	else
		return math.min( old, new )
	end
end

local dermaCtrs = vgui.GetControlTable( 'DVScrollBar' )

local tScroll = 0
local newerT = 0

function dermaCtrs:AddScroll( dlta )
	self.Old_Pos = nil
	self.Old_Sign = nil

	local OldScroll = self:GetScroll()

	dlta = dlta * amount

	local anim = self:NewAnimation( length, 0, ease )
	anim.StartPos = OldScroll
	anim.TargetPos = OldScroll + dlta + tScroll

	tScroll = tScroll + dlta
	
	local ctime = RealTime()
	local doing_scroll = true

	newerT = ctime

	anim.Think = function( anim, pnl, fraction )
		local nowpos = Lerp( fraction, anim.StartPos, anim.TargetPos )

		if ( ctime == newerT ) then
			self:SetScroll( getBiggerPos( self.Old_Sign, sign( dlta ), self.Old_Pos, nowpos ) )

			tScroll = tScroll - ( tScroll * fraction )
		end

		if ( doing_scroll ) then
			self.Old_Sign = sign( dlta )
			self.Old_Pos = nowpos
		end

		if ( ctime != newerT ) then
			doing_scroll = false
		end
	end

	return math.Clamp( self:GetScroll() + tScroll, 0, self.CanvasSize ) != self:GetScroll()

end

derma.DefineControl( 'DVScrollBar', '', dermaCtrs, 'Panel' )
