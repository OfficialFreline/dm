if ( CLIENT ) then
	hook.Add( 'ChatText', 'Chat', function( index, name, text, type )
		if ( type == 'joinleave' ) then
			return true
		end
	end )

	net.Receive( 'NetConnPly', function( len, pl )
		local name = net.ReadString()

		chat.AddText( Color( 15, 170, 235 ), name, Color( 255, 255, 255 ), ' ' .. DM.Translate( 'ConnPly', true ) )
		chat.PlaySound()
	end )

	net.Receive( 'NetDiscPly', function( len, pl )
		local ply = net.ReadEntity()

		chat.AddText( Color( 15, 170, 235 ), ply:Nick() .. ' (' .. ply:SteamID() .. ')', Color( 255, 255, 255 ), ' ' .. DM.Translate( 'DiscPly', true ) )
		chat.PlaySound()
	end )

	net.Receive( 'PmMsg', function( len, pl )
		local pl = net.ReadEntity()
		local text = net.ReadString()

		chat.AddText( Color( 215, 125, 60 ), '(PM) ', Color( 85, 130, 158 ), pl:GetNWString( 'ply_name' ), Color( 255, 255, 255 ), '->', Color( 85, 130, 158 ), DM.Translate( 'You', true ), Color( 255, 255, 255 ), ': ' .. text )
		chat.PlaySound()
	end )

	net.Receive( 'PlayerChangeNickMsg', function( len, pl )
		local nick = net.ReadString()
		local ply = net.ReadEntity()

		chat.AddText( Color( 15, 170, 235 ), ply:GetNWString( 'ply_name' ), Color( 255, 255, 255 ), ' changed his nickname to ', Color( 70, 162, 112 ), nick, Color( 255, 255, 255 ), '.' )
		chat.PlaySound()
	end )

	function ChatText( text )
		chat.AddText( Color( 85, 78, 164 ), '<> ', Color( 255, 255, 255 ), text )
		chat.PlaySound()
	end

	function ChatTextAdmin( text )
		chat.AddText( Color( 222, 84, 84 ), '| ', Color( 255, 255, 255 ), text )
		chat.PlaySound()
	end
end

if ( SERVER ) then
	util.AddNetworkString( 'NetConnPly' )
	util.AddNetworkString( 'NetDiscPly' )
	util.AddNetworkString( 'Pm' )
	util.AddNetworkString( 'PmMsg' )
	util.AddNetworkString( 'PlayerChangeNickMsg' )

	net.Receive( 'Pm', function( len, pl )
		local target = net.ReadEntity()
		local text = net.ReadString()

		net.Start( 'PmMsg' )
			net.WriteEntity( pl )
			net.WriteString( text )
		net.Send( target )
	end )
end

hook.Add( 'PlayerConnect', 'ChatPly', function( name, ip )
	net.Start( 'NetConnPly' )
		net.WriteString( name )
	net.Broadcast()
end )

hook.Add( 'PlayerDisconnected', 'ChatPly', function( ply )
	net.Start( 'NetDiscPly' )
		net.WriteEntity( ply )
	net.Broadcast()
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
