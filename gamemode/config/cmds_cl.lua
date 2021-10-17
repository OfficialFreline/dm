--[[
	AddActionDM( 'Test', function( ply )
		print( 'All a pleasant mood!' )
	end, true, true ) -- The first bool - for the admin panel or not, the second - for the local player (for the team activator) or not.
]]--

AddActionDM( LANG.GetTranslation( 'openSteam' ), function( ply )
	ply:ShowProfile()
end )

AddActionDM( LANG.GetTranslation( 'copySteamID' ), function( ply )
	local txt = ply:SteamID()

	textCopy( txt )
end )

AddActionDM( LANG.GetTranslation( 'copyPos' ), function( ply )
	local txt = ( 'Vector( %s )' ):format( string.gsub( tostring( ply:GetPos() ), ' ', ', ' ) )

	textCopy( txt )
end )

local x = LANG.GetTranslation( 'changeNick' )

AddActionDM( x, function( ply )
	Derma_StringRequest( x, 'Enter the name of the future nickname', '', function( s )
		if ( string.len( s ) > 30 ) then
			ChatText( 'Nick is too big!' )

			return
		elseif ( string.len( s ) <= 2 ) then
			ChatText( 'Nick is too small!' )

			return
		end

		RunConsoleCommand( 'dm_setnick', s )
	end )
end, false, true )

AddActionDM( LANG.GetTranslation( 'dataUpdate' ), function( ply )
	RunConsoleCommand( 'dm_checkdata' )
end, false, true )

local x = LANG.GetTranslation( 'sendMsg' )

AddActionDM( x, function( ply )
	Derma_StringRequest( x, 'Enter your message text', '', function( s )
		if ( string.len( s ) > 35 ) then
			ChatText( 'The message is too big!' )

			return
		elseif ( string.len( s ) <= 0 ) then
			ChatText( 'The message is empty!' )

			return
		end

		if ( LocalPlayer() != ply ) then
			net.Start( 'Pm' )
				net.WriteEntity( ply )
				net.WriteString( s )
			net.SendToServer( ply )

			chat.AddText( Color( 215, 125, 60 ), '(PM) ', Color( 85, 130, 158 ), LANG.GetTranslation( 'you' ), Color( 255, 255, 255 ), '->', Color( 85, 130, 158 ), ply:GetNick(), Color( 255, 255, 255 ), ': ' .. s )
		else
			chat.AddText( Color( 215, 125, 60 ), '(PM) ', Color( 85, 130, 158 ), 'To myself', Color( 255, 255, 255 ), ': ' .. s )
		end
	end )
end )

AddActionDM( LANG.GetTranslation( 'dropWeapon' ), function( ply )
	local wep = LocalPlayer():GetActiveWeapon()

	if ( not IsValid( wep ) ) then
		ChatText( "You don't have a gun on you!" )

		return
	end

	RunConsoleCommand( 'dm_dropswep', wep:GetClass() )
end, false, true )

AddActionDM( LANG.GetTranslation( 'adminAdd' ), function( ply )
	RunConsoleCommand( 'dm_setrank', ply:SteamID64(), 'admin' )
end, true, false )

AddActionDM( LANG.GetTranslation( 'adminRemove' ), function( ply )
	RunConsoleCommand( 'dm_setrank', ply:SteamID64(), 'user' )
end, true, false )

AddActionDM( LANG.GetTranslation( 'setHP' ), function( ply )
	local DM = DermaMenu()

	local tabl_hp = {
		15,
		25,
		50,
		75,
		100,
	}

	for x, c in ipairs( tabl_hp ) do
		DM:AddOption( c .. '%', function()
			RunConsoleCommand( 'dm_sethp', ply:SteamID64(), c )
		end )	
	end

	DM:Open()
end, true, false )

AddActionDM( LANG.GetTranslation( 'killSelf' ), function( ply )
	RunConsoleCommand( 'kill' )
end, false, true )

AddActionDM( LANG.GetTranslation( 'changeSize' ), function( ply )
	local DM = DermaMenu()

	DM:AddOption( 'Standart', function()
		net.Start( 'DMAdminSetScale' )
			net.WriteFloat( 1.0 )
			net.WriteEntity( ply )
		net.SendToServer()
	end )

	DM:AddOption( '0.5', function()
		net.Start( 'DMAdminSetScale' )
			net.WriteFloat( 0.5 )
			net.WriteEntity( ply )
		net.SendToServer()
	end )

	DM:AddOption( '1.5', function()
		net.Start( 'DMAdminSetScale' )
			net.WriteFloat( 1.5 )
			net.WriteEntity( ply )
		net.SendToServer()
	end )

	DM:Open()
end, true, false )

AddActionDM( LANG.GetTranslation( 'changeLanguage' ), function( ply )
	local DM = DermaMenu()

	for k, v in ipairs( LANG.GetLanguages() ) do
		DM:AddOption( v, function()
			RunConsoleCommand( 'dm_language', v )
		end )
	end

	DM:Open()
end, false, true )
