# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config
alias FzCommon.{CLI, FzInteger, FzString}

# Optional config across all envs
external_url = System.get_env("EXTERNAL_URL") || "http://localhost:4000"

# Enable Forwarded headers, e.g 'X-FORWARDED-HOST'
proxy_forwarded = FzString.to_boolean(System.get_env("PROXY_FORWARDED") || "false")

%{host: host, path: path, port: port, scheme: scheme} = URI.parse(external_url)

config :fz_http, FzHttpWeb.Endpoint,
  url: [host: host, scheme: scheme, port: port, path: path],
  check_origin: ["//127.0.0.1", "//localhost", "//#{host}"],
  proxy_forwarded: proxy_forwarded
