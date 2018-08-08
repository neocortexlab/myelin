defmodule Cmd.Utils do
  def print(message), do: IO.puts(message)

  def build_path, do: "build"
  def agents_path, do: "agents"

end

