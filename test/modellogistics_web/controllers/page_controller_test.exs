defmodule ModellogisticsWeb.PageControllerTest do
  use ModellogisticsWeb.ConnCase

  test "GET /ui", %{conn: conn} do
    conn = get(conn, "/ui")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
