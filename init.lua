local playerdata = {}
local teams = {"blue", "orange"} -- Avaitable teams

local number_of_members = {}
for _,team in pairs(teams) do
	number_of_members[team] = 0
end

local function set_team(player, team)
	local skin = "tag_game_player_" .. team .. ".png"
	default.player_set_textures(player, {skin})
	player:set_nametag_attributes({color = team})
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if not playerdata[name] then
			playerdata[name] = {}
	end

	local team_id = math.random(#teams)
	playerdata[name].team = teams[team_id]
	local team = playerdata[name].team
	set_team(player, team)

	number_of_members[team] = number_of_members[team] + 1
end)

minetest.register_on_punchplayer(function(player, hitter)
	local puncher_team = playerdata[hitter:get_player_name()].team
	local player_team = playerdata[player:get_player_name()].team
	print(puncher_team)
	set_team(player, puncher_team)

	if number_of_members[player_team] <= 0 then
		minetest.chat_send_all("Game ended, " .. player_team .. "won!" )
--		new_game()
	end
end)
