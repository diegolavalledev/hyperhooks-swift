import SwiftUI
import JavaScriptCore

public protocol HxModel {
  init?()
  var view: AnyView { get }
  func update(_: JSValue)
}
