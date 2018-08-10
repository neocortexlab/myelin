defmodule Cmd.New do
  @moduledoc """
  Generates new Myelin application

  ## Usage:
      myelin new PATH
  """

  @templates_path Path.join(:code.priv_dir(:myelin), "templates")
  @create_dirs ~w(agents models tests storage)

  def run([path]) do
    case File.exists?(path) do
      true ->
        IO.puts "#{path} is not empty!"

      false ->
        :ok = generate_app(path)
        IO.puts "Generated new app at #{path}"
    end
  end

  def run(_), do: IO.puts(@moduledoc)

  defp generate_app(path) do
    name = Path.basename(path)
    {public_key, _private_key} = Crypto.gen_key_pair()
    address = Crypto.gen_address(public_key) |> Crypto.to_hex()

    File.mkdir_p!(path)
    for dir <- @create_dirs, do: Path.join(path, dir) |> File.mkdir!

    File.write!(Path.join([path, "agents", "#{name}.ex"]), agent_code(address))

    File.touch!(Path.join(path, "myelin.ex"))
  end

  defp agent_code(address) do
    Path.join(@templates_path, "agent.ex")
    |> File.read!()
    |> String.replace("{{address}}", address)
  end
end

