GM.Name = 'Deathmatch'
GM.Author = 'Freline'

DM = DM or {}

local FileCl = SERVER and AddCSLuaFile or include
local FileSv = SERVER and include or function() end
local FileSh = function( Important )
	AddCSLuaFile( Important )

	return include( Important )
end

DM.Include = function( f )
	if ( string.find( f, '_sv.lua' ) ) then
		return FileSv( f )
	elseif ( string.find( f, '_cl.lua' ) ) then
		return FileCl( f )
	else
		return FileSh( f )
	end
end

DM.IncludeDirectory = function( dir )
	local fol = 'dm/gamemode/' .. dir .. '/'
	local files, folders = file.Find( fol .. '*', 'LUA' )

	for _, f in ipairs( files ) do
		DM.Include( fol .. f )
	end
end

DM.Include( 'config/main_sh.lua' )

DM.Include( 'core/language/lang_sh.lua' )

DM.IncludeDirectory( 'core/player' )
DM.IncludeDirectory( 'core' )

DM.Include( 'config/color_cl.lua' )

if ( CLIENT ) then
	LANG.Init()
end

DM.IncludeDirectory( 'core/interface/vgui' )
DM.IncludeDirectory( 'core/interface' )

DM.Include( 'config/cmds_cl.lua' )
