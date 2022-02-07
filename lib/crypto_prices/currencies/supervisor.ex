defmodule Crypto.Currencies.Supervisor do
  use Supervisor
  alias Crypto.Currencies
  alias Crypto.Currencies.Server

  @fields [:id, :name, :ticker, :price, :interval]

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, default_coins(), opts)
  end

  @impl true
  def init(coins) do
    children =
      for coin <- coins do

        {Server, [coin: Map.take(coin, @fields)]}
      end
    Supervisor.init(children, strategy: :one_for_one)
  end

  defp default_coins() do
    Currencies.list_coins()
  end
end
