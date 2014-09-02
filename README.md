# Workshop Manager

## Project

- Prototype site for Bryn Athyn that enables administrators to create events and enables regular users to register for those events.
- [View the live version of the site](http://workshopmanager.s3-website-us-east-1.amazonaws.com/)

## Prerequisites

[Node and npm](http://nodejs.org/), and [grunt-cli](http://gruntjs.com/getting-started)

## Commands

- To install the project dependencies

        $ npm install

- To build the project once

        $ grunt build

- To run the development environment
  1. In a terminal window

          $ grunt build_watch

  2. In another terminal window

          $ grunt preview

- To deploy to aws

        $ grunt deploy
