defmodule Grain.Repo.Migrations.CreateGrains do
  use Ecto.Migration

  def change do
    create table(:grains) do
      add :address, :string
      add :mark_number, :string
      add :grade, :string
      add :latest_price, :string
      add :market_name, :string
      add :starting_price, :string
      add :status, :string
      add :trade_amount, :string
      add :variety, :string
      add :year, :string
      add :trantype, :string

      timestamps()
    end

    create unique_index(:grains, [:mark_number])
  end
end
