
# lib/toolbar-view

{$, View}  = require 'atom-space-pen-views'
OmniboxView = require './omnibox-view'

module.exports =
class ToolbarView extends View

  @content: ->
    @div class:'browser-toolbar', tabindex:-1, =>
      @div outlet: 'navBtnsLft', class:'nav-btns left', =>
        @span outlet:'goLeft', class:'octicon browser-btn octicon-arrow-left'
        @span outlet:'goRight', class:'octicon browser-btn octicon-arrow-right'
        @span outlet:'refresh', class:'octicon browser-btn octicon-sync'
      @div outlet:'omniboxContainer', class:'omnibox-container'
      #@div outlet: 'navBtnsRgt', class:'nav-btns right', =>
      #  @span outlet:'toggleUI', class:'octicon browser-btn octicon-close'

  addTooltips: ->
    try
      atom.tooltips.add @toggleUI, {title: 'Hide URL / Navigation Bar'}
      atom.tooltips.add @goLeft, {title: 'Go Back'}
      atom.tooltips.add @goRight, {title: 'Go Forward'}
      atom.tooltips.add @refresh, {title: 'Refresh'}
    catch ex
      console.dir ex

  initialize: (@browser) ->
    if not @browser then @browser = atom.webBrowser
    window.currentToolbarView = @
    atom.workspace.addTopPanel { item: @, visible: true }
    @omniboxView = new OmniboxView @browser
    @omniboxContainer.append @omniboxView
    @favicon = @omniboxView.favicon

    @addTooltips()

    @setOmniText ''

    @on 'click', (e) =>
      if (classes = $(e.target).attr 'class') and
         (btnIdx  = classes.indexOf 'octicon-') > -1
        switch classes[btnIdx+8...]
          #when 'close'       then @browser.destroyToolbar()
          when 'arrow-left'  then @browser.back()
          when 'arrow-right' then @browser.forward()
          when 'sync'        then @browser.refresh()

  focus:   -> @omniboxView.focus()
  focused: -> @isFocused

  getOmniboxView: -> @omniboxView
  setOmniText: (text) ->
    @omniboxView.setText text
    if not text then @setFaviconDomain 'atom.io'

  setFaviconDomain: (domain) ->
    # temp until script is added
    @favicon.attr src: "http://www.google.com/s2/favicons?domain=#{domain}"

  destroy: ->
    @unsubscribe()
    @detach()

###
  octicon-bookmark
  bug
  chevron-left
  chevron-right
  file-directory
  gear
  globe
  history
  pencil
  pin
  plus
  star
  heart
  sync
  x
###
