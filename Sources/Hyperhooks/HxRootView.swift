import SwiftUI
import Combine
import JavaScriptCore

import HyperhooksCore // Comment-out to resolve Previews issues with Xcode 12 Beta 4

public struct HxRootView : View {

  let rootContainer: HxContainer

  public var body: some View {
    rootContainer.view
  }

  public init(_ entryPoint: String = "main", components: [HxRegistry.Component] = [.html]) {
  
    let providedEntryPointUrl = Bundle.main.url(forResource: entryPoint, withExtension: "js")
    
    let realEntryPoint = providedEntryPointUrl == nil
      ? Bundle.module.url(forResource: "default-main", withExtension: "js")!
      : providedEntryPointUrl!

    components.forEach {
      switch $0 {
      case .html:
        HxRegistry.shared.addComponents(.html)
      case .swiftUI:
        HxRegistry.shared.addComponents(.swiftUI)
      case .reactNative:
        HxRegistry.shared.addComponents(.reactNative)
      case .pack(let p):
        HxRegistry.shared.addComponents(p)
      case .single(let c):
        HxRegistry.shared.addComponent(c)
      }
    }

    // The Javascript Context
    let context:JSContext! = JSContext()
    
    // TODO: allow to initialize any container with arbitrary data
    // Initialize  a div with undefined data
    rootContainer = GroupModel()

    // Console log
    let consoleLog: @convention(block) (String) -> ()  = {
      print($0)
    }
    let console = JSValue.init(newObjectIn: context)!
    console.setValue(consoleLog, forProperty: "log")
    context.setObject(console, forKeyedSubscript: "console" as NSString)

    var currentContainer = rootContainer
    var getContainer: (@convention(block) () -> JSValue)!

    getContainer = {
      // Capture reference to the current data
      var capturedContainer = currentContainer

      // Callback for adding an element to current level
      let createElement: @convention(block) (JSValue, JSValue) -> JSValue = {componentNameOrUndefined, jsValue in
        let emptyContainer = componentNameOrUndefined.isUndefined
        if (emptyContainer) {
          capturedContainer.children.removeAll()
          return JSValue(undefinedIn: context)
        }
        let componentName = componentNameOrUndefined.toString()!
        // let resolvedComponent = componentName == "" ? "Text" : componentName
        guard let modelType = HxRegistry.shared.models[componentName] else {
          // Error
          return JSValue(object: "ERROR: Native component unknown to HxRegistry", in: context)
        }
        let model = modelType.init()!
        model.update(jsValue)
        // Append to container
        capturedContainer.children.append(HxAnyModel(model))
        // Move the container cursor down one level
        if let container = model as? HxContainer {
          currentContainer = container
        }
        // Recursively return the callback creator
        return getContainer()
      }
      return JSValue(object: createElement, in: context)
    }

    // Setup the HyperBridge namespace in javascript
    let hyperBridgeJs = JSValue(newObjectIn: context)!
    context.setObject(hyperBridgeJs, forKeyedSubscript: "Hyperhooks" as NSString)
    hyperBridgeJs.setValue(getContainer, forProperty: "getRoot")

    // Finally run the library's javascript

    let hhxCoreUrl =
      Bundle.hyperhooks.url(forResource: "hyperhooks-core", withExtension: "js")! // Comment-out to resolve Previews issues with Xcode 12 Beta 4
      // Bundle.module.url(forResource: "hyperhooks-core.cached", withExtension: "js")!

    context.evaluateScript(try! String(contentsOf: hhxCoreUrl), withSourceURL: hhxCoreUrl)

    HxRegistry.shared.scripts.values.forEach { url in
      context.evaluateScript(try! String(contentsOf: url), withSourceURL: url)
    }

    // HyperSwift specific js
    let hhxSwiftUrl = Bundle.module.url(forResource: "hyperhooks-swift", withExtension: "js")!
    context.evaluateScript(try! String(contentsOf: hhxSwiftUrl), withSourceURL: URL(string: "hyperhooks-swift.js"))

    // Host app main script
    context.evaluateScript(try! String(contentsOf: realEntryPoint), withSourceURL: realEntryPoint)
  }
}

struct HHxRootView_Previews: PreviewProvider {
    static var previews: some View {
        HxRootView()
    }
}
