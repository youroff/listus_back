defmodule Listus.ItemController do
  use Listus.Web, :controller

  alias Listus.{List, Item}

  def index(conn, params) do
    list(conn, params)
    |> MonEx.flat_map(& Item.all(&1))
    |> Response.apply_and_render(conn)
  end

  def show(conn, params) do
    list(conn, params)
    |> MonEx.flat_map(& Item.find(&1, id(params)))
    |> Response.apply_and_render(conn)
  end

  def update(conn, params) do
    list(conn, params)
    |> MonEx.flat_map(& Item.find(&1, id(params)))
    |> MonEx.flat_map(& Item.update(&1, params["item"]))
    |> Response.apply_and_render(conn)
  end

  def create(conn, params) do
    list(conn, params)
    |> MonEx.flat_map(& List.create(&1, params["item"]))
    |> Response.apply_and_render(conn)
  end

  def delete(conn, params) do
    list(conn, params)
    |> MonEx.flat_map(& Item.find(&1, id(params)))
    |> MonEx.flat_map(& Item.delete(&1))
    |> Response.apply_and_render(conn)
  end

  defp list(conn, %{"list_id" => id}) do
    List.find(conn.assigns.current_user, String.to_integer(id))
  end
  defp id(params), do: String.to_integer(params["id"])
end
