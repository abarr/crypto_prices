defmodule Crypto.Currencies.Coin do
  use Ecto.Schema
  import Ecto.Changeset
  alias Crypto.Currencies.Currency

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "coins" do
    field :name, :string
    field :ticker, :string
    field :interval, :integer, defualt: 5_000
    field :price, Ecto.Enum, values: [:spot, :buy, :sell], default: :spot
    has_many :currencies, Currency
    
    timestamps()
  end

  @doc false
  def changeset(coin, attrs) do
    coin
    |> cast(attrs, [:name, :ticker, :price, :interval])
    |> validate_required([:name, :ticker, :price])
    |> unique_constraint(:ticker, message: "A coin with this name and ticker already exists")
  end
end
