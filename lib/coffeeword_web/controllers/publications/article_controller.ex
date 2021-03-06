defmodule CoffeewordWeb.Publications.ArticleController do
  use CoffeewordWeb, :controller

  alias Coffeeword.Publications
  alias Coffeeword.Publications.Article

  plug :require_existing_author
  plug :authorize_article when action in [:edit, :update, :delete]

  def index(conn, _params) do
    articles = Publications.list_articles()
    render(conn, "index.html", articles: articles)
  end

  def new(conn, _params) do
    changeset = Publications.change_article(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    case Publications.create_article(conn.assigns.current_author, article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: publications_article_path(conn, :show, article))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    article =
      id
      |> Publications.get_article!()
      |> Publications.incr_article_views()

    render(conn, "show.html", article: article)
  end

  def edit(conn, _) do
    changeset = Publications.change_article(conn.assigns.article)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"article" => article_params}) do
    case Publications.update_article(conn.assigns.article, article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: publications_article_path(conn, :show, article))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _article} = Publications.delete_article(conn.assigns.article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: publications_article_path(conn, :index))
  end

  defp require_existing_author(conn, _) do
    author = Publications.ensure_author_exists(conn.assigns.current_user)
    assign(conn, :current_author, author)
  end

  defp authorize_article(conn, _) do
    article = Publications.get_article!(conn.params[:id])

    cond do
      conn.assigns.current_author.id == article.author_id ->
        assign(conn, :article, article)
      true ->
        conn
        |> put_flash(:info, "You can't modify that article!")
        |> redirect(to: publications_article_path(conn, :index))
        |> halt()
    end
  end
end
