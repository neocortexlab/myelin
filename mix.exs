defmodule Myelin.MixProject do
  use Mix.Project

  def project do
    [
      app: :myelin,
      version: "0.1.0",
      elixir: "~> 1.7",
      description: "The Pallium Network development framework",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        maintainers: ["Anton Zhuravlev <anton@pallium.network>"],
        links: %{"GitHub" => "https://github.com/neocortexlab/myelin"}
      ]
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
      {:keccakf1600, "~> 2.0.0", hex: :keccakf1600_orig}
    ]
  end
end
