# play

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

    script/music start
    script/web start

That'll make sure you don't have to reload your server each time, and it'll
also show you logs in your console.
