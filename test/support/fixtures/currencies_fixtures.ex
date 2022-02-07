defmodule Crypto.CurrenciesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Crypto.Currencies` context.
  """

  @doc """
  Generate a currency.
  """
  def currency_fixture(attrs \\ %{}) do
    coin = Crypto.CoinsFixtures.coin_fixture()
    {:ok, currency} =
      attrs
      |> Enum.into(%{
        current_price: "120.5",
        priced_at: ~N[2021-09-17 01:39:00],
        coin_id:  coin.id
      })
      |> Crypto.Currencies.create_currency()

    currency
  end
end
