defmodule Myelin.Cmd.Pipeline.CmdSpec do
  @moduledoc """
  Starts pipeline
  """

  def spec do
    {
      :pipeline, [
        name: "start_pipeline",
        about: @moduledoc,
        args: [
          agents: [
            value_name: "AGENTS",
            help: "Agent addresses",
            required: true,
            parser: :string
          ]
        ]
      ]
    }
  end
end
