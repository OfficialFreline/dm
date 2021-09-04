local function openSpawnMenu()
	SpawnMenu = vgui.Create( 'dm_frame' )
	SpawnMenu:SetSize( math.min( ScrW() - 10, 840 ), math.min( ScrH() - 6, 640 ) )
	SpawnMenu:Center()
	SpawnMenu:MakePopup()
	SpawnMenu:SetTitle( 'SpawnMenu | Taking arms' )
	SpawnMenu:ShowCloseButton( false )
	SpawnMenu:SetKeyBoardInputEnabled( false )

	local div = vgui.Create( 'DHorizontalDivider', SpawnMenu )
	div:Dock( FILL )
	div:SetDividerWidth( 4 )
	div:SetLeftMin( 20 )
	div:SetRightMin( 20 )

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

		local button = vgui.Create( 'dm_button', pan )
		button:Dock( FILL )
		button:SetText( v.PrintName or v.ClassName )
		button.DoClick = function()
			surface.PlaySound( 'UI/buttonclickrelease.wav' )

			RunConsoleCommand( 'dm_giveswep', v.ClassName )
		end

		local icon_wep = vgui.Create( 'DPanel', pan )
		icon_wep:SetWide( 138 )
		icon_wep:Dock( LEFT )

		local mat_name = v.IconOverride or 'entities/' .. v.ClassName .. '.png'
		local mat = Material( mat_name )

		if ( not mat or mat:IsError() ) then
			mat_name = mat_name:Replace( 'entities/', 'VGUI/entities/' )
			mat_name = mat_name:Replace( '.png', '' )
			mat = Material( mat_name )
		end

		icon_wep.Paint = function( self, w, h )
			surface.SetDrawColor( self:IsHovered() and Color(236,236,236) or Color(255, 255, 255) )
			surface.SetMaterial( mat )
			surface.DrawTexturedRect( 5, 5, h - 10, h - 10 )

			draw.OutlinedBox( 2, 2, w - 4, h - 4, DMColor.clear, DMColor.frame_bar, 4 )
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
