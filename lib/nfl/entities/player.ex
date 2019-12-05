defmodule Nfl.Entities.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def new(attrs) do
    changeset(%__MODULE__{}, attrs)
  end
end
