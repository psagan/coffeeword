defmodule CoffeewordWeb.SessionController do
  use CoffeewordWeb, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case CoffeewordWeb.Auth.login_by_email_and_pass(conn, email, pass, context: Coffeeword.Accounts) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Wlecome back")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username|password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> CoffeewordWeb.Auth.logout
    |> redirect(to: page_path(conn, :index))
  end
end