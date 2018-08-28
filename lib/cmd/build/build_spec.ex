defmodule Myelin.Cmd.Build.CmdSpec do
  @moduledoc """
  Command Spec for 'new'
  """
  def spec do
    {
      :build, [
        name: "build",
        about: "Builds agents"
      ]
    }
  end
end
