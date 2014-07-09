class @DummyData

  get_data: ->
    return {
      events: @get_events()
      event_types: @get_event_types()
      instructors: @get_instructors()
    }

  get_event_types: ->
    [
      { value: 'workshop', text: 'Workshop' }
      { value: 'open_shop', text: 'Open shop' }
      { value: 'tour', text: 'Guided tour' }
      { value: 'misc', text: 'Misc' }
    ]

  get_instructors: ->
    [
      { value: 'none', text: 'None' }
      { value: 'john_doe', text: 'John Doe' }
      { value: 'jane_smith', text: 'Jane Smith' }
      { value: 'william_jones', text: 'William Jones' }
    ]

  get_events: ->
    description = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    description_2 = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    [
      {
        title: 'Workshop 1',
        start: '2014-07-01T01:23'
        end: '2014-07-11T00:00'
        allDay: false
        instructor: 'john_doe'
        type: 'workshop'
        description: description
        cost: 300
        id: 1000
      },
      {
        title: 'Workshop 2',
        start: '2014-07-7',
        end: '2014-07-8'
        allDay: true
        instructor: 'william_jones'
        type: 'workshop'
        description: description
        cost: 300
        id: 1001
      },
      {
        title: 'Workshop 3',
        start: '2014-07-12'
        end: '2014-07-14'
        allDay: true
        instructor: 'jane_smith'
        type: 'workshop'
        description: description
        cost: 300
        id: 1002
      },
      {
        title: 'Tour 1',
        start: '2014-07-12'
        end: '2014-07-15'
        allDay: true
        instructor: 'william_jones'
        type: 'tour'
        description: description
        cost: 300
        id: 1003
      },
      {
        title: 'Tour 2',
        start: '2014-07-12'
        end: '2014-07-16'
        allDay: true
        instructor: 'william_jones'
        type: 'tour'
        description: description
        cost: 300
        id: 1004
      },
      {
        title: 'Tour 3'
        start: '2014-07-14'
        end: '2014-07-15'
        allDay: true
        instructor: 'john_doe'
        type: 'tour'
        description: description
        cost: 300
        id: 1005
      },
      {
        title: 'Tour 4'
        start: '2014-07-31'
        end: '2014-08-1'
        allDay: true
        type: 'tour'
        description: description
        cost: 300
        id: 1006
      },
      {
        title: 'Open shop 1',
        start: '2014-07-13'
        end: '2014-07-14'
        allDay: true
        type: 'open_shop'
        description: description_2
        id: 1007
      },
      {
        title: 'Open shop 2',
        start: '2014-07-16T9:00'
        end: '2014-07-16T14:00'
        allDay: false
        type: 'open_shop'
        description: description_2
        id: 1008
      },
      {
        title: 'Open shop 3',
        start: '2014-07-21'
        end: '2014-07-22'
        allDay: true
        type: 'open_shop'
        description: description_2
        id: 1009
      },
      {
        title: 'Misc event 1',
        start: '2014-07-20'
        end: '2014-07-22'
        allDay: true
        type: 'misc'
        description: description_2
        id: 1010
      },
      {
        title: 'Misc event 2',
        start: '2014-07-21T12:00'
        end: '2014-07-26T14:00'
        allDay: false
        type: 'misc'
        description: description_2
        id: 1011
      }
    ]
