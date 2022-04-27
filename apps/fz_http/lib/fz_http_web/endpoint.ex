defmodule FzHttpWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :fz_http
  alias FzHttpWeb.Session

  if Application.get_env(:fz_http, FzHttpWeb.Endpoint, :proxy_forwarded) do
    plug Plug.RewriteOn, [:x_forwarded_host, :x_forwarded_port, :x_forwarded_proto]
  end

  if Application.get_env(:fz_http, :sql_sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox
  end

  socket "/socket", FzHttpWeb.UserSocket,
    websocket: [
      connect_info: [:peer_data, :x_headers, :uri],
      # XXX: channel token should prevent CSWH but double check
      check_origin: false
    ],
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [
      connect_info: [
        session: {Session, :options, []}
      ],
      # XXX: csrf token should prevent CSWH but double check
      check_origin: false
    ]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :fz_http,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket,
      websocket: [
        connect_info: [
          session: {Session, :options, []}
        ],
        # XXX: csrf token should prevent CSWH but double check
        check_origin: false
      ]

    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :fz_http
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug(:session)
  plug FzHttpWeb.Router

  defp session(conn, _opts) do
    Plug.Session.call(conn, Plug.Session.init(Session.options()))
  end
end
