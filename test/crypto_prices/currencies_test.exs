defmodule Crypto.CurrenciesTest do
  use Crypto.DataCase

  alias Crypto.Currencies

  describe "currencies" do
    alias Crypto.Currencies.Currency

    import Crypto.CurrenciesFixtures
    import Crypto.CoinsFixtures

    @invalid_attrs %{current_price: nil, name: nil, priced_at: nil}

    test "list_currencies/0 returns all currencies" do
      currency = currency_fixture()
      assert currency in Currencies.list_currencies()
    end

    test "get_currency!/1 returns the currency with given id" do
      currency = currency_fixture()
      assert Currencies.get_currency!(currency.id) == currency
    end

    test "create_currency/1 with valid data creates a currency" do
      coin = coin_fixture()
      valid_attrs = %{current_price: "120.5", priced_at: ~N[2021-09-17 01:39:00], coin_id: coin.id}

      assert {:ok, %Currency{} = currency} = Currencies.create_currency(valid_attrs)
      assert currency.current_price == Decimal.new("120.5")
      assert currency.priced_at == ~N[2021-09-17 01:39:00]
    end

    test "create_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Currencies.create_currency(@invalid_attrs)
    end
  end
end
