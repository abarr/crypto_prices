defmodule Crypto.Favourites do
  @moduledoc """
  The Favourites context.
  """

  import Ecto.Query, warn: false
  alias Crypto.Repo

  alias Crypto.Favourites.Favourite

   ###### PUB SUB ######

   def subscribe("favourites") do
    Phoenix.PubSub.subscribe(Crypto.PubSub, "favourites")
  end


  @doc """
  Returns the list of favourites for a user

  ## Examples

      iex>  list_favourites_by_user_id(id)
      [%Favourite{}, ...]

  """
  def list_favourites_by_user_id(id) when is_nil(id), do: []
  def list_favourites_by_user_id(id) do
    Favourite
    |> where([f], f.user_id == ^id)
    |> select([f], f.coin_id)
    |> Repo.all()
  end

  @doc """
  Returns the list of coins and the total times it appears

  ## Examples

      iex>  list_coins_favourite_count()
      [%Favourite{}, ...]

  """
  def list_coins_favourite_count() do
    Favourite
    |> group_by([f], f.coin_id)
    |> select([f], %{count: count(f.id), coin_id: f.coin_id})
    |> Repo.all()
  end

  @doc """
  Return a favourite for a user and coin

  ## Examples

      iex>  get_favourite_by_user_coin!(user_id, coin_id)
      %Favourite{}

  """
  def get_favourite_by_user_coin!(user_id, coin_id) do
    Repo.get_by!(Favourite, [user_id: user_id, coin_id: coin_id])
  end

  @doc """
  Creates a favourite.

  ## Examples

      iex> create_favourite(%{field: value})
      {:ok, %Favourite{}}

      iex> create_favourite(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_favourite(attrs \\ %{}) do
    %Favourite{}
    |> Favourite.changeset(attrs)
    |> Repo.insert()
    |> notify(:favourites)
  end

  @doc """
  Deletes a favourite.

  ## Examples

      iex> delete_favourite(favourite)
      {:ok, %Favourite{}}

      iex> delete_favourite(favourite)
      {:error, %Ecto.Changeset{}}

  """
  def delete_favourite(%Favourite{} = favourite) do
    Repo.delete(favourite)
    |> notify(:favourites)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking favourite changes.

  ## Examples

      iex> change_favourite(favourite)
      %Ecto.Changeset{data: %Favourite{}}

  """
  def change_favourite(%Favourite{} = favourite, attrs \\ %{}) do
    Favourite.changeset(favourite, attrs)
  end

  defp notify(result, favourites) do
    Phoenix.PubSub.broadcast(Crypto.PubSub, to_string(favourites), {"favourites", result})
    result
  end
end
