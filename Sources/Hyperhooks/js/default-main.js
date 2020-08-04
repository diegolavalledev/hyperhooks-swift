let App = () => {
  const [count, setCount] = useState(0)

  return [
    h(Div, {}, 'This is the default entry-point.'),
    h(Div, {}, 'Add a main.js to your project to get started.'),
    h(Div, {},
      `Counter: ${count}`,
       h(Button, { onClick: () => { setCount(count + 1) }, value: 'Plus one' }),
    )
  ]
}

render(h(App), Hyperhooks.getRoot())
