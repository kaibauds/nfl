defmodule NflWeb.RushingView do
  use NflWeb, :view

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
