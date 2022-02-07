defmodule Crypto.Favourites.Favourite do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "favourites" do
    field :coin_id, :string
    field :user_id, :string

  end

  @doc false
  def changeset(favourite, attrs) do
    favourite
    |> cast(attrs, [:user_id, :coin_id])
    |> validate_required([:user_id, :coin_id])
  end
end
