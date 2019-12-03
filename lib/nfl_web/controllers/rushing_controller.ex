defmodule NflWeb.RushingController do
  use NflWeb, :controller

  alias Nfl.Stats
  alias Nfl.Stats.Rushing

  def index(conn, _params) do
    rushing_data = Stats.list_rushing_data()
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
