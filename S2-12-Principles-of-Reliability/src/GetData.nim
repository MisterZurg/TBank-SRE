import httpclient, strutils
import std/[times, os]
import strformat


type
  OutOfRetriesError = object of Exception


proc GetData(url: string): string {.raises: [HttpRequestError, Exception, OutOfRetriesError].} =
  echo "Getting Data from: ", url
  var
    client = newHttpClient()
    maxRetries = 3
    retryDelayMilliseconds = [0, 1000, 2000]
    retries = 0

  while retries < maxRetries:
    try:
      let response = client.get(url)
      if response.status.startsWith("5"):  # Проверяем, является ли статус 5xx
        echo "Retry with delay: ", retryDelayMilliseconds[retries]
        sleep(retryDelayMilliseconds[retries])
        retries += 1
      else:
          let resp = fmt"""
          Status: {response.status}
          Body: {response.body[ .. 55]}"""
          return resp
    except HttpRequestError as e:
          echo "HTTP Request Failed: ", e.msg
          retries -= 1
          sleep(1000)  # Ждем 1 секунду перед повторной попыткой
    except Exception as e:
          echo "An unexpected error occurred: ", e.msg
          return ""

  raise newException(OutOfRetriesError, "Все попытки исчерпаны")


# nimble run --verbose -d:ssl

echo GetData("http://google.com")

try:
  echo GetData("https://httpstat.us/500")
except OutOfRetriesError as e:
  echo "Error: ", e.msg


# echo GetData("https://httpstat.us/502")
# echo GetData("https://httpstat.us/503")
# echo GetData("https://httpstat.us/504")
