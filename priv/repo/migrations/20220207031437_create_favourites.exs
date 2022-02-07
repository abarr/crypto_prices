defmodule Crypto.Repo.Migrations.CreateFavourites do
  use Ecto.Migration

  def change do
    create table(:favourites, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :string
      add :coin_id, :string

    end
    create unique_index(:favourites, [:user_id, :coin_id], name: :user_coin_index)
  end
end
