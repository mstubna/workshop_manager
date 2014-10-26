# Workshop Manager

[FullCalendar.js](http://fullcalendar.io/) is a fantastic open source javascript library for displaying events in a beautiful customizable calendar. However, according to the author:

> FullCalendar is great for displaying events, but it isn't a complete solution for event content-management. Beyond dragging an event to a different time/day, you cannot change an event's name or other associated data. It is up to you to add this functionality through FullCalendar's event hooks.

This project demonstrates a Workshop Manager app that builds out that missing functionality.

[View the Workshop Manager demo](http://workshopmanager.s3-website-us-east-1.amazonaws.com)

Tapping on an event in the calendar displays the full event details. Events can also be created, copied, and deleted.
<a href="http://workshopmanager.s3-website-us-east-1.amazonaws.com">![](http://workshopmanager.s3-website-us-east-1.amazonaws.com/images/demo_1.png)</a>

Full event details can be edited.
<a href="http://workshopmanager.s3-website-us-east-1.amazonaws.com">![](http://workshopmanager.s3-website-us-east-1.amazonaws.com/images/demo_2.png)</a>

## Other open-source libraries used

- [jQueryUI Dialog](http://jqueryui.com/dialog/) to open a dialog for editing all of the event details.
- [Abide Validation](http://foundation.zurb.com/docs/components/abide.html) to validate user-entered data.
- [Foundation Grid](http://foundation.zurb.com/docs/components/grid.html) for responsive design.
- [Foundation Off Canvas](http://foundation.zurb.com/docs/components/offcanvas.html) to slide in the event details view on small mobile devices.
- [fastclick](https://github.com/ftlabs/fastclick) and [jQuery UI Touch Punch](http://touchpunch.furf.com/) to handle touch events.

## Set up for development

[Grunt](http://http://gruntjs.com/) is used to build the app from the source files.

### Prerequisites

[Node and npm](http://nodejs.org/), and [grunt-cli](http://gruntjs.com/getting-started) should be installed on your development system.

### Commands

- To install the project dependencies after downloading the source files

        $ npm install

- To run the development environment

  1. In a terminal window

          $ grunt build_watch

      This triggers the build process when source files change.

  2. In another terminal window

          $ grunt preview

      This serves the site on <http://localhost:8000>
