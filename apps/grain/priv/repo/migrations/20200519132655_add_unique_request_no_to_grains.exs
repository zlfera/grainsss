defmodule Grain.Repo.Migrations.AddUniqueRequestNoToGrains do
  use Ecto.Migration

  def change do
    create unique_index("grains", [:request_no])
  end
end
