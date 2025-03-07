import clip.{type Command}
import clip/opt.{type Opt}

fn city_opt() -> Opt(String) {
  opt.new("city") |> opt.help("Enter the city you want to query")
}

pub fn command() -> Command(String) {
  clip.command({
    use city <- clip.parameter
    city
  })
  |> clip.opt(city_opt())
  // |> clip.opt(age_opt())
}
