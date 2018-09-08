defmodule Myelin.Compiler do

  @agent_module :myelin
                |> :code.priv_dir()
                |> Path.join("agent_module.ex")
                |> File.read!()

  def compile_agent(agent_code, address) do
    agent_code
    |> agent_module(address)
    |> compile(address)
  end

  defp agent_module(code, address) do
    @agent_module
    |> String.replace("{{module}}", address |> String.to_atom() |> inspect())
    |> String.replace("{{address}}", address)
    |> String.replace("{{code}}", code)
  end

  defp compile(module_source, address) do
    try do
      code =
        module_source
        |> Code.compile_string()
        |> cleanup()
        |> Keyword.get(String.to_atom(address))

      {:ok, code}
    rescue
      error ->
        {:error, error}
    end
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
