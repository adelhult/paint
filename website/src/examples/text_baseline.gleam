import paint as p

pub fn baseline_example() {
  let px = 20
  p.combine([
    p.text("Hello", px:)
      |> p.text_baseline(p.TextBaselineAlphabetic)
      |> p.translate_x(-50.0),
    p.text("Hello", px:) |> p.text_baseline(p.TextBaselineBottom),
  ])
}
