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

### Pusher

Play's realtime notification is powered by [Pusher](http://pusher.com/). Pusher
allows Play to provide realtime updating to any client that cares. This includes
the site as well as Play clients. Clients will be updated in realtime as Play cycles
through songs as well as when new songs get queued.

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

    git clone https://github.com/play/play.git && cd play

Next, you need to run the bootstrap process, which will verify that we can talk
to iTunes, that you have all of your settings set up correctly, and will guide
you through the configuration setup:

    script/bootstrap

During the bootstrap process you'll be asked to enter your [Pusher][pusher]
credentials. This is optional, but it'll let you get realtime updates to your
Play queue. It's like the future. Websockets and shit.

Open up iTunes and start playing music from the iTunes DJ playlist.
At this point, you should be ready to play:

    rake start

That'll start the server up on [localhost:5050](http://localhost:5050).

This adds user authentication to requests made as a client. Play's API is used throughout the entire app whether its front end or general API requests, so authentication has to be smart.

### API/Client Auth

Each user on Play has a unique auth `token`. They will give this `token` to each Play client for it to make requests on their behalf.

In addition to these unique tokens, each Play installation also has its own unique system wide auth `token`. This can be used to auth and masquerade as any user on the system. When using this system wide `token`, a `login` must be provided in the request so Play knows what user the request is masquerading as. This is essentially how [Hubot](https://github.com/github/hubot) will commnuicate with Play.

Both of these styles tokens can be included as a **header** or as a **query param**.

### User Token

When using a user's `token`, only the `token` needs to be included. It can be added to the request in the header or as a query param.

#### Header

    "Authorization: 5422fd"

#### Query Param

    ?token=5422fd

### System Token

When using a system token, a `login` needs to be added to the request in addition to the system `token` added by the means described above. It can be added to the request in the header or as a query param.

#### Header

    "X-PLAY-LOGIN: maddox"

#### Query Param

    ?login=maddox


### Clients

Part of the fun with Play is getting it everywhere: in your office, on your
desktop, and on your phone. Once you get Play set up correctly, you'll need to
install [Nicecast][nicecast].

The following clients exist for Play:

#### OS X

[play/play-cocoa](https://github.com/play/play-cocoa)

<a href="https://github.com/play/play-cocoa">![](http://f.cl.ly/items/3J2U1Z2x033R3p1I1J0b/play-item.png)</a>

#### iOS

[play/play-cocoa](https://github.com/play/play-cocoa)

<a href="https://github.com/play/play-cocoa">![](http://f.cl.ly/items/1Z1W3P351q2V1m2v3n12/play-ios-iphone.png)</a>
<a href="https://github.com/play/play-cocoa">![](http://f.cl.ly/items/2Z0O09320f142y3x163q/play-ios-ipad.png)</a>

#### Windows

[play/play-windows](https://github.com/play/play-windows)

<a href="https://github.com/play/play-windows">![](http://cl.ly/3D0u3N102O1D0m1g3B1Y/Image%202012.04.19%202:35:54%20AM.png)</a>


#### Android

[play/play-android](https://github.com/play/play-android)

<a href="https://github.com/play/play-android">![](http://cl.ly/382B3t2x2P2w2R0V1U3B/play-android.png)</a>

#### Now Playing on TV

We also have a TV at the office with the currently-playing song. This doesn't
require any setup; just point your TV's browser at the main Play instance and
the TV interface should show up as long as the screen ratio is 16:9
(ie, 720p or 1080p).

![](http://cl.ly/1c0D0d0Y1a1K0S3s0N0m/Image%202012.04.19%204:46:51%20PM.png)

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

Native clients use (Pusher)[http://pusher.com/] to be updated in realtime. They will show
what is currently playing, and with some clients, what is queued. All clients are built
to consume the Shoutcast stream.

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
[contributors](https://github.com/play/play/contributors).

[nicecast]: http://rogueamoeba.com/nicecast/
[campfire]: http://campfirenow.com/
[pusher]:   http://pusher.com/
