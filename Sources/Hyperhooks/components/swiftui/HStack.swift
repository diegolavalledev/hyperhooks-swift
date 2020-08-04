import SwiftUI
import Combine
import JavaScriptCore

final class HStackModel: ObservableObject, HxContainer  {
  
  @Published var children: [HxAnyModel] = []

  func update(_ jsValue: JSValue) -> () { }

  var view: AnyView { AnyView(HStackView(model: self)) }
}

struct HStackView: View {
  @ObservedObject var model: HStackModel

  var body: some View {
    HStack {
      ForEach(model.children) {
        $0.view
      }
    }
  }
}
