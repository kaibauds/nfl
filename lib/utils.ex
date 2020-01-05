defmodule Utils do
  @doc """
  Gets the value of a map field, whereas the map itself
  can be a field of outer map.
  For example,there is a schema struct:

  m= %Rushing{rushing_distance: 100, player: %Player{name: "John"}}

  v(m, :rushing_distance) = 100
  v(m, [:player, :name]) = "John"
  """

  def v(struct = %{}, fields = [_ | _]) do
    Enum.reduce(fields, struct, &Map.get(&2, &1, %{}))
  end

  def v(struct = %{}, field) when is_atom(field) do
    Map.get(struct, field)
  end
end
