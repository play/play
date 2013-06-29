# play

## Install

There are a lot of moving parts in Play. We've built a bootstrap script to help
cut down the amount of things you'll have to do to get Play up and running. The
instructions below are platform-specific and assume an install on top of a brand
new, fresh-out-of-the-box machine.

###

For **OS X**, you'll need to first install Apple's [Command Line Tools](https://developer.apple.com/downloads/index.action?=command%20line%20tools)
so you can get software compiled on your Mac.

Once that's done, **install Homebrew**:

    ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"

With Homebrew installed, install Git:

    brew install git

Then clone the project:

    git clone https://github.com/play/play && cd play

And now you can start the bootstrap process:

    script/bootstrap


### the dirty harry developer's guide to a still beta v3 of play

Until we're further along, here's what you need to know:

    script/bootstrap
    script/play

`script/play` will run two servers: `web` and `music`. `script/bootstrap` should
let you know if there was a problem setting things up, but if you run into
trouble, look at the contents of `/tmp/play-bootstrap`.

You can shut everything down with:

    script/play stop

Want to actually listen to music? For now, run this:

    mpc play

Pause it with

    mpc pause

If you run into weird shit or anything confusing at all, file an issue. We're
getting close to wanting to polish this off, so every little bit helps.

## Development

Hacking on this? Spin it up manually with:

    RAILS_ENV=development script/play start

That'll make sure you don't have to reload your server each time, and it'll
also show you logs in your console.
