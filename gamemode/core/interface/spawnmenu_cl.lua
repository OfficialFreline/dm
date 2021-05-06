local function openSpawnMenu()
	SpawnMenu = vgui.Create( 'dm_frame' )
	SpawnMenu:SetSize( ScrW() * 0.6, ScrH() * 0.55 )
	SpawnMenu:Center()
	SpawnMenu:MakePopup()
	SpawnMenu:SetTitle( 'SpawnMenu | Taking arms' )
	SpawnMenu:ShowCloseButton( false )
	SpawnMenu:SetKeyBoardInputEnabled( false )

	local sp_main = vgui.Create( 'dm_scrollpanel', SpawnMenu )
	sp_main:SetWide( SpawnMenu:GetWide() * 0.6 )
	sp_main:Dock( LEFT )

	local sp_admin = vgui.Create( 'dm_scrollpanel', SpawnMenu )
	sp_admin:Dock( FILL )

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

		local button = vgui.Create( 'dm_button', z )
		button:SetTall( 136 )
		button:Dock( TOP )
		button:DockMargin( 0, 2, 0, 0 )
		button:SetText( '' )
		button.Paint = function( self, w, h )
			local b_color = Color( 220, 220, 220 )

			if ( self:IsHovered() ) then
				b_color = Color( 210, 210, 210 )
			end

			draw.RoundedBox( 6, 0, 0, w, h, b_color )

			surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
			surface.DrawOutlinedRect( 4, 4, h - 8, h - 8 )

			if ( self:IsHovered() ) then
				surface.SetDrawColor( Color( 236, 236, 236 ) )
			else
				surface.SetDrawColor( Color( 255, 255, 255 ) )
			end

			surface.SetMaterial( Material( v.IconOverride or 'entities/' .. v.ClassName .. '.png' ) )
			surface.DrawTexturedRect( 5, 5, h - 10, h - 10 )

			draw.SimpleText( v.PrintName or v.ClassName, 'SpawnMenu.1', w * 0.5 + h * 0.5 - 8, h * 0.5, Color( 0, 0, 0, 240 ), 1, 1 )
		end
		button.DoClick = function()
			surface.PlaySound( 'UI/buttonclickrelease.wav' )

			RunConsoleCommand( 'dm_giveswep', v.ClassName )
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
