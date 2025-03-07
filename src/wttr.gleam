import gleam/http/request
import gleam/http/response
import gleam/httpc
import gleam/io
import gleam/result
import gleam/string
import gleam/string_tree
import gleeunit/should

pub fn main() {
  io.println("Hello from wttr!")
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
