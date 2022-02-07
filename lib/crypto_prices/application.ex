defmodule Crypto.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Crypto.Repo,
      # Start the Telemetry supervisor
      CryptoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Crypto.PubSub},
      # Start coin servers Supervisor
      {Crypto.Currencies.Supervisor, name: Crypto.Currencies.Supervisor},
      # Start the Endpoint (http/https)
      CryptoWeb.Endpoint
      # Start a worker by calling: Crypto.Worker.start_link(arg)
      # {Crypto.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Crypto.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CryptoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
