defmodule NflWeb.RushingControllerTest do
  use NflWeb.ConnCase

  alias Nfl.Stats

  @create_attrs %{attempts: 42, attempts_per_game: "120.5", first_down_percentage: "120.5", first_downs: 42, forty_yards: 42, fum: 42, longest_rush: 42, rushing_yards: 42, rushing_yards_per_attempt: "120.5", rushing_yards_per_game: "120.5", touchdowns: 42, twenty_yards: 42}
  @update_attrs %{attempts: 43, attempts_per_game: "456.7", first_down_percentage: "456.7", first_downs: 43, forty_yards: 43, fum: 43, longest_rush: 43, rushing_yards: 43, rushing_yards_per_attempt: "456.7", rushing_yards_per_game: "456.7", touchdowns: 43, twenty_yards: 43}
  @invalid_attrs %{attempts: nil, attempts_per_game: nil, first_down_percentage: nil, first_downs: nil, forty_yards: nil, fum: nil, longest_rush: nil, rushing_yards: nil, rushing_yards_per_attempt: nil, rushing_yards_per_game: nil, touchdowns: nil, twenty_yards: nil}

  def fixture(:rushing) do
    {:ok, rushing} = Stats.create_rushing(@create_attrs)
    rushing
  end

  describe "index" do
    test "lists all rushing_data", %{conn: conn} do
      conn = get(conn, Routes.rushing_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Rushing data"
    end
  end

  describe "new rushing" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.rushing_path(conn, :new))
      assert html_response(conn, 200) =~ "New Rushing"
    end
  end

  describe "create rushing" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.rushing_path(conn, :create), rushing: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.rushing_path(conn, :show, id)

      conn = get(conn, Routes.rushing_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Rushing"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.rushing_path(conn, :create), rushing: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Rushing"
    end
  end

  describe "edit rushing" do
    setup [:create_rushing]

    test "renders form for editing chosen rushing", %{conn: conn, rushing: rushing} do
      conn = get(conn, Routes.rushing_path(conn, :edit, rushing))
      assert html_response(conn, 200) =~ "Edit Rushing"
    end
  end

  describe "update rushing" do
    setup [:create_rushing]

    test "redirects when data is valid", %{conn: conn, rushing: rushing} do
      conn = put(conn, Routes.rushing_path(conn, :update, rushing), rushing: @update_attrs)
      assert redirected_to(conn) == Routes.rushing_path(conn, :show, rushing)

      conn = get(conn, Routes.rushing_path(conn, :show, rushing))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, rushing: rushing} do
      conn = put(conn, Routes.rushing_path(conn, :update, rushing), rushing: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Rushing"
    end
  end

  describe "delete rushing" do
    setup [:create_rushing]

    test "deletes chosen rushing", %{conn: conn, rushing: rushing} do
      conn = delete(conn, Routes.rushing_path(conn, :delete, rushing))
      assert redirected_to(conn) == Routes.rushing_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.rushing_path(conn, :show, rushing))
      end
    end
  end

  defp create_rushing(_) do
    rushing = fixture(:rushing)
    {:ok, rushing: rushing}
  end
end
