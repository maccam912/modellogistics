defmodule ModellogisticsWeb.HealthControllerTest do
  use ModellogisticsWeb.ConnCase

  test "GET /health", %{conn: conn} do
    conn = get(conn, "/health")
    assert text_response(conn, 200) =~ "{\"statuses\":[{\"people\":200},{\"yesno\":200}]}"
  end
end
