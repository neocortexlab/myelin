defmodule Myelin.Agent do
  defmacro agent(address, do: block) do
    quote do
      defmodule unquote(String.to_atom("Elixir." <> address)) do
        alias Pallium.Env

        @self unquote(address)

        defp start_process(fun) do
          Env.start_process(@self, fun)
        end

        unquote(block)
      end
    end
  end
end
