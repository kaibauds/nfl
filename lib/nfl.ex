defmodule Nfl do
  alias Nfl.Repo
  import Ecto.Query

  @moduledoc """
  Nfl keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def name_id_map(schema) do
    schema |> select([p], {p.name, p.id}) |> Repo.all() |> Map.new()
  end
end
