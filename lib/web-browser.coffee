
# lib/web-browser

Toolbar = require './toolbar'
Page    = require './page'
{$, View}  = require 'atom'
# render frame helper
require './render-frames'

class WebBrowser
  activate: ->
    atom.webBrowser = @
    @pages = []

    setInterval @fixPages.bind @, 250

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

    atom.workspaceView.command "web-browser:newtab", =>
      # temp: todo - user configurable homepage
      atom.workspace.open('http://github.com/')

    # add a callback to simply check for which pane is active, if it is our browser tab then do the manual show/hide
    atom.workspace.onDidChangeActivePaneItem =>
      p = @getActivePage()
      if p
        if @lastPage then @lastPage.goInvisible()
        @page.goVisible()
      else
        @hideAll()

    # add a callback for handling http inside the editor
    @opener = (filePath, options) =>
      if /^https?:\/\//.test filePath
        p = new Page @, filePath
        @pages.push p
        p # return for opener

    atom.workspace.registerOpener @opener

  getToolbar:                -> @toolbar
  getOmniboxView:            -> @toolbar?.getOmniboxView()
  setOmniText:        (text) -> @toolbar?.setOmniText text
  setFaviconDomain: (domain) -> @toolbar?.setFaviconDomain domain

  hideAll: ->
    for page in @pages
      page.goInvisible()

  fixPages: ->
    if @pages.length == 0 then return
    if not @getActivePage()
      @hideAll()
      return
    atom.webRenderFrames.repositionFrames()

  destroyToolbar: ->
    @toolbar.destroy()
    @toolbar = null

  createPage: (url) ->
    @toolbar ?= new Toolbar @
    page = new Page @, url
    atom.workspace.activePane.activateItem page
    @pages.push page

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

  back:    -> @getActivePage()?.goBack()
  forward: -> @getActivePage()?.goForward()
  refresh: -> @getActivePage()?.reload()

  # module deactivation
  deactivate: ->
    atom.workspace.unregisterOpener @opener

module.exports = new WebBrowser
