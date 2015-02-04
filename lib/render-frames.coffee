
# lib/render-frames

{$, View}  = require 'atom'
OmniboxView = require './omnibox-view'
_ = require 'underscore-plus'

module.exports =
class WebRenderFrames

  constructor: ->
    @objectMap = []
    window.addEventListener 'resize', @repositionFrames.bind @, false

  # create a new frame from holder and URL
  createFrame: (holder, url) ->
    # if there's an existing frame in this page, use that
    if (_.where(@objectMap, {holder:holder}).length)
      webview = _.where(@objectMap, {holder:holder})[0]

      # is an existing frame -- use that 1
      webview.src = 'about:blank'
      return webview

    # create the new web view
    webview = $ """<webview plugins="on" allowfullscreen="on" autosize="on" class="native-key-bindings" />"""
    webview.id = _.uniqueId("embed_webview_");

    # give it a 'sticky holder' (floating/fixed div that holds the webview)
    sticky_holder = $('<div />').appendTo('body');
    $(sticky_holder).attr 'id', _.uniqueId('webview_sticky_holder_')
    $(sticky_holder).append webview
    $('body').append(sticky_holder)

    $(sticky_holder).css('width', '100%')
    $(sticky_holder).css('height', '100%')
    #console.log 'created web view w/ id: '+webview.id

    #todo: move to reposition handler
    $(sticky_holder).css 'position', 'fixed'
    #el = document.querySelector('.pane.active .item-views') || document.querySelector('.pane.active') || document.querySelector('.pane')

    el = holder
    offset = $(el).offset()
    width = $(el).width()
    height = $(el).height()
    top = offset.top - $(window).scrollTop()
    left = offset.left - $(window).scrollLeft()

    $(sticky_holder).css('top', top+'px')
    $(sticky_holder).css('left', left+'px')
    $(sticky_holder).css('width', width+'px')
    $(sticky_holder).css('height', height+'px')

    @objectMap.push {id: webview.id, sticky_holder: sticky_holder, webview: webview, holder: holder, measure: el}

    # All good.
    return webview

  repositionFrames: ->
    if not @objectMap or @objectMap.length == 0 then return
    #el = document.querySelector('.pane.active .item-views') || document.querySelector('.pane.active') || document.querySelector('.pane')

    for frame in @objectMap
      holder = el = frame.holder
      sticky_holder = frame.sticky_holder

      $(holder).css 'position', 'absolute'

      offset = $(holder).offset()
      width = $(el).width()
      height = $(el).height()
      top = offset.top - $(window).scrollTop()
      left = offset.left - $(window).scrollLeft()

      $(sticky_holder).css('top', top+'px')
      $(sticky_holder).css('left', left+'px')
      $(sticky_holder).css('width', width+'px')
      $(sticky_holder).css('height', height+'px')

      if holder.is(":visible")
        holder.goVisible()
      else
        holder.goInvisible()

  # there is only 1 remove
  removeFrame: (holder) ->
    # this code is currently kept in page-view

  # for UI and state updates both
  updateFrame: (holder) ->
    @repositionFrames()

atom.webRenderFrames ||= new WebRenderFrames()
