defmodule ModellogisticsWeb.PingControllerTest do
  use ModellogisticsWeb.ConnCase
  import ExUnit.CaptureLog

  test "GET /ping", %{conn: conn} do
    conn = get(conn, "/ping")
    assert text_response(conn, 200) == "pong"
  end
end
