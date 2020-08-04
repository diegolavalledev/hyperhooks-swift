import SwiftUI
import Combine
import JavaScriptCore

final class DivModel: ObservableObject, HxContainer {
  
  @Published var children: [HxAnyModel] = []
  @Published var backgroundColor: Color = Color.clear

  func update(_ jsValue: JSValue) -> () { }

  var view: AnyView { AnyView(DivView(model: self)) }
}

struct DivView: View {
  @ObservedObject var model: DivModel

  var body: some View {
    VStack {
      ForEach(model.children) {
        $0.view
      }
    }
    .background(model.backgroundColor)
  }
}
