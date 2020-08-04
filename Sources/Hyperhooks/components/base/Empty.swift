import SwiftUI
import Combine
import JavaScriptCore

final class TextModel: HxModel, ObservableObject {

  @Published var content = ""
  @Published var color = Color.black

  func update(_ jsValue: JSValue) {
    content = jsValue.objectForKeyedSubscript("text")!.toString()!
  }

  var view: AnyView { AnyView(TextView(model: self)) }
}

struct TextView : View {
  @ObservedObject var model: TextModel
  var body: some View {
    Text(model.content).foregroundColor(model.color)
  }
}
