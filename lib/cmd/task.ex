defmodule Cmd.Task do
  @moduledoc """
  Run tasks

  ## Usage:
      myelin task NAME
  """

  import Cmd.Utils

  def run([name]) do
    if File.regular?(name) do
      execute(name)
    else
      print "No such file: #{name}"
    end
  end

  def run(_) do
    case File.ls(tasks_path()) do
      {:error, :enoent} ->
        print "Run this command from the myelin project folder"

      {:ok, task_files} ->
        for task_file <- task_files do
          task_file
          |> execute()
        end
    end
  end

  def execute(name) do
    path = Path.join(tasks_path(), name)
    task = Code.compile_file(path) |> List.first |> elem(0)

    task.run()

    :code.purge(task)
    :code.delete(task)

  end
end
