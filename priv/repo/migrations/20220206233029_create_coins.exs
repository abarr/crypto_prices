defmodule Crypto.Repo.Migrations.CreateCoins do
  use Ecto.Migration

  def change do
    create_query =
      "CREATE TYPE price AS ENUM ('spot', 'buy', 'sell')"

    drop_query = "DROP TYPE price"
    execute(create_query, drop_query)

    create table(:coins, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :ticker, :string
      add :price, :string

      timestamps()
    end
    create unique_index(:coins, [:name, :ticker], name: :name_ticker_index)
  end
end
