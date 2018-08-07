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

    agent_file
    |> read_agent()
    |> compile()
    |> Crypto.to_hex()
    |> IO.inspect(label: :compiled)
  end

  defp read_agent(agent_file) do
    @agents_dir
    |> Path.join(agent_file)
    |> File.read!()
  end

  defp compile(agent_code) do
    """
    defmodule Agents do
      import Myelin.Agent

      #{agent_code}
    end
    """
    |> Code.compile_string()
    |> Keyword.delete(Agents)
    |> fetch_agent_code()
  end

  defp fetch_agent_code([{_module, code}]), do: code

  defp print(msg), do: IO.puts(msg)
end
