defmodule Listus.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:token) do

      timestamps()
    end

  end
end
