defmodule Myelin.Cmd.Agent.CmdSpec do
  @moduledoc """
  Command Spec for 'agent'
  """
  def spec do
    {
      :agent, [
        name: "agent",
        about: "Operations with agent",
        flags: [
          new: [
            short: "-n",
            long: "--new",
            help: "Create new agent",
            multiple: false,
          ],
          info: [
            short: "-i",
            long: "--info",
            help: "Get info about agent",
            multiple: false,
          ]
        ],
        args: [
          name: [
            value_name: "NAME",
            help: "Agent name",
            required: true,
            parser: :string
          ]
        ]
      ]
    }
  end
end
