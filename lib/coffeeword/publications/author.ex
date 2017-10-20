defmodule Coffeeword.Publications.Author do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coffeeword.Publications.Author


  schema "authors" do
    field :bio, :string
    field :role, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Author{} = author, attrs) do
    author
    |> cast(attrs, [:bio, :role])
    |> validate_required([:bio, :role])
    |> unique_constraint(:user_id)
  end
end
