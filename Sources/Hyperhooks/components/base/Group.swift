import SwiftUI
import Combine
import JavaScriptCore

final class GroupModel: ObservableObject, HxContainer {

  @Published var children: [HxAnyModel] = []

  func update(_ jsValue: JSValue) -> () { }

  var view: AnyView { AnyView(GroupView(model: self)) }
}

struct GroupView : View {
  @ObservedObject var model: GroupModel

  var body: some View {
    // TODO: Group has issues when re-rendering
    VStack {
      ForEach(model.children) {
        $0.view
      }
    }
  }
}
