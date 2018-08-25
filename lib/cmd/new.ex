defmodule Cmd.New do
  @moduledoc """
  Generates new Myelin application

  ## Usage:
      myelin new PATH
  """

  @templates_path Path.join(:code.priv_dir(:myelin), "templates")
  @create_dirs ~w(agents models tests storage scripts tasks)

  alias Crypto.Storage

  def run([path]) do
    case File.exists?(path) do
      true ->
        IO.puts "#{path} is not empty!"

      false ->
        File.mkdir_p!(path)
        File.cd!(path, fn -> generate_app(Path.basename(path)) end)
        IO.puts "Generated new app at #{path}"
    end
  end

  def run(_), do: IO.puts(@moduledoc)

  defp generate_app(name) do
    Enum.each(@create_dirs, &File.mkdir!/1)

    {pub_key, priv_key} = Crypto.gen_key_pair()
    address = Crypto.gen_address(pub_key) |> Crypto.to_hex()
    Storage.save_keys(name, address, priv_key, pub_key)

    File.write!(Path.join("agents", "#{name}.ex"), agent_code(address))

    File.touch!("myelin.ex")
  end

  defp agent_code(address) do
    Path.join(@templates_path, "agent.ex")
    |> File.read!()
    |> String.replace("{{address}}", address)
  end
end
