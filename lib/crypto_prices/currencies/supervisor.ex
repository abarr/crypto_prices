defmodule Crypto.Currencies.Supervisor do
  use Supervisor
  alias Crypto.Coins
  alias Crypto.Currencies.Server

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, default_coins(), opts)
  end

  @impl true
  def init(coins) do
    children =
      for coin <- coins do

        {Server, [coin: Map.take(coin, [:name, :ticker, :price])]}
      end
    Supervisor.init(children, strategy: :one_for_one)
  end

  defp default_coins() do
    Coins.list_coins()
  end
end
