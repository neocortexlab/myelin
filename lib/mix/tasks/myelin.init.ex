defmodule Mix.Tasks.Myelin.Init do
  @shortdoc "Initializes Myelin application"

  @moduledoc """
  Initializes Myelin application

      mix myelin.init APP_NAME
  """

  use Mix.Task

  def run([path]) do
    case File.exists?(path) do
      true ->
        Mix.shell.info "#{path} is not empty!"

      false ->
        Mix.shell.info "Initializing new app at #{path}"
        :myelin
        |> :code.priv_dir()
        |> Path.join("app_template")
        |> File.cp_r!(path)
    end
  end

  def run(_) do
    Mix.shell.info @moduledoc
  end
end
