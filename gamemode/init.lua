AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )

include( 'shared.lua' )

timer.Destroy( 'HostnameThink' )

hook.Add( 'PreGamemodeLoaded', 'widgets_disabler_cpu', function()
	function widgets.PlayerTick()
	end

	hook.Remove( 'PlayerTick', 'TickWidgets' )
end )
