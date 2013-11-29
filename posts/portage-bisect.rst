.. title: {hg, git} bisect + portage
.. slug: portage-bisect
.. date: 2010-06-15 19:06:24
.. tags: рус,gentoo,linux,eng,hg

Recently I did stumble into a `annoying bug in awesome
WM <http://awesome.naquadah.org/bugs/index.php?do=details&task_id=772>`__.
Devs asked me to do *git bisect* in order to help fixing it, but it
appeared that simple compiling and running the binary wasn't enough for
reproducing it, so I though a bit and managed to couple *bisect*\ ing
and Portage.

.. TEASER_END

I assume you know what is ***bisect*** (and if not, but want to, see the
documentation), so basically what you need is to *emerge* package in
question from certain changeset (and then test it for bug) after running
*${your-dvcs-here} bisect*. Here's how I did it:

::

    #!/bin/sh
    rm -rf /tmp/awesome*
    cp -rp ~sterkrig/tmp/awesome /tmp/awesome-3.4.999
    rm -rf /tmp/awesome-3.4.999/.*
    cd /tmp
    tar cjf awesome-3.4.999.tar.bz2 awesome-3.4.999
    mv -f awesome-3.4.999.tar.bz2 /usr/portage/distfiles
    chown portage:portage /usr/portage/distfiles/awesome-3.4.999.tar.bz2
    chmod 664 /usr/portage/distfiles/awesome-3.4.999.tar.bz2
    ebuild --force /usr/local/portage/x11-wm/awesome/awesome-3.4.999.ebuild manifest
    emerge awesome
    cd ~

Let me explain what does it do:

-  we'll treat git checkouts as **awesome 3.4.999** (bisecting between
   3.4.4 and 3.4.5), it really doesn't matter;
-  sources are copied to other location, *.git* gets removed, and *tar*
   creates tarball similar to those of „official“ releases;
-  next thing is to update manifest for our ebuild (it's just a copy of
   awesome-3.4.5.ebuild from the tree) and *emerge* it

Happy bisecting!

P.S. And my bug was fixed three days after report. And nobody had
noted it, hehe.
