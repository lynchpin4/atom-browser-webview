# atom-browser-webview todo

1. webview inject script for

  - context menu (document.activeElement) etc
  - favicon retrieval
  - find in page (see: vimium)
  - proper current url retrieval (for omnibox, when not focused) (done)
  - window.prompt, alert, confirm shims (bootstrap / atom UIs)

2. add new tab in file menu (done)

3. fix for active / focused panes (dont hide tabs as long as their pane is VISIBLE not just active.. when panes are split)
