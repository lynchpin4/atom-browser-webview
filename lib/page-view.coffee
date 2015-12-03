
# lib/page-view

{$, View}  = require 'atom-space-pen-views'

module.exports =
class PageView extends View

  @content: ->
    @div class:'browser-page', tabindex:-1

  initialize: (page) ->
    page.setView @
    @localPage = page
    url = page.url

    @browser     = page.getBrowser()
    @page = page

    @webview = atom.webRenderFrames.createFrame @
    page.webview = @webview
    @webview[0].src = url

    console.log 'created webview'
    window.cur_page_view_frame = @
    #@page.createTab()

    @webview.on 'did-finish-load', =>
      url = @getUrl()
      title = @getTitle()
      @page.setTitle title
      @localPage.locationChanged url
      @localPage.setTitle title

      if @browser.omnibox
        @browser.omnibox.setUrl url


  getTitle: ->
    webview = @getWebview()
    if webview.getTitle
      return webview.getTitle()

  getUrl: ->
    if not @webview or not @webview[0]
      return ''
    webview = @webview[0]
    if webview.getUrl
      return @getWebview().getUrl()

  setLocation: (url) ->
    if @webview
      @webview.attr src: url

  getWebview: ->
    return @webview[0]

  goBack: ->
    if @webview
      @webview[0].goBack()

  goForward: ->
    if @webview
      @webview[0].goForward()

  goVisible: ->
    @css('visibility', 'visible')
    $(@webview).css('visibility', 'visible')
    $(@webview).parent().removeClass 'holder-hidden'

  goInvisible: ->
    @css('visibility', 'hidden')
    $(@webview).parent().addClass 'holder-hidden'
    $(@webview).css('visibility', 'hidden')

  reload: ->
    if @webview
      console.log 'reloading webview'
      @webview.reload()

  destroy: ->
    clearInterval @urlInterval
    console.log 'destroyed webview'
    $(@webview).parent().remove()
