.. title: From cronjobs to abusing Github Actions
.. slug: replace-your-local-cronjobs
.. date: 2025-11-07 14:43:24 UTC+04:00
.. tags: programmierung

Quite often I find myself writing a script that I need running periodically.
Since I'm an old \*nix-head, my first instinct is to use a cronjob for that.
Obviously, there is a lot of downsides to this approach, I won't even list
them.  But it's 2025, and there's enough free tools for that!

.. TEASER_END

So, let's take as an example a scenario common for me: poll some service, check
if something changed since last time, send a notification.  I've written a
couple of these scripts, and put them in my crontrackers_ repo.  On the
earlier stages of development, they were run manually or by *cron*, stored
their state in a local file, and showed notification using local desktop
environment.  That had to change!

.. _crontrackers: https://github.com/skrattaren/crontrackers

Your code
=========

Nothing surprising here: presumably, you already have the code to poll some
API, scrape the web or something.  Just commit it and push to Github, like a
normal person.

Running it
==========

To run your code, we'll be using Github Actions.  Chances are, you're already
familiar with them, otherwise you're welcome to RTFM_ a bit.  Make sure to also
learn how to compile/run your particular codebase (Python, C++, Rust,
whatever).

For our use case ("cloud cronjob"), one particularly interesting option is
``on: schedule``, see `Events that trigger workflows`_.  It even uses tried and
true POSIX *cron* syntax!

You might also want to re-run your action(s) on every code push event, in that
case ``on: push`` is your friend too.

.. _RTFM: https://docs.github.com/en/actions
.. _Events that trigger workflows: https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#schedule

Configuration
*************

Let's assume you're not a psychopath, and you don't hardcode every option and
parameter.  Fortunately, Github Actions employ Variables_ and Secrets_.  Choose
whatever you need.

Take a look at `my example`_ to see how it all fits together.

.. _Secrets: https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets
.. _Variables: https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-variables
.. _my example: https://github.com/skrattaren/crontrackers/blob/main/.github/workflows/workflow.yml

Public repo, private logs
*************************

Quite often, you want to keep your code public, but not to expose your personal
data, even if it's just a list of parcels to track.  The best solution I've
found so far is to keep a private fork of your public repo, and configure
variables there.

Notifications
=============

If you want some kind of notification sent by your action, I recommend
ntfy.sh_.  Send a plain old HTTP request, and receive a notification on your
mobile device, or on a desktop (just keep a tab open in your browser).

.. _ntfy.sh: https://ntfy.sh/

Storing state
=============

Another common thing is to store some kind of state between workflow runs, even
if it's just a list of strings in JSON.  From what I learnt back in 2024, it's
not possible with plain vanilla Github Actions.  So I found a couple of
services allowing storing JSON and managing it via HTTP.

Pantry_:

- the first I've found
- doesn't require registration
- recently had a major (a whole month of!) downtime, so I decided to look elsewhere

So for now I use JSONBin.io_:

- basically the same, although API is a bit different
- requires registration
- forces versioning
- doesn't allow empty content (*WHY?!..*)
- UI/UX feels a bit less polished
- stable so far, but it's too early to tell.

.. _JSONBin.io: https://jsonbin.io/
.. _Pantry: https://getpantry.cloud/

That's basically it!
********************
