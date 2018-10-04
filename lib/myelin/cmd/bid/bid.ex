defmodule Myelin.Cmd.Bid do
  @moduledoc """
  Proposes bid

  ## Usage:
      myelin bid AGENT
  """

  import Myelin.Utils

  alias PalliumCore.Core.Bid

  def process(args, _flags) do
    {:ok, address} = resolve_address(args.agent)
    Myelin.init()
    Myelin.bid(address, bid(address))
    print "Ok"
  end


  # @fields ~w(ip net cluster device_name device_type memory_limit)a
  defp bid(address) do
    %Bid{
      agent_address: address,
      cluster_id: "cluster_id",
      device_desc: "",
      device_name: "NVIDIA",
      device_type: :cpu,
      memory_limit: 1_000_000,
      node_id: ""
    }
  end
end
