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
		icon_wep.Paint = function( self, w, h )
			if ( self:IsHovered() ) then
				surface.SetDrawColor( Color( 236, 236, 236 ) )
			else
				surface.SetDrawColor( Color( 255, 255, 255 ) )
			end
			
			surface.SetMaterial( Material( v.IconOverride or 'entities/' .. v.ClassName .. '.png' ) )
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
