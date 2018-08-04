defmodule Mix.Tasks.Myelin.New do
  @shortdoc "Generates new Myelin application"

  @moduledoc """
  Generates new Myelin application

  ## Usage:

      mix myelin.new PATH
  """

  use Mix.Task

  def run([path]) do
    case File.exists?(path) do
      true ->
        Mix.shell.info "#{path} is not empty!"

      false ->
        :myelin
        |> :code.priv_dir()
        |> Path.join("app_template")
        |> File.cp_r!(path)
        Mix.shell.info "Generated new app at #{path}"
    end
  end

  def run(_) do
    Mix.shell.info @moduledoc
  end
end
