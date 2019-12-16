defmodule NflWeb.RushingController do
  use NflWeb, :controller

  alias Nfl.Stats
  alias Nfl.Stats.Rushing

  @moduledoc """
  :query_state will be stored in the conn.assigns, in the format as the example below:
  { [player: "Tom"], [sort_by: :rushing_yards] } = {fileters, sort_rules}
  Keyword lists can hold multiple fields for both fileters and sort_rules;
  more importantly, it ensure the order of the "sort_by"s.
  """

  @type filters_t :: keyword
  @type sorts_t :: keyword(:asc | :desc)
  @type query_state_t :: nil | {filters_t, sorts_t}

  defp get_query_state(conn), do: conn.assigns[:query_state]

  defp set_query_state(conn, query_state), do: Plug.Conn.assign(conn, :query_state, query_state)

  defp revert_order(:asc), do: :desc
  defp revert_order(:desc), do: :asc

  defp new_query_state(_query_state = nil, params = %{}) when map_size(params) == 0 do
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
    query_state = new_query_state(get_query_state(conn), params)
    set_query_state(conn, query_state)
    query_state
  end

  def index(conn, params) do
    {filters, sorts} = reset_query_state(conn, params)

    rushing_data = Stats.list_rushing_data(:with_preload, filters, sorts)
    render(conn, "index.html", rushing_data: rushing_data)
  end

  def new(conn, _params) do
    changeset = Stats.change_rushing(%Rushing{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"rushing" => rushing_params}) do
    case Stats.create_rushing(rushing_params) do
      {:ok, rushing} ->
        conn
        |> put_flash(:info, "Rushing created successfully.")
        |> redirect(to: Routes.rushing_path(conn, :show, rushing))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    rushing = Stats.get_rushing!(id)
    render(conn, "show.html", rushing: rushing)
  end

  def edit(conn, %{"id" => id}) do
    rushing = Stats.get_rushing!(id)
    changeset = Stats.change_rushing(rushing)
    render(conn, "edit.html", rushing: rushing, changeset: changeset)
  end

  def update(conn, %{"id" => id, "rushing" => rushing_params}) do
    rushing = Stats.get_rushing!(id)

    case Stats.update_rushing(rushing, rushing_params) do
      {:ok, rushing} ->
        conn
        |> put_flash(:info, "Rushing updated successfully.")
        |> redirect(to: Routes.rushing_path(conn, :show, rushing))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", rushing: rushing, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    rushing = Stats.get_rushing!(id)
    {:ok, _rushing} = Stats.delete_rushing(rushing)

    conn
    |> put_flash(:info, "Rushing deleted successfully.")
    |> redirect(to: Routes.rushing_path(conn, :index))
  end
end
