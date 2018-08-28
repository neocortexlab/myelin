defmodule Myelin.Cmd.Task do
  @moduledoc """
    Handle task
  """
  import Cmd.Utils
  @create_dirs ~w(assets src)

  def process(args, flags) do
    cond do
      flags.new -> new(args)
      flags.gen -> gen(args)
      flags.run -> run(args)
      true -> :ok
    end
  end

  defp new(args) do
    path = Path.join(task_path(), args.name)
    case File.exists?(path) do
      true ->
        IO.puts "#{path} is not empty!"

      false ->
        File.mkdir_p!(path)
        File.cd!(path, fn -> generate_task(args.name) end)
        IO.puts "Generated new task at #{path}"
    end
  end

  defp gen(args) do
    path_t = Path.join(task_path(), args.name)
    scheme = Path.join(path_t, "#{args.name}.thrift")
    out_py = Path.join([path_t, "src", "py"])
    out_ex = Path.join([path_t, "src", "ex"])

    File.mkdir_p!(out_py)
    File.mkdir_p!(out_ex)

    Thrift.Generator.generate!(scheme, out_ex)
    System.cmd("thrift", ["-gen", "py", "-out", out_py, scheme])

    server_file = generate_py_server(args.name |> String.capitalize)
    File.write!(Path.join(path_t, "#{args.name}-server.py"), server_file)
  end

  defp run(args) do
    task_p = Path.join([task_path(), args.name])

    port = File.cd!(task_p, fn -> Port.open({:spawn, "python #{args.name}-server.py"}, [:binary]) end)
    {_, os_pid} = Port.info(port, :os_pid)

    [task_p, "src", "ex", "#{args.name}_service.ex"]
    |> Path.join()
    |> Code.compile_file()

    task = Code.compile_file(Path.join(task_p, "#{args.name}.exs")) |> List.first |> elem(0)

    try do
      task.run()
    rescue
      e ->
        System.cmd("kill", ["-KILL","#{os_pid}"])
        IO.puts("An error occurred: " <> e.message)
    end

    System.cmd("kill", ["-KILL","#{os_pid}"])
    Port.close(port)
  end

  defp generate_task(name) do
    Enum.each(@create_dirs, &File.mkdir!/1)

    task_script =
      """
      defmodule #{name |> String.capitalize }Task do
        alias #{Macro.camelize(name)}Service.Binary.Framed.Client

        def run() do
          {:ok, client} = Client.start_link("localhost", 9090, [])
          # INSERT YOUR CODE HERE
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

  defp generate_py_server(name) do
      """
      import glob
      import sys
      sys.path.append('src/py')

      from #{name |> String.downcase} import #{name}Service
      from thrift.transport import TSocket
      from thrift.transport import TTransport
      from thrift.protocol import TBinaryProtocol
      from thrift.server import TServer

      class #{name}ServiceHandler:
              # INSERT YOUR CODE

      if __name__ == '__main__':
          handler = #{name}ServiceHandler()
          processor = #{name}Service.Processor(handler)
          transport = TSocket.TServerSocket(port=9090)
          tfactory = TTransport.TFramedTransportFactory()
          pfactory = TBinaryProtocol.TBinaryProtocolFactory()

          server = TServer.TSimpleServer(processor, transport, tfactory, pfactory)
          print 'Serving ...'
          server.serve()
      """
  end
end
