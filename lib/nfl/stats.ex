defmodule Nfl.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false
  alias Nfl.Repo

  alias Nfl.Stats.Rushing
  alias Nfl.Entities.Player

  defp apply_filters_and_sorts(query, _query_state = {filters, sorts}) do
    add_filter_to_query = fn {field, v}, query ->
      case field do
        :player_name ->
          query
          |> where(
            [rushing, player],
            ilike(player.name, ^"#{v}%") or ilike(player.name, ^"% #{v}%")
          )

        # be noticed that certain parameter can be added be the framework by default
        :_utf8 ->
          query

        # extension to search by multiple fields
        _field ->
          # query |> where(^[{_field, v}])
          query
      end
    end

    flip = fn {a, b} -> {b, a} end
    order_by_list = Enum.map(sorts, &flip.(&1))

    Enum.reduce(filters, query, &add_filter_to_query.(&1, &2)) |> order_by(^order_by_list)
  end

  @doc """
  Returns the list of rushing_data.
  """
  def list_rushing_data do
    Repo.all(Rushing)
  end

  def list_rushing_data(:with_preload) do
    Rushing
    |> preload([:player, :team, :position])
    |> Repo.all()
  end

  def list_rushing_data_query(
        :with_preload,
        filters,
        sorts
      ) do
    Rushing
    |> join(:inner, [r], p in Player, on: r.player_id == p.id)
    |> apply_filters_and_sorts({filters, sorts})
    |> preload([:player, :team, :position])
  end

  def list_rushing_data(
        :with_preload,
        filters,
        sorts
      ) do
    list_rushing_data_query(:with_preload, filters, sorts)
    |> Repo.all()
  end

  @doc """
  Gets a single rushing.

  Raises `Ecto.NoResultsError` if the Rushing does not exist.

  ## Examples

      iex> get_rushing!(123)
      %Rushing{}

      iex> get_rushing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rushing!(id), do: Repo.get!(Rushing, id)

  @doc """
  Creates a rushing.

  ## Examples

      iex> create_rushing(%{field: value})
      {:ok, %Rushing{}}

      iex> create_rushing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rushing(attrs \\ %{}) do
    %Rushing{}
    |> Rushing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rushing.

  ## Examples

      iex> update_rushing(rushing, %{field: new_value})
      {:ok, %Rushing{}}

      iex> update_rushing(rushing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rushing(%Rushing{} = rushing, attrs) do
    rushing
    |> Rushing.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Rushing.

  ## Examples

      iex> delete_rushing(rushing)
      {:ok, %Rushing{}}

      iex> delete_rushing(rushing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rushing(%Rushing{} = rushing) do
    Repo.delete(rushing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rushing changes.

  ## Examples

      iex> change_rushing(rushing)
      %Ecto.Changeset{source: %Rushing{}}

  """
  def change_rushing(%Rushing{} = rushing) do
    Rushing.changeset(rushing, %{})
  end
end
