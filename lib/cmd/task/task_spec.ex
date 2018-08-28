defmodule Myelin.Cmd.Task.CmdSpec do
  @moduledoc """
  Command Spec for 'task'
  """
  def spec do
    {
      :task, [
        name: "task",
        about: "Operations with tasks",
        flags: [
          new: [
            short: "-n",
            long: "--new",
            help: "Create new task",
            multiple: false,
          ],
          gen: [
            short: "-g",
            long: "--gen",
            help: "Generate auxiliary files from the Thrift scheme",
            multiple: false,
          ],
          run: [
            short: "-r",
            long: "--run",
            help: "Run the task",
            multiple: false,
          ]
        ],
        args: [
          name: [
            value_name: "NAME",
            help: "Task name",
            required: true,
            parser: :string
          ]
        ]
      ]
    }
  end
end
