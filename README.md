# Play

Play is an employee-powered iTunes-based client-driven distributed music server
for your office. Also it can prepare your taxes.

## Background

Did you know that listening to music while you work produces better and faster
code? It's true. It's in a README.

We listen to music constantly at GitHub. So I wrote Play. Initially it was a
modest shell-oriented music server, but we've since grown it to quite the setup:

![Play at GitHub](http://cl.ly/EHBs/play.png)

We have employees all over the world, but Play lets us all listen to the same
music as if we were all in the office together. This has actually made a big
impact on our culture.

## The Setup

### OS X

Play is built for the Mac. We use a Mac Mini.

### iTunes

Play is **iTunes-based**. That means we can let iTunes do what it's good at and
manage the state of our music. We use **iTunes DJ** to handle the main Play
queue, specifically because it emulates what Play does: provide a smart playlist
neverending songs.

### The Stream and Speakers

We use [Nicecast][nicecast] to take the audio stream from iTunes and deliver it
to our client apps so everyone can stream from their platform of choice.

We also use iTunes' built-in AirPlay support to stream to multiple speakers
across our office network.

### Web

The heart of Play is the web app. This is effectively an API to access and
control your iTunes library over the web. The app also handles music upload:
just drag your files to the browser window, then they'll get uploaded and
indexed in iTunes. No complex file sharing and office VPN setups necessary.

### API

We primarily drive Play through [Campfire][campfire], the chat service we use
internally at GitHub. Most Play interactions happen through the API rather than
the web interface, and the API is actually a superset of the functionality
available through the web.

## Installation

### Setup

Play has a lot of moving parts, but we've tried to simplify installation as much
as we could.

First, clone down the repository:

    git clone https://github.com/holman/play.git && cd play

Next, you need to run the bootstrap process, which will verify that we can talk
to iTunes, that you have all of your settings set up correctly, and will guide
you through the configuration setup:

    bin/bootstrap

During the bootstrap process you'll be asked to enter your [Pusher][pusher]
credentials. This is optional, but it'll let you get realtime updates to your
Play queue. It's like the future. Websockets and shit.

At this point, you should be ready to play.

    rake start

That'll start the server up on [localhost:5050](http://localhost:5050).

### Clients

Part of the fun with Play is getting it everywhere: in your office, on your
desktop, and on your phone. Once you get Play set up correctly, you'll need to
install [Nicecast][nicecast] and set it up to stream iTunes (not the system
audio).

The following clients exist for Play:

- [OS X]()
- [Windows]()
- [iPhone]()
- [Android]()

We also have a TV at the office with the currently-playing song. This doesn't
require any setup; just point your TV's browser at the main Play instance and
the TV interface should show up as long as the screen ratio is 16:9
(ie, 720p or 1080p).

## Technical Details

### AppleScript

The entire Play + iTunes bridge is handled via AppleScript. Play talks to
AppleScript, AppleScript talks to iTunes, and we make it dance.

### The Web is the API

The web app is a simple, straightfoward Sinatra app. State that we can't stash
in iTunes is persisted through **Redis**.

The entire web app is just a thin client over the API, which is delivered
through JSON. We only really deliver one HTML page: the main root page. All data
on that page is populated via JSON requests. This means we can focus on one API
and use it for both the web and for every other client.

The frontend is built with SCSS, CoffeeScript, Mustache, Pusher, and jQuery. All
assets are compiled and delivered via Sprockets.

### Native Clients

Right now all of our native clients exist only to deliver the Stream. They grab
the Stream, parse out the metadata embedded in the Stream, and give you a nice
view of what's currently playing while you listen to it.

The idea is to build out all of our clients to include the full capabilities of
Play.

## Contributing

We'd love to see your contributions to Play. If you'd like to hack on Play,
you'll likely want to run Play in development mode:

    shotgun

That will reload the code on each page request. You can hit the server on
[localhost:9393](http://localhost:9393).

You can run the tests with:

    rake

Fork the project, make your commits, then send a Pull Request.

## Play

Play was written by [Zach Holman](https://twitter.com/holman) and shaped by the
fine ladies and gentlemen at [GitHub](https://github.com/github). We've also
benefited from a lot of hard work from our
[contributors](https://github.com/holman/play/contributors).

[nicecast]: https://github.com
[campfire]: https://github.com
[pusher]:   https://github.com
