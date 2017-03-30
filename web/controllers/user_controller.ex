defmodule Listus.UserController do
  use Listus.Web, :controller

  alias Listus.User

  def create(conn, _params) do
    User.create()
    |> Response.apply_and_render(conn)
  end
end
