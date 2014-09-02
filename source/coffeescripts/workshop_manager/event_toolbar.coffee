class @EventToolbar

  constructor: (args) ->
    { parent_view } = args
    @construct_view parent_view

  construct_view: (parent_view) ->
    @view = $("<div id='event_toolbar' class='clearfix'></div>")

    @new_button = $("<div class='tiny button left'><span class='fa fa-lg fa-plus'></span>New event</div>")
    @edit_button = $("<div class='tiny secondary button'><span class='fa fa-lg fa-pencil'></span></div>")
    @copy_button = $("<div class='tiny secondary button'><span class='fa fa-lg fa-copy'></span></div>")
    @delete_button = $("<div class='tiny alert button'><span class='fa fa-lg fa-trash-o'></span></div>")

    @event_subtoolbar = $("<div id='event_subtoolbar' class='left hide'></div>").append [@edit_button, @copy_button, @delete_button]
    @view.append [@new_button, @event_subtoolbar]
    parent_view.append @view

    @new_button.on 'click', =>
      $(this).trigger 'new_event'
      return false
    @edit_button.on 'click', =>
      $(this).trigger 'edit_event'
      return false
    @copy_button.on 'click', =>
      $(this).trigger 'copy_event'
      return false
    @delete_button.on 'click', =>
      $(this).trigger 'delete_event'
      return false

  update_view: (event) ->
    if event?
      @event_subtoolbar.removeClass 'hide'
    else
      @event_subtoolbar.addClass 'hide'
