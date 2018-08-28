defmodule Myelin.Cmd.Agent do
  @moduledoc """
    Handle agent
  """

  import Cmd.Utils
  alias Crypto.Storage

  @templates_path Path.join(:code.priv_dir(:myelin), "templates")

  def process(args, flags) do
    cond do
      flags.new -> new(args.name)
      flags.info -> info(args.name)
      true -> :ok
    end
  end

  def new(name) do
    {pub_key, priv_key} = Crypto.gen_key_pair()
    address = Crypto.gen_address(pub_key) |> Crypto.to_hex()
    Storage.save_keys(name, address, priv_key, pub_key)

    File.write!(Path.join("agents", "#{name}.ex"), agent_code(address))
    print "Agent #{name} was created"
  end

  defp info(_name) do
    print "info"
  end

  defp agent_code(address) do
    Path.join(@templates_path, "agent.ex")
    |> File.read!()
    |> String.replace("{{address}}", address)
  end
end
