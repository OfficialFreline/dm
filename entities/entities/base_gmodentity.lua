AddCSLuaFile()

DEFINE_BASECLASS( 'base_anim' )

ENT.Spawnable = false

if ( CLIENT ) then
	ENT.MaxWorldTipDistance = 256

	function ENT:BeingLookedAtByLocalPlayer()
		local ply = LocalPlayer()

		if ( not IsValid( ply ) ) then
			return false
		end

		local view = ply:GetViewEntity()
		local dist = self.MaxWorldTipDistance

		dist = dist * dist

		if ( view:IsPlayer() ) then
			return view:EyePos():DistToSqr( self:GetPos() ) <= dist and view:GetEyeTrace().Entity == self
		end

		local pos = view:GetPos()

		if ( pos:DistToSqr( self:GetPos() ) <= dist ) then
			return util.TraceLine( {
				start = pos,
				endpos = pos + view:GetAngles():Forward() * dist,
				filter = view,
			} ).Entity == self
		end

		return false
	end
end

function ENT:SetOverlayText( text )
	self:SetNWString( 'GModOverlayText', text )
end

function ENT:GetOverlayText()
	local txt = self:GetNWString( 'GModOverlayText' )

	if ( txt == '' ) then
		return ''
	end

	if ( game.SinglePlayer() ) then
		return txt
	end

	local PlayerName = self:GetPlayerName()

	return txt .. ' (' .. PlayerName .. ')'
end

function ENT:SetPlayer( ply )
	if ( IsValid( ply ) ) then
		self:SetVar( 'Founder', ply )
		self:SetVar( 'FounderIndex', ply:UniqueID() )

		self:SetNWString( 'FounderName', ply:GetNick() )
	end
end

function ENT:GetPlayer()
	return self:GetVar( 'Founder', NULL )
end

function ENT:GetPlayerIndex()
	return self:GetVar( 'FounderIndex', 0 )
end

function ENT:GetPlayerName()
	local ply = self:GetPlayer()

	if ( IsValid( ply ) ) then
		return ply:GetNick()
	end

	return self:GetNWString( 'FounderName' )
end
