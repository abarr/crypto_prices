defmodule Crypto.FavouritesTest do
  use Crypto.DataCase

  alias Crypto.Favourites

  describe "favourites" do
    alias Crypto.Favourites.Favourite

    import Crypto.FavouritesFixtures

    @invalid_attrs %{coin_id: nil, user_id: nil}

    test "create_favourite/1 with valid data creates a favourite" do
      valid_attrs = %{coin_id: "7488a646-e31f-11e4-aace-600308960662", user_id: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %Favourite{} = favourite} = Favourites.create_favourite(valid_attrs)
      assert favourite.coin_id == "7488a646-e31f-11e4-aace-600308960662"
      assert favourite.user_id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_favourite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Favourites.create_favourite(@invalid_attrs)
    end

    test "delete_favourite/1 deletes the favourite" do
      favourite = favourite_fixture()
      assert {:ok, %Favourite{}} = Favourites.delete_favourite(favourite)
      assert_raise Ecto.NoResultsError, fn -> Favourites.get_favourite_by_user_coin!(favourite.user_id, favourite.coin_id) end
    end

  end
end
