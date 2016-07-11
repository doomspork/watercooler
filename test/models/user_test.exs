defmodule Watercooler.UserTest do
  use Watercooler.ModelCase

  alias Watercooler.User

  @valid_attrs %{proivder_id: "some content", provider: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
