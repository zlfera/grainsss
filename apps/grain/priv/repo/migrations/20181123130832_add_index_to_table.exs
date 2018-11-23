defmodule Grain.Repo.Migrations.AddIndexToTable do
  use Ecto.Migration

  def change do
    create index(:grains, [:inserted_at])
  end
end
