const render = makeRender((virtualNode, createElementOrPayload) => {

  let payload = typeof createElementOrPayload === 'function'
    ? { $createElement: createElementOrPayload }
    : createElementOrPayload
  let { $createElement, replace } = payload
  let childPayload, rerenderPayload

  if (typeof virtualNode === 'string') {
    $createElement('', { text: virtualNode })
  } else {
    const { nativeComponent } = virtualNode
    if (nativeComponent) {
      let $nextCreateElement = nativeComponent($createElement)
      childPayload = { $createElement: $nextCreateElement }
      rerenderPayload = { ...childPayload, replace: true }
    } else if (replace) {
      $createElement()
      childPayload = { $createElement }
      rerenderPayload = payload
    } else {
      let  $nextCreateElement = $createElement('Group', {})
      childPayload = { $createElement:  $nextCreateElement }
      rerenderPayload = { ...childPayload, replace: true }
    }
  }

  return {
    childPayload,
    childrenDidRender: () => {
      // It would be nice to append stuff other after render

      return { rerenderPayload }
    }
  }
})
