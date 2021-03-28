function GMopenTab()
	menuTab = vgui.Create( 'DPanel' )
	menuTab:SetSize( ScrW() * 0.6, ScrH() * 0.7 )
	menuTab:Center()
	menuTab:MakePopup()
	menuTab:SetKeyBoardInputEnabled( false )
	menuTab.Paint = function( self, w, h )
		draw.OutlinedBox( 0, 0, w, h, Color( 75, 75, 75, 245 ), Color( 0, 0, 0 ) ) -- Background
		draw.OutlinedBox( 0, 0, w, 70, Color( 125, 125, 125 ), Color( 0, 0, 0 ) ) -- Bar
	end

	local Title = 'Deathmatch'

	surface.SetFont( 'Tab.1' )

	local TitleLabel = vgui.Create( 'DLabel', menuTab )
	TitleLabel:SetPos( menuTab:GetWide() * 0.5 - surface.GetTextSize( Title ) * 0.5, 10 )
	TitleLabel:SetSize( menuTab:GetWide(), 50 )
	TitleLabel:SetText( Title )
	TitleLabel:SetFont( 'Tab.1' )

	local sp = vgui.Create( 'dm_scrollpanel', menuTab )
	sp:Dock( FILL )
	sp:DockMargin( 10, 80, 10, 10 )
	-- sp:GetVBar():SetWide( 0 )
	sp.Paint = function( self, w, h )
		draw.Blur( self )
	end

	surface.SetFont( 'Tab.2' )

	local infoButton = vgui.Create( 'DButton', sp )
	infoButton:SetTall( 30 )
	infoButton:Dock( TOP )
	infoButton:SetText( '' )
	infoButton.Paint = function( self, w, h )
		draw.SimpleText( 'Nick', 'Tab.2', 10, 0, Color( 255, 255, 255 ) )
		draw.SimpleText( 'Ping', 'Tab.2', w - surface.GetTextSize( 'Ping' ) - 10, 0, Color( 255, 255, 255 ) )
		draw.SimpleText( 'KD (Kills/Deaths)', 'Tab.2', w * 0.5 - surface.GetTextSize( 'KD (Kills/Deaths)' ) * 0.5, 0, Color( 255, 255, 255 ) )
	end

	surface.SetFont( 'Tab.3' )

	for k, v in pairs( player.GetAll() ) do
		local playerAvatar
		local playerAvatarButton

		local playerButton = vgui.Create( 'DButton', sp )
		playerButton:SetTall( 40 )
		playerButton:Dock( TOP )
		playerButton:DockMargin( 0, 5, 0, 0 )
		playerButton:SetText( '' )
		playerButton.Paint = function( self, w, h )
			if ( IsValid( v ) ) then
				local x
				local textColor = Color( 255, 255, 255 )

				if ( self:IsHovered() or playerAvatarButton:IsHovered() ) then
					draw.RoundedBox( 4, 3, 3, w - 6, h - 6, Color( 115, 115, 115, 200 ) )

					textColor = Color( 235, 235, 235 )

					playerAvatar:SetVisible( true )

					x = 30
				else
					draw.RoundedBox( 4, 0, 0, w, h, Color( 115, 115, 115, 200 ) )
					draw.OutlinedBox( 3, 3, w - 6, h - 6, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 50 ) )

					playerAvatar:SetVisible( false )

					x = 0
				end

				local name = v:GetNWString( 'ply_name' )

				if ( name == nil ) then
					name = v:Name()
				end

				draw.SimpleText( name, 'Tab.3', 12 + x, 11, textColor )
				draw.SimpleText( v:Ping() or '', 'Tab.3', w - surface.GetTextSize( v:Ping() or '' ) - 12, 11, textColor )

				local frags = v:GetNWString( 'ply_frags' )
				local deaths = v:GetNWString( 'ply_deaths' )

				if ( deaths < 1 ) then
					deaths = 1
				end

				local text = frags / deaths .. ' (' .. frags .. '/' .. deaths .. ')' or ''

				draw.SimpleText( text, 'Tab.3', w * 0.5 - surface.GetTextSize( text ) * 0.5, 11, textColor )
			end
		end
		playerButton.DoClick = function()
			surface.PlaySound( 'UI/buttonclickrelease.wav' )

			menuTab:Clear()

			surface.SetFont( 'Tab.1' )

			local PlayerLabel = vgui.Create( 'DLabel', menuTab )
			PlayerLabel:SetPos( menuTab:GetWide() * 0.5 - surface.GetTextSize( v:GetNWString( 'ply_name' ) or '' ) * 0.5, 11 )
			PlayerLabel:SetSize( menuTab:GetWide(), 50 )
			PlayerLabel:SetText( v:GetNWString( 'ply_name' ) )
			PlayerLabel:SetFont( 'Tab.1' )

			local globalPanel = vgui.Create( 'DPanel', menuTab )
			globalPanel:Dock( FILL )
			globalPanel:DockMargin( 10, 80, 10, 10 )
			globalPanel.Paint = function( self, w, h )
				draw.Blur( self )
			end

			local w = menuTab:GetWide() - 20

			local playerPrev_panel = vgui.Create( 'DPanel', globalPanel )
			playerPrev_panel:Dock( LEFT )
			playerPrev_panel:SetWide( w / 2.6 )
			playerPrev_panel.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
			end

			local playerPrev = vgui.Create( 'DModelPanel', playerPrev_panel )
			playerPrev:Dock( FILL )
			playerPrev:SetModel( v:GetModel() or 'models/player/alyx.mdl' )
			playerPrev:SetFOV( 32 )

			local playerPrev_panel2 = vgui.Create( 'DPanel', playerPrev )
			playerPrev_panel2:Dock( FILL )
			playerPrev_panel2.Paint = function( self, w, h )
				draw.OutlinedBox( 0, 0, w, h, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 150 ) )
			end

			local scrollpanel = vgui.Create( 'dm_scrollpanel', globalPanel )
			scrollpanel:Dock( RIGHT )
			scrollpanel:SetWide( w - playerPrev_panel:GetWide() - 10 )

			local firstk = true

			for l, n in pairs( DMCommandsTable ) do
				if ( n.localplayer and v == LocalPlayer() or not n.localplayer ) then
					cmdButton = vgui.Create( 'dm_button', scrollpanel )
					cmdButton:Dock( TOP )

					if ( not firstk ) then
						cmdButton:DockMargin( 0, 5, 0, 0 )
					else
						firstk = not firstk
					end
					
					cmdButton:SetTall( 40 )

					if ( n.admin ) then
						cmdButton:SetText( '[' .. DM.Translate( 'Admin', true ) .. '] ' .. n.name )
					else
						cmdButton:SetText( n.name )
					end
					
					cmdButton:SetFont( 'Tab.3' )
					cmdButton:SetTextColor( Color( 255, 255, 255 ) )
					cmdButton.DoClick = function()
						surface.PlaySound( 'UI/buttonclickrelease.wav' )

						if ( n.admin ) then
							if ( LocalPlayer():Admin() ) then
								n.action( v )
							else
								ChatTextAdmin( DM.Translate( 'NotAdmin', true ) )
							end
						else
							n.action( v )
						end
					end
				end
			end
		end

		playerAvatar = vgui.Create( 'AvatarImage', playerButton )
		playerAvatar:SetSize( 28, 28 )
		playerAvatar:SetPos( 6, 6 )
		playerAvatar:SetPlayer( v )

		playerAvatarButton = vgui.Create( 'dm_button', playerAvatar )
		playerAvatarButton:Dock( FILL )
		playerAvatarButton:SetText( '' )
		playerAvatarButton.Paint = function( self, w, h )
			if ( self:IsHovered() ) then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 30 ) )
			end
		end
		playerAvatarButton.DoClick = function()
			local DM = DermaMenu()
			local steamid = v:SteamID()
			local steamid64 = v:SteamID64()

			DM:AddOption( v:GetNWString( 'ply_name' ), function()
				SetClipboardText( v:GetNWString( 'ply_name' ) )
			end ):SetIcon( 'icon16/emoticon_happy.png' )
			DM:AddOption( 'SteamID:  ' .. steamid, function()
				SetClipboardText( steamid )

				ChatText( 'Copied: ' .. steamid )
			end ):SetIcon( 'icon16/sport_8ball.png' )
			DM:AddOption( 'SteamID64:  ' .. ( steamid64 or 'Unknown' ), function()
				SetClipboardText( steamid64 )

				ChatText( 'Copied: ' .. steamid64 )
			end ):SetIcon( 'icon16/sport_8ball.png' )
			DM:AddOption( 'Rank:  ' .. v:GetNWString( 'ply_rank' ), function()
				SetClipboardText( v:GetNWString( 'ply_rank' ) )
			end ):SetIcon( 'icon16/user_suit.png' )

			DM:Open()
		end
	end
end

function GM:ScoreboardShow()
	if ( not IsValid( menuTab ) ) then
		GMopenTab()
	else
		menuTab:SetVisible( true )
	end
end

function GM:ScoreboardHide()
	menuTab:SetVisible( false )
	-- menuTab:Remove() // Required for tests
end
