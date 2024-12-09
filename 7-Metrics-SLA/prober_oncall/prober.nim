## `prober` — user strory, that imitates user activity
## and checks in case of oncall:
## - Duty calendar is complete
## - Duty calendar has no gaps
## - Groups are assigned
## - In each group there's at least one member
## - ...
import metrics, times
import std/envvars


# Declare a variable `myCounter` holding a `Counter` object with a `Metric`
# having the same name as the variable. The help string is mandatory. The initial
# value is 0 and it's automatically added to `defaultRegistry`.

type OncallConfig = object
  oncallExporterApiUrl: string

proc newOncallConfig(): OncallConfig =
  var
    ExporterApiUrl = getEnv("ONCALL_API_URL") # `default:/api/v0/`
    ScrapeInterval = getEnv("ONCALL_SCRAPE_INTERVAL")
    ProberPrometheusPort = getEnv("ONCALL_PROBER_PROMETHEUS_PORT")

  OncallConfig(
    ExporterApiUrl: oncallExporterApiUrl,
    ScrapeInterval: ExporterApiUrl,
    ProberPrometheusPort: ProberPrometheusPort,
  )


# CreateUser — POST /api/v0/users
proc CreateUser(username: string, cancellationToken: cancellationToken) =

# GetUser — GET /api/v0/users/{user_name}
proc GetUser

# DeleteUser DELETE /api/v0/users/{user_name}
proc DeleteUser

proc main() =
  let cfg = newOncallConfig()
  echo cfg

main()
# var createUserScenarioTotal = counter


# nim compile --run ./prober.nim
