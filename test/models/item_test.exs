defmodule Listus.ItemTest do
  use ExUnit.Case, async: false
  alias Listus.{Item, List, User}
  import MonEx.{Result, Option}

  setup do
    ok(user) = User.create()
    ok(list) = List.create(user, %{name: "My List"})
    ok(user: user, list: list)
  end

  test "create", %{list: list} do
    assert error(e) = Item.create(list, %{name: ""})
    assert {"can't be blank", _} = e.errors[:name]

    assert ok(item) = Item.create(list, %{name: "Banana"})
    assert item.name == "Banana"
  end

  test "create dupe", %{list: list} do
    assert ok(item) = Item.create(list, %{name: "Banana"})
    assert ok(item2) = Item.create(list, %{name: "banana"})
    assert item2.id == item.id
  end

  test "all", %{list: list} do
    Item.create(list, %{name: "First", pos: 0})
    Item.create(list, %{name: "Second", pos: 1})

    assert Enum.map(Item.all(list), & &1.name) == ["First", "Second"]
    item_names = Enum.map(Item.all(list), & &1.name)
    assert Enum.member?(item_names, "First")
    assert Enum.member?(item_names, "Second")
  end

  test "find", %{list: list} do
    ok(item) = Item.create(list, %{name: "First", pos: 0})
    assert some(i) = Item.find(list, item.id)
    assert i == item
  end

  test "update", %{list: list} do
    ok(item) = Item.create(list, %{name: "First"})
    error(e) = Item.update(item, %{qty: 0})
    assert {"must be greater than %{number}", _} = e.errors[:qty]

    ok(item) = Item.update(item, %{name: "LOL", qty: 50, pos: 5})
    assert item.name == "First" # Can't change the name on update
    assert item.qty == 50
    assert item.pos == 5
  end

  test "delete", %{list: list} do
    ok(item) = Item.create(list, %{name: "First"})
    ok(stats) = Item.delete(item)
    assert stats == %{stats: %{"relationships-deleted" => 1}, type: "w"}
  end
end
