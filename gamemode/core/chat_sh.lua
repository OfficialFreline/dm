local color_white = Color( 255, 255, 255 )

if ( CLIENT ) then
	hook.Add( 'ChatText', 'Chat', function( index, name, text, type )
		if ( type == 'joinleave' ) then
			return true
		end
	end )

	net.Receive( 'dmText', function( len, ply )
		local tabl = net.ReadTable()

		-- PrintTable( tabl )

		chat.AddText( unpack( tabl ) )
		chat.PlaySound()
	end )

	function ChatText( text )
		chat.AddText( Color( 85, 78, 164 ), '<> ', color_white, text )
		chat.PlaySound()
	end

	function ChatTextAdmin( text )
		chat.AddText( Color( 222, 84, 84 ), '| ', color_white, text )
		chat.PlaySound()
	end

	function GM:OnPlayerChat( ply, strText, bTeamOnly, bPlayerIsDead )
		local ct = {}
		
		if ( bPlayerIsDead ) then
			table.insert( ct, Color( 240, 66, 75 ) )
			table.insert( ct, '(Dead) ' )
		end
	
		if ( IsValid( ply ) ) then
			if ( ply:Admin() ) then
				table.insert( ct, Color( 174, 82, 245 ) )
				table.insert( ct, 'Admin | ' )
			end

			table.insert( ct, Color( 85, 178, 232 ) )
			table.insert( ct, ply:GetNick() )
		else
			table.insert( ct, 'Console' )
		end
	
		table.insert( ct, color_white )
		table.insert( ct, ': ' .. strText )
		
		chat.AddText( unpack( ct ) )
	
		return true
	end
end

if ( SERVER ) then
	util.AddNetworkString( 'dmText' )
	util.AddNetworkString( 'Pm' )

	net.Receive( 'Pm', function( len, pl )
		local target = net.ReadEntity()
		local text = net.ReadString()

		sendMsg( target, Color( 215, 125, 60 ), '(PM) ', Color( 85, 130, 158 ), pl:GetNick(), color_white, '->', Color( 85, 130, 158 ), DM.Translate( 'You', true ), color_white, ': ' .. text )
	end )

	function sendMsg( player, ... )
		local tbl = { ... }
		
		net.Start( 'dmText' )
			net.WriteTable( tbl )
		net.Send( player )
	end

	function sendMsgAll( ... )
		local tbl = { ... }

		net.Start( 'dmText' )
			net.WriteTable( tbl )
		net.Broadcast()
	end
end

hook.Add( 'PlayerConnect', 'ChatPly', function( name, ip )
	sendMsgAll( Color( 15, 170, 235 ), name, color_white, ' ' .. DM.Translate( 'ConnPly', true ) )
end )

hook.Add( 'PlayerDisconnected', 'ChatPly', function( ply )
	sendMsgAll( Color( 15, 170, 235 ), ply:GetNick() .. ' (' .. ply:SteamID() .. ')', color_white, ' ' .. DM.Translate( 'DiscPly', true ) )
end )

local OldData

timer.Create( 'TimeConsoleTime', 0.5, 0, function()
	if ( player.GetAll() != 0 ) then
		local NewData = os.date( ' %H:%M ' )

		if ( NewData != OldData ) then
			MsgC( Color( 200, 200, 200 ), ( '=' ):rep( 30 ) .. NewData .. ( '=' ):rep( 30 ) .. '\n' )

			OldData = NewData
		end
	end
end )
