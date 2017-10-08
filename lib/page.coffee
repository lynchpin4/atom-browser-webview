
# lib/page

{Model} = require 'theorist'
PageView  = require './page-view'
urlUtil   = require 'url'
{$, View}  = require 'atom-space-pen-views'
{CompositeDisposable, Emitter} = require 'event-kit'

module.exports =
class Page extends Model

  constructor: (@browser, @url) ->
    console.log 'browser page created'
    @emitter = new Emitter
    @disposables = new CompositeDisposable
    atom.webBrowser.page = @

  setTitle: (@title) -> if @tabView then @tabView.find('.title').text(@title)
  getTitle:     ->
    if @pageView and @pageView.getTitle
      return @pageView.getTitle()
    return 'Loading..'
  getLongTitle: -> @getTitle()

  back:    -> @pageView.goBack()
  forward: -> @pageView.goForward()
  refresh: -> @pageView.reload()

  goVisible: ->
    if @pageView then @pageView.goVisible()
  goInvisible: ->
    if @pageView then @pageView.goInvisible()

  setLocation: (@url) ->
    @pageView.setLocation @url

  locationChanged: (@url) ->
    @update

  # called from the page view
  createTab: ->
    tabBarView  = atom.workspaceView.find('.pane.active').find('.tab-bar').view()
    tabView     = tabBarView.tabForItem @
    $tabView    = $ tabView
    @url         = @getPath()
    @$tabFavicon = $ '<img class="tab-favicon">'
    $tabView.append @$tabFavicon
    $tabView.find('.title').css paddingLeft: 20
    @tabView = $tabView

  update: ->
    @browser.setOmniText @url
    faviconDomain = urlUtil.parse(@url).hostname
    @setFaviconDomain faviconDomain
    @browser.setFaviconDomain faviconDomain
    if @pageView and @pageView.getTitle
      @setTitle @getTitle()
      @emitter.emit 'did-change-title', @getTitle()
    # @pageView?.setLocation(@url)

  onDidChangeTitle: (callback) ->
    @emitter.on 'did-change-title', callback

  setFaviconDomain: (domain) ->
    #@$tabFavicon.attr src: "http://www.google.com/s2/favicons?domain=#{domain}"

  setView: (@pageView, @webView) ->
  getBrowser:   -> @browser
  getClass:     -> Page
  getViewClass: -> PageView
  getView:      -> @pageView
  getPath:      -> @url

  getWebview: ->
    @pageView?.getWebview()

  goForward: ->
    @pageView?.goForward()

  goBack: ->
    @pageView?.goBack()

  reload: ->
    @pageView?.reload()

  serialize: ->
    {}

  detach: ->
    console.log 'detaching tab page'

  destroy: ->
    @pageView.destroy()
    @pageView = null

    # remove the URL on relaunch
    index = atom.webBrowser.pages.indexOf @
    atom.webBrowser.pages.splice(index, 1)
