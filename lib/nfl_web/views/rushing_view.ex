defmodule NflWeb.RushingView do
  use NflWeb, :view

  import Utils

  def view_columns,
    do: [
      "Player",
      "Team",
      "Position",
      "Rushing Yards",
      "Rushing Touchdowns",
      "Longest Rush",
      "Attempts per_game",
      "Total Attempts",
      "Rushing_Yards per_attempt",
      "Rushing_Yards per_game",
      "Rushing First_downs",
      "First_Down Percentage",
      "Twenty+ Yards",
      "Forty+ Yards",
      "Rushing Fumbles"
    ]

  def data_columns,
    do:
      [~w(player name)a, ~w(team name)a, ~w(position name)a] ++
        ~w(rushing_yards touchdowns longest_rush attempts_per_game attempts rushing_yards_per_attempt
         rushing_yards_per_game first_downs first_down_percentage twenty_yards forty_yards fum)a

  def data_column(view_column),
    do: Enum.at(data_columns(), Enum.find_index(view_columns(), &(&1 == view_column)))

  def sort_sign(:asc), do: "↑"

  def sort_sign(:desc), do: "↓"

  def sort_sign(conn, field) do
    {_, sorts} = Plug.Conn.get_session(conn, :query_state)

    case sorts do
      [{^field, order} | _] -> sort_sign(order)
      _ -> ""
    end
  end

  def filter_value(conn, field) do
    {filters, _} = Plug.Conn.get_session(conn, :query_state)

    IO.inspect(filters, label: "filters")

    case Enum.find(filters, &match?({^field, _}, &1)) do
      {_, v} -> v
      nil -> ""
    end
  end
end
