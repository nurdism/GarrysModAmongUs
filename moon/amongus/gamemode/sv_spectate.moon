GM.SpectateMap = {}

GM.Spectate_CycleEntity = (ply, delta = 0) =>
	pool = {}
	local cur, first
	for i, otherPly in ipairs player.GetAll!
		if ply ~= otherPly and otherPly\Alive! and otherPly\GetObserverMode! > 0
			table.insert pool, otherPly

	@SpectateMap[ply] = (((@SpectateMap[ply] or 1) + delta - 1) % #pool) + 1

	if ply\GetObserverMode! == OBS_MODE_ROAMING
		ply\Spectate OBS_MODE_CHASE

	ply\SpectateEntity pool[@SpectateMap[ply]]

GM.Spectate_CycleMode = (ply) =>
	current = ply\GetObserverMode!

	switch current
		when OBS_MODE_ROAMING
			ply\Spectate OBS_MODE_CHASE

		when OBS_MODE_CHASE
			ply\Spectate OBS_MODE_IN_EYE

		when OBS_MODE_IN_EYE
			ply\Spectate OBS_MODE_ROAMING

		else
			ply\Spectate OBS_MODE_ROAMING

hook.Add "KeyPress", "NMW AU Spectate Cycle", (ply, key) ->
	if ply\GetObserverMode! > 0
		switch key
			when IN_ATTACK
				GAMEMODE\Spectate_CycleEntity ply, 1
			when IN_ATTACK2
				GAMEMODE\Spectate_CycleEntity ply, -1
			when IN_JUMP
				GAMEMODE\Spectate_CycleMode ply
			when IN_DUCK
				ply\Spectate OBS_MODE_ROAMING

GM.__specInitialized = {}
hook.Add "PlayerSpawn", "NMW AU Spec", (ply) ->
	if not GAMEMODE.__specInitialized[ply]
		GAMEMODE.__specInitialized[ply] = true
		if GAMEMODE\IsGameInProgress!
			GAMEMODE\Player_Hide ply
			GAMEMODE\Spectate_CycleMode ply
