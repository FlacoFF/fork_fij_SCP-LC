SLCHooks = SLCHooks or {
	__ActiveSCPs = {},
	__PreventUpdate = false,
}

function SCPHook( scp, name, func )
	if !SLCHooks[scp] then
		SLCHooks[scp] = {}
	end

	SLCHooks[scp][name] = func
end

function EnableSCPHook( scp )
	if SLCHooks.__ActiveSCPs[scp] then return end

	local tab = SLCHooks[scp]
	if !tab then return end

	SLCHooks.__ActiveSCPs[scp] = true

	for k, v in pairs( tab ) do
		hook.Add( k, scp, v )
		//print( "hook enabled", k, scp )
	end

	if SERVER and !SLCHooks.__PreventUpdate then
		net.Start( "SLCHooks" )
			net.WriteBool( false )
			net.WriteString( scp )
		net.Broadcast()
	end
end

function DisableSCPHook( scp )
	local tab = SLCHooks[scp]
	if !tab then return end

	SLCHooks.__ActiveSCPs[scp] = nil

	for k, v in pairs( tab ) do
		hook.Remove( k, scp )
		//print( "[single] hook removed", k, scp )
	end
end

function ClearSCPHooks()
	for scp, _ in pairs( SLCHooks.__ActiveSCPs ) do
		for k, _ in pairs( SLCHooks[scp] ) do
			hook.Remove( k, scp )
			//print( "[clear] hook removed", k, scp )
		end
	end

	SLCHooks.__ActiveSCPs = {}
end

function TransmitSCPHooks( ply )
	net.Start( "SLCHooks" )
		net.WriteBool( true )
		net.WriteTable( SLCHooks.__ActiveSCPs )

	if ply then
		net.Send( ply )
	else
		net.Broadcast()
	end
end