defmodule Myelin.Cmd.Runpipeline do
  import Myelin.Utils

  def process(%{pipeline_id: pipeline_id, input: input}, _flags) do
    print "Running pipeline"
    Myelin.init()
    Myelin.run_pipeline(pipeline_id, input)
  end
end
