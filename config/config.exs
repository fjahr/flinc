# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :flinc, Flinc.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "HpXsTaYNFJJzS6C6v9EiVFi+eGtbJ4WpFTwZj1dTo7rvVRUmteYKQHAj2sm8UDUH",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Flinc.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

# Configure guardian
config :guardian, Guardian,
  issuer: "Flinc",
  ttl: { 3, :days },
  verify_issuer: true,
  allowed_algos: ["ES512"],
  secret_key: %{
    "crv" => "P-521",
    "d" => "axDuTtGavPjnhlfnYAwkHa4qyfz2fdseppXEzmKpQyY0xd3bGpYLEF4ognDpRJm5IRaM31Id2NfEtDFw4iTbDSE",
    "kty" => "EC",
    "x" => "AL0H8OvP5NuboUoj8Pb3zpBcDyEJN907wMxrCy7H2062i3IRPF5NQ546jIJU3uQX5KN2QB_Cq6R_SUqyVZSNpIfC",
    "y" => "ALdxLuo6oKLoQ-xLSkShv_TA0di97I9V92sg1MKFava5hKGST1EKiVQnZMrN3HO8LtLT78SNTgwJSQHAXIUaA-lV"
  },
  serializer: Flinc.GuardianSerializer,
  hooks: GuardianDb

config :hound, driver: "chrome_driver"

config :guardian_db, GuardianDb,
  repo: Flinc.Repo,
  sweep_interval: 1440

config :flinc, ecto_repos: [Flinc.Repo]

config :ex_admin,
  repo: Flinc.Repo,
  module: Flinc,
  modules: [
    Flinc.ExAdmin.Dashboard,
    Flinc.ExAdmin.User,
    Flinc.ExAdmin.Board,
    Flinc.ExAdmin.List,
    Flinc.ExAdmin.Card
  ]

config :xain, :after_callback, {Phoenix.HTML, :raw}
