defmodule ModellogisticsWeb.PingController do
  use ModellogisticsWeb, :controller

  def index(conn, _params) do
    text(conn, "pong")
  end
end
