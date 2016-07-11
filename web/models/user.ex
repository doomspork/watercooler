defmodule Watercooler.User do
  use Watercooler.Web, :model

  schema "users" do
    field :avatar, :string
    field :username, :string
    field :provider, :string
    field :provider_uid, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:avatar, :username, :provider, :provider_uid])
    |> validate_required([:avatar, :username, :provider, :provider_uid])
  end
end
