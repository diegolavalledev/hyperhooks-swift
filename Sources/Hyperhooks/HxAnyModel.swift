import SwiftUI
import JavaScriptCore
import Combine

public final class HxAnyModel: ObservableObject, HxModel, Identifiable  {
  
  private var model: HxModel

  init(_ model: HxModel) {
    self.model = model
  }

  public init?() {
    return nil
  }

  public var view: AnyView { model.view }

  public func update(_ jsValue: JSValue) {
    // self.objectWillChange.send()
    model.update(jsValue)
  }
}
