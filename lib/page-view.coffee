
# lib/page-view

{$, View} = require 'atom'
require './render-frames'

module.exports =
class PageView extends View

  @content: ->
    @div class:'browser-page', tabindex:-1

  initialize: (page) ->
    page.setView @
    @localPage = page
    url = page.url

    browser     = page.getBrowser()
    omniboxView = browser.getOmniboxView()
    @page = page
    
    #debug
    # @subscribe @, 'click', (e) => console.log 'PageView click', e.ctrlKey

    @webview = atom.webRenderFrames.createFrame @
    page.webview = @webview
    @webview[0].src = url

    console.log 'created webview'
    window.cur_page_view_frame = @
    @page.createTab()
    @subscribe @webview, 'did-finish-load', =>
      url = @getUrl()
      title = @getTitle()
      @page.setTitle title
      @localPage.locationChanged url
      @localPage.setTitle title

  getTitle: ->
    if not @webview or not @webview.getTitle
      return ''
    if @webview.getTitle()
      return @webview.getTitle()

  getUrl: ->
    return @webview[0].src || @webview.attr 'src' || 'about:blank'

  setLocation: (url) ->
    if @webview
      @webview.attr src: url

  goBack: ->
    if @webview
      @webview.goBack()

  goForward: ->
    if @webview
      @webview.goForward()
      
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
    #$(@webview).remove()
    
    
