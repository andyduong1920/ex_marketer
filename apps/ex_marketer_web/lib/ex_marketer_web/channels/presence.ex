defmodule ExMarketerWeb.Presence do
  use Phoenix.Presence,
    otp_app: :ex_marketer_web,
    pubsub_server: ExMarketer.PubSub
end
