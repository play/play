#!/bin/sh
#
# Spin up our separate testing-only mpd and then kill it after ten seconds
# (which hopefully is as long a test suite as we'll see... maybe).
mpd test/daemon/mpd.conf > /dev/null 2>&1
# { sleep 10; kill $(cat /tmp/play-test/.mpd/pid); } &