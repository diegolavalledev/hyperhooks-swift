const Button = props => (createElement) => {
  createElement(
    'Button',
    {
      text: props.value,
      action: props.onClick
    }
  )
}
