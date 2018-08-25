defmodule Cmd.CLI do
  @moduledoc """
  Myelin Command Line Interface

  ## Commands:

  myelin new AGENT_NAME             - creates new agent
  myelin build                      - builds agents
  myelin deploy                     - deploys agents
  myelin send AGENT ACTION PARAMS   - sends message
  myelin task NAME                  - runs tasks
  myelin help                       - this help message
  """

  import Cmd.Utils

  def main(["help" | _]), do: print @moduledoc
  def main([]), do: print @moduledoc

  def main([cmd | rest]) do
    case cmd_module(cmd) do
      nil ->
        print "Unknown command #{inspect cmd}. Run `myelin help` for help"
      module ->
        apply(module, :run, [rest])
    end
  end

  def cmd_module(cmd) do
    module = String.to_atom("Elixir.Cmd.#{Macro.camelize(cmd)}")
    Code.ensure_loaded(module)
    case function_exported?(module, :run, 1) do
      true -> module
      false -> nil
    end
  end
end
