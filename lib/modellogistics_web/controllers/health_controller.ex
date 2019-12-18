defmodule ModellogisticsWeb.HealthController do
  use ModellogisticsWeb, :controller

  defp get_config() do
    {:ok, contents} = File.read("config.toml")
    {:ok, config} = Toml.decode(contents)
    config
  end

  defp health_names(config) do
    %{"endpoints" => endpoints} = config
    Map.keys(endpoints)
  end

  defp health_endpoints(config, names) do
    names
      |> Enum.map(fn name -> config["endpoints"][name] end)
      |> Enum.map(fn endpoint -> endpoint["url"] <> endpoint["health"] end)
  end

  def health(conn, _params) do
    c = get_config()
    health_names = health_names(c)
    endpoints = health_endpoints(c, health_names)
    status_codes = endpoints
      |> Enum.map(fn url -> Task.async(fn -> HTTPoison.get(url) end) end)
      |> Enum.map(fn task -> Task.await(task, 1500) end)
      |> Enum.map(fn {:ok, response} -> response.status_code end)
    all_statuses = Enum.zip(health_names, status_codes)
      |> Enum.map(fn {t1, t2} -> %{t1 => t2} end)
    jsonstruct = %{"statuses" => all_statuses}
    {:ok, jsonstring} = Jason.encode(jsonstruct)
    text(conn, jsonstring)
  end
end
