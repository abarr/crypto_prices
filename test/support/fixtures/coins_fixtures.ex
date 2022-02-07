defmodule Crypto.CoinsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Crypto.Coins` context.
  """

  @doc """
  Generate a coin.
  """
  def coin_fixture(attrs \\ %{}) do
    {:ok, coin} =
      attrs
      |> Enum.into(%{
        name: "some name",
        price: :spot,
        ticker: "some ticker",
        interval: 5000
      })
      |> Crypto.Currencies.create_coin()

    coin
  end
end
