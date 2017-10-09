defmodule AWSMetadata.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_aws_metadata,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {AWSMetadata.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:timex, "~> 3.1.24"},
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:aws, github: "uberbrodt/aws-elixir", branch: "metadata_client"},
      {:distillery, "~> 1.5", runtime: false},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
