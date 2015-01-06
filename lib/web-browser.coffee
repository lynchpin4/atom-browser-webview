
# lib/web-browser

Toolbar = require './toolbar'
Page    = require './page'

class WebBrowser
  activate: ->
    atom.webBrowser = @
    atom.menu.add [
      { label: 'Packages', submenu: [{ label: 'Browser', submenu: [ { label: 'Toggle Browser UI', command: 'web-browser:toggle' }  ] }]}
    ]
    atom.workspaceView.command "web-browser:toggle", =>
      @toolbar ?= new Toolbar @
      switch
        when not @toolbar.visible()
          @toolbar.show().focus()
        when not @toolbar.focused()
          @toolbar.focus()
        else
          @toolbar.hide()

    atom.workspace.onDidChangeActivePaneItem =>
      #if @getActivePage() then @page.update()
      #else if @page then @page.locationChanged @page.getPath()
      page = @getActivePage()
      if page
        @page.goVisible()
      else
        if @page then @page.goInvisible()

    @opener = (filePath, options) =>
      if /^https?:\/\//.test filePath
        new Page @, filePath

    atom.workspace.registerOpener @opener

  getToolbar:                -> @toolbar
  getOmniboxView:            -> @toolbar?.getOmniboxView()
  setOmniText:        (text) -> @toolbar?.setOmniText text
  setFaviconDomain: (domain) -> @toolbar?.setFaviconDomain domain

  destroyToolbar: ->
    @toolbar.destroy()
    @toolbar = null

  createPage: (url) ->
    @toolbar ?= new Toolbar @
    atom.workspace.activePane.activateItem new Page @, url

  setLocation: (url) ->
    @toolbar ?= new Toolbar @
    @toolbar.setOmniText url
    if @getActivePage()?.setLocation url
    else @createPage url

  getActivePage: ->
    page = atom.workspace.getActivePaneItem()
    if page instanceof Page then @page = page; return @page

  back:    -> @getActivePage()?.goBack()
  forward: -> @getActivePage()?.goForward()
  refresh: -> @getActivePage()?.reload()

  deactivate: ->
    #atom.workspace.unregisterOpener @opener

module.exports = new WebBrowser
