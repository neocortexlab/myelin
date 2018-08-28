defmodule Cmd.Send do
  @moduledoc """
  Sends message to agent

  ## Usage:
      myelin send AGENT ACTION PROPS
  """

  import Cmd.Utils

  def process(args, _flags) do
    print "Sending message to #{args.name}"

    {:ok, address} = resolve_address(args.name)

    Myelin.init()
    response = Myelin.send_msg(address, args.action, Enum.join(args.props, " "))
    print "Response: #{inspect response}"
  end
end
