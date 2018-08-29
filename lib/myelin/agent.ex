defmodule Myelin.Agent do
  defmacro agent(address, do: block) do
    quote do
      defmodule unquote(String.to_atom("Elixir." <> address)) do
        alias Pallium.Env

        @self unquote(address)

        defp start_process(fun), do: Env.start_process(@self, fun)

        defp get_value(key), do: Env.get_value(@self, key)

        defp set_value(key, value), do: Env.set_value(@self, key, value)

        defp set_state(state), do: Env.set_state(@self, state)

        unquote(block)
      end
    end
  end
end
