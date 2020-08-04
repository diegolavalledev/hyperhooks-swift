extension Array where Element == HxComponent {
  static var swiftUI: Self {[
    .init("HStack", model: HStackModel.self),
    .init("VStack", model: VStackModel.self),
    .init("ZStack", model: ZStackModel.self),
    .init("Spacer", model: SpacerModel.self),
    //.init("Text", model: SpacerModel.self),
  ]}
}
