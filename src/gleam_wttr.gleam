import argv
import cli
import clip
import clip/help
import gleam/http/request
import gleam/httpc
import gleam/io
import gleam/json
import gleam/string

pub fn main() {
  let parse =
    cli.command()
    |> clip.help(help.simple("city", "the city you want to query"))
    |> clip.run(argv.load().arguments)

  case parse {
    Ok(city) -> {
      let weather = get_wttr(city)
      case weather {
        Ok(s) -> s |> io.println
        Error(_) -> io.println("wttr.in is currently not available")
      }
    }
    Error(e) -> e |> io.println_error
  }
}

type Weather {
  Weather(emoji: String, degree: String)
}

pub fn get_wttr(city: String) -> Result(String, Nil) {
  // encode % (percent sign) as %25
  let assert Ok(base_request) =
    request.to(string.concat(["https://wttr.in/", city, "?format=%25c%25t"]))

  let response = httpc.send(base_request)

  case response {
    Ok(r) -> {
      case string.split(r.body, on: "  ") {
        [emoji, degree, ..] -> Ok(filter_output(Weather(emoji, degree)))

        _ -> Error(Nil)
      }
    }
    Error(_) -> Error(Nil)
  }
}

fn filter_output(weather_input: Weather) -> String {
  json.object([
    #(
      "text",
      json.string(string.join(
        [weather_input.emoji, weather_input.degree],
        with: "",
      )),
    ),
  ])
  |> json.to_string
  |> string.split(":")
  |> string.join(": ")
}
