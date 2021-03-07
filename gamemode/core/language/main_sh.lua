DM.Language = {}
LANGUAGE = {}

include( 'list/' .. DM.Config.Language .. '.lua' )

if ( SERVER ) then
    AddCSLuaFile( 'list/' .. DM.Config.Language .. '.lua' )
end

DM.Language = LANGUAGE
LANGUAGE = nil

assert( DM.Language, '[DM] Language not found!' )

function DM.Translate( trans, ... )
	return string.format( DM.Language[ trans ] or trans, ... )
end
