| (Just to save a useful and complex construct for future reference)
| List all the overlay maintainers who hasn't migrated their packages to
*virtual/pkgconfig*:

::

    ack --files-with-matches dev-util/pkgconfig | xargs dirname | uniq \
           | xargs -I {} grep '<name>' '{}/metadata.xml' \
           | sed 's:\s\+<name>\(.\+\)</name>:\1:' | sort -u

| 
| Yes, I use *ack* instead of *grep*, being too lazy to add all the
neccessary options.
