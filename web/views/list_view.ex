defmodule Listus.ListView do
  use Listus.Web, :view

  def render("index.json", %{data: lists}) do
    Enum.map lists, & Map.from_struct(&1)
  end

  def render("show.json", %{data: list}) do
    Map.from_struct(list)
  end

  def render("create.json", %{data: list}) do
    Map.from_struct(list)
  end
end
