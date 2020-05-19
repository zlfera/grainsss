defmodule Grain.Repo.Migrations.DropMarkNumberToGrains do
  use Ecto.Migration

  def change do
    drop unique_index("grains", [:mark_number])
  end
end
