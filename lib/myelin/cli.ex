defmodule Myelin.CmdSpec do
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
  #import Cmd.Utils
  @submodule_specs %{
    :new          => Myelin.Cmd.New,
    :build        => Myelin.Cmd.Build,
    :agent        => Myelin.Cmd.Agent,
    :task         => Myelin.Cmd.Task,
    :delpoy       => Myelin.Cmd.Deploy,
    :send         => Myelin.Cmd.Send,
    :tx           => Myelin.Cmd.Tx,
    :bid          => Myelin.Cmd.Bid,
    :pipeline     => Myelin.Cmd.Pipeline,
    :run_pipeline => Myelin.Cmd.Runpipeline,
  }

  def main([]), do: parse(["--help"])
  def main(args), do: parse(args)

  defp parse(args) do
    Optimus.new!(
      name: "myelin",
      description: "The Pallium Network development framework",
      version: "0.1.1,",
      allow_unknown_args: true,
      parse_double_dash: true,
      subcommands: submodules()
    ) |> Optimus.parse!(args) |> execute
  end

  defp submodules() do
    @submodule_specs
    |> Enum.map(fn {_, v} -> apply(Module.concat([v, "CmdSpec"]), :spec, []) end)
    |> List.flatten
  end

  defp execute(cmd) do
    {name, result} = cmd
    module = Module.concat("Myelin.Cmd", get_module_name(name))
    module.process(result.args, result.flags)
  end

  defp get_module_name(atom_list) do
    atom_list
    |> List.first
    |> Atom.to_string
    |> String.capitalize
  end
end
