defmodule Myelin.Compiler do
  alias Cmd.Utils

  @agent_template :myelin
                  |> :code.priv_dir()
                  |> Path.join("agent_module.ex")
                  |> File.read!()

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
