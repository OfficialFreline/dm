DMCommandsTable = {}

local ents_FindByClass = ents.FindByClass
local hook_Add = hook.Add
local gui_SetMousePos = gui.SetMousePos
local gui_MousePos = gui.MousePos
local gui_EnableScreenClicker = gui.EnableScreenClicker
local string_match = string.match
local string_lower = string.lower
local hook_Remove = hook.Remove
local Material = Material
local Color = Color
local surface_CreateFont = surface.CreateFont
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawRect = surface.DrawRect
local surface_DrawTexturedRect = surface.DrawTexturedRect
local render_UpdateScreenEffectTexture = render.UpdateScreenEffectTexture
local render_SetScissorRect = render.SetScissorRect

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
		GAMEMODE[ FKeyBinds[ bnd ]]( GAMEMODE )
	end

	return
end

hook_Remove( 'RenderScreenspaceEffects', 'RenderColorModify' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderBloom' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderToyTown' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderTexturize' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderSunbeams' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderSobel' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderSharpen' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderMaterialOverlay' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderMotionBlur' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderColorModify' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderBloom' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderToyTown' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderTexturize' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderSunbeams' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderSobel' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderSharpen' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderMaterialOverlay' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderMotionBlur' )
hook_Remove( 'RenderScreenspaceEffects', 'RenderBokeh' )
hook_Remove( 'RenderScene', 'RenderStereoscopy' )
hook_Remove( 'RenderScene', 'RenderSuperDoF' )
hook_Remove( 'RenderScene', 'RenderStereoscopy' )
hook_Remove( 'RenderScene', 'RenderSuperDoF' )
hook_Remove( 'PreRender', 'PreRenderFrameBlend' )
hook_Remove( 'GUIMousePressed', 'SuperDOFMouseDown' )
hook_Remove( 'GUIMouseReleased', 'SuperDOFMouseUp' )
hook_Remove( 'PreventScreenClicks', 'SuperDOFPreventClicks' )
hook_Remove( 'PostRender', 'RenderFrameBlend' )
hook_Remove( 'PostDrawEffects', 'RenderWidgets' )
hook_Remove( 'Think', 'DOFThink' )
hook_Remove( 'NeedsDepthPass', 'NeedsDepthPass_Bokeh' )

function render.SupportsHDR()
	return false
end

function render.SupportsPixelShaders_2_0()
	return false
end

function render.SupportsPixelShaders_1_4()
	return false
end

function render.SupportsVertexShaders_2_0()
	return false
end

function render.GetDXLevel()
	return 80
end

local Commands = {
    gmod_mcore_test = 1,
    mat_queue_mode = -1,
    cl_threaded_bone_setup = 1,
    r_threaded_particles = 1,
    r_queued_ropes = 1,
    cl_threaded_client_leaf_system = 1,
    r_threaded_renderables = 1,
    mat_fastnobump = 1,
    mat_fastspecular = 1,
    r_fastzreject = 1,
    cl_phys_props_max = 100,
    r_propsmaxdist = 500,
    cl_updaterate = 32,
    cl_cmdrate = 32,
    cl_interp = 0.1,
    cl_interp_ratio = 2,
    studio_queue_mode = 1,
    fps_max = 0,
	cl_drawmonitors = 0,
}

for k, v in SortedPairs( Commands ) do
	RunConsoleCommand( k, v )
end

local scrw, scrh = ScrW(), ScrH()
local Mat = Material( 'pp/blurscreen' )
local WhiteColor = Color( 255, 255, 255 )

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

function draw.Circle( x, y, w, h, ang, color, x0, y0 )
    for i = 0, ang do
        local c = math.cos( math.rad( i ) )
        local s = math.sin( math.rad( i ) )
        local newx = y0 * s - x0 * c
        local newy = y0 * c + x0 * s

        draw.NoTexture()

        surface.SetDrawColor( color )
        surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, i )
    end
end
