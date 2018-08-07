defmodule Myelin.Agent do
  defmacro agent(address, do: block) do
    quote do
      defmodule unquote(String.to_atom("Elixir." <> address)) do
        @self unquote(address)
        unquote(block)
      end
    end
  end
end
