defmodule Cmd.New do
  @moduledoc """
  Generates new Myelin application

  ## Usage:
      myelin new PATH
  """

  @app_template_path Path.join(:code.priv_dir(:myelin), "app_template")

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
    address = Crypto.gen_address(public_key) |> Base.encode16(case: :lower)

    File.mkdir_p!(path)
    File.cp_r!(@app_template_path, path)

    agent_path = Path.join(path, "agents/#{name}.ex")
    agent_template_path = Path.join(path, "agents/agent.ex")
    agent_code =
      agent_template_path
      |> File.read!()
      |> String.replace("{{address}}", address)

    File.rm!(agent_template_path)
    File.write!(agent_path, agent_code)
  end
end

