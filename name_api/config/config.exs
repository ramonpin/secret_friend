import Config

config :logger,
  level: :debug

config :name_api,
  host: "localhost",
  port: 3000,
  call_api: NameApi.CallApi

## Load environment configuration
config_env = "#{Mix.env()}.exs"

if File.exists?("config/#{config_env}") do
  import_config(config_env)
end
