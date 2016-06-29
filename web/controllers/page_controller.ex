defmodule Flinc.PageController do
  use Flinc.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
