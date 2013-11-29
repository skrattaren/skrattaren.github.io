.. title: psycopg2 возвращает кортеж из строки
.. slug: psycopg-tuples-of-strings-ru
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

