import SwiftUI
import Combine
import JavaScriptCore

final class SpacerModel: ObservableObject, HxModel {
  func update(_ jsValue: JSValue) -> () { }
  var view: AnyView { AnyView(SpacerView(model: self)) }
}

struct SpacerView: View {
  @ObservedObject var model: SpacerModel

  var body: some View {
    Spacer()
  }
}
