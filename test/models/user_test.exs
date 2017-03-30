defmodule Listus.UserTest do
  use ExUnit.Case, async: false
  alias Listus.User
  import MonEx.Result

  test "create / find_by_uuid" do
    ok(user) = User.create()
    assert ok(found) = User.find_by_uuid(user.uuid)
    assert found.id == user.id
    assert error(:empty) = User.find_by_uuid("WTFLOL")
  end
end
