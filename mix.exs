defmodule AWSMetadata.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_aws_metadata,
      version: "0.2.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: "Fetch, cache, and refresh AWS IAM Credentials",
      package: package(),
      aliases: aliases(),
      deps: deps(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {AWSMetadata.Application, []}
    ]
  end

  defp aliases do
    [
      test: "test --no-start" 
    ]
  end

  defp package do
    [
      maintainers: ["Chris Brodt"],
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/uberbrodt/ex_aws_metadata"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:timex, "~> 3.1"},
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
    ]
  end
end
