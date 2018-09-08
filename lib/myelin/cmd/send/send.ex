defmodule Myelin.Cmd.Send do
  @moduledoc """
  Sends message to agent

  ## Usage:
      myelin send AGENT ACTION PROPS
  """

  import Myelin.Utils

  def process(args, _flags) do
    print "Sending message to #{args.name}"

    {:ok, address} = resolve_address(args.name)

    Myelin.init()
    response = Myelin.send_msg(address, args.action, args.props)
    print "Response: #{inspect response}"
  end
end
