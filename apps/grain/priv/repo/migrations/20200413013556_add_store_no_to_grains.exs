defmodule Grain.Repo.Migrations.AddStoreNoToGrains do
  use Ecto.Migration

  def change do
    alter table(:grains) do
      add :store_no, :string
      add :storage_depot_name, :string
    end
  end
end
