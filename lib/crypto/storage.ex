defmodule Crypto.Storage do
  @moduledoc """
    Stores addresses and keys of agents
  """

  @storage_path "storage"

  def save_keys(agent_name, address, priv_key, pub_key) do
    write(agent_name, address)
    write(address, encode_keys(priv_key, pub_key))
  end

  def get_address(agent_name) do
    read(agent_name)
  end

  defp encode_keys(priv_key, pub_key) do
    [priv_key, pub_key]
    |> Enum.map(&Crypto.to_hex/1)
    |> Enum.join("\n")
  end

  defp write(key, data) do
    case File.exists?(filename(key)) do
      true ->
        raise "File exists: #{key}"
      false ->
        write!(key, data)
    end
  end

  defp write!(key, data) do
    File.write!(filename(key), data)
  end

  defp read(key) do
    File.read(filename(key))
  end

  defp filename(key), do: Path.join(@storage_path, key)
end
