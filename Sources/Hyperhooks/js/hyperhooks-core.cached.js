'use strict'
// Globals
//
let globalNode, globalHookIndex, globalAncestors = []

// Virtual DOM utils
//
const isArray = node => Array.isArray(node)
const isString = node => typeof node === 'string'
const isNull = node => node === null
const isComponent = node =>
  !isNull(node) && !isArray(node) && typeof node === 'object'
const isProto = node => isComponent(node) && node.body === undefined

// Hooks
//
const argsChanged = (aa, bb) => !aa || bb.some((b, i) => b !== aa[i])

const _getHook = () => {
  const { state: { hooks } } = globalNode
  if (globalHookIndex === hooks.length) hooks.push({})
  return hooks[globalHookIndex++]
}

const useEffect = (callback, args) => {
  const hook = _getHook()
  if (argsChanged(hook.args, args)) {
    hook.value = callback
    hook.args = args
    const { state: { effects, finalEffects } } = globalNode
    effects.push(hook)
    finalEffects.push(hook)
  }
}

const useLayoutEffect = (callback, args) => {
  const hook = _getHook()
  if (argsChanged(hook.args, args)) {
    hook.value = callback
    hook.args = args
    const { state: { layoutEffects } } = globalNode
    layoutEffects.push(hook)
  }
}

const useMemo = (callback, args) => {
  const hook = _getHook()
  if (argsChanged(hook.args, args)) {
    hook.args = args
    hook.callback = callback
    return hook.value = callback()
  }
  return hook.value
}

const useContext = (context) => {
  // TODO: Missing creatContext and context provider
  const { state: { contexts } } = globalNode
  const provider = contexts[context.id]
  if (!provider) return context.defaultValue
  const hook = _getHook()
  if (hook.value === null) {
    hook.value = true
    provider.sub(globalNode)
  }
  const { props: providerProps } = provider
  return providerProps.value
}

const useReducer = (reducer, initialValue) => {
  const hook = _getHook()
  if (!hook.value) {
    const capturedState = globalNode.state
    hook.value = [
      initialValue,
      action => {
        const nextValue = reducer(hook.value[0], action)
        // TODO: when calling a setter with string, value seems to be trimmed and nextValue === hook.value[0] despite the extra spaces
        if (nextValue !== hook.value[0]) {
          hook.value[0] = nextValue
          // RE-render
          const { node } = capturedState
          const newNode = _recreateNode(node)
          if (node._rerender !== undefined) node._rerender(newNode)
        }
      }
    ]
  }
  return hook.value
}

const useImperativeHandle = (ref, createHandle, args) => {
  const hook = _getHook()
  if (argsChanged(hook.args, args)) {
    hook.args = args
    if (ref) {
      ref.current = createHandle()
    }
  }
}

const useState = s => useReducer((_, action) => action, s)
const useRef = current => useState({ current })[0]
const useCallback = (callback, args) => useMemo(() => callback, args)

// Hyperscript
//
const _handleCleanup = effects => {
  effects.forEach(e => {
    if (e._cleanup) { // DO NOT use effects.filter()
      e._cleanup()
      delete e._cleanup
    }
  })
}

const _handleEffects = effects => {
  _handleCleanup(effects)
  effects.forEach(hook => {
    const result = hook.value()
    if (typeof result === 'function') hook._cleanup = result
  })
  return [] // Important to reset current incarnation of useEffects
}

const _cleanup = children => {
  // DFS (depth first search) algorithm
  children.forEach(child => {
    if (isArray(child)) _cleanup(child)
    else if (isComponent(child)) {
      const { state, body } = child
      _handleCleanup(state.finalEffects)
      _cleanup(body)
    }
  })
}

const _probeDfs = (node, level = 0) => {
  if (isNull(node) || isString(node) || isProto(node)) return level
  let maxLevel = level
  const array = isArray(node) ? node : node.body
  array.forEach(child => {
    maxLevel = Math.max(maxLevel, _probeDfs(child, level + 1))
  })
  return maxLevel
}

const _removeDfsAtLevel = (node, test, targetLevel, level = 1) => {
  let found, i = 0, child
  while(found === undefined && i < node.length) {
    child = node[i]
    if (level === targetLevel && test(child)) {
      node.splice(i, 1)
      return child
    }
    if (level < targetLevel && (isArray(child) || isComponent(child)))
      found = _removeDfsAtLevel(child, test, targetLevel, level + 1)
    i++
  }
  if (found !== undefined) return found
}

const _removePreviousInstanceBfs = node => {
  if (globalAncestors.length === 0) return

  const parent = globalAncestors[globalAncestors.length - 1]
  if (isProto(parent)) return // first mount

  const { body: previousInstances } = parent

  const { props: { key }, component } = node
  // Keyed elements have priority, or find first with matching type
  const checkNodeIdentity = testNode => isComponent(testNode) && (
    (key !== undefined && key === testNode.props.key) ||
    (key === undefined && component === testNode.component)
  )

  // Scan previous instances
  const maxLevel = _probeDfs(node)
  let targetLevel = 1, found
  while(found === undefined && targetLevel <= maxLevel)
    found = _removeDfsAtLevel(tree, checkNodeIdentity, targetLevel++)
  return found
}

const _recreateNode = (node) => {
  if (node.state === undefined) {
    // Previous state
    const previousInstance = _removePreviousInstanceBfs(node)
    if (previousInstance === undefined) node.state = {
      // Initial state
      hooks: [],
      effects: [],
      finalEffects: [],
      layoutEffects: [], // TODO: test
      contexts: [], // TODO: test
      handles: [], // TODO: test
    }
    else node.state = previousInstance.state
    node.state.node = node
  }

  const { component, props, state, body: previousBody } = node
  // Globals (hooks)
  globalNode = node
  globalHookIndex = 0
  globalAncestors.push(node)

  // Invoke component
  const maybeInstance = component(props)

  globalAncestors.pop()
  state.effects = _handleEffects(state.effects)

  let nativeComponent, body
  if (typeof maybeInstance === 'function') {
    // This is a native component
    nativeComponent = maybeInstance
    body = props.children
  } else body = isArray(maybeInstance) ? maybeInstance : [ maybeInstance ]

  // Clean up (unmount) unmatched previous instances
  if (previousBody !== undefined) _cleanup(previousBody)

  return Object.assign(node, { nativeComponent, body })
}

const h = (component, attrs = {}, ...children) =>
  _recreateNode({ component, props: { children, ...attrs } })

// Render
//
const makeRender = childrenWillRender => {
  const _render = (node, previousPayload) => {
    if (isNull(node)) return // Early return
    let {
      childPayload, childrenDidRender
    } = isArray(node) ? {} : childrenWillRender(node, previousPayload)
    // Children render
    if (!isString(node)) {
      let body = isArray(node) ? node : node.body
      let payload = isArray(node) ? previousPayload : childPayload
      body.forEach(child => { _render(child, payload) })
    }
    // Post-render
    if (isArray(node)) return
    const { rerenderPayload } = childrenDidRender()
    if (isString(node)) return // String node, early return
    // Re-render
    node._rerender = newNode => { _render(newNode, rerenderPayload) }
    const { state } = node
    state.layoutEffects = _handleEffects(state.layoutEffects)
  }

  return _render
}
