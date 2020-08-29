# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :ex_marketer,
  ecto_repos: [ExMarketer.Repo]

config :ex_marketer_web,
  ecto_repos: [ExMarketer.Repo],
  generators: [context_app: :ex_marketer]

# Configures the endpoint
config :ex_marketer_web, ExMarketerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uendsnR1rSVMKMmFqKMi84dbJQ7BAaJUdj7aJShc2+vM/ZMz7/nLOX+x1UlwlbwV",
  render_errors: [view: ExMarketerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ExMarketer.PubSub,
  live_view: [signing_salt: "Aqg6zBze"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :hackney, use_default_pool: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
