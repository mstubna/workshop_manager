$ ->
  new WorkshopManager

class WorkshopManager

  constructor: ->
    @construct_view()

    # load the data
    data = (new DummyData).get_data()

    utilities = new Utilities

    # components
    @event_calendar = new EventCalendar
      parent_view: @calendar_view
      data: data
      utilities: utilities

    @event_details = new EventDetails
      parent_view: @details_view
      data: data
      utilities: utilities

    @event_details_aside = new EventDetails
      parent_view: @details_aside_view
      data: data
      utilities: utilities

    @event_toolbar = new EventToolbar
      parent_view: @toolbar_view
      data: data
      utilities: utilities

    @event_toolbar_aside = new EventToolbar
      parent_view: @toolbar_aside_view
      data: data
      utilities: utilities

    @event_input = new EventInput
      parent_view: @view
      data: data
      utilities: utilities

    # interaction
    $(@event_calendar).on 'event_clicked', (e, args) =>
      { @event, dblclick } = args
      @update_details @event
      @update_toolbars @event
      if dblclick
        @event_input.open @event
      else if @is_small_media_query() and @event?
        @toggle_off_canvas()

    $(@event_input).on 'render_event', (e, args) =>
      @event_calendar.update_view args.event

    $(@event_input).on 'event_saved', (e, args) =>
      @event = args.event
      @event_calendar.update_view @event
      @update_details @event

    $(@new_button).on 'click', =>
      event_data = @get_new_event_data()
      #override with user selection if present
      if @event_calendar.selected?
        event_data.start = @event_calendar.selected.start.format()
        event_data.end = @event_calendar.selected.end.format()
      @event_calendar.render_event event_data
      @event = @event_calendar.get_event event_data.id
      @update_details @event
      @event_input.open @event, true
      return false

    $(@event_toolbar).on 'edit_event', =>
      @event_input.open @event

    $(@event_toolbar_aside).on 'edit_event', =>
      @event_input.open @event
      @toggle_off_canvas()

    $(@event_toolbar).on 'copy_event', =>
      event_data = @clone_event_data_from_event @event
      @event_calendar.render_event event_data
      @event = @event_calendar.get_event event_data.id
      @update_details @event

    $(@event_toolbar_aside).on 'copy_event', =>
      event_data = @clone_event_data_from_event @event
      @event_calendar.render_event event_data
      @event = @event_calendar.get_event event_data.id
      @update_details @event

    $(@event_toolbar).on 'delete_event', =>
      @event_calendar.delete_event @event
      @event = null
      @update_details()
      @update_toolbars()

    $(@event_toolbar_aside).on 'delete_event', =>
      @event_calendar.delete_event @event
      @event = null
      @update_details()
      @update_toolbars()
      @toggle_off_canvas()

    $(@event_details_aside).on 'view_clicked', =>
      @toggle_off_canvas()

    # close the off-canvas menu on window resize to a non-small size
    $(window).on 'resize', Foundation.utils.throttle( =>
      @toggle_off_canvas() if @is_off_canvas_open() and not @is_small_media_query()
    , 300)

  update_details: (event) =>
    @event_details.update_view event
    @event_details_aside.update_view event

  update_toolbars: (event) =>
    @event_toolbar.update_view event
    @event_toolbar_aside.update_view event

  toggle_off_canvas: =>
    @off_canvas.foundation 'offcanvas', 'toggle', 'move-left'

  is_off_canvas_open: =>
    @off_canvas.hasClass 'move-left'

  is_small_media_query: ->
    is_small = matchMedia(Foundation.media_queries.small).matches
    is_medium = matchMedia(Foundation.media_queries.medium).matches
    is_small and not is_medium

  construct_view: ->
    @view = $('#workshop_manager')
    @new_button = $("<div class='new_button tiny button left'>
      <span class='fa fa-lg fa-plus'></span>New event</div>")
    left_container = $("<div class='small-12 medium-8 columns'></div>")
    right_container = $("<div class='show-for-medium-up medium-4 columns'></div>")
    @calendar_view = $("<div></div>")
    @details_view = $("<div></div>")
    @details_aside_view = $("<div></div>")
    @toolbar_view = $("<div></div>")
    @toolbar_aside_view = $("<div></div>")

    @off_canvas = $("<div class='off-canvas-wrap' data-offcanvas></div>")
    @off_canvas.append($("<div class='inner-wrap'></div>").append([
      $("<aside class='right-off-canvas-menu'></aside>").append([
        @toolbar_aside_view
        @details_aside_view
      ])
      @calendar_view
      $("<a class='exit-off-canvas'></a>")
    ]))

    @view.append [
      $("<div class='app_row row'></div").append(@new_button)
      left_container.append(@off_canvas)
      right_container.append([
        @toolbar_view
        @details_view
      ])
    ]

  get_new_event_data: ->
    now = moment()
    return {
      id: @get_random_id()
      title: 'New Event',
      start: now.format('YYYY-MM-DD')
      end: now.clone().add(1,'day').format('YYYY-MM-DD')
      allDay: true
    }

  clone_event_data_from_event: (event) ->
    return {
      id: @get_random_id()
      title: "Copy of #{event.title}"
      type: event.type
      start: event.start.format()
      end: event.end.format()
      instructor: event.instructor
      cost: event.cost
      description: event.description
      allDay: event.allDay
    }

  get_random_id: ->
    Math.round(Math.random()*1000000000)
