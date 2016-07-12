defmodule Watercooler.User do
  use Watercooler.Web, :model

  alias Watercooler.Repo

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

  def from_auth(auth) do
    auth
    |> lookup_by_auth
    |> user_from_result
  end

  defp user_from_result({auth, nil}) do
    %__MODULE__{avatar: auth.info.image,
                provider: Atom.to_string(auth.provider),
                provider_uid: auth.uid}
  end
  defp user_from_result({_auth, user}), do: user

  defp lookup_by_auth(%Ueberauth.Auth{provider: provider, uid: uid} = auth) do
    provider = Atom.to_string(provider)
    query = from u in __MODULE__,
            where: u.provider == ^provider and u.provider_uid == ^uid,
            select: u

    {auth, Repo.one(query)}
  end
end
