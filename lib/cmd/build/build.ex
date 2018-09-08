defmodule Myelin.Cmd.Build do
  @moduledoc """
  Builds Agents

  ## Usage:
      myelin build
  """

  import Cmd.Utils

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
         {:ok, src} <- read_agent_source(agent_name),
         {:ok, code} <- Compiler.compile_agent(src, address)
    do
      code_hex = Crypto.to_hex(code)
      content = Enum.join([address, code_hex], "\n")
      File.mkdir_p!(build_path())
      File.write!(Path.join(build_path(), agent_name), content)
      print "Building agent #{agent_name} successfully completed"
    else
      {:error, reason} ->
        print "Error while building agent: #{inspect reason}"
    end
  end
end
