defmodule Myelin.Utils do
  alias Myelin.Storage

  def print(message), do: IO.puts(message)

  def build_path, do: "build"
  def agents_path, do: "agents"
  def task_path, do: "tasks"

  def resolve_address(str) do
    case is_address?(str) do
      true ->
        {:ok, str}
      false ->
        get_address(str)
    end
  end

  def is_address?(address) do
    address =~ ~r/^[\da-f]{64}$/
  end

  def get_address(agent_name) do
    Storage.get_address(agent_name)
  end

  def read_agent_source(agent_name) do
    agents_path()
    |> Path.join(agent_name <> ".agent")
    |> File.read()
  end

  def insert_address(src, address) do
    String.replace(src, "{{address}}", address)
  end
end
