defmodule Coffeeword.Publications.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coffeeword.Publications.{Article, Author}


  schema "articles" do
    field :body, :string
    field :title, :string
    field :views, :integer
    belongs_to :author, Author

    timestamps()
  end

  @doc false
  def changeset(%Article{} = article, attrs) do
    article
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
