defmodule Listus.ListTest do
  use ExUnit.Case, async: false
  alias Listus.{List, User}
  import MonEx.{Result, Option}

  setup do
    ok(user) = User.create()
    ok(user: user)
  end

  test "create", %{user: user} do
    assert error(e) = List.create(user, %{})
    assert {"can't be blank", _} = e.errors[:name]

    assert ok(list) = List.create(user, %{name: "My List"})
    assert list.name == "My List"
  end

  test "all", %{user: user} do
    List.create(user, %{name: "First List"})
    List.create(user, %{name: "Second List"})

    assert Enum.map(List.all(user), & &1.name) == ["First List", "Second List"]
  end

  test "find", %{user: user} do
    ok(list) = List.create(user, %{name: "First List"})
    assert some(l) = List.find(user, list.id)
    assert l == list
  end

  test "update", %{user: user} do
    ok(list) = List.create(user, %{name: "First List"})
    error(e) = List.update(list, %{name: ""})
    assert {"can't be blank", _} = e.errors[:name]
    ok(list) = List.update(list, %{name: "LOL"})
    assert list.name == "LOL"
  end

  test "delete", %{user: user} do
    ok(list) = List.create(user, %{name: "First List"})
    ok(stats) = List.delete(list)
    assert stats == %{stats: %{"nodes-deleted" => 1, "relationships-deleted" => 1}, type: "w"}
  end
end
