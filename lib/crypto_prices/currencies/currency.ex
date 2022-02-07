defmodule Crypto.Currencies.Currency do
  use Ecto.Schema
  import Ecto.Changeset
  alias Crypto.Currencies.Coin

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "currencies" do
    field :current_price, :decimal
    field :priced_at, :naive_datetime
    belongs_to :coin, Coin

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:current_price, :priced_at, :coin_id])
    |> validate_required([:current_price, :priced_at, :coin_id])
    |> foreign_key_constraint(:coin_id)
  end
end
