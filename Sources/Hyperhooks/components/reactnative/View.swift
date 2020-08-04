import SwiftUI
import Combine
import JavaScriptCore

final class RnViewModel: ObservableObject, HxContainer {
  
  @Published var children: [HxAnyModel] = []

  func update(_ jsValue: JSValue) -> () { }

  var view: AnyView { AnyView(RnViewView(model: self)) }
}

struct RnViewView: View {
  @ObservedObject var model: RnViewModel

  var body: some View {
    VStack {
      ForEach(model.children) {
        $0.view
      }
    }
  }
}
