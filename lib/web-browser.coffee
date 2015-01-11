
# lib/web-browser

Toolbar = require './toolbar'
Page    = require './page'
{$, View}  = require 'atom'

class WebBrowser
  activate: ->
    atom.webBrowser = @
    @pages = []

    # toggle the webbrowser dropdown UI
    atom.workspaceView.command "web-browser:toggle", =>
      @toolbar ?= new Toolbar @
      switch
        when not @toolbar.visible()
          @toolbar.show().focus()
        when not @toolbar.focused()
          @toolbar.focus()
        else
          @toolbar.hide()

    # add a callback to simply check for which pane is active, if it is our browser tab then do the manual show/hide
    atom.workspace.onDidChangeActivePaneItem =>
      page = @getActivePage()
      if page
        if @lastPage and @lastPage != @page then @lastPage.goInvisible()
        @page.goVisible()
        @lastPage = page
      else
        for page in @pages
          page.goInvisible()

    # add a callback for handling http inside the editor
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
    page = new Page @, url
    atom.workspace.activePane.activateItem page
    @lastPage = page
    @pages.push page

  setLocation: (url) ->
    @toolbar ?= new Toolbar @
    @toolbar.setOmniText url
    if @getActivePage()?.setLocation url
    else @createPage url

  # if the current page is a browser
  getActivePage: ->
    page = atom.workspace.getActivePaneItem()
    if page instanceof Page then @page = page; return @page

  back:    -> @getActivePage()?.goBack()
  forward: -> @getActivePage()?.goForward()
  refresh: -> @getActivePage()?.reload()

  # module deactivation
  deactivate: ->
    atom.workspace.unregisterOpener @opener

module.exports = new WebBrowser
