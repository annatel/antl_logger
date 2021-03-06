defmodule AntlLogger.MixProject do
  use Mix.Project

  def project do
    [
      app: :antl_logger,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:jason, "~> 1.3"},
      {:plug_logger_json, "~> 0.7.0"},
      {:logger_file_backend, "~> 0.0.10"}
    ]
  end
end
