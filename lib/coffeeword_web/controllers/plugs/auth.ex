defmodule CoffeewordWeb.Auth do
  import Plug.Conn

  def init(opts) do
    opts |> Keyword.fetch!(:context)
  end

  def call(conn, context) do
    user_id = get_session(conn, :user_id)

    cond do
      conn.assigns[:current_user] ->
        conn
      user = user_id && context.get_user(user_id) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def login_by_email_and_pass(conn, email, given_pass, opts) do
    context = Keyword.fetch!(opts, :context)
    user = context.get_by_email(email)

    cond do
      user && checkpw(given_pass, user.credential.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw() # prevents time attack
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  import Phoenix.Controller
  alias CoffeewordWeb.Router.Helpers

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "Musisz być zalogowany")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end
end