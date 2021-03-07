local function openContextMenu()
	ContextMenu = vgui.Create( 'dm_frame' )
	ContextMenu:SetSize( ScrW() * 0.42, ScrH() * 0.45 )
	ContextMenu:Center()
	ContextMenu:MakePopup()
	ContextMenu:SetTitle( 'ContextMenu | Local actions' )
	ContextMenu:SetKeyBoardInputEnabled( false )
	ContextMenu:ShowCloseButton( false )

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

function GM:OnContextMenuOpen()
	if ( not IsValid( ContextMenu ) ) then
		openContextMenu()
	else
		ContextMenu:SetVisible( true )
	end
end

function GM:OnContextMenuClose()
	ContextMenu:SetVisible( false )
	ContextMenu:Remove()
end
