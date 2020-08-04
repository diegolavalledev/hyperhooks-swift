import Foundation

public class HxRegistry {

  public enum Component {
    case html
    case swiftUI
    case reactNative
    case pack([HxComponent])
    case single(HxComponent)
  }

  var models: [String: HxModel.Type] = [:]
  var scripts: [String: URL] = [:]

  public static let shared: HxRegistry = {
    let instance = HxRegistry()
    instance.addComponent(.init("", model: TextModel.self))
    instance.addComponent(.init("Group", model: GroupModel.self))
    return instance
  }()

  public func addComponent(_ component: HxComponent) {
    guard models[component.name] == nil else {
      // Component already registrered
      return
    }
    models[component.name] = component.model
    scripts[component.name] = component.js
  }

  public func addComponents(_ components: [HxComponent]) {
    components.forEach(addComponent)
  }
}
