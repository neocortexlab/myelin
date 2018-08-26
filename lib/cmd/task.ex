defmodule Cmd.Task do
  @moduledoc """
  Run tasks

  ## Usage:
      myelin task NAME
  """
  import Cmd.Utils
  @create_dirs ~w(assets src)

  def handle(args, flags) do
    {action, _} = Enum.find(flags, fn{_, val} -> val == true end)
    case action do
      :new -> new(args)
    end
  end

  defp new(args) do
    path = Path.join(tasks_path(), args.name)
    case File.exists?(path) do
      true ->
        IO.puts "#{path} is not empty!"

      false ->
        File.mkdir_p!(path)
        File.cd!(path, fn -> generate_task(args.name) end)
        IO.puts "Generated new task at #{path}"
    end
  end

  defp generate_task(name) do
    Enum.each(@create_dirs, &File.mkdir!/1)

    task_script =
      """
        defmodule #{name |> String.capitalize }Task do
          def run() do
            :ok
          end
        end
      """
    task_thrift_scheme =
      """
        namespace py #{name}

        service #{name |> String.capitalize}Service {
        }
      """
      File.write!("#{name}.exs", task_script)
      File.write!("#{name}.thrift", task_thrift_scheme)
  end
end

# Thrift.Generator.generate!("abcd/tasks/jpg/jpg.thrift")
# File.mkdir("abcd/tasks/src/python/")
# System.cmd("thrift", ["-gen", "py", "-out", "abcd/tasks/src/py/","abcd/tasks/jpg/jpg.thrift"])
# client_path = Path.join(tasks_path(), "client.ex")
# task_client = Code.compile_file(client_path) |> List.first |> elem(0)
# path = Path.join(tasks_path(), name)
# task = Code.compile_file(path) |> List.first |> elem(0)
# task.run()
#
# :code.purge(task)
# :code.delete(task)


#
# def run([name]) do
#   if File.regular?(name) do
#     execute(name)
#   else
#     print "No such file: #{name}"
#   end
# end
#
# def run(_) do
#   case File.ls(tasks_path()) do
#     {:error, :enoent} ->
#       print "Run this command from the myelin project folder"
#
#     {:ok, task_files} ->
#       for task_file <- task_files do
#         task_file
#         |> execute()
#       end
#   end
# end
