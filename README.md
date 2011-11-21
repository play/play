[![play](http://f.cl.ly/items/0M3D1T3o282g1x1C0q09/splash.png)](http://cl.ly/BOJT)

## Background

We like playing music at the GitHub office. Everyone has their own library on
their own machines, and everyone except for me plays shitty music. Play is
designed to make office music more palatable.

Play is **api-driven** and **web-driven**. All music is dropped on a central
Mac system. Once it's available to Play, users can control what's being played.
Users can either use a nice web view or the API, which lends itself for use on
the command line or through Campfire.

Play will play all the songs that are added to its Queue. Play will play the
crap out of that Queue. And you know what?  If there's nothing left in the
Queue, Play will figure out who's in the office and play something that they'll
like.

No shit.

## Screencast

[There's a video](http://zachholman.com/screencast/play). It includes some
explicit close-ups of a command line prompt.

## Install

The underlying tech of Play uses `afplay` to control music (for now), so you'll
need a Mac. `afplay` is just a simple command-line wrapper to OS X's underlying
music libraries, so it should come preinstalled with your Mac, and it should
play anything iTunes can play.

Play also expects MySQL to be installed. Play runs in Ruby 1.8.7.

### Install

Play is installed by cloning down the repository:

    git clone https://github.com/holman/play

Then run the `setup` script. It's cool.

    bin/setup

## Play

Things are managed with the `bin/play` executable.

    play start       Starts up the web and music servers.
    play help        All of the other commands available in play.

## Hubot

Play also has [Hubot](https://hubot.github.com) integration. Just add
[play.coffee](https://github.com/github/hubot-scripts/blob/master/src/scripts/play.coffee)
to your Hubot.

## Rdio

There is a setup script to help fill out the right play.yml settings for Rdio. 
You'll need to set it up with your client keys from Rdio.

    play rdio       Helps set the yml variables

Playing Rdio tracks also requires Google Chrome.

## Set up your office (optional)

This isn't a required step. If nothing's in the queue and Play has still been
told to play something, it'll just play random music. But you can set it up so
it will play a suitable artist for someone who's currently in the office.

That particular step is left to the reader's imagination — here at GitHub we
poll our router's ARP tables and update an internal application with MAC
addresses — but all Play cares about is a URL that returns comma-separated
string identifiers. We get that string by hitting the `office_url` in
`config/play.yml`. The string that's returned from that URL should look
something like this:

    holman,kneath,defunkt

That means those three handsome lads are in the office right now. Once we get
that, we'll compare each of those with the users we have in our database. We do
that by checking a user attribute called `office_string`, which is just a
unique identifier to associate back to Play's user accounts. In this example,
I'd log into my account and change my `office_string` to be "holman" so I could
match up. It could be anything, though; we actually use MAC addresses here.

## API

Play has a full API that you can use to do tons of fun stuff. In fact, the API
is more feature-packed than the web UI. Because we're programmers. And baller.

Check out the [API docs on the wiki](https://github.com/holman/play/wiki/API).

## ♬ ★★★

This was created by [Zach Holman](http://zachholman.com). You can follow me on
Twitter as [@holman](http://twitter.com).

I usually find myself playing Justice, Deadmau5, and Muse at the office.
