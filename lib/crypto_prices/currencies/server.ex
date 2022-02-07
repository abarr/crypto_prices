defmodule Crypto.Currencies.Server do
  use GenServer

  def start_link({:coin, coin}) do
    GenServer.start_link(__MODULE__, coin, name: String.to_atom(coin.ticker))
  end

  def child_spec(opts) do
    {coin, _opts} = Keyword.pop(opts, :coin)
    %{
      id: coin.name,
      start: {__MODULE__, :start_link, [coin: coin]}
    }
  end

  ## Callbacks
  @impl true
  def init(coin) do
    {:ok, coin}
  end
end
