defmodule Myelin.Cmd.Bid.CmdSpec do
  @moduledoc """
  Proposes bid
  """

  def spec do
    {
      :bid, [
        name: "bid",
        about: "Proposes bid",
        args: [
          agent: [
            value_name: "AGENT",
            help: "Agent name or address",
            required: true,
            parser: :string
          ]
        ]
      ]
    }
  end
end
