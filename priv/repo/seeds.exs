# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

alias Nfl.Entities.{Player, Team}
alias Nfl.Refs.Position
alias Nfl.Stats
alias Nfl.Stats.Rushing

@stats_key_mapping %{
  "1st" => :first_downs,
  "1st%" => :first_down_percentage,
  "20+" => :twenty_yards,
  "40+" => :forty_yards,
  "Att" => :attempts,
  "Att/G" => :attempts_per_game,
  "Avg" => :rushing_yards_per_attempt,
  "FUM" => :fum,
  "Lng" => :longest_rush,
  "Player" => :player,
  "Pos" => :position,
  "TD" => :touchdowns,
  "Team" => :team,
  "Yds" => :rushing_yards,
  "Yds/G" => :rushing_yards_per_game
}

@doc "transform a raw map that represent an entry of rushing data to the schema map"

rushing_data_from_raw= fn rushing_data_raw ->
  rushing_data_raw
  |> Enum.map(fn {key_raw, value} -> {@stats_key_mapping[key_raw], value} end)
  |> Map.new()
end

raw_data_map_list =
  "./priv/repo/rushing.json"
  |> File.read!()
  |> Jason.decode!()

raw_data_map_list
|> Stream.map(&%{name: &1["Player"]})
|> Stream.reject(&is_nil(&1.name))
|> Enum.each(&Nfl.Repo.insert!(Player.new(&1), on_conflict: :nothing))

player_name_id_map = Nfl.name_id_map(Player)

raw_data_map_list
|> Stream.map(&%{name: &1["Team"]})
|> Stream.reject(&is_nil(&1.name))
|> Enum.each(&Nfl.Repo.insert!(Team.new(&1), on_conflict: :nothing))

team_name_id_map = Nfl.name_id_map(Team)

raw_data_map_list
|> Stream.map(&%{name: &1["Pos"]})
|> Stream.reject(&is_nil(&1.name))
|> Enum.each(&Nfl.Repo.insert!(Position.new(&1), on_conflict: :nothing))

position_name_id_map = Nfl.name_id_map(Position)

replace_name_with_id = fn data_map ->
  data_map
  |> Stream.map(
    &case &1 do
      {:player, name} -> {:player_id, player_name_id_map[name]}
      {:team, name} -> {:team_id, team_name_id_map[name]}
      {:position, name} -> {:position_id, position_name_id_map[name]}
      _ -> &1
    end
  )
  |> Map.new()
end

# the functions "with_td?" and "remove_td" will be used later to parse
# the "longest_rush" field and format the 2 columns split out of it
# an example of "longest_rush" value: "55T", in which the "T" means
# the "touch down" happened.

with_td? = fn
  x when is_integer(x) -> false
  x -> String.contains?(x, "T")
end

remove_td = fn
  x when is_integer(x) -> x
  x -> x |> String.trim() |> String.replace("T", "") |> String.to_integer()
end

# "format_number" will convert a vaule, when it's a comma separated number,
# such as "999,999", into number 999999

format_number = fn
  v when is_bitstring(v) -> v |> String.replace(",", "") |> String.to_integer()
  v -> v
end

raw_data_map_list
|> Stream.map(&(rushing_data_from_raw.(&1) |> replace_name_with_id.()))
|> Stream.map(
  &(&1
    |> Map.update!(:rushing_yards, fn v -> format_number.(v) end)
    |> Map.put(:longest_rush_td, with_td?.(&1.longest_rush))
    |> Map.update!(:longest_rush, fn v -> remove_td.(v) end))
)
|> Enum.each(&Nfl.Repo.insert!(Rushing.new(&1), on_conflict: :nothing))
