.. title: Piping commands till it hurts
.. slug: piping-cmds
.. date: 2012-07-04 12:07:18
.. tags: gentoo,linux,eng

(Just to save a useful and complex construct for future reference)

List all the overlay maintainers who hasn't migrated their packages to
*virtual/pkgconfig*:

::

    ag --files-with-matches dev-util/pkgconfig | xargs dirname | uniq \
           | xargs -I {} grep '<name>' '{}/metadata.xml' \
           | sed 's:\s\+<name>\(.\+\)</name>:\1:' | sort -u


Yes, I use ag_ instead of *grep*, being too lazy to add all the necessary
options. And wait. And *ag* is so much better however you look at it.

.. _ag: https://github.com/ggreer/the_silver_searcher
