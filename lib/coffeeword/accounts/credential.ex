defmodule Coffeeword.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coffeeword.Accounts.{Credential, User}


  schema "credentials" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def email_password_changeset(%Credential{} = credential, attrs) do
    credential
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
