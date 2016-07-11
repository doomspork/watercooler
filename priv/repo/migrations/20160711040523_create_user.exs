defmodule Watercooler.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :avatar, :string
      add :username, :string
      add :provider, :string
      add :provider_uid, :string

      timestamps()
    end

  end
end
