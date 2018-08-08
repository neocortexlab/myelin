defmodule Cmd.Build do
  @moduledoc """
  Builds Myelin agents.

  ## Usage:
      myelin build
  """

  @address_regex ~r/^agent "([^"]+)"/

  import Cmd.Utils

  def run([]), do: build_all()

  def run(_), do: IO.puts(@moduledoc)

  defp build_all do
    case File.ls(agents_path()) do
      {:error, :enoent} ->
        print "Run this command from the myelin project folder"

      {:ok, agent_files} ->
        for agent_file <- agent_files, do: build(agent_file)
    end
  end

  defp build(agent_file) do
    agent_src = read_agent_src(agent_file)
    address = get_address(agent_src)
    code = compile_agent(agent_src)
    content = Enum.join([address, code], "\n")
    compiled_filename = Path.basename(agent_file, ".ex")
    File.mkdir_p!(build_path())
    File.write!(Path.join("build", compiled_filename), content)
    print "Building agent #{inspect compiled_filename} successfully completed"
  end

  defp get_address(src) do
    case Regex.run(@address_regex, src) do
      [_, address] -> address
      _ -> raise "Address not found in agent code"
    end
  end

  defp compile_agent(src) do
    src
    |> compile()
    |> Crypto.to_hex()
  end

  defp read_agent_src(agent_file) do
    agents_path()
    |> Path.join(agent_file)
    |> File.read!()
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
