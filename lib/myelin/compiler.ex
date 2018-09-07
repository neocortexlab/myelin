defmodule Myelin.Compiler do
  alias Cmd.Utils

  @agent_template """
    defmodule {{module}} do
      import Myelin.Agent
      alias Pallium.Env

      @self "{{address}}"

      def start_task(agent, task), do: Env.start_task(@self, agent, task)
      def get_value(key), do: Env.get_value(@self, key)
      def set_value(key, value), do: Env.set_value(@self, key, value)
      def set_state(state), do: Env.set_state(@self, state)

      {{code}}
    end
  """

  def compile_file(agent_name, address) do
    with {:ok, src} <- Utils.read_agent_source(agent_name) do
      {:ok, compile(src, address)}
    end
  end

  def compile_template(template_name, address) do
    with {:ok, tmpl} <- Utils.read_agent_source(template_name) do
      code =
        tmpl
        |> Utils.insert_address(address)
        |> compile(address)
      {:ok, code}
    end
  end

  def compile(agent_source, address) do
    @agent_template
    |> String.replace("{{module}}", address |> String.to_atom() |> inspect())
    |> String.replace("{{address}}", address)
    |> String.replace("{{code}}", agent_source)
    |> Code.compile_string()
    |> cleanup()
    |> Keyword.get(String.to_atom(address))
  end

  defp cleanup(compiled) do
    compiled
    |> Keyword.keys()
    |> purge_modules()

    compiled
  end

  defp purge_modules([]), do: :ok
  defp purge_modules([mod | rest]) do
    :code.purge(mod)
    :code.delete(mod)
    purge_modules(rest)
  end
end
