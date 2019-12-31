# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Nfl.Repo.insert!(%Nfl.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Nfl.Entities.{Player, Team}
alias Nfl.Refs.Position
alias Nfl.Stats
alias Nfl.Stats.Rushing

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

with_td? = fn
  x when is_integer(x) -> false
  x -> String.contains?(x, "T")
end

remove_td = fn
  x when is_integer(x) -> x
  x -> x |> String.trim() |> String.replace("T", "") |> String.to_integer()
end

format_number = fn
  v when is_bitstring(v) -> v |> String.replace(",", "") |> String.to_integer()
  v -> v
end

raw_data_map_list
|> Stream.map(&(Stats.rushing_data_from_raw(&1) |> replace_name_with_id.()))
|> Stream.map(
  &(&1
    |> Map.update!(:rushing_yards, fn v -> format_number.(v) end)
    |> Map.put(:longest_rush_td, with_td?.(&1.longest_rush))
    |> Map.update!(:longest_rush, fn v -> remove_td.(v) end))
)
|> Enum.each(&Nfl.Repo.insert!(Rushing.new(&1), on_conflict: :nothing))
