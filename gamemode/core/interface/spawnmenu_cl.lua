local function openSpawnMenu()
	SpawnMenu = vgui.Create( 'dm_frame' )
	SpawnMenu:SetSize( ScrW() * 0.5166, ScrH() * 0.55 )
	SpawnMenu:Center()
	SpawnMenu:MakePopup()
	SpawnMenu:SetTitle( 'SpawnMenu | Taking arms' )
	SpawnMenu:ShowCloseButton( false )
	SpawnMenu:SetKeyBoardInputEnabled( false )

	local sp = vgui.Create( 'dm_threegrid', SpawnMenu )
	sp:Dock( FILL )
	sp:InvalidateParent( true )
	sp:SetColumns( 3 )
	sp:SetHorizontalMargin( 5 )
	sp:SetVerticalMargin( 5 )
	sp:SetColumns( 3 )

	for k, v in pairs( list.Get( 'Weapon' ) ) do
		if ( not v.Spawnable or not table.HasValue( DM.Config.GreenWeapon, v.ClassName ) ) then
			continue
		end

		local button = vgui.Create( 'DButton' )
		button:SetTall( 136 )
		button:SetText( '' )
		button.Paint = function( self, w, h )
			local b_color = Color( 220, 220, 220 )

			if ( self:IsHovered() ) then
				b_color = Color( 210, 210, 210 )
			end

			draw.RoundedBox( 4, 0, 0, w, h, b_color )

			surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
			surface.DrawOutlinedRect( w * 0.5 - 46, h * 0.5 - 61, 92, 92 )

			surface.SetDrawColor( Color( 255, 255, 255 ) )
			surface.SetMaterial( Material( v.IconOverride or 'entities/' .. v.ClassName .. '.png' ) )
			surface.DrawTexturedRect( w * 0.5 - 45, h * 0.5 - 60, 90, 90 )

			draw.SimpleText( v.PrintName or v.ClassName, 'SpawnMenu.1', w * 0.5, h * 0.5 + 48, Color( 0, 0, 0, 240 ), 1, 1 )
		end
		button.DoClick = function()
			surface.PlaySound( 'UI/buttonclickrelease.wav' )

			net.Start( 'SpawnMenuGiveWeapon' )
				net.WriteString( v.ClassName )
			net.SendToServer()
		end

		sp:AddCell( button )
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
	SpawnMenu:Remove()
end
