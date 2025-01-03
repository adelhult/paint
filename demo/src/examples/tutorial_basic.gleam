import paint
import paint/canvas

pub fn main() {
  let picture = paint.circle(50.0)
  canvas.display(canvas.center(picture), "#mycanvas")
}
