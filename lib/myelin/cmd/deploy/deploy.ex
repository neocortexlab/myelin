defmodule Myelin.Cmd.Deploy do
  @moduledoc """
  Deploys agent

  ## Usage:
      myelin deploy
  """

  import Myelin.Utils

  alias PalliumCore.Crypto

  def process(_args, _flags), do: deploy_all()

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
    [[address, _] | _] = code =
      build_path()
      |> Path.join(file)
      |> File.read!()
      |> String.split("\n")
      |> Enum.chunk_every(2)
      |> Enum.map(fn [address, hex] -> [address, Crypto.from_hex(hex)] end)

    Myelin.init()
    response = Myelin.deploy_agent(address, code, deploy_params())

    print "The #{file} Agent was successfully deployed at #{address}"
    print "Transaction: #{inspect response}"
    print "Decoded data: #{inspect Base.decode64(response["data"])}"
  end

  defp deploy_params, do: %{foo: "bar", model: "hash"}
end
