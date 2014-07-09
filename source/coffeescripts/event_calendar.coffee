class @EventCalendar

  constructor: (args) ->
    { parent_view, data } = args
    @construct_view parent_view

    @view.fullCalendar
      defaultDate: moment().format('YYYY-MM-DD')
      selectable: true
      aspectRatio: 1.5
      nextDayThreshold: '01:00:00'
      header:
        left: 'month, basicWeek'
        center: 'title'
        right: 'prev, next'
      events: data.events
      eventRender: (event, element) =>
        element.addClass(event.type) if event.type?
        # workaround to fix FullCalendar issue with clicks on touch devices
        element.on 'click', (e) =>
          @handle_event_click e, event, element
          return false
        element.on 'dblclick', (e) =>
          @handle_event_click e, event, element, true
          return false

      select: (start, end) =>
        @selected = {start, end}

    # hide the month/week buttons on small devices
    $('.fc-header-left').addClass 'show-for-medium-up'

    @view.on 'click', =>
      @handle_event_click()
      return false

  handle_event_click: (jsEvent, event, element, dblclick) =>
    $('.fc-event').removeClass 'selected'
    $(jsEvent?.currentTarget)?.addClass 'selected'
    $(this).trigger 'event_clicked', { jsEvent, event, element, dblclick }

  update_view: (event) ->
    @view.fullCalendar 'updateEvent', event

  delete_event: (event) ->
    @view.fullCalendar 'removeEvents', event._id

  render_event: (event_data) ->
    @view.fullCalendar 'renderEvent', event_data

  get_event: (event_id) ->
    @view.fullCalendar('clientEvents', event_id)[0]

  construct_view: (parent_view) ->
    @view = $("<div id='event_calendar'></div>")
    parent_view.append @view
