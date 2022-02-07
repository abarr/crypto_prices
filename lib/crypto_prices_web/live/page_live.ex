defmodule CryptoWeb.PageLive do
  use CryptoWeb, :live_view

  alias Crypto.{Currencies, Accounts, Favourites}

  @impl true
  def mount(_params, %{"user_token" => token}, socket) do
    {:ok,
      socket
      |> assign_new(:current_user, fn -> Accounts.get_user_by_session_token(token) end)
    }
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :current_user, nil)}
  end

  @impl true
  def handle_params(_, _, socket) do
    coins = coins_to_monitor()

    if connected?(socket), do: subscribe_to_coins(coins); subscribe_to_favourites()

    favourites =
      if socket.assigns[:current_user], do:
        Favourites.list_favourites_by_user_id(socket.assigns.current_user.id),
          else: []

    {:noreply,
      socket
      |> assign(coins: coins)
      |> assign(prices: get_prices(coins))
      |> assign(favourites: favourites)
      |> assign(favourites_count: Favourites.list_coins_favourite_count())
    }
  end

  @impl true
  def handle_event("add-favourite", %{"id" => user_id, "coin" => coin_id}, socket) do
    case Favourites.create_favourite(%{user_id: user_id, coin_id: coin_id}) do
      {:ok, _} ->
        {:noreply, push_patch(socket, to: "/")}

      {:error, _} ->
        socket =
          socket
          |> put_flash(:error, "Unable to make favourite right now")

        {:noreply, socket}
    end
  end

  def handle_event("remove-favourite", %{"id" => user_id, "coin" => coin_id}, socket) do
    fave = Favourites.get_favourite_by_user_coin!(user_id, coin_id)
    case Favourites.delete_favourite(fave) do
      {:ok, _} ->
        {:noreply, push_patch(socket, to: "/")}

      {:error, _} ->
        socket =
          socket
          |> put_flash(:error, "Unable to remove favourite right now")

        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({"favourites", {:ok, _result}}, socket) do
    {:noreply,
      socket
      |> assign(favourites_count: Favourites.list_coins_favourite_count())
    }
  end

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

  defp subscribe_to_favourites() do
    Favourites.subscribe("favourites")
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

  defp current_users_favourite?(coin, favourites) do
    if coin.id in favourites, do: true, else: false
  end

  defp get_count(coin_id, favourites_count) do
    favourite = Enum.find(favourites_count, fn f -> f.coin_id == coin_id end)
    if is_nil(favourite), do: 0, else: favourite.count
  end
end
