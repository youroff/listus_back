defmodule JSONApi.Response do
  import MonEx.{Result, Option}
  import Phoenix.Controller
  import Plug.Conn

  def apply(item, conn, opts \\ [])
  def apply(ok(model), %Plug.Conn{} = conn, opts) do
    conn
    |> assign(Keyword.get(opts, :as, :data), model)
    |> put_status(status conn)
  end

  def apply(error(e), %Plug.Conn{} = conn, _) do
    conn
    |> assign(:error, e)
    |> put_status(:unprocessable_entity)
  end

  def apply(some(model), %Plug.Conn{} = conn, opts) do
    conn
    |> assign(Keyword.get(opts, :as, :data), model)
    |> put_status(status conn)
  end

  def apply(none(), %Plug.Conn{} = conn, _) do
    conn
    |> put_status(:not_found)
  end

  def apply(models, %Plug.Conn{} = conn, opts) when is_list(models) do
    conn
    |> assign(Keyword.get(opts, :as, :data), models)
    |> put_status(status conn)
  end

  def render(conn) do
    case conn do
      %Plug.Conn{status: 422} ->
        json(conn, %{errors: transform_errors(conn.assigns.error)})
      %Plug.Conn{status: 204} ->
        json(conn, "")
      %Plug.Conn{status: 404} ->
        json(conn, "Not found")
      %Plug.Conn{status: 403} ->
        json(conn, "Not authorized")
      _ ->
        Phoenix.Controller.render(conn)
    end
  end

  def apply_and_render(res, conn, opts \\ []) do
    __MODULE__.apply(res, conn, opts) |> __MODULE__.render()
  end

  defp status(%Plug.Conn{private: %{phoenix_action: :create}}), do: :created
  defp status(%Plug.Conn{private: %{phoenix_action: :update}}), do: :no_content
  defp status(%Plug.Conn{private: %{phoenix_action: :delete}}), do: :no_content
  defp status(_), do: :ok

  # Adjust formats
  defp transform_errors(error) do
    Ecto.Changeset.traverse_errors(error, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
