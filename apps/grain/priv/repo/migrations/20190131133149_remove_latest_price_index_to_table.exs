defmodule Grain.Repo.Migrations.RemoveLatestPriceIndexToTable do
  use Ecto.Migration

  def change do
    drop index(:grains, [:latest_price])
  end
end
