defmodule Cmd.SendMsg do
  @moduledoc """
  Sends message to agent

  ## Usage:
      myellin send_msg PARAMS

  """

  import Cmd.Utils

  def run([]), do: IO.puts(@moduledoc)

  def run(args) do
    print "Sending message #{inspect args}"
  end
end
