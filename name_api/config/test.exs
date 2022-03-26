import Config

config :logger,
  level: :none

config :name_api,
  call_api: NameApi.CallApiMock
