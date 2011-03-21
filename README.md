# Play
Play is your company's dj.

## Background

We want to play music at our office. Everyone has their own library on their
own machines, and everyone except for me plays shitty music. Play is designed
to make office music more palatable.

Play is **api-driven** and **web-driven**. All music is dropped on a central
Mac system. Once it's available to Play, users can control what's being played.
Users can either use a nice web view or the API, which lends itself for use on
the command line or through Campfire.

Play will play all the songs that are added to its Queue. Play will play the
crap out of that Queue. And you know what?  If there's nothing left in the
Queue, Play will figure out who's in the office and play something that they'll
like.

No shit.

## Install

The underlying tech of Play uses `afplay` to control music (for now), so you'll
need a Mac. `afplay` is just a simple command-line wrapper to OS X's underlying
music libraries, so it should come preinstalled with your Mac, and it should
play anything iTunes can play.

Play also expects MySQL to be installed.

### Install the gem

Play itself is installed with a gem.

    gem install play

### Fill out ~/.play.yml

You'll need to set up your configuration values, which we store in
`~/.play.yml`. You can view the [example file on
GitHub](https://github.com/holman/play/blob/master/play.yml.example).

### Set up your database

This is a bit of a pain that we'll correct eventually. For now, create your
MySQL database by hand. We expect the database to be called `play`, but it's
really pulled from whatever you have in `~/.play.yml`. When that's set up, run:

    bin/play --migrate

### Set up your GitHub application

Next, go to GitHub and [register a new OAuth
application](https://github.com/account/applications/new). Users sign in with
their GitHub account. Copy the Client ID and Client Secret into Play's
`~/.play.yml` file.

### Set up your music folder

Next, tell Play where to look for music. It's the `path` attribute in
`~/.play.yml`. We'll then look at your path and import everything
recursively when you run:

    play -i

## Play

Once you're all set up, you can spin up the web app with:

    play -w

You can hit the server at [localhost:5050](http://localhost:5050). Queue some
hawt, hawt music up. We'll wait.

Ready? Cool. The only thing left to do is actually start the music server.
That's done with:

    play -d

You'll detach it and put it in the background, where it will sit waiting for
salacious music to play for you. When you want to kill it for reals, run:

    play -s

For all the fun commands and stuff you can do, just run:

    play -h


## Set up your office (optional)

This isn't a required step. If nothing's in the queue and Play has still been
told to play something, it'll just play random music. But you can set it up so
it will play a suitable artist for someone who's currently in the office.

That particular step is left to the reader's imagination — here at GitHub we
poll our router's ARP tables and update an internal application with MAC
addresses — but all Play cares about is a URL that returns comma-separated
string identifiers. We get that string by hitting the `office_url` in
`~/.play.yml`. The string that's returned from that URL should look
something like this:

    holman,kneath,defunkt

That means those three handsome lads are in the office right now. Once we get
that, we'll compare each of those with the users we have in our database. We do
that by checking a user attribute called `office_string`, which is just a
unique identifier to associate back to Play's user accounts. In this example,
I'd log into my account and change my `office_string` to be "holman" so I could
match up. It could be anything, though; we actually use MAC addresses here.

## ♬ ★★★

This was created by [Zach Holman](http://zachholman.com). You can follow me on
Twitter as [@holman](http://twitter.com).

I usually find myself playing Justice, Kanye West, and Muse at the office.
