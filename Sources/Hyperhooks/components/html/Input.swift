import SwiftUI
import Combine
import JavaScriptCore

final class InputModel: ObservableObject, HxModel  {

  var type = ""
  @Published var value = ""
  @Published var placeholder = ""
  @Published var onchange: (String) -> () = {_ in }

  func update(_ jsValue: JSValue) -> () {
    type = jsValue.objectForKeyedSubscript("type")!.toString()!
    value = jsValue.objectForKeyedSubscript("value")!.toString()!
    placeholder = jsValue.objectForKeyedSubscript("placeholder")!.toString()!
    let jsOnchange = jsValue.objectForKeyedSubscript("onChange")!
    onchange = {
      jsOnchange.call(withArguments: [$0])
    }
  }

  var view: AnyView { AnyView(InputView(model: self)) }
}

struct InputView : View {
  @ObservedObject var model: InputModel
  
  func onCommit() -> () -> () {
    {
      self.model.onchange(self.model.value)
    }
  }

  var body: some View {
    Group {
      if model.type == "password" {
        SecureField(
          model.placeholder,
          text: $model.value,
          onCommit: onCommit()
        )
      } else {
        TextField(
          model.placeholder,
          text: $model.value,
          onCommit: onCommit()
        )
      }
    }
      .textFieldStyle(RoundedBorderTextFieldStyle())
  }
}
