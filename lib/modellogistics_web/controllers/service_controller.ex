defmodule ModellogisticsWeb.ServiceController do
  use ModellogisticsWeb, :controller
  require Logger

  defp get_config() do
    {:ok, contents} = File.read("config.toml")
    {:ok, config} = Toml.decode(contents)
    config
  end

  defp start_request(url, _body) do
    starttime = DateTime.utc_now
    {:ok, starttime, url, Task.async(fn -> HTTPoison.get(url) end)}
  end

  defp finish_request(tasktuple) do
    {:ok, starttime, url, task} = tasktuple
    {:ok, response} = Task.await(task)
    endtime = DateTime.utc_now
    diff = DateTime.diff(endtime, starttime, :microsecond)
    ms = Float.to_string(diff/1000)
    Logger.debug(Jason.encode!(%{"url" => url, "elapsed_time" => ms <> " ms", "status_code" => response.status_code}))
    Jason.decode!(response.body)
  end

  def index(conn, %{"service" => "hello"}) do
    c = get_config()
    %{"services" => %{"hello" => %{"stages" => [stages]}}} = c
    endpoint_urls = stages
      |> Enum.map(fn name -> c["endpoints"][name]["url"] <> c["endpoints"][name]["inference"] end)

    responses = endpoint_urls
      |> Enum.map(fn x -> start_request(x, nil) end)
      |> Enum.map(fn task -> finish_request(task) end)

    responses_map = Enum.zip(stages, responses)
      |> Enum.into(%{})

    combined_response = %{"responses" => responses_map}
    {:ok, encoded} = Jason.encode(combined_response)
    text(conn, encoded)
  end

  def index(conn, params) do
    %{"service" => svc} = params
    text(conn, "service " <> svc)
  end

end
