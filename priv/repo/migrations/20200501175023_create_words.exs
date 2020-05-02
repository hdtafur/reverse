defmodule Reverse.Repo.Migrations.CreateWords do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :body, :string

      timestamps()
    end

  end
end
