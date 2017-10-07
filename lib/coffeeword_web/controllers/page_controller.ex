defmodule CoffeewordWeb.PageController do
  use CoffeewordWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
