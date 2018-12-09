defmodule Grain.Repo.Migrations.AddLatestPriceIndexToTable do
  use Ecto.Migration

  def change do
    create index(:grains, [:latest_price])
  end
end
