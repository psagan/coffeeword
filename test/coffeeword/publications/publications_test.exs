defmodule Coffeeword.PublicationsTest do
  use Coffeeword.DataCase

  alias Coffeeword.Publications

  describe "articles" do
    alias Coffeeword.Publications.Article

    @valid_attrs %{body: "some body", title: "some title", views: 42}
    @update_attrs %{body: "some updated body", title: "some updated title", views: 43}
    @invalid_attrs %{body: nil, title: nil, views: nil}

    def article_fixture(attrs \\ %{}) do
      {:ok, article} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Publications.create_article()

      article
    end

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      assert Publications.list_articles() == [article]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert Publications.get_article!(article.id) == article
    end

    test "create_article/1 with valid data creates a article" do
      assert {:ok, %Article{} = article} = Publications.create_article(@valid_attrs)
      assert article.body == "some body"
      assert article.title == "some title"
      assert article.views == 42
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Publications.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()
      assert {:ok, article} = Publications.update_article(article, @update_attrs)
      assert %Article{} = article
      assert article.body == "some updated body"
      assert article.title == "some updated title"
      assert article.views == 43
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = Publications.update_article(article, @invalid_attrs)
      assert article == Publications.get_article!(article.id)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = Publications.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> Publications.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = Publications.change_article(article)
    end
  end
end
