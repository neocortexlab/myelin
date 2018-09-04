defmodule Myelin.Cmd.Bid do
  @moduledoc """
  Proposes bid

  ## Usage:
      myelin bid AGENT
  """

  import Cmd.Utils

  def process(args, _flags) do
    {:ok, address} = resolve_address(args.agent)
    Myelin.init()
    response = Myelin.bid(address, bid())
    print "Ok"
  end


  # @fields ~w(ip net cluster device_name device_type memory_limit)a
  defp bid do
    %{
      ip: "127.0.0.1",
      net: "net_id",
      cluster: "cluster_id",
      device_name: "NVIDIA",
      device_type: "GPU",
      memory_limit: "1000000000",
    }
  end
end
