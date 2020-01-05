defmodule Nfl.StatsTest do
  use Nfl.DataCase

  alias Nfl.Stats

  describe "rushing_data" do
    alias Nfl.Stats.Rushing

    @valid_attrs %{
      attempts: 42,
      attempts_per_game: "120.5",
      first_down_percentage: "120.5",
      first_downs: 42,
      forty_yards: 42,
      fum: 42,
      longest_rush: 42,
      rushing_yards: 42,
      rushing_yards_per_attempt: "120.5",
      rushing_yards_per_game: "120.5",
      touchdowns: 42,
      twenty_yards: 42
    }
    @update_attrs %{
      attempts: 43,
      attempts_per_game: "456.7",
      first_down_percentage: "456.7",
      first_downs: 43,
      forty_yards: 43,
      fum: 43,
      longest_rush: 43,
      rushing_yards: 43,
      rushing_yards_per_attempt: "456.7",
      rushing_yards_per_game: "456.7",
      touchdowns: 43,
      twenty_yards: 43
    }
    @invalid_attrs %{
      attempts: nil,
      attempts_per_game: nil,
      first_down_percentage: nil,
      first_downs: nil,
      forty_yards: nil,
      fum: nil,
      longest_rush: nil,
      rushing_yards: nil,
      rushing_yards_per_attempt: nil,
      rushing_yards_per_game: nil,
      touchdowns: nil,
      twenty_yards: nil
    }

    def rushing_fixture(attrs \\ %{}) do
      {:ok, rushing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stats.create_rushing()

      rushing
    end

    test "list_rushing_data/0 returns all rushing_data" do
      rushing = rushing_fixture()
      assert Stats.list_rushing_data() == [rushing]
    end

    test "get_rushing!/1 returns the rushing with given id" do
      rushing = rushing_fixture()
      assert Stats.get_rushing!(rushing.id) == rushing
    end

    test "create_rushing/1 with valid data creates a rushing" do
      assert {:ok, %Rushing{} = rushing} = Stats.create_rushing(@valid_attrs)
      assert rushing.attempts == 42
      assert rushing.attempts_per_game == Decimal.new("120.5")
      assert rushing.first_down_percentage == Decimal.new("120.5")
      assert rushing.first_downs == 42
      assert rushing.forty_yards == 42
      assert rushing.fum == 42
      assert rushing.longest_rush == 42
      assert rushing.rushing_yards == 42
      assert rushing.rushing_yards_per_attempt == Decimal.new("120.5")
      assert rushing.rushing_yards_per_game == Decimal.new("120.5")
      assert rushing.touchdowns == 42
      assert rushing.twenty_yards == 42
    end

    test "create_rushing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stats.create_rushing(@invalid_attrs)
    end

    test "update_rushing/2 with valid data updates the rushing" do
      rushing = rushing_fixture()
      assert {:ok, %Rushing{} = rushing} = Stats.update_rushing(rushing, @update_attrs)
      assert rushing.attempts == 43
      assert rushing.attempts_per_game == Decimal.new("456.7")
      assert rushing.first_down_percentage == Decimal.new("456.7")
      assert rushing.first_downs == 43
      assert rushing.forty_yards == 43
      assert rushing.fum == 43
      assert rushing.longest_rush == 43
      assert rushing.rushing_yards == 43
      assert rushing.rushing_yards_per_attempt == Decimal.new("456.7")
      assert rushing.rushing_yards_per_game == Decimal.new("456.7")
      assert rushing.touchdowns == 43
      assert rushing.twenty_yards == 43
    end

    test "update_rushing/2 with invalid data returns error changeset" do
      rushing = rushing_fixture()
      assert {:error, %Ecto.Changeset{}} = Stats.update_rushing(rushing, @invalid_attrs)
      assert rushing == Stats.get_rushing!(rushing.id)
    end

    test "delete_rushing/1 deletes the rushing" do
      rushing = rushing_fixture()
      assert {:ok, %Rushing{}} = Stats.delete_rushing(rushing)
      assert_raise Ecto.NoResultsError, fn -> Stats.get_rushing!(rushing.id) end
    end

    test "change_rushing/1 returns a rushing changeset" do
      rushing = rushing_fixture()
      assert %Ecto.Changeset{} = Stats.change_rushing(rushing)
    end
  end
end
