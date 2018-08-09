defmodule Cmd.Send do
  @moduledoc """
  Sends message to agent

  ## Usage:
      myellin send AGENT ACTION PROPS
  """

  import Cmd.Utils

  def run([agent, action | props]) do
    print "Sending message to #{agent}"

    {:ok, address} = resolve_address(agent)

    Myelin.init()
    response = Myelin.send_msg(address, action, Enum.join(props, " "))
    print "Response: #{inspect response}"
  end

  def run(_), do: IO.puts(@moduledoc)
end
