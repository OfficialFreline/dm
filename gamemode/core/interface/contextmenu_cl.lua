local function CreateCM( title )
	ContextMenu = vgui.Create( 'dm_frame' )
	ContextMenu:SetSize( ScrW() * 0.35, ScrH() * 0.45 )
	ContextMenu:Center()
	ContextMenu:MakePopup()
	ContextMenu:SetTitle( 'ContextMenu | ' .. title )
	ContextMenu:SetKeyBoardInputEnabled( false )
	ContextMenu:ShowCloseButton( false )
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

	local PanelSelect = ContextMenu:Add( 'DPanelSelect' )
	PanelSelect:Dock( FILL )

	-- From ScrollPanel
	PanelSelect.VBar:SetWide( 14 )
	PanelSelect.VBar:SetHideButtons( true )
	PanelSelect.VBar.Paint = nil
	PanelSelect.VBar.btnGrip.Paint = function( self, w, h )
		draw.RoundedBox( 4, 4, 4, w - 8, h - 8, self.Depressed and DMColor.sp_hov or DMColor.sp )
	end

	for name, model in SortedPairs( player_manager.AllValidModels() ) do
		local icon = vgui.Create( 'SpawnIcon' )
		icon:SetSize( 64, 64 )
		icon:SetModel( model )
		icon.mdl = name
		icon.OpenMenu = function( button )
			local DM = DermaMenu()
			DM:AddOption( '#spawnmenu.menu.copy', function()
				SetClipboardText( model )
			end ):SetIcon( 'icon16/page_copy.png' )
			DM:Open()
		end

		PanelSelect:AddPanel( icon )
	end

	function PanelSelect:OnActivePanelChanged( old, new )
		if ( old != new ) then
			RunConsoleCommand( 'cl_playermodel', new.mdl )
		end
	end
end

local list_aim = {
	'Small Square',
	'Crosshair from all sides',
}

local function openCrosshairMenu()
	CreateCM( LANG.GetTranslation( 'crosshairs' ) )

	local sp = vgui.Create( 'dm_scrollpanel', ContextMenu )
	sp:Dock( FILL )

	local text_info = vgui.Create( 'DPanel', ContextMenu )
	text_info:Dock( TOP )
	text_info.Paint = function( self, w, h )
		draw.SimpleText( LANG.GetTranslation( 'type_cross' ), 'Button', w * 0.5, h * 0.5, Color(255,255,255), 1, 1 )
	end

	local standart = vgui.Create( 'dm_button', sp )
	standart:Dock( TOP )
	standart:DockMargin( 0, 4, 0, 0 )
	standart:SetText( LANG.GetTranslation( 'standart' ) )
	standart.DoClick = function()
		surface.PlaySound( 'UI/buttonclickrelease.wav' )

		RunConsoleCommand( 'crosshair_dm', 0 )
	end

	for m, n in pairs( list_aim ) do
		local btn = vgui.Create( 'dm_button', sp )
		btn:Dock( TOP )
		btn:DockMargin( 0, 4, 0, 0 )
		btn:SetText( n )
		btn.DoClick = function()
			surface.PlaySound( 'UI/buttonclickrelease.wav' )

			RunConsoleCommand( 'crosshair_dm', m )
		end
	end
end

