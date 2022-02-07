defmodule CryptoWeb.PageLive do
  use CryptoWeb, :live_view

  alias Crypto.Currencies

  @impl true
  def mount(_params, _session, socket) do
    coins = coins_to_monitor()
    if connected?(socket), do: subscribe_to_coins(coins)

    {:ok,
      socket
      |> assign(coins: coins)
      |> assign(prices: get_prices(coins))
    }
  end

  @impl true
  def handle_info({topic, {:ok, result}}, socket) do
    topics = Enum.map(socket.assigns.coins, fn c -> c.id end)
    if topic in topics do
      inc? = price_increased?(result, socket.assigns.prices)
      socket = assign(socket, prices: get_prices(socket.assigns.coins))
      {:noreply, push_event(socket, "highlight", %{id: topic, inc: inc?})}
    else
      {:noreply, socket}
    end
  end

  defp price_increased?(result, prices) do
    last_price = Enum.find(prices, fn p -> p.coin_id == result.coin_id end)
    cond do
      last_price.current_price == result.current_price -> nil
      last_price.current_price > result.current_price -> false
      true -> true
    end
  end

  defp coins_to_monitor() do
    Currencies.list_coins()
    |> Enum.map(fn c -> Map.take(c, [:id, :name]) end)
  end

  defp subscribe_to_coins(coins) do
    for coin <- coins do
      Currencies.subscribe(coin.id)
    end
  end

  defp get_prices(coins) do
    coins
    |> Enum.map(fn c -> c.id end)
    |> Currencies.get_latest_prices()
  end

  defp price(coin_id, prices) do
    price = Enum.find(prices, fn p -> p.coin_id == coin_id end)
    Number.Currency.number_to_currency(price.current_price)
  end
end
