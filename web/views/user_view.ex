defmodule Listus.UserView do
  use Listus.Web, :view

  def render("create.json", %{data: user}) do
    Map.from_struct(user)
  end
end
