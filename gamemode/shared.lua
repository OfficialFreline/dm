GM.Name = 'Deathmatch'
GM.Author = 'Freline'

DM = DM or {}

local FileCl = SERVER and AddCSLuaFile or include
local FileSv = SERVER and include or function() end
local FileSh = function( Important )
	AddCSLuaFile( Important )

	return include( Important )
end
local Include = function( f )
	if ( string.find( f, '_sv.lua' ) ) then
		return FileSv( f )
	elseif ( string.find( f, '_cl.lua' ) ) then
		return FileCl( f )
	else
		return FileSh( f )
	end
end
local IncludeDirectory = function( dir )
	local fol = 'dm/gamemode/' .. dir .. '/'
	local files, folders = file.Find( fol .. '*', 'LUA' )

	for _, f in ipairs( files ) do
		Include( fol .. f )
	end
end

Include( 'config_sh.lua' )

IncludeDirectory( 'core/language' )
IncludeDirectory( 'core' )
IncludeDirectory( 'core/player' )
IncludeDirectory( 'core/interface/vgui' )
IncludeDirectory( 'core/interface' )
