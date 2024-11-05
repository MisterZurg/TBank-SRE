## `prober` ... imitates user activity
import metrics, times
import std/envvars


# Declare a variable `myCounter` holding a `Counter` object with a `Metric`
# having the same name as the variable. The help string is mandatory. The initial
# value is 0 and it's automatically added to `defaultRegistry`.

type Config = object
  oncallExporterApiUrl: string

proc newConfig(): Config =
  var oncallExporterApiUrl = getEnv("ZELIBOBA")
  # exporterScrapeInterval
  #

  Config(oncallExporterApiUrl: oncallExporterApiUrl)


proc main() =
  let cfg = newConfig()
  echo cfg

main()
# var createUserScenarioTotal = counter


# nim compile --run ./prober.nim
