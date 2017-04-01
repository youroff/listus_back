defmodule Listus.UserTest do
  use ExUnit.Case, async: false
  alias Listus.User
  import MonEx.{Result, Option}

  test "create / find_by_uuid" do
    ok(user) = User.create()
    assert some(found) = User.find_by_uuid(user.uuid)
    assert found.id == user.id
    assert none() = User.find_by_uuid("WTFLOL")
  end
end
