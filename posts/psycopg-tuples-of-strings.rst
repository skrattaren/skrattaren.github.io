.. title: psycopg2 возвращает кортеж из строки / psycopg2 returns tuples of string
.. slug: psycopg-tuples-of-strings
.. date: 2009-12-29 14:12:20
.. tags: python,linux,eng,рус

Игрался я сегодня с базой на `PostgreSQL <http://www.postgresql.org/>`__
(v8.3, если кому интересно) из Python посредством psycopg2, но внезапно
застрял, да как-то неожиданно. Вылез в оболочку
`bpython <http://www.bpython-interpreter.org/>`__\ а и узрел…

::

    >>> cur.execute('''SELECT (parent, level) FROM "MsgElems" WHERE msg_id=1;''')

    >>> cur.fetchone()

    ('(0,1)',)

*SELECT* возвращает кортеж из строки, именно *одной* строки. Вот это
сюрприз. Ни в Python DBAPI PEP, ни в psycopg docs я ничего не нашёл
умного, загрустил уже, но потом в голову пришла гениальная (как обычно)
идея:

::

    >>> cur.execute('''SELECT parent, level FROM "MsgElems" WHERE msg_id=1;''')

    >>> cur.fetchone()

    (0, 1)

Вот такие пироги, остерегайтесь. А я тем временем попытаюсь выяснить,
что это за ерунда, да и ерунда ли вообще.

Today I was fiddling with `PostgreSQL <http://www.postgresql.org/>`__
(v8.3, if anyone is interested) database from Python using famous
psycopg2, but suddenly got stuck in unexpected place. Had switched to
`bpython <http://www.bpython-interpreter.org/>`__ shell I saw the
following:

::

    >>> cur.execute('''SELECT (parent, level) FROM "MsgElems" WHERE msg_id=1;''')

    >>> cur.fetchone()

    ('(0,1)',)

*SELECT* returned tuple of string, one string. Now that's what I call
unexpected… I didn't find anything neither in Python DBAPI PEP nor
psycopg docs, but after some time a bright idea came:

::

    >>> cur.execute('''SELECT parent, level FROM "MsgElems" WHERE msg_id=1;''')

    >>> cur.fetchone()

    (0, 1)

Watch out. Meanwhile I'll try to find out, what triggers such weird
behaviour, and if it is weird at all.
