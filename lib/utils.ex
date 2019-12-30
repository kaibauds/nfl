defmodule Utils do
  def v(struct, fields = [_ | _]) do
    # Enum.reduce(fields, struct, & &2[&1])
    Enum.reduce(fields, struct, &Map.get(&2, &1))
  end

  def v(struct, field) when is_atom(field) do
    Map.get(struct, field)
  end
end
