defmodule Myelin.Cmd.Tx do
  @moduledoc """
  Checks transaction presence in blockchain

  ## Usage:
      myelin tx HASH
  """

  import Myelin.Utils

  def process(%{hash: hash}, _flags) do
    print "Checking tx #{hash}"

    Myelin.init()

    case Myelin.check_tx(hash) do
      nil -> "Transaction not found"
      %{"height" => height} -> "Transaction found in block with height #{height}"
    end
    |> print()
  end
end
