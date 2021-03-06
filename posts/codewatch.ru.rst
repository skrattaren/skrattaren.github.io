.. title: Пишешь код и видишь результат
.. slug: codewatch
.. date: 2009-12-22 18:12:20
.. tags: python,linux,programmierung

Пришла мне тут в голову интересная идея. Нужно написать генератор кода
на C++ (по данным, вытягиваемым из базы данных), так что я установил
`Jinja2 <http://jinja.pocoo.org/2/>`__, навострил текстовые редакторы и
подумал: «А не будет ли круто сразу видеть результат, прямо по ходу
написания кода? Зачем мне два монитора, в конце концов — на одном буду
писать, а второй пусть результат кажет.»

.. TEASER_END

Сказано — сделано. Идея потихоньку назревала: работаю я на `Gentoo
Linux <http://gentoo.org/>`__, а ядро Linux умеет
`inotify <http://www.mjmwired.net/kernel/Documentation/filesystems/inotify.txt>`__
— систему оповещения об изменениях в файлах, и существуют обвязки вокруг
неё для Python. Раз мы будем смотреть не просто текст, а код, то сразу
вспоминается `Pygments <http://pygments.org/>`__ — будем и расцвечивать
его, не отходя от кассы. Ну и выводить всё в терминал будем не просто
так, а через стандартный
`**less** <http://www.greenwoodsoftware.com/less/>`__.

Итак, в общих чертах: запускаем сценарий, который в бесконечной петле
будет следить за изменениями во всех нужных файлах и, когда файлы
изменяются, перезагружать модуль, запускать главную функцию,
раскрашивать результат, скармливать его *less*'у и ждать следующего
события.

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

За комментарии считайте записи для журналирования (следил за ними через
*tail -f* в третьем терминале)

Пара примечаний:

-  существует минимум два комплекта обвязок Python+inotify:
   `pyinotify <http://trac.dbzteam.org/pyinotify/wiki>`__, побольше и
   посерьёзней,
   `inotifyx <http://www.alittletooquiet.net/software/inotifyx/>`__,
   помоложе и попроще; я выбрал вторую, по причине обещанной простоты и
   лёгкости;
-  данные для *less* мы пишем в стандартный ввод (*stdin.write()*), а не
   «общаемся» с ним через *Popen.communicate()*, потому что метод
   *communicate()* ждёт ответа от процесса, а нам того не надобно;
-  уловка, которая мне нравится в этом (довольно прямолинейном, в
   общем-то), сценарийчике: после скармливания строки *less*'у, мы
   вешаем ему на стандартный ввод (который был каналом — pipe)
   стандартный ввод интерпретатора (фактически, терминала). Если этого
   не сделать, то *less* будет глух к командам извне — нажатия кнопок в
   терминале до него просто не дойдут.

`Сценарийчик (уже безжалостно перепиленный) для использования в
командной строке на
GitHub <https://github.com/skrattaren/scripties/blob/master/inotify_watcher.py>`__
