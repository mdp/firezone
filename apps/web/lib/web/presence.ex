defmodule Web.Presence do
  use Phoenix.Presence,
    otp_app: :domain,
    pubsub_server: Domain.PubSub
end
