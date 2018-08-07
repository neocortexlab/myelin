defmodule Cmd.Build do
  @moduledoc """
  Builds Myelin agents.

  ## Usage:
      myelin build
  """

  @agents_dir "agents"

  def run([]), do: build_agents()

  def run(_), do: IO.puts(@moduledoc)

  defp build_agents do
    case File.ls(@agents_dir) do
      {:error, :enoent} ->
        print "Run this command from the myelin project folder"

      {:ok, agent_files} ->
        for agent_file <- agent_files, do: build(agent_file)
    end
  end

  defp build(agent_file) do
    print "Building agent from #{agent_file}"
    # TODO: fetch real agent address
    address = "TODO"
    @agents_dir
    |> Path.join(agent_file)
    |> File.read!()
    |> gen_code()
    |> compile(address)
  end

  defp gen_code(agent_code) do
    """
    defmodule Agents do
      import Myelin.Agent

      #{agent_code}
    end
    """
  end

  defp compile(code, address) do
    code
    |> Code.compile_string()
    |> Keyword.get(String.to_atom("Elixir." <> address))
    |> Crypto.to_hex()
  end

  defp print(msg), do: IO.puts(msg)
end
