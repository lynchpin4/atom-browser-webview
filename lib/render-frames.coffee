
# lib/render-frames

{$, View}  = require 'atom'
OmniboxView = require './omnibox-view'
_ = require 'underscore-plus'
$ = require('./jquery.sticky')($)

module.exports =
class WebRenderFrames
  
  constructor: ->
    # done
    console.log('jquery sticky init')
    @objectMap = []

  # create a new frame from holder and URL
  createFrame: (holder, url) ->
    # todo
    if (_.where(@objectMap, {holder:holder}).length)
      webview = _.where(@objectMap, {holder:holder})[0]
      
      console.log 'reset existing context for holder..' + webview.id
      # is an existing frame -- use that 1
      webview.src = 'about:blank'
      return webview

    # create the new web view
    webview = $ """<webview plugins="on" allowfullscreen="on" autosize="on" />"""
    webview.id = _.uniqueId("embed_webview_");
    
    # give it a sticky holder
    sticky_holder = $('<div />').appendTo('body');
    $(sticky_holder).attr 'id', _.uniqueId('webview_sticky_holder_')
    $(sticky_holder).append webview
    $('body').append(sticky_holder)
    
    $(sticky_holder).css('width', '100%')
    $(sticky_holder).css('height', '100%')
    console.log 'created web view w/ id: '+webview.id
    
    #todo: move to reposition handler
    $(sticky_holder).css 'position', 'fixed'
    el = document.querySelector('.pane.active .item-views') || document.querySelector('.pane.active') || document.querySelector('.pane')
    
    offset = $(el).offset()
    width = $(el).width()
    height = $(el).height()
    top = offset.top - $(window).scrollTop()
    left = offset.left - $(window).scrollLeft()
    
#  /*  if (document.querySelectorAll('.tab-bar').length >= 1)
#    {
#      var tabsEl = ($(document.querySelector('.tab-bar')).offset().top) + ($(document.querySelector('.tab-bar')).height());
#      top += tabsEl;
  #  } 
    
    $(sticky_holder).css('top', top+'px')
    $(sticky_holder).css('left', left+'px')
    $(sticky_holder).css('width', width+'px')
    $(sticky_holder).css('height', height+'px')
    
    @objectMap.push {id: webview.id, sticky_holder: sticky_holder, webview: webview, holder: holder, measure: el}
    
    # All good.
    return webview
    
    

  # there is only 1 remove
  removeFrame: (holder) ->
    # todo

  # for UI and state updates both
  updateFrame: (holder) ->
    # todo

atom.webRenderFrames = new WebRenderFrames()
