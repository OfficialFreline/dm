if ( LANG ) then
	return
end

LANG = {}

DM.Include( 'lang_cl.lua' )

local dir = ( GM.FolderName or 'dm' ) .. '/gamemode/config/languages/'
local files = file.Find( dir .. '*.lua', 'LUA' )

for _, fname in ipairs( files ) do
	local path = dir .. fname

	if ( string.Right( fname, 3 ) == 'lua' ) then
		DM.Include( path )

		MsgN( 'Included DM language file: ' .. fname )
   end
end

if ( SERVER ) then
	local count = table.Count

	function LANG.Msg( arg1, arg2 )
		if ( isstring( arg1 ) ) then
			LANG.ProcessMsg( nil, arg1, arg2 )
		else
			LANG.ProcessMsg( arg1, arg2 )
		end
   end

	function LANG.ProcessMsg( send_to, name, params )
		if ( type( send_to ) == 'Player' and not IsValid( send_to ) ) then
			return
		end

		local c = params and count( params ) or 0

		net.Start( 'DM_LangMsg' )
		net.WriteString( name )
		net.WriteUInt( c, 8 )

		if c > 0 then
			for k, v in pairs( params ) do
				net.WriteString( k )
				net.WriteString( tostring( v ) )
			end
		end

		if ( send_to ) then
			net.Send( send_to )
		else
			net.Broadcast()
		end
	end

	function LANG.MsgAll( name, params )
		LANG.Msg( nil, name, params )
	end

	CreateConVar( 'dm_lang_serverdefault', 'english', FCVAR_ARCHIVE )

	local function ServerLangRequest( ply, cmd, args )
		if ( not IsValid( ply ) ) then
			return
		end

		net.Start( 'DM_ServerLang' )
			net.WriteString( GetConVarString( 'dm_lang_serverdefault' ) )
		net.Send( ply )
	end

	concommand.Add( '_dm_request_serverlang', ServerLangRequest )
else
	local function RecvMsg()
		local name = net.ReadString()
		local c = net.ReadUInt( 8 )
		local params = nil

		if c > 0 then
			params = {}

			for i = 1, c do
				params[ net.ReadString() ] = net.ReadString()
			end
		end

		LANG.Msg( name, params )
	end

   net.Receive( 'DM_LangMsg', RecvMsg )

   LANG.Msg = LANG.ProcessMsg

	local function RecvServerLang()
		local lang_name = net.ReadString()

		lang_name = lang_name and string.lower( lang_name )

		if ( LANG.Strings[ lang_name ] ) then
			if ( LANG.IsServerDefault( GetConVarString( 'dm_language' ) ) ) then
				LANG.SetActiveLanguage( lang_name )
			end

			LANG.ServerLanguage = lang_name

			print( 'Server default language is:', lang_name )
		end
	end

	net.Receive( 'DM_ServerLang', RecvServerLang )
end

function LANG.NameParam( name )
	return 'LID\t' .. name
end

LANG.Param = LANG.NameParam

function LANG.GetNameParam( text )
	return string.match( text, '^LID\t([%w_]+)$' )
end
