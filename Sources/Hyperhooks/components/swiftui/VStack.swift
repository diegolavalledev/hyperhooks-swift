import SwiftUI
import Combine
import JavaScriptCore

final class VStackModel: ObservableObject, HxContainer  {
  
  @Published var children: [HxAnyModel] = []

  func update(_ jsValue: JSValue) -> () { }

  var view: AnyView { AnyView(VStackView(model: self)) }
}

struct VStackView: View {
  @ObservedObject var model: VStackModel

  var body: some View {
    VStack {
      ForEach(model.children) {
        $0.view
      }
    }
  }
}
