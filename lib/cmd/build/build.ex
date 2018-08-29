defmodule Myelin.Cmd.Build do
  @moduledoc """
  Builds Agents

  ## Usage:
      myelin build
  """

  import Cmd.Utils

  alias Myelin.Compiler

  def process(_args, _flags), do: build_all()

  defp build_all do
    case File.ls(agents_path()) do
      {:error, :enoent} ->
        print "Run this command from the myelin project folder"

      {:ok, agent_files} ->
        for agent_file <- agent_files do
          agent_file
          |> Path.basename(".ex")
          |> build()
        end
    end
  end

  def build(agent_name) do
    with {:ok, address} <- get_address(agent_name),
         {:ok, code} <- Compiler.compile_file(agent_name)
    do
      content = Enum.join([address, code], "\n")
      File.mkdir_p!(build_path())
      File.write!(Path.join(build_path(), agent_name), content)
      print "Building agent #{agent_name} successfully completed"
    end
  end
end
