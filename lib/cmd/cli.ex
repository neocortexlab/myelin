defmodule Cmd.CLI do
  @moduledoc """
  Myelin Command Line Interface

  ## Commands:

  myelin new AGENT_NAME - creates new agent
  myelin help           - this help message
  """

  alias Cmd.New

  def main(["new" | rest]), do: New.run(rest)

  def main(_) do
    IO.puts @moduledoc
  end
end
