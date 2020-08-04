extension HxComponent {
  static var div: Self {
    .init("Div", model: DivModel.self)
  }
}

extension Array where Element == HxComponent {
  static var html: Self {[
    .div,
    .init("Span", model: SpanModel.self),
    .init("Button", model: ButtonModel.self),
    .init("Input", model: InputModel.self),
  ]}
}
