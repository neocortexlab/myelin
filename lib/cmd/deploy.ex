defmodule Cmd.Deploy do
  @moduledoc """
  Deploys agent

  ## Usage:
      myelin deploy
  """

  import Cmd.Utils

  def run([]), do: deploy_all()

  def run(_), do: IO.puts(@moduledoc)

  defp deploy_all do
    case File.ls(build_path()) do
      {:error, :enoent} ->
        print "Run this command from the myelin project folder"

      {:ok, []} ->
        print "No built agents found!"

      {:ok, files} ->
        for file <- files, do: deploy(file)
    end
  end

  defp deploy(file) do
    [address, code] = load(file)

    Myelin.init()
    response = Myelin.deploy_agent(address, code)

    print "The #{file} Agent was successfully deployed at #{address}"
    print "Transaction: #{inspect response}"
    print "Decoded data: #{inspect Base.decode64(response["data"])}"
  end

  defp load(file) do
    build_path()
    |> Path.join(file)
    |> File.read!()
    |> String.split("\n", parts: 2)
  end
end
