defmodule Myelin.Cmd.New.CmdSpec do
  @moduledoc """
  Command Spec for 'new'
  """
  def spec do
    {
      :new, [
        name: "new",
        about: "Creates new Myelin project",
        args: [
          name: [
            value_name: "NAME",
            help: "Project name",
            required: true,
            parser: :string
          ]
        ]
      ]
    }
  end
end
