defmodule Myelin.Cmd.Pipeline do
  import Myelin.Utils

  def process(%{agents: agents}, _flags) do
    Myelin.init()
    pid = Myelin.start_pipeline(agents)
    print pid
  end
end

