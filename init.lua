local playerdata = {}
local teams = {"blue", "orange"} -- Avaitable teams

local number_of_members = {}

local function set_team(player, team)
	local name = player:get_player_name()
	local skin = "tag_game_player_" .. team .. ".png"
	default.player_set_textures(player, {skin})
	player:set_nametag_attributes({color = team})
	playerdata[name].team = team
	number_of_members[team] = number_of_members[team] + 1
end

function reset_plyer_counter()
	for _, team in pairs(teams) do
		number_of_members[team] = 0
	end
end
reset_plyer_counter()

local function write_stat(team1, team2)
	minetest.chat_send_all("Number of members in the " .. team1 .. " team: " .. number_of_members[team1])
	minetest.chat_send_all("Number of members in the " .. team2 .. " team: " .. number_of_members[team2])
end

local function new_game()
	minetest.chat_send_all("New game!")
	reset_plyer_counter()
	for _, player in pairs(minetest.get_connected_players()) do
		local team_id = math.random(#teams)
		local team = teams[team_id]
		set_team(player, team)
	end
	write_stat(teams[1], teams[2])
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if not playerdata[name] then
			playerdata[name] = {}
	end

	local team_id = math.random(#teams)
	local team = teams[team_id]
	set_team(player, team)
end)

minetest.register_on_punchplayer(function(player, hitter)
	local puncher_team = playerdata[hitter:get_player_name()].team
	local player_team = playerdata[player:get_player_name()].team
	print(puncher_team .. "; " .. player_team)
	if player_team == puncher_team then
		if number_of_members[player_team] <= 0 or number_of_members[puncher_team] <=0 then -- this is just a precaution
			new_game()
		end
		return
	end
	set_team(player, puncher_team)
	number_of_members[player_team] = number_of_members[player_team] - 1

	if number_of_members[player_team] <= 0 then
		new_game()
		return
	end

	write_stat(teams[1], teams[2])
end)
