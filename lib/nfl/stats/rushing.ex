defmodule Nfl.Stats.Rushing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rushing_data" do
    field :attempts, :integer
    field :attempts_per_game, :decimal
    field :first_down_percentage, :decimal
    field :first_downs, :integer
    field :forty_yards, :integer
    field :fum, :integer
    field :longest_rush, :string
    field :rushing_yards, :integer
    field :rushing_yards_per_attempt, :decimal
    field :rushing_yards_per_game, :decimal
    field :touchdowns, :integer
    field :twenty_yards, :integer
    belongs_to :player, Nfl.Entities.Player
    belongs_to :team, Nfl.Entities.Team
    belongs_to :position, Nfl.Refs.Position

    timestamps()
  end

  @doc false
  def changeset(rushing, attrs) do
    rushing
    |> cast(attrs, [
      :attempts_per_game,
      :attempts,
      :rushing_yards,
      :rushing_yards_per_attempt,
      :rushing_yards_per_game,
      :touchdowns,
      :longest_rush,
      :first_downs,
      :first_down_percentage,
      :twenty_yards,
      :forty_yards,
      :fum,
      :player_id,
      :team_id,
      :position_id
    ])
    |> validate_required([
      :attempts_per_game,
      :attempts,
      :rushing_yards,
      :rushing_yards_per_attempt,
      :rushing_yards_per_game,
      :touchdowns,
      :longest_rush,
      :first_downs,
      :first_down_percentage,
      :twenty_yards,
      :forty_yards,
      :fum,
      :player_id,
      :team_id,
      :position_id
    ])
    |> unique_constraint(:player_id)
  end

  def new(attrs), do: changeset(%__MODULE__{}, attrs)
end
