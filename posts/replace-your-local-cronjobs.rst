.. title: Replace your local cronjobs!
.. slug: replace-your-local-cronjobs
.. date: 2025-05-10 19:43:24 UTC+03:00
.. status: draft
.. tags: 
.. category: 
.. link: 
.. description: 
.. type: text

Quite often I find myself writing a script that I need running periodically.
Since I'm an old \*nix-head, my first instinct is to use a cronjob for that.
Obviously, there is a lot of downsides to this approach, I won't even list
them.  But it's 2025, and there's enough free tools to adapt for that!

So, let's take as an example a scenario common for me: poll some service, check
if something changed since last time, send a notification.  I've written a
couple of these scripts, and put them in my crontrackers_ repo.  On the
earlier stages of development, they were run manually or by *cron*, stored
their state in a local file, and showed notification using local desktop
environment.  That had to change!

Your code
=========

Nothing surprising here: presumably, you already have the code to poll some
API, scrape the web or something.  Just commit it and push to Github, like a
normal person.

Running the code
================

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

Let's assume you're not a psychopath.
Github Action Variables and Secrets

https://github.com/skrattaren/crontrackers/blob/main/.github/workflows/workflow.yml

Notifications
=============

ntfy.sh_

Storing state
=============

JSONBin.io_ or Pantry_


.. _JSONBin.io: https://jsonbin.io/
.. _Pantry: https://getpantry.cloud/
.. _ntfy.sh: https://ntfy.sh/
.. _crontrackers: https://github.com/skrattaren/crontrackers
