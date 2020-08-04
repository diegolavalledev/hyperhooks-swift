const Input = ({ type = 'text', value, placeholder, onChange }) => {
  if (type === 'button') {
  } else if (type === 'checkbox') {
  } else if (type === 'color') {
  } else if (type === 'date') {
  } else if (type === 'datetime-local') {
  } else if (type === 'email') {
  } else if (type === 'file') {
  } else if (type === 'hidden') {
  } else if (type === 'image') {
  } else if (type === 'month') {
  } else if (type === 'number') {
  // } else if (type === 'password') {
  } else if (type === 'radio') {
  } else if (type === 'range') {
  } else if (type === 'reset') {
  } else if (type === 'search') {
  } else if (type === 'submit') {
  } else if (type === 'tel') {
  } else if (type === 'time') {
  } else if (type === 'url') {
  } else if (type === 'week') {
  // } else if (type === 'text') {
  } else {
    // type === 'password' || type === 'text'
    return (createElement) => {
      createElement(
        'Input',
        {
          type,
          ...value ? { value } : {},
          ...placeholder ? { placeholder } : {},
          ...onChange ? { onChange } : {},
        }
      )
    }
  }
}
