defmodule Listus.ListController do
  use Listus.Web, :controller

  alias Listus.List

  def index(conn, _params) do
    List.all(conn.assigns.current_user)
    |> Response.apply_and_render(conn)
  end

  def show(conn, params) do
    List.find(conn.assigns.current_user, id(params))
    |> Response.apply_and_render(conn)
  end

  def update(conn, params) do
    List.find(conn.assigns.current_user, id(params))
    |> MonEx.flat_map(& List.update(&1, params["list"]))
    |> Response.apply_and_render(conn)
  end

  def create(conn, params) do
    List.create(conn.assigns.current_user, params["list"])
    |> Response.apply_and_render(conn)
  end

  def delete(conn, params) do
    List.find(conn.assigns.current_user, id(params))
    |> MonEx.flat_map(& List.delete(&1))
    |> Response.apply_and_render(conn)
  end

  defp id(params), do: String.to_integer(params["id"])
end
