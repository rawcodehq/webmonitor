defmodule Webmonitor.Mixfile do
  use Mix.Project

  def project do
    [app: :webmonitor,
     version: "0.0.1-#{git_commit_sha}",
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
    [mod: {Webmonitor, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger, :gettext,
      :phoenix_ecto, :postgrex, :httpoison, :bamboo, :bamboo_smtp, :comeonin,
      :phoenix_pubsub, :tzdata, :timex, :timex_ecto, :ex_aws, :edeliver]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0-rc"},
     {:phoenix_html, "~> 2.4"},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"},

     {:timex, "~> 2.2"},
     {:ex_aws, "1.0.0-beta0", github: "CargoSense/ex_aws"},
     {:timex_ecto, "~> 1.1"},
     {:comeonin, "~> 2.4"},
     {:httpoison, "~> 0.8.0"},
     {:bamboo, github: "thoughtbot/bamboo", override: true}, # there is an issue with bamboo using the static config and not the one provided by relx
     #{:bamboo, "~> 0.6"},
     {:bamboo_smtp, github: "fewlinesco/bamboo_smtp"},

     # deployment stuff
     {:exrm, "~> 1.0"},
     {:edeliver, ">= 1.2.10"},

     # dev stuff
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:credo, "~> 0.4", only: [:dev, :test]},
     {:dialyxir, "~> 0.3.3", only: [:dev, :test]},
     ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp git_commit_sha do
    {sha, 0} = System.cmd("git", ["log", "-1", "--format=%h"])
    String.strip(sha)
  end

end
