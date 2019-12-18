defmodule ModellogisticsWeb.ServiceController do
  use ModellogisticsWeb, :controller

  defp get_config() do
    {:ok, contents} = File.read("config.toml")
    {:ok, config} = Toml.decode(contents)
    config
  end

  def index(conn, %{"service" => "hello"}) do
    c = get_config()
    %{"services" => %{"hello" => endpoint_names}} = c
    endpoints = endpoint_names
      |> Enum.map(fn name -> c["endpoints"][name] end)
    responses = endpoints
      |> Enum.map(fn x -> HTTPoison.get(x) end)
      |> Enum.map(fn {:ok, %HTTPoison.Response{body: body}} -> Jason.decode(body) end)
      |> Enum.map(fn {:ok, content} -> content end)

    combined_response = %{"responses" => responses}
    {:ok, encoded} = Jason.encode(combined_response)
    text(conn, encoded)
  end

  def index(conn, params) do
    %{"service" => svc} = params
    text(conn, "service " <> svc)
  end

end
