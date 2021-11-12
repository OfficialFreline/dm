DMCommandsTable = {}

local ents_FindByClass = ents.FindByClass
local gui_SetMousePos = gui.SetMousePos
local gui_MousePos = gui.MousePos
local gui_EnableScreenClicker = gui.EnableScreenClicker
local string_match = string.match
local string_lower = string.lower
local Material = Material
local Color = Color
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawRect = surface.DrawRect
local surface_DrawTexturedRect = surface.DrawTexturedRect
local render_UpdateScreenEffectTexture = render.UpdateScreenEffectTexture
local render_SetScissorRect = render.SetScissorRect

CreateClientConVar( 'crosshair_dm', 0, true )

include( 'shared.lua' )

timer.Create( 'CleanBodys', 60, 0, function()
	RunConsoleCommand( 'r_cleardecals' )

	for k, v in ipairs( ents_FindByClass( 'class C_ClientRagdoll' ) ) do
		v:Remove()
	end

	for k, v in ipairs( ents_FindByClass( 'class C_PhysPropClientside' ) ) do
		v:Remove()
	end   
end )

local GUIToggled = false
local mouseX, mouseY = ScrW() * 0.5, ScrH() * 0.5

function GM:ShowSpare1()
	GUIToggled = not GUIToggled

	if ( GUIToggled ) then
		gui_SetMousePos( mouseX, mouseY )
	else
		mouseX, mouseY = gui_MousePos()
	end

	gui_EnableScreenClicker( GUIToggled )
end

local FKeyBinds = {
	[ 'gm_showhelp' ] = 'ShowHelp',
	[ 'gm_showteam' ] = 'ShowTeam',
	[ 'gm_showspare1' ] = 'ShowSpare1',
	[ 'gm_showspare2' ] = 'ShowSpare2',
}

function GM:PlayerBindPress( ply, bind, pressed )
	local bnd = string_match( string_lower( bind ), 'gm_[a-z]+[12]?' )

	if ( bnd and FKeyBinds[ bnd ] and GAMEMODE[ FKeyBinds[ bnd ] ] ) then
		GAMEMODE[ FKeyBinds[ bnd ] ]( GAMEMODE )
	end

	return
end

local Commands_List = {
	cl_updaterate = 128,
	cl_cmdrate = 128,
	gmod_mcore_test = 1,
	r_threaded_renderables = 1,
	mat_queue_mode = -1,
	studio_queue_mode = 1,
	fps_max = 0,
}

for k, v in SortedPairs( Commands_List ) do
	RunConsoleCommand( k, v )
end

local scrw, scrh = ScrW(), ScrH()
local Mat = Material( 'pp/blurscreen' )
local WhiteColor = Color(255, 255, 255)

local function DrawRect( x, y, w, h, t )
	if ( not t ) then
		t = 1
	end

	surface_DrawRect( x, y, w, t )
	surface_DrawRect( x, y + h - t, w, t )
	surface_DrawRect( x, y, t, h )
	surface_DrawRect( x + w - t, y, t, h )
end

function draw.OutlinedBox( x, y, w, h, col, bordercol, thickness )
	surface_SetDrawColor( col )
	surface_DrawRect( x + 1, y + 1, w - 2, h - 2 )

	surface_SetDrawColor( bordercol )

	DrawRect( x, y, w, h, thickness )
end

function draw.Blur( panel, amount )
	local x, y = panel:LocalToScreen( 0, 0 )

	surface_SetDrawColor( WhiteColor )
	surface_SetMaterial( Mat )

	for i = 1, 3 do
		Mat:SetFloat( '$blur', i * 0.3 * ( amount or 8 ) )
		Mat:Recompute()

		render_UpdateScreenEffectTexture()

		surface_DrawTexturedRect( x * -1, y * -1, scrw, scrh )
	end
end

function draw.RectBlur( x, y, w, h )
	surface_SetDrawColor( WhiteColor )
	surface_SetMaterial( Mat )
	
	for i = 1, 3 do
		Mat:SetFloat( '$blur', ( i / 3 ) * 8 )
		Mat:Recompute()

		render_UpdateScreenEffectTexture()
		render_SetScissorRect( x, y, x + w, y + h, true )

		surface_DrawTexturedRect( 0, 0, scrw, scrh )
		
		render_SetScissorRect( 0, 0, 0, 0, false )
	end
end
