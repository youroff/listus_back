defmodule Listus.ItemView do
  use Listus.Web, :view

  def render("index.json", %{data: items}) do
    Enum.map items, & Map.from_struct(&1)
  end

  def render("show.json", %{data: item}) do
    Map.from_struct(item)
  end

  def render("create.json", %{data: item}) do
    Map.from_struct(item)
  end
end
