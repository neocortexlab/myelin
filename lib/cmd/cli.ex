defmodule Cmd.CLI do
  @moduledoc """
  Myelin Command Line Interface

  ## Commands:

  myelin new AGENT_NAME - creates new agent
  myelin help           - this help message
  """

  alias Cmd.{Build, New}

  def main(["new" | rest]), do: New.run(rest)
  def main(["build" | rest]), do: Build.run(rest)

  def main(_) do
    IO.puts @moduledoc
  end
end
