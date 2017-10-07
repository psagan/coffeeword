# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :coffeeword,
  ecto_repos: [Coffeeword.Repo]

# Configures the endpoint
config :coffeeword, CoffeewordWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "f4cd5bGIhBZkGGBcIq2B7pk4708n3EeRIRmV3lRDPGFLEs7YcGy18xFME1BtDoGw",
  render_errors: [view: CoffeewordWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Coffeeword.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
