defmodule ModellogisticsWeb.ServiceControllerTest do
  use ModellogisticsWeb.ConnCase

  test "GET /hello", %{conn: conn} do
    conn = get(conn, "/hello")
    response = text_response(conn, 200)
    %{"responses" => [%{"answer" => yn} | _]} = Jason.decode!(response)
    assert (yn == "yes") || (yn == "no")
  end
end
