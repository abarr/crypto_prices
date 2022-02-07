defmodule Crypto.FavouritesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Crypto.Favourites` context.
  """

  @doc """
  Generate a favourite.
  """
  def favourite_fixture(attrs \\ %{}) do
    {:ok, favourite} =
      attrs
      |> Enum.into(%{
        coin_id: "7488a646-e31f-11e4-aace-600308960662",
        user_id: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Crypto.Favourites.create_favourite()

    favourite
  end
end
