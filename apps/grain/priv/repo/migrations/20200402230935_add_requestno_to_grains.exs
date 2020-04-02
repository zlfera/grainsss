defmodule Grain.Repo.Migrations.AddRequestnoToGrains do
  use Ecto.Migration

  def change do
    alter table(:grains) do
      add :request_no, :string
    end
  end
end
