import SwiftUI
import Combine
import JavaScriptCore

final class SpanModel: ObservableObject, HxContainer  {
  @Published var children: [HxAnyModel] = []

  func update(_ jsValue: JSValue) -> () { }

  var view: AnyView { AnyView(SpanView(model: self)) }
}

struct SpanView: View {
  @ObservedObject var model: SpanModel

  var body: some View {
    HStack {
      ForEach(model.children) {
        $0.view
      }
    }
  }
}
