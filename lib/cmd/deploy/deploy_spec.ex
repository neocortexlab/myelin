defmodule Myelin.Cmd.Deploy.CmdSpec do
  @moduledoc """
  Command Spec for 'deploy'
  """
  def spec do
    {
      :deploy, [
        name: "deploy",
        about: "deploys agents"
      ]
    }
  end
end
