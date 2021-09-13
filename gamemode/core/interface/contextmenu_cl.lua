local function CreateCM( title )
	ContextMenu = vgui.Create( 'dm_frame' )
	ContextMenu:SetSize( ScrW() * 0.35, ScrH() * 0.45 )
	ContextMenu:Center()
	ContextMenu:MakePopup()
	ContextMenu:SetTitle( 'ContextMenu | ' .. title )
	ContextMenu:SetKeyBoardInputEnabled( false )
	ContextMenu:ShowCloseButton( false )

	-- local KeyDown_ = false

	-- function ContextMenu:Think()
	--	 if ( input.IsKeyDown( KEY_C ) and KeyDown_ ) then
	--		 self:Close()
	--	 elseif ( not input.IsKeyDown( KEY_C ) ) then
	--		 KeyDown_ = true
	--	 end
	-- end
end

local function openCmdPanel()
	CreateCM( LANG.GetTranslation( 'localActions' ) )

	local sp = vgui.Create( 'dm_scrollpanel', ContextMenu )
	sp:Dock( FILL )

	local firstk = true

	for l, n in pairs( DMCommandsTable ) do
		if ( n.localplayer ) then
			cmdButton = vgui.Create( 'dm_button', sp )
			cmdButton:Dock( TOP )

			if ( not firstk ) then
				cmdButton:DockMargin( 0, 5, 0, 0 )
			else
				firstk = not firstk
			end
			
			cmdButton:SetTall( 40 )

			if ( n.admin ) then
				cmdButton:SetText( '[' .. LANG.GetTranslation( 'admin' ) .. '] ' .. n.name )
			else
				cmdButton:SetText( n.name )
			end

			cmdButton.DoClick = function()
				surface.PlaySound( 'UI/buttonclickrelease.wav' )

				if ( n.admin ) then
					if ( LocalPlayer():Admin() ) then
						n.action( v )
					else
						ChatTextAdmin( LANG.GetTranslation( 'notAdmin' ) )
					end
				else
					n.action( v )
				end
			end
		end
	end
end

local function openModelPanel()
	CreateCM( LANG.GetTranslation( 'models' ) )

	local playerPrev_panel = vgui.Create( 'DPanel', ContextMenu )
	playerPrev_panel:Dock( LEFT )
	playerPrev_panel:SetWide( ContextMenu:GetWide() / 2.6 )
	playerPrev_panel.Paint = function( self, w, h )
		draw.OutlinedBox( 0, 0, w, h, DMColor.clear, DMColor.frame_bar, 4 )
	end

	local playerPrev = vgui.Create( 'DModelPanel', playerPrev_panel )
	playerPrev:Dock( FILL )
	playerPrev:SetModel( LocalPlayer():GetModel() )
	playerPrev:SetFOV( 32 )
	playerPrev.LayoutEntity = function( Entity )
		return
	end

	function playerPrev.Entity:GetPlayerColor()
		return LocalPlayer():GetPlayerColor()
	end

	local sp = vgui.Create( 'dm_scrollpanel', ContextMenu )
	sp:Dock( FILL )
	sp:DockMargin( 4, 0, 0, 0 )

	for name, model in SortedPairs( player_manager.AllValidModels() ) do
		local btn

		local pan = vgui.Create( 'DPanel', sp )
		pan:SetTall( 80 )
		pan:Dock( TOP )
		pan.Paint = function( self, w, h )
			if ( model == LocalPlayer():GetModel() ) then
				draw.RoundedBox( 8, 3, 3, w - 6, h - 6, Color(231, 76, 60) )
			end
		end

		btn = vgui.Create( 'dm_button', pan )
		btn:Dock( FILL )
		btn:SetText( model )
		btn.DoClick = function()
			surface.PlaySound( 'UI/buttonclickrelease.wav' )
			
			RunConsoleCommand( 'dm_changemdl', model )

			playerPrev:SetModel( model )
		end
	end
end

local function openContextMenu()
	CreateCM( 'Option selection' )

	local btn_1 = vgui.Create( 'dm_button', ContextMenu )
	btn_1:SetWide( ContextMenu:GetWide() * 0.5 - 5 )
	btn_1:Dock( LEFT )
	btn_1:SetText( LANG.GetTranslation( 'localActions' ) )
	btn_1.DoClick = function()
		ContextMenu:Remove()

		openCmdPanel()
	end

	local btn_2 = vgui.Create( 'dm_button', ContextMenu )
	btn_2:SetWide( ContextMenu:GetWide() * 0.5 - 5 )
	btn_2:Dock( RIGHT )
	btn_2:SetText( LANG.GetTranslation( 'models' ) )
	btn_2.DoClick = function()
		ContextMenu:Remove()

		openModelPanel()
	end
end

function GM:OnContextMenuOpen()
	if ( not IsValid( ContextMenu ) ) then
		openContextMenu()
	else
		ContextMenu:SetVisible( true )
	end
end

function GM:OnContextMenuClose()
	ContextMenu:Remove()
end
