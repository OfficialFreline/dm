local color_white = Color(255,255,255)

local function openSpawnMenu()
	SpawnMenu = vgui.Create( 'dm_frame' )
	SpawnMenu:SetSize( math.min( ScrW() - 10, 840 ), math.min( ScrH() - 6, 640 ) )
	SpawnMenu:Center()
	SpawnMenu:MakePopup()
	SpawnMenu:SetTitle( 'SpawnMenu | ' .. LANG.GetTranslation( 'arms' ) )
	SpawnMenu:ShowCloseButton( false )
	SpawnMenu:SetKeyBoardInputEnabled( false )

	local div = vgui.Create( 'DHorizontalDivider', SpawnMenu )
	div:Dock( FILL )
	div:SetDividerWidth( 4 )
	div:SetLeftMin( 20 )
	div:SetRightMin( 20 )

	local text_info = vgui.Create( 'DPanel', SpawnMenu )
	text_info:Dock( TOP )
	text_info:DockMargin( 0, 0, 0, 4 )
	text_info.Paint = function( self, w, h )
		draw.SimpleText( LANG.GetTranslation( 'available' ), 'Button', div:GetLeftWidth() * 0.5, h * 0.5, color_white, 1, 1 )
		draw.SimpleText( LANG.GetTranslation( 'rest' ), 'Button', div:GetLeftWidth() + ( SpawnMenu:GetWide() - div:GetLeftWidth() ) * 0.5, h * 0.5, color_white, 1, 1 )
	end

	local sp_main = vgui.Create( 'dm_scrollpanel', SpawnMenu )
	local sp_admin = vgui.Create( 'dm_scrollpanel', SpawnMenu )

	div:SetLeft( sp_main )
	div:SetLeftMin( 300 )
	div:SetLeftWidth( math.max( 300, SpawnMenu:GetWide() * 0.35 ) )
	div:SetRight( sp_admin )
	div:SetRightMin( 300 )

	for k, v in pairs( list.Get( 'Weapon' ) ) do
		if ( not v.Spawnable ) then
			continue
		end

		local z

		if ( not table.HasValue( DM.Config.GreenWeapon, v.ClassName ) ) then
			z = sp_admin
		else
			z = sp_main
		end

		local pan = vgui.Create( 'DPanel', z )
		pan:SetTall( 136 )
		pan:Dock( TOP )
		pan:DockMargin( 0, 2, 0, 0 )
		pan.Paint = nil

		local function SelectWeapon( wep )
			surface.PlaySound( 'UI/buttonclickrelease.wav' )

			RunConsoleCommand( 'dm_giveswep', wep )
		end

		local button = vgui.Create( 'dm_button', pan )
		button:Dock( FILL )
		button:SetText( v.PrintName or v.ClassName )
		button.DoClick = function()
			SelectWeapon( v.ClassName )
		end

		local icon_wep = vgui.Create( 'DButton', pan )
		icon_wep:SetWide( 138 )
		icon_wep:Dock( LEFT )
		icon_wep:DockMargin( 0, 0, 4, 0 )
		icon_wep:SetText( '' )

		local mat_name = v.IconOverride or 'entities/' .. v.ClassName .. '.png'
		local mat = Material( mat_name )

		if ( not mat or mat:IsError() ) then
			mat_name = mat_name:Replace( 'entities/', 'VGUI/entities/' )
			mat_name = mat_name:Replace( '.png', '' )
			mat = Material( mat_name )
		end

		icon_wep.Paint = function( self, w, h )
			draw.RoundedBox( 4, 4, 4, w - 8, h - 8, DMColor.frame_bar )

			surface.SetDrawColor( self:IsHovered() and Color(236,236,236) or color_white )
			surface.SetMaterial( mat )
			surface.DrawTexturedRect( 10, 10, w - 20, h - 20 )

			if ( icon_wep:IsHovered() ) then
				button.Depr = true
			else
				button.Depr = false
			end
		end
		icon_wep.DoClick = function()
			SelectWeapon( v.ClassName )
		end
	end
end

function GM:OnSpawnMenuOpen()
	if ( not IsValid( SpawnMenu ) ) then
		openSpawnMenu()
	else
		SpawnMenu:SetVisible( true )
	end
end

function GM:OnSpawnMenuClose()
	SpawnMenu:SetVisible( false )
	-- SpawnMenu:Remove()
end
