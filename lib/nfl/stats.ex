defmodule Nfl.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false
  alias Nfl.Repo

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

  @doc """
  Returns the list of rushing_data.

  ## Examples

      iex> list_rushing_data()
      [%Rushing{}, ...]

  """
  def list_rushing_data do
    Repo.all(Rushing)
  end

  def list_rushing_data_with_preload do
    Rushing
    |> preload([:player, :team, :position])
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

  @doc "transform a raw map that represent an entry of rushing data to the schema map"

  def rushing_data_from_raw(rushing_data_raw) do
    rushing_data_raw
    |> Enum.map(fn {key_raw, value} -> {@stats_key_mapping[key_raw], value} end)
    |> Map.new()
  end
end
