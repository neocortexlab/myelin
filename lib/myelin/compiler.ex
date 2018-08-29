defmodule Myelin.Compiler do
  alias Cmd.Utils

  def compile_file(agent_name) do
    with {:ok, src} <- Utils.read_agent_source(agent_name) do
      {:ok, compile(src)}
    end
  end

  def compile_template(template_name, address) do
    with {:ok, tmpl} <- Utils.read_agent_source(template_name) do
      code =
        tmpl
        |> Utils.insert_address(address)
        |> compile()
      {:ok, code}
    end
  end

  def compile(agent_source) do
    """
      defmodule Agents do
        import Myelin.Agent

        #{agent_source}
      end
    """
    |> Code.compile_string()
    |> cleanup()
    |> Keyword.delete(Agents)
    |> fetch_agent_code()
    |> Crypto.to_hex()
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

  defp fetch_agent_code([{_module, code}]), do: code
end
