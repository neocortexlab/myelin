defmodule Cmd.Build do
  @moduledoc """
  Builds Myelin agents.

  ## Usage:
      myelin build
  """

  import Cmd.Utils

  def run([]), do: build_all()

  def run(_), do: IO.puts(@moduledoc)

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

  defp build(agent_name) do
    {:ok, agent_src} = read_agent_source(agent_name)
    {:ok, address} = get_address(agent_name)
    code = compile_agent(agent_src)
    content = Enum.join([address, code], "\n")
    File.mkdir_p!(build_path())
    File.write!(Path.join(build_path(), agent_name), content)
    print "Building agent #{agent_name} successfully completed"
  end

  defp compile_agent(src) do
    src
    |> compile()
    |> Crypto.to_hex()
  end

  defp compile(agent_src) do
    compiled =
      """
        defmodule Agents do
          import Myelin.Agent

          #{agent_src}
        end
      """
      |> Code.compile_string()

    purge_modules(Keyword.keys(compiled))

    compiled
    |> Keyword.delete(Agents)
    |> fetch_agent_code()
  end

  # TODO: ensure this is really required
  defp purge_modules([]), do: :ok
  defp purge_modules([mod | rest]) do
    :code.purge(mod)
    :code.delete(mod)
    purge_modules(rest)
  end

  defp fetch_agent_code([{_module, code}]), do: code
end
