defmodule CoffeewordWeb.Publications.ArticleControllerTest do
  use CoffeewordWeb.ConnCase

  alias Coffeeword.Publications

  @create_attrs %{body: "some body", title: "some title", views: 42}
  @update_attrs %{body: "some updated body", title: "some updated title", views: 43}
  @invalid_attrs %{body: nil, title: nil, views: nil}

  def fixture(:article) do
    {:ok, article} = Publications.create_article(@create_attrs)
    article
  end

  describe "index" do
    test "lists all articles", %{conn: conn} do
      conn = get conn, publications_article_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Articles"
    end
  end

  describe "new article" do
    test "renders form", %{conn: conn} do
      conn = get conn, publications_article_path(conn, :new)
      assert html_response(conn, 200) =~ "New Article"
    end
  end

  describe "create article" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, publications_article_path(conn, :create), article: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == publications_article_path(conn, :show, id)

      conn = get conn, publications_article_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Article"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, publications_article_path(conn, :create), article: @invalid_attrs
      assert html_response(conn, 200) =~ "New Article"
    end
  end

  describe "edit article" do
    setup [:create_article]

    test "renders form for editing chosen article", %{conn: conn, article: article} do
      conn = get conn, publications_article_path(conn, :edit, article)
      assert html_response(conn, 200) =~ "Edit Article"
    end
  end

  describe "update article" do
    setup [:create_article]

    test "redirects when data is valid", %{conn: conn, article: article} do
      conn = put conn, publications_article_path(conn, :update, article), article: @update_attrs
      assert redirected_to(conn) == publications_article_path(conn, :show, article)

      conn = get conn, publications_article_path(conn, :show, article)
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, article: article} do
      conn = put conn, publications_article_path(conn, :update, article), article: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Article"
    end
  end

  describe "delete article" do
    setup [:create_article]

    test "deletes chosen article", %{conn: conn, article: article} do
      conn = delete conn, publications_article_path(conn, :delete, article)
      assert redirected_to(conn) == publications_article_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, publications_article_path(conn, :show, article)
      end
    end
  end

  defp create_article(_) do
    article = fixture(:article)
    {:ok, article: article}
  end
end
