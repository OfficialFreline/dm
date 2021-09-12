AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )

include( 'shared.lua' )

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	phys:Wake()

	if ( self:Getamount() == 0 ) then
		self:Setamount( 1 )
	end
end

function ENT:DecreaseAmount()
	local amount = self:Getamount() - 1

	self:Setamount( amount )

	if ( amount <= 0 ) then
		self:Remove()
		self.PlayerUse = false
		self.Removed = true
	end
end

function ENT:OnTakeDamage( dmg )
	self:TakePhysicsDamage( dmg )
end

function ENT:Use( activator, caller )
	if ( type( self.PlayerUse ) == 'function' ) then
		local val = self:PlayerUse( activator, caller )

		if ( val != nil ) then
			return val
		end
	elseif ( self.PlayerUse != nil ) then
		return self.PlayerUse
	end

	local class = self:GetWeaponClass()
	local weapon = ents.Create( class )

	if ( not weapon:IsWeapon() ) then
		weapon:SetPos( self:GetPos() )
		weapon:SetAngles( self:GetAngles() )
		weapon:Spawn()
		weapon:Activate()

		self:DecreaseAmount()

		return
	end

	local primaryAmmoType = weapon:GetPrimaryAmmoType()
	local secondaryAmmoType = weapon:GetSecondaryAmmoType()

	weapon:Remove()

	weapon = activator:Give( class, true )

	local clip1, clip2 = self.clip1, self.clip2

	if ( weapon:IsValid() ) then
		if ( clip1 and clip1 != -1 and weapon:Clip1() != -1 ) then
			weapon:SetClip1( clip1 )

			clip1 = 0
		end

		if ( clip2 and clip2 != -1 and weapon:Clip2() != -1 ) then
			weapon:SetClip2( self.clip2 )

			clip2 = 0
		end
	else
		weapon = activator:GetWeapon( class )

		if ( clip2 and clip2 > 0 and weapon:Clip2() != -1 ) then
			weapon:SetClip2( weapon:Clip2() + clip2 )

			clip2 = 0
		end
	end

	if ( primaryAmmoType > 0 ) then
		local primAmmo = activator:GetAmmoCount( primaryAmmoType )

		primAmmo = primAmmo + ( self.ammoadd or 0 ) + ( clip1 or 0 )

		activator:SetAmmo( primAmmo, primaryAmmoType )
	end

	if ( secondaryAmmoType > 0 ) then
		local secAmmo = activator:GetAmmoCount( secondaryAmmoType ) + ( clip2 or 0 )

		activator:SetAmmo( secAmmo, secondaryAmmoType )
	end

	self:DecreaseAmount()
	self:EmitSound( 'items/ammo_pickup.wav' ) -- For a better perception
end

function ENT:StartTouch( ent )
	if ( ent.IsSpawnedWeapon != true or self:GetWeaponClass() != ent:GetWeaponClass() or self.hasMerged or ent.hasMerged ) then
		return
	end

	ent.hasMerged = true
	ent.USED = true

	local selfAmount, entAmount = self:Getamount(), ent:Getamount()
	local totalAmount = selfAmount + entAmount

	self.ammoadd, ent.ammoadd = self.ammoadd or 0, ent.ammoadd or 0
	self.ammoadd = math.floor( ( self.ammoadd * selfAmount + ent.ammoadd * entAmount ) / totalAmount )

	if ( self.clip1 or ent.clip1 ) then
		self.clip1 = math.floor( ( ( self.clip1 or 0 ) * selfAmount + ( ent.clip1 or 0 ) * entAmount ) / totalAmount )
	end

	if ( self.clip2 or ent.clip2 ) then
		self.clip2 = math.floor( ( ( self.clip2 or 0 ) * selfAmount + ( ent.clip2 or 0 ) * entAmount ) / totalAmount )
	end

	self:Setamount( totalAmount )
	
	ent:Remove()
end