local function openColorPanel()
	CreateCM( LANG.GetTranslation( 'colors' ) )

	local left_pnl = vgui.Create( 'DPanel', ContextMenu )
	left_pnl:Dock( LEFT )
	left_pnl:SetWide( ContextMenu:GetWide() * 0.5 - 8 )
	left_pnl.Paint = nil

	local text_info = vgui.Create( 'DPanel', left_pnl )
	text_info:Dock( TOP )
	text_info:DockMargin( 0, 0, 0, 4 )
	text_info.Paint = function( self, w, h )
		draw.SimpleText( LANG.GetTranslation( 'colorPlayer' ), 'Button', w * 0.5, h * 0.5, Color(255,255,255), 1, 1 )
	end

	local mixer_left = vgui.Create( 'DColorMixer', left_pnl )
	mixer_left:Dock( FILL )
	mixer_left:SetAlphaBar( false )
	mixer_left:SetPalette( false )

	local right_pnl = vgui.Create( 'DPanel', ContextMenu )
	right_pnl:Dock( RIGHT )
	right_pnl:SetWide( ContextMenu:GetWide() * 0.5 - 8 )
	right_pnl.Paint = nil

	local text_info = vgui.Create( 'DPanel', right_pnl )
	text_info:Dock( TOP )
	text_info:DockMargin( 0, 0, 0, 4 )
	text_info.Paint = function( self, w, h )
		draw.SimpleText( LANG.GetTranslation( 'colorWeapon' ), 'Button', w * 0.5, h * 0.5, Color(255,255,255), 1, 1 )
	end

	local mixer_right = vgui.Create( 'DColorMixer', right_pnl )
	mixer_right:Dock( FILL )
	mixer_right:SetAlphaBar( false )
	mixer_right:SetPalette( false )

	local function UpdateFromControls()
		RunConsoleCommand( 'cl_playercolor', tostring( mixer_left:GetVector() ) )
		RunConsoleCommand( 'cl_weaponcolor', tostring( mixer_right:GetVector() ) )
	end

	mixer_left.ValueChanged = UpdateFromControls
	mixer_right.ValueChanged = UpdateFromControls
end

local function openContextMenu()
	CreateCM( LANG.GetTranslation( 'options' ) )

	local pnl = vgui.Create( 'DPanel', ContextMenu )
	pnl:Dock( FILL )
	pnl.Paint = nil

	local btn_1 = vgui.Create( 'dm_button', pnl )
	btn_1:SetWide( ContextMenu:GetWide() * 0.5 - 8 )
	btn_1:Dock( LEFT )
	btn_1:SetText( LANG.GetTranslation( 'localActions' ) )
	btn_1.DoClick = function()
		ContextMenu:Remove()

		openCmdPanel()
	end

	local btn_2 = vgui.Create( 'dm_button', pnl )
	btn_2:SetWide( ContextMenu:GetWide() * 0.5 - 8 )
	btn_2:Dock( RIGHT )
	btn_2:SetText( LANG.GetTranslation( 'models' ) )
	btn_2.DoClick = function()
		ContextMenu:Remove()

		openModelPanel()
	end

	local pan_bottom = vgui.Create( 'DPanel', ContextMenu )
	pan_bottom:Dock( BOTTOM )
	pan_bottom:DockMargin( 0, 4, 0, 0 )
	pan_bottom.Paint = nil

	local btn_bottom_left = vgui.Create( 'dm_button', pan_bottom )
	btn_bottom_left:SetWide( ContextMenu:GetWide() * 0.5 - 8 )
	btn_bottom_left:SetText( LANG.GetTranslation( 'crosshairs' ) )
	btn_bottom_left.DoClick = function()
		ContextMenu:Remove()

		openCrosshairMenu()
	end

	local btn_bottom_right = vgui.Create( 'dm_button', pan_bottom )
	btn_bottom_right:Dock( RIGHT )
	btn_bottom_right:SetWide( ContextMenu:GetWide() * 0.5 - 8 )
	btn_bottom_right:SetText( LANG.GetTranslation( 'thirdperson' ) )
	btn_bottom_right.DoClick = function()
		ContextMenu:Remove()

		RunConsoleCommand( 'person_menu' )
	end

	local btn_top = vgui.Create( 'dm_button', ContextMenu )
	btn_top:Dock( TOP )
	btn_top:DockMargin( 0, 0, 0, 4 )
	btn_top:SetText( LANG.GetTranslation( 'colors' ) )
	btn_top.DoClick = function()
		ContextMenu:Remove()

		openColorPanel()
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
