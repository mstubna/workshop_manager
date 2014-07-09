class @EventInput

  constructor: (args) ->
    { @parent_view, @data, @utilities } = args
    @construct_view()

  construct_view: ->
    @view = $("<div id='event_input'></div>")

    @save_button = $("<div class='tiny button right'>Save</div>")
    @cancel_button = $("<div class='tiny secondary button right'>Cancel</div>")

    @save_button.on 'click', =>
      if @validate_view()
        # to work around a FullCalendar bug, we render the event twice on the calendar.
        # during the first time around, FullCalendar clears the end for some reason
        @update_data()
        $(this).trigger 'render_event', { @event }
        @update_data()
        $(this).trigger 'event_saved', { @event }
        @close()
      return false

    @cancel_button.on 'click', =>
      @close()
      return false

    @header_view = $("<h5></h5>")
    @title_view = $("<input id='event_title' type='text' placeholder='Event title' />")

    @start_date_view = $("<input class='date_input' type='date' />")
    @start_date_label = $("<label class='small-12 medium-5 columns'>Start date</label>").append @start_date_view

    @start_time_view = $("<input class='time_input' type='time' />")
    @start_time_label = $("<label class='small-12 medium-5 columns'>Start time</label>").append @start_time_view

    @end_date_view = $("<input class='date_input' type='date'/>")
    @end_date_label = $("<label class='small-12 medium-5 columns'>End date</label>").append @end_date_view

    @end_time_view = $("<input class='time_input' type='time'/>")
    @end_time_label = $("<label class='small-12 medium-5 columns'>End time</label>").append @end_time_view

    @all_day_view = $("<input id='all_day_input' type='checkbox' />")
    @all_day_label = $("<label class='small-12 medium-2 columns'>All day</label>").append @all_day_view

    @date_time_inputs = [
      @all_day_label
      @start_date_label
      @start_time_label
      @end_date_label
      @end_time_label
    ]
    @date_time_view = $("<div class='row'></div>").append @date_time_inputs

    @type_view = $("<select id='type_input'></select>")
    @type_view.append @data.event_types.map (x) ->
      $("<option value='#{x.value}'>#{x.text}</option>")

    @instructor_view = $("<select id='instructor_input'></select>")
    @instructor_view.append @data.instructors.map (x) ->
      $("<option value='#{x.value}'>#{x.text}</option>")

    @cost_view = $("<input id='cost_input' type='number' placeholder='$'/>")
    @description_view = $("<textarea id='description_input' wrap='soft'></textarea>")
    @view.append [
      @header_view = $("<h5></h5>")
      $("<label>Name</label>").append(@title_view)
      @date_time_view
      $("<div class='row'></div>").append [
        $("<label class='small-12 medium-5 columns'>Type</label>").append(@type_view)
        $("<label class='small-12 medium-5 columns'>Instructor</label>").append(@instructor_view)
        $("<label class='small-12 medium-2 columns'>Cost</label>").append(@cost_view)
      ]
      $("<div></div>").append $("<label>Description</label>").append(@description_view)
      @delete_button
      @copy_button
      @save_button
      @cancel_button
    ]

    @view.dialog(
      appendTo: @parent_view
      dialogClass: 'workshop_manager_dialog'
      position:
        my: 'center'
        at: 'center'
        of: @parent_view
      autoOpen: false
      resizable: false
      draggable: false
      modal: true)

    @all_day_view.on 'change', => @update_all_day_view()

  open: (event, is_new) ->
    @update_view event, is_new
    @validate_view()
    width = Math.max @parent_view.width()*2/3, 325
    @view.dialog 'option', 'width', width
    @view.dialog 'open'

  close: ->
    @view.dialog 'close'

  validate_view: ->
    all_day = @all_day_view.prop 'checked'

    # remove any existing errors
    @date_time_inputs.map (x) ->
      x.removeClass 'error'
      x.children('small.error').remove()

    # adds en error message to a label
    add_error = (label, msg) ->
      label.addClass 'error'
      label.append $("<small class='error'>#{msg}</small>")

    is_valid = true

    # validate dates
    unless moment(@start_date_view.val()).isValid()
      add_error @start_date_label, 'please enter a valid date'
      is_valid = false

    unless moment(@end_date_view.val()).isValid()
      add_error @end_date_label, 'please enter a valid date'
      is_valid = false

    if is_valid and moment(@start_date_view.val()).isAfter(moment(@end_date_view.val()))
      add_error @start_date_label, 'event must end after it starts'
      is_valid = false

    # if not all_day, also validate date+times
    if is_valid and not all_day
      start = moment @start_date_view.val() + 'T' + @start_time_view.val()
      end = moment @end_date_view.val() + 'T' + @end_time_view.val()

      unless start.isValid()
        add_error @start_time_label, 'please enter a valid time (HH:MM)'
        is_valid = false

      unless end.isValid()
        add_error @end_time_label, 'please enter a valid time (HH:MM)'
        is_valid = false

      if is_valid and start.isAfter(end)
        add_error @start_time_label, 'event must end after it starts'
        is_valid = false

    is_valid

  update_data: ->
    @event ?= {} # create an empty event object if none exists
    @event.title = @title_view.val()
    all_day = @all_day_view.prop 'checked'
    @event.allDay = all_day

    if all_day
      @event.start = @start_date_view.val()
      @event.end = moment.utc(@end_date_view.val()).add(1,'day').format('YYYY-MM-DD')
    else
      @event.start = @start_date_view.val() + 'T' + @start_time_view.val()
      @event.end = @end_date_view.val() + 'T' + @end_time_view.val()

    @event.type = @type_view.prop 'value'
    @event.instructor = @instructor_view.prop 'value'
    @event.cost = (@cost_view.val() if @cost_view.val() and @cost_view.val() > 0)
    @event.description = @description_view.val()

  update_all_day_view: ->
    # hide the time boxes
    all_day = @all_day_view.prop 'checked'
    @utilities.add_remove_class(@start_time_label, 'hide', all_day)
    @utilities.add_remove_class(@end_time_label, 'hide', all_day)

    # rearrange grid
    @utilities.add_remove_class(@end_date_label, 'medium-offset-2', not all_day)

    # clear out the time boxes when switching to all_day mode
    if all_day
      @start_time_view.val '00:00'
      @end_time_view.val '00:00'

  update_view: (@event, is_new) ->
    @header_view.text if is_new then 'Create event' else 'Edit event'
    @title_view.val @event?.title
    @start_date_view.val @event?.start.format('YYYY-MM-DD')
    @start_time_view.val @event?.start.format('HH:mm')
    if @event?.allDay
      end_date = @event?.end?.clone().subtract(1,'day').format('YYYY-MM-DD')
    else
      end_date = @event?.end?.format('YYYY-MM-DD')
    @end_date_view.val end_date
    @end_time_view.val @event?.end?.format('HH:mm')
    @type_view.prop 'value', @event?.type
    @instructor_view.prop 'value', @event?.instructor
    @cost_view.val @event?.cost
    @all_day_view.prop 'checked', @event?.allDay
    @description_view.val @event?.description
    @update_all_day_view()
