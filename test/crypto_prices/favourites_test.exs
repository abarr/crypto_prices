defmodule Crypto.FavouritesTest do
  use Crypto.DataCase

  alias Crypto.Favourites

  describe "favourites" do
    alias Crypto.Favourites.Favourite

    import Crypto.FavouritesFixtures

    @invalid_attrs %{coin_id: nil, user_id: nil}

    test "list_favourites/0 returns all favourites" do
      favourite = favourite_fixture()
      assert Favourites.list_favourites() == [favourite]
    end

    test "get_favourite!/1 returns the favourite with given id" do
      favourite = favourite_fixture()
      assert Favourites.get_favourite!(favourite.id) == favourite
    end

    test "create_favourite/1 with valid data creates a favourite" do
      valid_attrs = %{coin_id: "7488a646-e31f-11e4-aace-600308960662", user_id: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %Favourite{} = favourite} = Favourites.create_favourite(valid_attrs)
      assert favourite.coin_id == "7488a646-e31f-11e4-aace-600308960662"
      assert favourite.user_id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_favourite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Favourites.create_favourite(@invalid_attrs)
    end

    test "update_favourite/2 with valid data updates the favourite" do
      favourite = favourite_fixture()
      update_attrs = %{coin_id: "7488a646-e31f-11e4-aace-600308960668", user_id: "7488a646-e31f-11e4-aace-600308960668"}

      assert {:ok, %Favourite{} = favourite} = Favourites.update_favourite(favourite, update_attrs)
      assert favourite.coin_id == "7488a646-e31f-11e4-aace-600308960668"
      assert favourite.user_id == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_favourite/2 with invalid data returns error changeset" do
      favourite = favourite_fixture()
      assert {:error, %Ecto.Changeset{}} = Favourites.update_favourite(favourite, @invalid_attrs)
      assert favourite == Favourites.get_favourite!(favourite.id)
    end

    test "delete_favourite/1 deletes the favourite" do
      favourite = favourite_fixture()
      assert {:ok, %Favourite{}} = Favourites.delete_favourite(favourite)
      assert_raise Ecto.NoResultsError, fn -> Favourites.get_favourite!(favourite.id) end
    end

    test "change_favourite/1 returns a favourite changeset" do
      favourite = favourite_fixture()
      assert %Ecto.Changeset{} = Favourites.change_favourite(favourite)
    end
  end
end
