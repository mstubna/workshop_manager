class @EventDetails

  constructor: (args) ->
    { parent_view, @data, @utilities } = args
    @construct_view parent_view

  construct_view: (parent_view) ->
    @view = $("<div class='event_details'></div>")
    parent_view.append @view

    @view.on 'click', =>
      $(this).trigger 'view_clicked'
      return false

  update_view: (event) ->
    @view.empty()

    return unless event?

    @view.append $("<h6>#{event.title}</h6>")

    from_str = "#{event.start.format('YYYY-MM-DD')}"
    unless event.allDay
      from_str = from_str + " &nbsp;#{event.start.format('hh:mm A')}"

    if event.allDay
      to_str = "#{event.end.clone().subtract(1,'day').format('YYYY-MM-DD')}"
    else
      to_str = "#{event.end.format('YYYY-MM-DD')} &nbsp;#{event.end.format('hh:mm A')}"

    if from_str is to_str
      @view.append $("<div><small>Date</small>&nbsp;&nbsp;#{from_str}</div>")
    else
      @view.append $("<div><small>From</small>&nbsp;&nbsp;#{from_str}</div>")
      @view.append $("<div><small>To</small>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{to_str}</div>")

    if event.instructor? and event.instructor isnt 'none'
      instructor = @utilities.find_object_matching @data.instructors, 'value', event.instructor
      @view.append $("<div class='details_instructor'>#{instructor?.text}</div>")

    if event.description? and event.description.length > 0
      @view.append $("<div class='details_description'>#{event.description}</div>")

    if event.cost? and event.cost > 0
      @view.append $("<div class='details_cost'>Cost: &nbsp;$#{event.cost}</div>")

    @view.append $("<div class='details_register tiny button disabled'>Register</div>")
