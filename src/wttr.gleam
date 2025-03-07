import argv
import cli
import clip
import clip/help
import gleam/http/request
import gleam/httpc
import gleam/io
import gleam/result
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

pub fn get_wttr(city: String) -> Result(String, Nil) {
  let assert Ok(base_request) =
    request.to(string.concat(["https://wttr.in/", city, "?format=1"]))

  let response = httpc.send(base_request)

  case response {
    Ok(r) -> Ok(r.body)
    Error(_) -> Error(Nil)
  }
}
