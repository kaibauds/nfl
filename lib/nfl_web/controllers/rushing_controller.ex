defmodule NflWeb.RushingController do
  use NflWeb, :controller

  alias Nfl.Stats
  alias Nfl.Stats.Rushing

  import Utils

  @moduledoc """
  :query_state will be stored in the session, in the format as the example below:
  { [player: "Tom"], [sort_by: :rushing_yards] }

  Keyword lists can hold multiple fields for both fileters and sorts; more importantly,
  it ensure the order of the sorts, which is why it shouldn't be stored in a map.
  """

  @type filters_t :: keyword
  @type sorts_t :: keyword(:asc | :desc)
  @type query_state_t :: nil | {filters_t, sorts_t}

  def get_query_state(conn), do: Plug.Conn.get_session(conn, :query_state)

  def set_query_state(conn, query_state),
    do: Plug.Conn.put_session(conn, :query_state, query_state)

  defp revert_order(:asc), do: :desc
  defp revert_order(:desc), do: :asc

  defp new_query_state(_query_state = nil, params = %{}) when map_size(params) == 0 do
    {Keyword.new(), Keyword.new()}
  end

  defp new_query_state(_query_state = nil, params = %{"_utf8" => _}) when map_size(params) == 1 do
    {Keyword.new(), Keyword.new()}
  end

  defp new_query_state(query_state, params = %{"sort_by" => sort_field_name})
       when map_size(params) == 1 do
    {filters, sorts} =
      case query_state do
        nil -> {Keyword.new(), Keyword.new()}
        v -> v
      end

    sort_field = String.to_atom(sort_field_name)
    {last_direction, other_sorts} = Keyword.pop(sorts, sort_field, :desc)
    new_sorts = [{sort_field, revert_order(last_direction)} | other_sorts]
    {filters, new_sorts}
  end

  defp new_query_state(query_state, params = %{}) do
    {filters, sorts} =
      case query_state do
        nil -> {Keyword.new(), Keyword.new()}
        v -> v
      end

    new_filters =
      Keyword.merge(
        filters,
        Enum.map(params, fn {field_name, v} -> {String.to_atom(field_name), v} end)
      )

    {new_filters, sorts}
  end

  defp reset_query_state(conn, params) do
    last_query_state = get_query_state(conn)
    query_state = new_query_state(last_query_state, params)
    new_conn = set_query_state(conn, query_state)
    {new_conn, query_state}
  end

  def index(conn, params) do
    {new_conn, {filters, sorts}} = reset_query_state(conn, params)

    rushing_data = Stats.list_rushing_data(:with_preload, filters, sorts)

    render(new_conn, "index.html", rushing_data: rushing_data)
  end

  def download(conn, _params) do
    {filters, sorts} = get_query_state(conn)

    rushing_data = Stats.list_rushing_data(:with_preload, filters, sorts)

    rushing_data_csv =
      [view_module(conn).view_columns()]
      |> Stream.concat(
        rushing_data
        |> Stream.map(fn row ->
          Enum.reduce(
            view_module(conn).data_columns(),
            [],
            &[
              case &1 do
                :longest_rush -> view_module(conn).longest_rush_text(row)
                _ -> v(row, &1)
              end
              | &2
            ]
          )
          |> Enum.reverse()
          |> Stream.map(&to_string(&1))
        end)
      )
      |> CSV.encode()
      |> Enum.map(& &1)

    send_download(conn, {:binary, rushing_data_csv}, filename: "rushing_data.csv")
  end
end
