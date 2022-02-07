defmodule Crypto.Currencies.Server do
  use GenServer
  alias Crypto.Currencies
  alias Crypto.Currencies.Coinbase

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
    case update_currency_price(coin) do
      {:ok, _} ->
        schedule_update(coin)
        {:ok, coin}

      _ ->
        # Raise on error - implement recovery strategy
        raise """
          Unable to start price monitoring service
        """
    end
  end

  @impl true
  def handle_info(:update_coin_price, coin) do
    case update_currency_price(coin) do
      {:ok, _} ->
        schedule_update(coin)
        {:noreply, coin}
      _ ->
        # Implement logging to notify support that there is a problem
        IO.puts "Service unable to update - #{coin.name} at #{NaiveDateTime.local_now()}"
        schedule_update(coin)
        {:noreply, coin}
    end
  end

  defp update_currency_price(coin) do
    Coinbase.get_price(coin.ticker, coin.price)
    |> Map.put(:coin_id, coin.id)
    |> Currencies.create_currency()
  end

  # set timer
  defp schedule_update(coin) do
    Process.send_after(self(), :update_coin_price, coin.interval)
  end
end
