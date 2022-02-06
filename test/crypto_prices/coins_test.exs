defmodule Crypto.CoinsTest do
  use Crypto.DataCase

  alias Crypto.Coins

  describe "coins" do
    alias Crypto.Coins.Coin

    import Crypto.CoinsFixtures

    @invalid_attrs %{name: nil, price: nil, ticker: nil}

    test "list_coins/0 returns all coins" do
      coin = coin_fixture()
      assert Coins.list_coins() == [coin]
    end

    test "get_coin!/1 returns the coin with given id" do
      coin = coin_fixture()
      assert Coins.get_coin!(coin.id) == coin
    end

    test "create_coin/1 with valid data creates a coin" do
      valid_attrs = %{name: "some name", price: :spot, ticker: "some ticker"}

      assert {:ok, %Coin{} = coin} = Coins.create_coin(valid_attrs)
      assert coin.name == "some name"
      assert coin.price == :spot
      assert coin.ticker == "some ticker"
    end

    test "create_coin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Coins.create_coin(@invalid_attrs)
    end

    test "update_coin/2 with valid data updates the coin" do
      coin = coin_fixture()
      update_attrs = %{name: "some updated name", price: :spot, ticker: "some updated ticker"}

      assert {:ok, %Coin{} = coin} = Coins.update_coin(coin, update_attrs)
      assert coin.name == "some updated name"
      assert coin.price == :spot
      assert coin.ticker == "some updated ticker"
    end

    test "update_coin/2 with invalid data returns error changeset" do
      coin = coin_fixture()
      assert {:error, %Ecto.Changeset{}} = Coins.update_coin(coin, @invalid_attrs)
      assert coin == Coins.get_coin!(coin.id)
    end

    test "delete_coin/1 deletes the coin" do
      coin = coin_fixture()
      assert {:ok, %Coin{}} = Coins.delete_coin(coin)
      assert_raise Ecto.NoResultsError, fn -> Coins.get_coin!(coin.id) end
    end

    test "change_coin/1 returns a coin changeset" do
      coin = coin_fixture()
      assert %Ecto.Changeset{} = Coins.change_coin(coin)
    end
  end
end
