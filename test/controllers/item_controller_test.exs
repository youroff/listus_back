defmodule Listus.ItemControllerTest do
  use Listus.ConnCase
  alias Listus.{User, List, Item}

  setup %{conn: conn} do
    ok(user) = User.create()
    ok(list) = List.create(user, %{name: "My List"})
    ok(item) = Item.create(list, %{name: "Banana", pos: 0})
    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user, list: list, item: item}
  end

  test "load items", %{conn: conn, user: user, list: list} do
    Item.create(list, %{name: "Carrot"})
    conn = get conn, list_item_path(conn, :index, list), uuid: user.uuid
    items = json_response(conn, 200)
    assert Enum.map(items, & &1["name"]) == ["Banana", "Carrot"]
  end

  test "show item", %{conn: conn, user: user, list: list, item: item} do
    conn = get conn, list_item_path(conn, :show, list, item), uuid: user.uuid
    i = json_response(conn, 200)
    assert i["id"] == item.id
  end

  test "creates item", %{conn: conn, user: user, list: list} do
    conn = post conn, list_item_path(conn, :create, list), uuid: user.uuid, item: [name: "LOL"]
    assert %{"name" => "LOL", "id" => _} = json_response(conn, 201)
  end

  test "update item", %{conn: conn, user: user, list: list, item: item} do
    conn = put conn, list_item_path(conn, :update, list, item), uuid: user.uuid, item: [name: "LOL", pos: 10, qty: 2]
    assert json_response(conn, 204)
    some(i) = Item.find(list, item.id)
    assert i.id == item.id
    assert i.name == "Banana" # Can't change
    assert i.qty == 2
    assert i.pos == 10
  end

  test "delete item", %{conn: conn, user: user, list: list, item: item} do
    conn = delete conn, list_item_path(conn, :update, list, item), uuid: user.uuid
    assert json_response(conn, 204)
    assert none() = Item.find(list, item.id)
  end
end
