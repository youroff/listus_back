defmodule Listus.Plugs.AuthByUUID do
  import Plug.Conn
  import MonEx.Option
  alias Listus.User

  def init(opts), do: opts

  def call(conn, _opts) do
    case User.find_by_uuid(conn.params["uuid"]) do
      some(user) -> assign(conn, :current_user, user)
      none() -> send_resp(conn, :forbidden, "Not authorized") |> halt()
    end
  end
end
