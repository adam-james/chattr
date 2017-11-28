defmodule ChattrWeb.PageController do
  use ChattrWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
