.. title: Change the code and see the result
.. slug: codewatch
.. date: 2009-12-22 18:12:20
.. tags: python,linux,programmierung

An interesting idea came to me several days ago. I have to write C++
code generator (sourcing data from SQL database), so I installed
`Jinja2 <http://jinja.pocoo.org/2/>`__, sharpened text editors and then
asked myself: „Wouldn't it be beautiful to see the result just as I type
Python code, portion by portion? There's a use for two monitors: the
first one displays coding, the second one keeps freshly generated result
always ready for review.“


.. TEASER_END

I liked and cherished the idea, and it was maturing: my workbox runs
`Gentoo Linux <http://gentoo.org/>`__, and Linux kernel supports
`inotify <http://www.mjmwired.net/kernel/Documentation/filesystems/inotify.txt>`__
— file change notification system, and there's Python bindings for it.
Moreover, since we want not plain text but source code to get displayed,
`Pygments <http://pygments.org/>`__ spring into mind instantly — why not
to pygmentize output? And, of course, standard for modern \*nix
distribuition but glorious
neverthe\ `**less** <http://www.greenwoodsoftware.com/less/>`__ to page
the result.

So the idea is basically this: we start watcher-script, which watches
(looping endlessly) all the source files we want, and when files are
changed, reloads modules, re-runs key function, pygmentizes result
string, pipes it to less's stdin through UNIX pipe and waits for next
filechange event.

**And here's the code**:

.. code-block:: python

    #!/usr/bin/env python
    # -*- coding: utf-8 -*-

    from inotifyx import *
    import sys, os, logging, subprocess

    import templater

    from pygments import highlight
    from pygments.lexers import HtmlLexer
    from pygments.formatters import TerminalFormatter

    # Logging is helpful in debugging
    LOG_FILENAME = '/tmp/debug_viewer.log'
    logging.basicConfig(filename=LOG_FILENAME,level=logging.DEBUG)

    # Initting inotifyx
    fd = init()

    watcher = add_watch(fd, 'templater.py', IN_MODIFY)

    try:
        # Starting infinite loop
        while True:
            logging.debug('Starting iteration\n')
            try:
                reload(templater)
                string = templater.render_template()
                highlighted = highlight(string, HtmlLexer(), TerminalFormatter())
                logging.debug('Spawning less\n')
                less = subprocess.Popen(['less', '-'],
                                        stdin=subprocess.PIPE)
                logging.debug('less spawned, piping data\n')
                less.stdin.write(highlighted)
                less.stdin = sys.stdin
            except SyntaxError, e_text:
                print 'SyntaxError was raised'
                print SyntaxError
            logging.debug('Data piped, waiting for inotification\n')
            get_events(fd)
            logging.debug('Inotified, killing less\n')
            less.terminate()
            logging.debug('_______________________\n')

    except KeyboardInterrupt:
        less.terminate()
        os.close(fd)

Treat log messages I used for debugging (*tail -f* in other terminal) as
a comments (-:E

Few things worth mentioning:

-  there's two packages binding Python to inotify system: more complex
   and established
   `pyinotify <http://trac.dbzteam.org/pyinotify/wiki>`__ and newer and
   simpler
   `inotifyx <http://www.alittletooquiet.net/software/inotifyx/>`__. I
   opted for second one, because of declared simplicity and speed
-  script *stdin.writes()* to spawned *less* process, not
   *Popen.communicates()*. This is because *.communicate()* method waits
   for returned data, and we don't need this
-  the trick I like most in this quite straightforward script is binding
   terminal *STDIN* to *less*'es one after piping in highlighted code.
   Before I did this, *less* was incontrollable, since keypresses didn't
   reach it

`CLI script (refactored mercilessly) on
BitBucket <https://bitbucket.org/skrattaren/scripties/src/tip/inotify_watcher.py>`__

`Screencast <http://files.myopera.com/Sterkrig/files/codewatcher.ogv>`__
