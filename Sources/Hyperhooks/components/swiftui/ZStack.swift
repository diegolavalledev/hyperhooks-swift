import SwiftUI
import Combine
import JavaScriptCore

final class ZStackModel: ObservableObject, HxContainer  {
  
  @Published var children: [HxAnyModel] = []

  func update(_ jsValue: JSValue) -> () { }

  var view: AnyView { AnyView(ZStackView(model: self)) }
}

struct ZStackView: View {
  @ObservedObject var model: ZStackModel

  var body: some View {
    ZStack {
      ForEach(model.children) {
        $0.view
      }
    }
  }
}
