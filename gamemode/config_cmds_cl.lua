DMCommandsTable = {
	{
		name = 'Back to the list of players',
		action = function( ply )
			menuTab:Remove()

			openTab()
		end,
	},
	{
		name = 'Open Steam',
		action = function( ply )
			ply:ShowProfile()
		end,
	},
	{
		name = 'Copy SteamID',
		action = function( ply )
			local txt = ply:SteamID()

			SetClipboardText( txt )

			ChatText( 'Copied: ' .. txt )
		end,
	},
	{
		name = 'Copy the position of the player vector',
		action = function( ply )
			local txt = ( 'Vector( %s )' ):format( string.gsub( tostring( ply:GetPos() ), ' ', ', ' ) )

			SetClipboardText( txt )

			ChatText( 'Copied: ' .. txt )
		end,
	},
	{
		name = 'Change nickname',
		action = function( ply )
	    	Derma_StringRequest( 'Change nickname', 'Enter the name of the future nickname', '', function( s )
	    		if ( string.len( s ) > 30 ) then
	    			ChatText( 'Nick is too big!' )

	    			return
	    		elseif ( string.len( s ) <= 2 ) then
		    		ChatText( 'Nick is too small!' )

		    		return
		    	end

				net.Start( 'PlayerChangeNick' )
					net.WriteString( s )
				net.SendToServer()
	    	end )
		end,
		localplayer = true,
	},
	{
		name = 'Update your database',
		action = function( ply )
			net.Start( 'PlayerCheckData' )
			net.SendToServer()

			ChatTextAdmin( 'Your details have been updated!' )
		end,
		localplayer = true,
	},
	{
		name = 'Send private message',
		action = function( ply )
	    	Derma_StringRequest( 'Send private message', 'Enter your message text', '', function( s )
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

					chat.AddText( Color( 215, 125, 60 ), '(PM) ', Color( 85, 130, 158 ), DM.Translate( 'You', true ), Color( 255, 255, 255 ), '->', Color( 85, 130, 158 ), ply:GetNWString( 'ply_name' ), Color( 255, 255, 255 ), ': ' .. s )
				else
					chat.AddText( Color( 215, 125, 60 ), '(PM) ', Color( 85, 130, 158 ), 'To myself', Color( 255, 255, 255 ), ': ' .. s )
				end
	    	end )
		end,
	},
	{
		name = 'Throw away the taken weapon',
		action = function( ply )
			net.Start( 'Dweapon' )
			net.SendToServer()
		end,
		localplayer = true,
	},
	{
		name = 'Issue admin panel',
		action = function( ply )
			net.Start( 'DmAdminSetAdmin' )
				net.WriteEntity( ply )
			net.SendToServer()
		end,
		admin = true,
	},
	{
		name = 'Remove admin panel',
		action = function( ply )
			net.Start( 'DmAdminRemoveAdmin' )
				net.WriteEntity( ply )
			net.SendToServer()
		end,
		admin = true,
	},
	{
		name = 'Install HP',
		action = function( ply )
			local DM = DermaMenu()

			DM:AddOption( '15%', function()
				net.Start( 'DmAdminSetHP' )
					net.WriteEntity( ply )
					net.WriteString( 15 )
				net.SendToServer()
			end )

			DM:AddOption( '50%', function()
				net.Start( 'DmAdminSetHP' )
					net.WriteEntity( ply )
					net.WriteString( 50 )
				net.SendToServer()
			end )

			DM:AddOption( '100%', function()
				net.Start( 'DmAdminSetHP' )
					net.WriteEntity( ply )
					net.WriteString( 100 )
				net.SendToServer()
			end )

			DM:Open()
		end,
		admin = true,
	},
	{
		name = 'Change model',
		action = function( ply )
			local menu = vgui.Create( 'dm_frame' )
			menu:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
			menu:Center()
			menu:MakePopup()
			menu:SetTitle( 'Model selection' )

			local browser = vgui.Create( 'DFileBrowser', menu )
			browser:Dock( FILL )
			browser:SetPath( 'GAME' )
			browser:SetBaseFolder( 'models' )
			browser:SetName( 'Available' )
			browser:SetFileTypes( '*.mdl' )
			browser:SetOpen( true )
			browser:SetModels( true )

			function browser:OnSelect( path, pnl )
				net.Start( 'DMAdminEditModel' )
					net.WriteString( path )
					net.WriteEntity( ply )
				net.SendToServer()

				menu:Close()
			end
		end,
		admin = true,
	},
}
