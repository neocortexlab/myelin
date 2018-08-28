defmodule Myelin.Cmd.New do
  @moduledoc """
  Generates new Myelin project

  ## Usage:
      myelin new PATH
  """

  @create_dirs ~w(agents models tests storage tasks)

  alias Myelin.Cmd.Agent

  def process(args, _flags) do
    case File.exists?(args.name) do
      true ->
        IO.puts "Folder #{args.name} is not empty!"

      false ->
        File.mkdir_p!(args.name)
        File.cd!(args.name, fn -> generate_app(Path.basename(args.name)) end)
        IO.puts "Generated new project at #{args.name}"
    end
  end

  defp generate_app(name) do
    Enum.each(@create_dirs, &File.mkdir!/1)
    Agent.new(name)
    File.touch!("myelin.ex")
  end
end
