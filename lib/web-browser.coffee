
# lib/web-browser

Toolbar = require './toolbar'
Page    = require './page'
{$, View}  = require 'atom-space-pen-views'

# render frame helper
require './render-frames'

class WebBrowser

  config:
    homepage:
      type: 'string'
      default: "http://github.com/"
    autoReloadCache:
      type: 'boolean'
      default: false
    autoReopen:
      type: 'boolean'
      default: true

  activate: (state) ->
    @state = state

    atom.webBrowser = @
    @pages = []

    setInterval @fixPages.bind @, 250

    atom.commands.add 'atom-workspace',
      'web-browser:toggle': (event) =>
        @toolbar ?= new Toolbar @
        if not @toolbar.visible()
          @toolbar.show().focus()
        else
          @toolbar.hide()

        if not @toolbar.focused()
          @toolbar.focus()


    atom.commands.add 'atom-workspace',
      'web-browser:newtab': (event) =>
        @toolbar ?= new Toolbar @
        if not @toolbar.visible() then @toolbar.show().focus()
        atom.workspace.open @config.homepage.default

    atom.commands.add 'atom-workspace',
      'web-browser:newtab-showui': (event) =>
        @newTabShowUI()

    atom.commands.add 'atom-workspace',
      'web-browser:devtools': (event) =>
        webview = atom.webBrowser.getActivePage()?.getWebview()
        webview?.openDevTools()

    atom.commands.add 'atom-workspace',
      'web-browser:go-back': (event) =>
        @back()

    atom.commands.add 'atom-workspace',
      'web-browser:go-forward': (event) =>
        @forward()

    atom.commands.add 'atom-workspace',
      'web-browser:reload': (event) =>
        @reload()

    # add a callback to simply check for which pane is active, if it is our browser tab then do the manual show/hide
    atom.workspace.onDidChangeActivePaneItem =>
      p = @getActivePage()
      if p
        if @lastPage then @lastPage.goInvisible()
        @page.goVisible()
        @toolbar.show()
      else
        @hideAll()
      @fixPages()

    # add the file menu 'New Tab (Browser)'
    @addFileMenuItem()

    # add a callback for handling http inside the editor
    @opener = (filePath, options) =>
      if /^https?:\/\//.test filePath
        p = new Page @, filePath
        @pages.push p
        setTimeout(( -> atom.webRenderFrames.repositionFrames() ), 200)
        return p # return for opener

    atom.workspace.addOpener @opener

    # reopen previous pages (if reloaded)
    setTimeout @reopen.bind @, 3000

  getToolbar:                -> @toolbar
  getOmniboxView:            -> @toolbar?.getOmniboxView()
  setOmniText:        (text) -> @toolbar?.setOmniText text
  setFaviconDomain: (domain) -> @toolbar?.setFaviconDomain domain

  # add a 'new browser tab' item to the current file menu
  addFileMenuItem: ->
    menu = atom.menu.template[1]
    menu.submenu.splice 2, 0, { label: 'New Tab (Browser)', command: 'web-browser:newtab-showui' }
    atom.menu.template[1] = menu
    console.dir menu
    atom.menu.update()

  reopen: ->
    should_run = @config.autoReopen.default
    if not should_run then return

    if @state.urls and @state.urls.length
      for url in @state.urls
        try
          @createPage url
        catch ex
          console.log('exception starting webpage: ')
          console.dir(ex)

  openURL: (uri, toolbar=no) ->
    if toolbar
      @toolbar ?= new Toolbar @
      @toolbar.show().focus()
    @createPage uri

  newTabShowUI: ->
    @toolbar ?= new Toolbar @
    @toolbar.show().focus()
    atom.workspace.open @config.homepage.default

  hideAll: ->
    for page in @pages
      page.goInvisible()
    try @toolbar.hide()

  fixPages: ->
    if @pages.length == 0 then return
    atom.webRenderFrames.repositionFrames()

  destroyToolbar: ->
    @toolbar.destroy()
    @toolbar = null

  createPage: (url) ->
    @toolbar ?= new Toolbar @
    atom.workspace.open @config.homepage.default

  setLocation: (url) ->
    @toolbar ?= new Toolbar @
    @toolbar.setOmniText url
    page = @getActivePage()
    if page then page?.setLocation url
    else @createPage url

  # get the current browser page
  getActivePage: ->
    page = atom.workspace.getActivePaneItem()
    if page instanceof Page
      if @lastPage != page then @lastPage = @page
      @page = page
      page
    else
      false

  getWebView: ->
    page = @getActivePage()
    if page then return page.webview[0]

  serialize: ->
    urls = []
    if @pages.length != 0
      for page in @pages
        urls.push page.url
    { urls: urls }

  # Toolbar / Omnibox / API Commands
  back: ->
    if not atom.webBrowser.getActivePage() then return
    webview = atom.webBrowser.getActivePage()?.getWebview()
    if not webview then return

    @getActivePage()?.goBack()
  forward: ->
    if not atom.webBrowser.getActivePage() then return
    webview = atom.webBrowser.getActivePage()?.getWebview()
    if not webview then return

    @getActivePage()?.goForward()
  refresh: ->
    if not atom.webBrowser.getActivePage() then return
    webview = atom.webBrowser.getActivePage()?.getWebview()
    if not webview then return

    if @config.autoReloadCache
      webview.reloadIgnoringCache()
    else
      @getActivePage()?.reload()

module.exports = new WebBrowser
