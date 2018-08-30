defmodule Myelin.Cmd.Tx.CmdSpec do
  @moduledoc """
  Options spec for tx command
  """

  def spec do
    {
      :tx, [
        name: "tx",
        about: "Checks transaction presence in blockchain",
        args: [
          hash: [
            value_name: "HASH",
            help: "Transaction hash",
            required: true,
            parser: :string
          ]
        ]
      ]
    }
  end
end
