defmodule ModellogisticsWeb.Plugs.StartTimer do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    start = DateTime.utc_now
    assign(conn, :start, start)
  end

end
