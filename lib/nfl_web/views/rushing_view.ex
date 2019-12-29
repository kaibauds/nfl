defmodule NflWeb.RushingView do
  use NflWeb, :view

  def view_columns do
    ~w(Player Team Position Total_Rushing_Yards Total_Rushing_Touchdowns Longest_Rush
       Attempt/game Attempts Rushing_Yards/attempt Rushing_Yards/game First_Downs
       First_Downs% Twenty_Yards Forty_Yards Fum)
  end

  def data_columns do
    [[:player, :name], [:team, :name], [:position, :name]] ++
      ~w(rushing_yards touchdowns longest_rush attempts_per_game attempts rushing_yards_per_attempt
         rushing_yards_per_game first_downs first_down_percentage twenty_yards forty_yards fum)a
  end

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
