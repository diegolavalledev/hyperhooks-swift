import Foundation

public struct HxComponent {
  let name: String
  let model: HxModel.Type
  let js: URL
  
  public init(_ name: String, model: HxModel.Type, js: URL? = nil) {
    self.name = name
    self.model = model
    let jsName = name == "" ? "Empty" : name
    self.js = js == nil
      ? Bundle.module.url(forResource: jsName, withExtension: "js")!
      : js!
  }
}
