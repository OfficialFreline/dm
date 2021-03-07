include( 'shared.lua' )

timer.Create( 'CleanBodys', 60, 0, function()
    RunConsoleCommand( 'r_cleardecals' )

    for k, v in ipairs( ents.FindByClass( 'class C_ClientRagdoll' ) ) do
        v:Remove()
    end

    for k, v in ipairs( ents.FindByClass( 'class C_PhysPropClientside' ) ) do
        v:Remove()
    end   
end )

RunConsoleCommand( 'cl_drawmonitors', 0 )

hook.Add( 'InitPostEntity', 'cl_init', function()
	LocalPlayer():ConCommand( 'stopsound; cl_updaterate 32; cl_cmdrate 32; cl_interp_ratio 2; cl_interp 0; mem_max_heapsize 2048; datacachesize 512; mem_min_heapsize 512' )
end )

local GUIToggled = false
local mouseX, mouseY = ScrW() * 0.5, ScrH() * 0.5

function GM:ShowSpare1()
	GUIToggled = not GUIToggled

	if ( GUIToggled ) then
		gui.SetMousePos( mouseX, mouseY )
	else
		mouseX, mouseY = gui.MousePos()
	end

	gui.EnableScreenClicker( GUIToggled )
end

local FKeyBinds = {
	[ 'gm_showhelp' ] = 'ShowHelp',
	[ 'gm_showteam' ] = 'ShowTeam',
	[ 'gm_showspare1' ] = 'ShowSpare1',
	[ 'gm_showspare2' ] = 'ShowSpare2',
}

function GM:PlayerBindPress( ply, bind, pressed )
	local bnd = string.match( string.lower( bind ), 'gm_[a-z]+[12]?' )

	if ( bnd and FKeyBinds[ bnd ] and GAMEMODE[ FKeyBinds[ bnd ] ] ) then
		GAMEMODE[ FKeyBinds[ bnd ]]( GAMEMODE )
	end

	return
end

hook.Remove( 'RenderScreenspaceEffects', 'RenderColorModify' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderBloom' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderToyTown' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderTexturize' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderSunbeams' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderSobel' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderSharpen' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderMaterialOverlay' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderMotionBlur' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderColorModify' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderBloom' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderToyTown' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderTexturize' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderSunbeams' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderSobel' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderSharpen' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderMaterialOverlay' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderMotionBlur' )
hook.Remove( 'RenderScreenspaceEffects', 'RenderBokeh' )
hook.Remove( 'RenderScene', 'RenderStereoscopy' )
hook.Remove( 'RenderScene', 'RenderSuperDoF' )
hook.Remove( 'RenderScene', 'RenderStereoscopy' )
hook.Remove( 'RenderScene', 'RenderSuperDoF' )
hook.Remove( 'PreRender', 'PreRenderFrameBlend' )
hook.Remove( 'GUIMousePressed', 'SuperDOFMouseDown' )
hook.Remove( 'GUIMouseReleased', 'SuperDOFMouseUp' )
hook.Remove( 'PreventScreenClicks', 'SuperDOFPreventClicks' )
hook.Remove( 'PostRender', 'RenderFrameBlend' )
hook.Remove( 'PostDrawEffects', 'RenderWidgets' )
hook.Remove( 'Think', 'DOFThink' )
hook.Remove( 'NeedsDepthPass', 'NeedsDepthPass_Bokeh' )

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

local scrw, scrh = ScrW(), ScrH()
local Mat = Material( 'pp/blurscreen' )
local WhiteColor = Color( 255, 255, 255 )
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local render_UpdateScreenEffectTexture = render.UpdateScreenEffectTexture
local render_SetScissorRect = render.SetScissorRect

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
