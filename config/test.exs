use Mix.Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ex_marketer, ExMarketer.Repo,
  username: "postgres",
  password: "postgres",
  database: "ex_marketer_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ex_marketer_web, ExMarketerWeb.Endpoint,
  http: [port: 4002],
  server: true

config :ex_marketer_web, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Wallaby
config :wallaby,
  otp_app: :ex_marketer,
  chromedriver: [headless: System.get_env("CHROME_HEADLESS", "true") !== "false"],
  screenshot_dir: "tmp/wallaby_screenshots",
  screenshot_on_failure: true

config :ex_marketer,
  google_client: ExMarketer.Crawler.GoogleClientMock,
  http_adapter: ExMarketer.Crawler.HttpAdapterMock
