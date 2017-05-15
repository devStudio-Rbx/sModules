--// Initialization

local PlayerService	= game:GetService("Players")
local TeamService	= game:GetService("Teams")

local Module		= {}

--// Functions

function Module.IsTeamMate(PlayerOne, PlayerTwo)
	--/ Returns if PlayerOne and PlayerTwo are on the same team
	
	return PlayerOne.Team == PlayerTwo.Team
end

function Module.GetPlayersWithinRadius(Position, Radius, PlayerList)
	PlayerList = PlayerList or PlayerService:GetPlayers()
	local PlayersFound = {}
	
	for PlayerIndex, Player in next, PlayerList do
		if Player.Character then
			if Player.Character:FindFirstChild("HumanoidRootPart") then
				if (Player.Character.HumanoidRootPart.Position - Position).magnitude <= Radius then
					table.insert(PlayersFound, Player)
				end
			else
				warn(Player.Name .. " does not have a HumanoidRootPart and cannot be checked for Position")
				debug.traceback()
			end
		else
			warn(Player.Name .. " does not have a character and cannot be checked for Position")
			debug.traceback()
		end
	end
	
	return PlayersFound
end

function Module.GetObjectOwner(Descendant)
	--/ Returns the Player and Character that the Descendant is part of
	
	assert(typeof(Descendant) == "Instance", "Descendant must be an Instance")
	
	local Character = Descendant
	local Player
	
	repeat
		if Character.Parent then
			Character = Character.Parent
			Player = PlayerService:GetPlayerFromCharacter(Character)
		else
			return nil
		end
	until Player

	return Character, Player
end

return Module
