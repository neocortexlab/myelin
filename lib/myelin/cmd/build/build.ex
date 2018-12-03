defmodule Myelin.Cmd.Build do
  @moduledoc """
  Builds Agents

  ## Usage:
      myelin build
  """

  import Myelin.Utils

  alias PalliumCore.Compiler
  alias PalliumCore.Crypto

  def process(_args, _flags), do: build_all()

  defp build_all do
    case File.ls(agents_path()) do
      {:error, :enoent} ->
        print "Run this command from the myelin project folder"

      {:ok, agent_files} ->
        for agent_file <- agent_files do
          agent_file
          |> Path.basename(".agent")
          |> build()
        end
    end
  end

  def build(agent_name) do
    with {:ok, address} <- get_address(agent_name),
         {:ok, code} <- Compiler.compile_agent(agent_name, address)
    do
      code_hex =
        code
        |> Enum.map(fn [atom, bytes] -> [atom, Crypto.to_hex(bytes)] end)
        |> List.flatten()
        |> Enum.join("\n")
      path = build_path()
      File.mkdir_p!(path)
      File.write!(Path.join(path, agent_name), code_hex)
      print "Building agent #{agent_name} successfully completed"
    else
      {:error, reason} ->
        print "Error while building agent: #{inspect reason}"
    end
  end
end
