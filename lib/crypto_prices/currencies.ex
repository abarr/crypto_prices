defmodule Crypto.Currencies do
  @moduledoc """
  The Currencies context.
  """

  import Ecto.Query, warn: false
  alias Crypto.Repo

  alias Crypto.Currencies.{Currency, Coin}

  ###### PUB SUB ######

  def subscribe(topic) do
    Phoenix.PubSub.subscribe(Crypto.PubSub, topic)
  end


  ###### CURRENCIES ######

  @doc """
  Returns the list of currencies.

  ## Examples

      iex> list_currencies()
      [%Currency{}, ...]

  """
  def list_currencies do
    Repo.all(Currency)
  end

  @doc """
  Gets a single currency.

  Raises `Ecto.NoResultsError` if the Currency does not exist.

  ## Examples

      iex> get_currency!(123)
      %Currency{}

      iex> get_currency!(456)
      ** (Ecto.NoResultsError)

  """
  def get_currency!(id), do: Repo.get!(Currency, id)

  @doc """
  Gets the most recent prices for the coins monitored
  in list of coin id's

  ## Examples

      iex> get_latest_prices!(["67565dfaas6 ...", ...])
     [%Currency{}, ...]
  """
  def get_latest_prices(list) do
    Currency
    |> where([c], c.coin_id in ^list)
    |> distinct([c], c.coin_id)
    |> order_by([c], desc: c.priced_at)
    |> Repo.all()
  end


  @doc """
  Creates a currency.

  ## Examples

      iex> create_currency(%{field: value})
      {:ok, %Currency{}}

      iex> create_currency(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_currency(attrs \\ %{}) do
    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert()
    |> notify(attrs[:coin_id])
  end


  ###### COINS ######

 @doc """
  Returns the list of coins.

  ## Examples

      iex> list_coins()
      [%Coin{}, ...]

  """
  def list_coins do
    Repo.all(Coin)
  end

  @doc """
  Gets a single coin.

  Raises `Ecto.NoResultsError` if the Coin does not exist.

  ## Examples

      iex> get_coin!(123)
      %Coin{}

      iex> get_coin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_coin!(id), do: Repo.get!(Coin, id)

  @doc """
  Creates a coin.

  ## Examples

      iex> create_coin(%{field: value})
      {:ok, %Coin{}}

      iex> create_coin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_coin(attrs \\ %{}) do
    %Coin{}
    |> Coin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a coin.

  ## Examples

      iex> update_coin(coin, %{field: new_value})
      {:ok, %Coin{}}

      iex> update_coin(coin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_coin(%Coin{} = coin, attrs) do
    coin
    |> Coin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a coin.

  ## Examples

      iex> delete_coin(coin)
      {:ok, %Coin{}}

      iex> delete_coin(coin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_coin(%Coin{} = coin) do
    Repo.delete(coin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking coin changes.

  ## Examples

      iex> change_coin(coin)
      %Ecto.Changeset{data: %Coin{}}

  """
  def change_coin(%Coin{} = coin, attrs \\ %{}) do
    Coin.changeset(coin, attrs)
  end

  defp notify(result, topic) do
    Phoenix.PubSub.broadcast(Crypto.PubSub, to_string(topic), {topic, result})
    result
  end
end
