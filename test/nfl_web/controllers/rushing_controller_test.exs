defmodule NflWeb.RushingControllerTest do
  use NflWeb.ConnCase

  alias Nfl.Stats

  @create_attrs %{
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

  def fixture(:rushing) do
    {:ok, rushing} = Stats.create_rushing(@create_attrs)
    rushing
  end

  describe "index" do
    test "lists all rushing_data", %{conn: conn} do
      conn = get(conn, Routes.rushing_path(conn, :index))
      assert html_response(conn, 200) =~ "Nfl"
    end
  end
end
