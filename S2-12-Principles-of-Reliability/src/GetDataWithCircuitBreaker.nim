import httpclient,
  times, os,
  strformat, strutils

type
  State = enum
    Closed, Open, HalfOpen

  CircuitBreaker = ref object
      state: State
      n_fails: int

proc hello_objects(cb: CircuitBreaker) =
  # override this base method
  echo "CircuitBreaker with State ", cb.state, "n_fails ", cb.n_fails

proc setState(cb: CircuitBreaker, state: State) =
  echo "->> Changing State from ", cb.state, "to ", state
  cb.state = state

proc sendRequest(url: string): (string, string) =
  var client = newHttpClient()
  try:
    let response = client.get(url)
    if response.status.startsWith("2"):
      echo "->> Sucess req"
      return (response.status, response.body[ .. 55])
    else:
      echo "->> Failed req"
      return (response.status, "Failed")
  except HttpRequestError as e:
      echo "HTTP Request Failed: ", e.msg
  except Exception as e:
      echo "An unexpected error occurred: ", e.msg
      return ("", "")


proc GetDataWithCircuitBreaker(cb: CircuitBreaker, url: string): string  =
  ## GetDataWithCircuitBreaker — имплементирует логику CircuitBreaker
  ##  1. В нормальном состоянии (Closed) — отправлять запросы как обычно.
  ##  2. При нескольких подряд ошибках (3 неудачи) — переключаться в режим Open и блокировать запросы на 10 секунд.
  ##  3. После тайм-аута (10 сек) — переключаться в режим Half-Open и разрешать 1 тестовый запрос.
  var
    maxFails = 3

  echo "->> Trying to send request to ", url

  while true:
    case cb.state
    of State.Closed:
      while cb.n_fails < maxFails:
        try:
          let (status, body) = sendRequest(url)

          if status.startsWith("2"):
            let resp = fmt"""
            Status: {status}
            Body: {body}"""
            return resp
          else:
            cb.n_fails += 1

        except Exception as e:
            echo "->> Shit happend: ", e.msg
            return ""

      # 2. При нескольких подряд ошибках (3 неудачи) — переключаться в режим Open и блокировать запросы на 10 секунд.
      cb.setState(State.Open)
    of State.Open:
      echo "->> Blocking requests for 10 seconds"
      sleep(10000)
      # 3. После тайм-аута (10 сек) — переключаться в режим Half-Open и разрешать 1 тестовый запрос.
      cb.setState(State.HalfOpen)
    of State.HalfOpen:
      try:
        let (status, body) = sendRequest(url)
        # Если запрос успешен → вернуться в Closed.
        if status.startsWith("2"):
          cb.setState(State.Closed)
          let resp = fmt"""
          Status: {status}
          Body: {body}"""
          return resp
        else:
          # Если снова ошибка → остаться в Open.
          cb.setState(State.Open)

      except Exception as e:
          echo "->> Shit happend: ", e.msg
          return ""


# nimble build --verbose -d:ssl
var cb = CircuitBreaker(state: Closed, n_fails: 0)

echo cb.GetDataWithCircuitBreaker("http://google.com")

# Reset ...
cb = CircuitBreaker(state: Closed, n_fails: 0)

try:
  echo cb.GetDataWithCircuitBreaker("https://httpstat.us/500")
except Exception as e:
  echo "Error: ", e.msg
