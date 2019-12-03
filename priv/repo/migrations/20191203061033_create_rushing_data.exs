defmodule Nfl.Repo.Migrations.CreateRushingData do
  use Ecto.Migration

  def change do
    create table(:rushing_data) do
      add :attempts_per_game, :decimal
      add :attempts, :integer
      add :rushing_yards, :integer
      add :rushing_yards_per_attempt, :decimal
      add :rushing_yards_per_game, :decimal
      add :touchdowns, :integer
      add :longest_rush, :integer
      add :first_downs, :integer
      add :first_down_percentage, :decimal
      add :twenty_yards, :integer
      add :forty_yards, :integer
      add :fum, :integer
      add :player_id, references(:players, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)
      add :position_id, references(:positions, on_delete: :nothing)

      timestamps()
    end

    create index(:rushing_data, [:player_id])
    create index(:rushing_data, [:team_id])
    create index(:rushing_data, [:position_id])
  end
end
