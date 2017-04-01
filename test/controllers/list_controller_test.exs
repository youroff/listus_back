defmodule Listus.ListControllerTest do
  use Listus.ConnCase
  alias Listus.{User, List}

  setup %{conn: conn} do
    ok(user) = User.create()
    ok(list) = List.create(user, %{name: "My List"})
    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user, list: list}
  end

  test "creates list", %{conn: conn, user: user} do
    conn = post conn, list_path(conn, :create), uuid: user.uuid, list: [name: "My List"]
    assert %{"name" => "My List", "id" => _} = json_response(conn, 201)
  end

  test "load lists", %{conn: conn, user: user, list: list} do
    conn = get conn, list_path(conn, :index), uuid: user.uuid
    assert [l] = json_response(conn, 200)
    assert l["id"] == list.id
  end

  test "show lists", %{conn: conn, user: user, list: list} do
    conn = get conn, list_path(conn, :show, list), uuid: user.uuid
    assert %{"id" => list.id, "name" => list.name} == json_response(conn, 200)
  end

  test "update list", %{conn: conn, user: user, list: list} do
    conn = put conn, list_path(conn, :update, list), uuid: user.uuid, list: [name: "LOL"]
    assert json_response(conn, 204)
    some(list) = List.find(user, list.id)
    assert list.name == "LOL"
  end

  test "delete list", %{conn: conn, user: user, list: list} do
    conn = delete conn, list_path(conn, :update, list), uuid: user.uuid
    assert json_response(conn, 204)
    assert none() = List.find(user, list.id)
  end
end
