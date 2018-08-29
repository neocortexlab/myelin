defmodule Myelin.MixProject do
  use Mix.Project

  def project do
    [
      app: :myelin,
      version: "0.1.1",
      elixir: "~> 1.7",
      description: "The Pallium Network development framework",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        maintainers: [
          "Anton Zhuravlev <anton@pallium.network>",
          "Dmitry Zhelnin <dmitry.zhelnin@gmail.com>",
        ],
        links: %{"GitHub" => "https://github.com/neocortexlab/myelin"}
      ],
      escript: [main_module: Myelin.CmdSpec]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:neuron, "~> 0.7.0"},
      {:ed25519, "~> 1.3"},
      {:optimus, "~> 0.1.8"},
      {:thrift, github: "pinterest/elixir-thrift"}
    ]
  end
end
