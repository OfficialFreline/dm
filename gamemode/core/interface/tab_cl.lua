function AddActionDM( Name, Do, AdminBool, LocalPlayerBool )
	local tabl = {
		name = Name,
		action = Do,
		admin = AdminBool,
		localplayer = LocalPlayerBool,
	}

	table.Add( DMCommandsTable, { tabl } )
end // Lightweight system

function GMopenTab()
	menuTab = vgui.Create( 'DPanel' )
	menuTab:SetSize( ScrW() * 0.6, ScrH() * 0.7 )
	menuTab:Center()
	menuTab:MakePopup()
	menuTab:SetKeyBoardInputEnabled( false )
	menuTab.Paint = function( self, w, h )
		draw.OutlinedBox( 0, 0, w, h, Color( 75, 75, 75, 245 ), Color( 0, 0, 0, 230 ) ) -- Background
		draw.OutlinedBox( 0, 0, w, 70, Color( 63, 63, 63 ), Color( 0, 0, 0 ) ) -- Bar
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
	sp.Paint = function( self, w, h )
		draw.Blur( self )
	end

	surface.SetFont( 'Tab.2' )

	local infoButton = vgui.Create( 'dm_button', sp )
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

		local playerButtonM = vgui.Create( 'dm_button', sp )
		playerButtonM:SetTall( 40 )
		playerButtonM:Dock( TOP )
		playerButtonM:DockMargin( 0, 5, 0, 0 )
		playerButtonM:SetText( '' )	

		local playerButton = vgui.Create( 'dm_button', playerButtonM )
		playerButton:Dock( FILL )
		playerButton:SetText( '' )	
		playerButton.Paint = function( self, w, h )
			if ( IsValid( v ) ) then
				local x
				local textColor = Color( 255, 255, 255 )

				if ( self:IsHovered() or playerAvatarButton:IsHovered() ) then
					textColor = Color( 235, 235, 235 )

					playerAvatar:SetVisible( true )

					x = 30
				else
					playerAvatar:SetVisible( false )

					x = 0
				end

				local name = v:GetNick()

				if ( name == nil ) then
					name = v:Name()
				end

				draw.SimpleText( name, 'Tab.3', 12 + x, 11, textColor )
				draw.SimpleText( v:Ping() or '', 'Tab.3', w - surface.GetTextSize( v:Ping() or '' ) - 12, 11, textColor )

				local frags = v:GetFrags()
				local deaths = v:GetDeaths()

				if ( deaths < 1 ) then
					deaths = 1
				end

				local text = string.sub( frags / deaths, 0, 6 ) .. ' (' .. frags .. '/' .. deaths .. ')' or ''

				draw.SimpleText( text, 'Tab.3', w * 0.5 - surface.GetTextSize( text ) * 0.5, 11, textColor )
			end
		end
		playerButton.DoClick = function()
			surface.PlaySound( 'UI/buttonclickrelease.wav' )

			menuTab:Clear()

			surface.SetFont( 'Tab.1' )

			local nick = v:GetNick() or ''
			local txt = 'Player: ' .. nick

			local PlayerLabel = vgui.Create( 'DLabel', menuTab )
			PlayerLabel:SetPos( menuTab:GetWide() * 0.5 - surface.GetTextSize( txt ) * 0.5, 11 )
			PlayerLabel:SetSize( menuTab:GetWide(), 50 )
			PlayerLabel:SetText( txt )
			PlayerLabel:SetFont( 'Tab.1' )

			local globalPanel = vgui.Create( 'DPanel', menuTab )
			globalPanel:Dock( FILL )
			globalPanel:DockMargin( 10, 80, 10, 10 )
			globalPanel.Paint = function( self, w, h )
				draw.Blur( self )
			end

			local w = menuTab:GetWide() - 20

			local leftPanel = vgui.Create( 'DPanel', globalPanel )
			leftPanel:Dock( LEFT )
			leftPanel:SetWide( w / 2.6 )
			leftPanel.Paint = nil	

			local btn_return = vgui.Create( 'dm_button', leftPanel )
			btn_return:Dock( TOP )
			btn_return:SetTall( 40 )
			btn_return:SetText( 'Back to the list of players' )
			btn_return.DoClick = function()
				menuTab:Remove()

				GMopenTab()
			end

			local playerPrev_panel = vgui.Create( 'DPanel', leftPanel )
			playerPrev_panel:Dock( FILL )
			playerPrev_panel:DockMargin( 0, 8, 0, 0 )
			playerPrev_panel.Paint = nil

			local playerPrev = vgui.Create( 'DModelPanel', playerPrev_panel )
			playerPrev:Dock( FILL )
			playerPrev:SetModel( v:GetModel() or 'models/player/alyx.mdl' )
			playerPrev:SetCamPos( Vector( 45, 15, 45 ) )
			playerPrev:SetFOV( 58 )
			playerPrev.LayoutEntity = function( Entity )
				return
			end

			function playerPrev.Entity:GetPlayerColor()
				return v:GetPlayerColor()
			end

			local playerPrev_panel2 = vgui.Create( 'DPanel', playerPrev )
			playerPrev_panel2:Dock( FILL )
			playerPrev_panel2.Paint = function( self, w, h )
				draw.OutlinedBox( 0, 0, w, h, Color( 0, 0, 0, 0 ), Color( 255, 255, 255, 50 ) )
			end

			local scrollpanel = vgui.Create( 'dm_scrollpanel', globalPanel )
			scrollpanel:Dock( RIGHT )
			scrollpanel:SetWide( w - leftPanel:GetWide() - 10 )

			local firstk = true

			for l, n in pairs( DMCommandsTable ) do
				if ( not n.localplayer ) then
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
			DM:AddOption( 'SteamID64:  ' .. steamid64, function()
				SetClipboardText( steamid64 )

				ChatText( 'Copied: ' .. steamid64 )
			end ):SetIcon( 'icon16/sport_8ball.png' )
			DM:AddOption( 'Rank:  ' .. v:GetRank(), function()
				SetClipboardText( v:GetRank() )
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
