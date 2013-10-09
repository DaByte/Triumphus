if IsClient then
	return nil
end

local settings = {
	CharacterAutoLoads = true; -- A bool indicating whether the character of a player will load automatically. Use this setting in place of `Players.CharacterAutoLoads`. Defaults to `true`.
	RespawnCooldown = 5; -- A number indicating the amount of time to wait after a character dies before respawning, in seconds. Defaults to 5.
}

local function getHumanoid(character)
	local children = character:GetChildren()
	for i = 1,#children do
		if children[i]:IsA'Humanoid' then
			return children[i]
		end
	end
	return nil
end

local addedPlayers

local function Remove(player)
	if addedPlayers[player] then
		addedPlayers[player]:disconnect()
		addedPlayers[player] = nil
	end
end

local function Add(player)
	local function respawn()
		if not settings.CharacterAutoLoads then return end
		wait(settings.RespawnCooldown)
		if not settings.CharacterAutoLoads then return end
		return player:LoadCharacter()
	end

	addedPlayers[player] = player.CharacterAdded:connect(function(character)
		local humanoid = getHumanoid(character)
		if humanoid then
			humanoid.Died:connect(respawn)
		end
	end)

	if settings.CharacterAutoLoads then
		player:LoadCharacter()
	end
end

return {
	Add = Add;
	Remove = Remove;
	Settings = settings;
}
