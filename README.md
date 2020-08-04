_Hyperhooks Swift_ is the renderer component for [Hyperhooks](https://github.com/hyperhooks/hyperhooks-core) which targets Native _iOS_ and other Apple Platforms.

# Intro

On the _Swift_ side the `Hyperhooks` Swift Package provides `HxRootView` – a _SwiftUI View_ which specifies the _JavaScript_ entry-point and acts as insertion point for the rendered content.

On the JavaScript side `hyperhooks-swift` provides the `render` function which inserts a component into the view hierarchy at the specified root.

# Usage

To add Hyperhooks to your _Xcode_ project as _Swift Package Manager_ dependency use the URL: `https://github.com/hyperhooks/hyperhooks-swift`

To get started follow these 3 easy steps…

## Step 1

Import the package.

```
import SwiftUI
import Hyperhooks // Here.
…
```

## Step 2

Add a `HxRootView` somewhere in your hierarchy.

```
…
@main
struct MyApp: App {

  var body: some Scene {
    WindowGroup {
      HxRootView() // Here.
…
```

## Step 3

Create a `main.js` containing your Hyperhooks component.


```javascript
let App = () => {
  const [count, setCount] = useState(0)

  return h(Div, {},
    `Total bananas: ${count}`,
    h(Button, {
      onClick: () => {
        setCount(count + 1)
      },
      value: 'Add some 🍌🍌!'
    })
  )
}

render(h(App), Hyperhooks.getRoot())
```

That's it, now you can run your app or use Xcode's _live preview_ functionality to interact and see your changes to the code reflected immediately!
