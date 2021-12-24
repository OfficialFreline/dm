local PLAYER = FindMetaTable( 'Player' )

function PLAYER:Admin()
	return ( self:GetRank() == 'admin' or self:IsSuperAdmin() or self:IsAdmin() )
end

if ( SERVER ) then
	function GM:PlayerNoClip( ply, desiredState )
		if ( desiredState == false ) then
			return true
		elseif ( ply:Admin() ) then
			return true
		end
	end

	function GM:PhysgunPickup( ply, ent )
		if ( ply:Admin() ) then
			return true
		end
	end
end
