defmodule Listus.Mixfile do
  use Mix.Project

  def project, do: [
    app: :listus,
    version: "0.0.1",
    elixir: "~> 1.2",
    elixirc_paths: elixirc_paths(Mix.env),
    compilers: [:phoenix, :gettext] ++ Mix.compilers,
    build_embedded: Mix.env == :prod,
    start_permanent: Mix.env == :prod,
    deps: deps()
  ]

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application, do: [
    mod: {Listus, []},
    applications: [:phoenix, :bolt_sips, :cowboy, :logger, :gettext]
  ]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps, do: [
    {:phoenix, "~> 1.2.1"},
    {:ecto, "~> 2.1"},
    {:bolt_sips, "~> 0.2"},
    {:monex, "~> 0.1.1"},
    {:phoenix_live_reload, "~> 1.0", only: :dev},
    {:gettext, "~> 0.11"},
    {:cowboy, "~> 1.0"},
    {:uuid, "~> 1.1"}
  ]
end
