defmodule Nfl.Repo.Migrations.SplitLongestRushField do
  use Ecto.Migration

  def change do
    alter table(:rushing_data) do
      remove :longest_rush
      add :longest_rush, :integer
      add :longest_rush_td, :boolean
    end

    create index(:rushing_data, [:rushing_yards])
    create index(:rushing_data, [:longest_rush])
    create index(:rushing_data, [:touchdowns])
  end
end
