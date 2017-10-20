defmodule CoffeewordWeb.Publications.ArticleView do
  use CoffeewordWeb, :view

  alias Coffeeword.Publications

  def author_name(%Publications.Article{author: author}) do
    author.user.name
  end

end
