defmodule Myelin.Cmd.Runpipeline.CmdSpec do
  @moduledoc """
  Runs pipeline
  """

  def spec do
    {
      :runpipeline, [
        name: "run_pipeline",
        about: @moduledoc,
        args: [
          pipeline_id: [
            value_name: "PIPELINE_ID",
            help: "Pipeline id",
            required: true,
            parser: :string
          ],
          input: [
            value_name: "INPUT",
            help: "Pipeline input",
            required: false,
            parser: :string
          ]
        ]
      ]
    }
  end
end

