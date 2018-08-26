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
  #import Cmd.Utils
  def main([]), do: parse(["--help"])
  def main(args), do: parse(args)

  defp parse(args) do
    Optimus.new!(
      name: "myelin",
      description: "The Pallium Network development framework",
      version: "0.1.0,",
      allow_unknown_args: true,
      parse_double_dash: true,
      subcommands: [
        task: [
          name: "task",
          about: "Operations with tasks",
          flags: [
            new: [
              short: "-n",
              long: "--new",
              help: "Create new task",
              multiple: false,
            ],
            gen: [
              short: "-g",
              long: "--gen",
              help: "Generate auxiliary files from the Thrift scheme",
              multiple: false,
            ],
            run: [
              short: "-r",
              long: "--run",
              help: "Run the task",
              multiple: false,
            ]
          ],
          args: [
            name: [
              value_name: "NAME",
              help: "Task name",
              required: true,
              parser: :string
            ]
          ]
        ]
      ]
    ) |> Optimus.parse!(args) |> execute
  end

  def execute(cmd) do
    {name, result} = cmd
    module = Module.concat("Cmd", get_module_name(name))
    module.handle(result.args, result.flags)
  end

  defp get_module_name(atom_list) do
    atom_list
    |> List.first
    |> Atom.to_string
    |> String.capitalize
  end
end

# def main(["help" | _]), do: print @moduledoc
# def main([]), do: print @moduledoc
#
# def main([cmd | rest]) do
#   case cmd_module(cmd) do
#     nil ->
#       print "Unknown command #{inspect cmd}. Run `myelin help` for help"
#     module ->
#       apply(module, :run, [rest])
#   end
# end
#
# def cmd_module(cmd) do
#   module = String.to_atom("Elixir.Cmd.#{Macro.camelize(cmd)}")
#   Code.ensure_loaded(module)
#   case function_exported?(module, :run, 1) do
#     true -> module
#     false -> nil
#   end
# end
