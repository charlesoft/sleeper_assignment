defmodule SleeperAssignmentWeb.PageController do
  use SleeperAssignmentWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
