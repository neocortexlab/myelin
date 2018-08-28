defmodule Myelin.Cmd.Send.CmdSpec do
  @moduledoc """
  Sends message to agent
  """
  def spec do
    {
      :send, [
        name: "send",
        about: "Sends message to agent",
        args: [
          name: [
            value_name: "NAME",
            help: "Agent name or address",
            required: true,
            parser: :string
          ],
          action: [
            value_name: "ACTION",
            help: "Message action",
            required: true,
            parser: :string
          ],
          props: [
            value_name: "NAME",
            help: "Message props",
            required: true,
            parser: :string
          ]
        ]
      ]
    }
  end
end
