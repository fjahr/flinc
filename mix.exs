defmodule Flinc.Mixfile do
  use Mix.Project

  def project do
    [app: :flinc,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Flinc, []},
     applications: [
       :phoenix,
       :phoenix_html,
       :cowboy,
       :logger,
       :gettext,
       :phoenix_ecto,
       :postgrex,
       :comeonin,
       :ex_machina,
       :phoenix_pubsub,
       :ex_admin
     ]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.2.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_html, "~> 2.4"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.9"},
      {:comeonin, "~> 2.0"},
      {:guardian, "~> 0.12.0"},
      {:cowboy, "~> 1.0"},
      {:credo, "~> 0.2", only: [:dev, :test]},
      {:ex_machina, "~> 1.0"},
      {:exactor, "~> 2.2.0"},
      {:hound, "~> 1.0"},
      {:guardian_db, "~> 0.7.0"},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:ex_admin, github: "smpallen99/ex_admin"},
      {:ecto, "~> 2.0", override: true}
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]
   ]
  end
end
