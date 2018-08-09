defmodule Cmd.Utils do
  @address_regex ~r/^agent "([^"]+)"/

  def print(message), do: IO.puts(message)

  def build_path, do: "build"
  def agents_path, do: "agents"

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
    case read_agent_source(agent_name) do
      {:ok, agent_src} ->
        case Regex.run(@address_regex, agent_src) do
          [_, address] -> {:ok, address}
          _ -> {:error, "No address in agent source"}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  def read_agent_source(agent_name) do
    agents_path()
    |> Path.join(agent_name <> ".ex")
    |> File.read()
  end
end

