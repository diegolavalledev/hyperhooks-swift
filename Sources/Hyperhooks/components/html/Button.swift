import SwiftUI
import Combine
import JavaScriptCore

final class ButtonModel: ObservableObject, HxModel  {

  @Published var buttonContent = ""
  @Published var action = { } // TODO: Published not needed? Analyze

  func update(_ jsValue: JSValue) -> () {
    buttonContent = jsValue.objectForKeyedSubscript("text")!.toString()!
    let jsAction = jsValue.objectForKeyedSubscript("action")!
    action = {
      jsAction.call(withArguments: [])
    }
  }

  var view: AnyView { AnyView(ButtonView(model: self)) }

}

struct ButtonView : View {
  @ObservedObject var model: ButtonModel

  var body: some View {
    Button(action: model.action) {
      Text(model.buttonContent)
    }
  }
}
