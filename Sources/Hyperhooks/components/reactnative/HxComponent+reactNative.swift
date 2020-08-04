extension Array where Element == HxComponent {
  static var reactNative: Self {[
    .init("View", model: RnViewModel.self)
  ]}
}
