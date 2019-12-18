defmodule ModellogisticsWeb.Plugs.Logging do
  require Logger
  import Plug.Conn
  alias Plug.Conn

  def init(default), do: default

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _default) do
    Logger.debug(Jason.encode!(%{"request" => conn.body_params}))
    start = DateTime.utc_now
    assign(conn, :start, start)

    conn = Conn.register_before_send(conn, fn conn ->
      stop = DateTime.utc_now
      diff = DateTime.diff(stop, start, :microsecond)
      ms = Float.to_string(diff/1000)
      status = Integer.to_string(conn.status)
      resp = conn.resp_body
      Logger.debug(Jason.encode!(%{"elapsed_time" => ms <> " ms"}))
      Logger.debug(Jason.encode!(%{"status" => status}))
      Logger.debug(Jason.encode!(%{"response" => resp}))
      conn
    end)

    conn
  end
end
