LANG.Strings = {}

CreateConVar( 'dm_language', 'auto', FCVAR_ARCHIVE )

LANG.DefaultLanguage = 'english'
LANG.ActiveLanguage = LANG.DefaultLanguage
LANG.ServerLanguage = 'english'

local cached_default, cached_active

function LANG.CreateLanguage( raw_lang_name )
	if ( not raw_lang_name ) then
		return
	end

	lang_name = string.lower( raw_lang_name )

	if ( not LANG.IsLanguage( lang_name ) ) then
		LANG.Strings[ lang_name ] = {
			[ '' ] = '',
			language_name = raw_lang_name,
		}
   end

	if ( lang_name == LANG.DefaultLanguage ) then
		cached_default = LANG.Strings[ lang_name ]

		setmetatable( LANG.Strings[ lang_name ], {
			__index = function( tbl, name )
				return Format( '[ERROR: Translation of %s not found]', name ), false
			end
		} )
	end

	return LANG.Strings[ lang_name ]
end

function LANG.GetTranslation( name )
	return cached_active[ name ]
end

function LANG.GetRawTranslation( name )
	return rawget( cached_active, name ) or rawget( cached_default, name )
end

local GetRaw = LANG.GetRawTranslation

function LANG.TryTranslation( name )
	return GetRaw( name ) or name
end

local interp = string.Interp

function LANG.GetParamTranslation( name, params )
	return interp( cached_active[ name ], params )
end

LANG.GetPTranslation = LANG.GetParamTranslation

function LANG.GetTranslationFromLanguage( name, lang_name )
	return rawget( LANG.Strings[ lang_name ], name )
end

function LANG.GetUnsafeLanguageTable()
	return cached_active
end

function LANG.GetUnsafeNamed( name )
	return LANG.Strings[ name ]
end

function LANG.GetLanguageTable( lang_name )
	lang_name = lang_name or LANG.ActiveLanguage

	local cpy = table.Copy( LANG.Strings[ lang_name ] )

	SetFallback( cpy )

	return cpy
end

local function SetFallback( tbl )
	local m = getmetatable( tbl )

	if ( m and m.__index ) then
		return
	end

	setmetatable( tbl, {
		__index = cached_default
	} )
end

function LANG.SetActiveLanguage( lang_name )
	lang_name = lang_name and string.lower( lang_name )

	if ( LANG.IsLanguage( lang_name ) ) then
		local old_name = LANG.ActiveLanguage

		LANG.ActiveLanguage = lang_name
		cached_active = LANG.Strings[ lang_name ]

		SetFallback( cached_active )

		if ( old_name != lang_name ) then
			hook.Call( 'DMLanguageChanged', GAMEMODE, old_name, lang_name )

			if ( DMCommandsTable != nil ) then
				dmBuildCmd()
			end
		end
	else
		MsgN( Format( "The language '%s' does not exist on this server. Falling back to English...", lang_name ) )

		if ( lang_name != LANG.DefaultLanguage ) then
			LANG.SetActiveLanguage( LANG.DefaultLanguage )
		end
	end
end

function LANG.Init()
	local lang_name = GetConVarString( 'dm_language' )

	if ( LANG.IsServerDefault( lang_name ) ) then
		lang_name = LANG.ServerLanguage
	end

	LANG.SetActiveLanguage( lang_name )
end

function LANG.IsServerDefault( lang_name )
	lang_name = string.lower( lang_name )

	return ( lang_name == 'server default' ) or ( lang_name == 'auto' )
end

function LANG.IsLanguage( lang_name )
	lang_name = lang_name and string.lower( lang_name )

	return LANG.Strings[ lang_name ]
end

local function LanguageChanged( cv, old, new )
	if ( new and new != LANG.ActiveLanguage ) then
		if ( LANG.IsServerDefault( new ) ) then
			new = LANG.ServerLanguage
		end

		LANG.SetActiveLanguage( new )
	end
end

cvars.AddChangeCallback( 'dm_language', LanguageChanged )

local function ForceReload()
	LANG.SetActiveLanguage( 'english' )
end

concommand.Add( 'dm_language_reload', ForceReload )

function LANG.GetLanguages()
	local langs = {}

	for lang, strings in pairs( LANG.Strings ) do
		table.insert( langs, lang )
	end

	return langs
end
