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

    @event_toolbar = new EventToolbar
      parent_view: @toolbar_view
      data: data
      utilities: utilities

    @event_input = new EventInput
      parent_view: @view
      data: data
      utilities: utilities

    # interaction
    $(@event_calendar).on 'event_clicked', (e, args) =>
      { @event, dblclick } = args
      @event_details.update_view @event
      @event_toolbar.update_view @event
      @event_input.open(@event) if dblclick

    $(@event_input).on 'render_event', (e, args) =>
      @event_calendar.update_view args.event

    $(@event_input).on 'event_saved', (e, args) =>
      @event = args.event
      @event_calendar.update_view @event
      @event_details.update_view(@event)

    $(@event_toolbar).on 'new_event', =>
      event_data = @get_new_event_data()
      #override with user selection if present
      if @event_calendar.selected?
        event_data.start = @event_calendar.selected.start.format()
        event_data.end = @event_calendar.selected.end.format()
      @event_calendar.render_event event_data
      @event = @event_calendar.get_event event_data.id
      @event_details.update_view @event
      @event_input.open @event, true

    $(@event_toolbar).on 'edit_event', =>
      @event_input.open @event

    $(@event_toolbar).on 'copy_event', =>
      event_data = @clone_event_data_from_event @event
      @event_calendar.render_event event_data
      @event = @event_calendar.get_event event_data.id
      @event_details.update_view @event

    $(@event_toolbar).on 'delete_event', =>
      @event_calendar.delete_event @event
      @event = null
      @event_details.update_view()
      @event_toolbar.update_view()

  construct_view: ->
    @view = $('#workshop_manager')
    @header = $("
      <div id='header' class='app_row row'>
      </div>")
    left_container = $("<div class='small-12 medium-8 columns'></div>")
    right_container = $("<div class='small-12 medium-4 columns'></div>")
    @calendar_view = $("<div class='row'></div>")
    @details_view = $("<div></div>")
    @toolbar_view = $("<div></div>")
    @view.append [
      @header
      $("<div class='app_row row'></div>").append ([
        left_container.append(@calendar_view)
        right_container.append([
          $("<div class='small_spacer show-for-medium-up'></div>")
          @toolbar_view
          @details_view
        ])
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
