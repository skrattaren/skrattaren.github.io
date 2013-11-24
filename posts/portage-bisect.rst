.. title: {hg, git} bisect + portage
.. slug: portage-bisect
.. date: 2010-06-15 19:06:24
.. tags: рус,gentoo,linux,eng,hg

Не так давно имел я счастье вляпаться в `неприятную
ошибочку <http://awesome.naquadah.org/bugs/index.php?do=details&task_id=772>`__
с моим любимым awesome. Разрабы попросили сделать *git bisect*, чтоб
найти причину косяка, но выяснилось, что просто запуском свежесобранного
бинарника не отделаться. Пришлось немного подумать и сопрячь *bisect* и
Portage.

Recently I did stumble into a `annoying bug in awesome
WM <http://awesome.naquadah.org/bugs/index.php?do=details&task_id=772>`__.
Devs asked me to do *git bisect* in order to help fixing it, but it
appeared that simple compiling and running the binary wasn't enough for
reproducing it, so I though a bit and managed to couple *bisect*\ ing
and Portage.


.. TEASER_END

Будем считать, что Вы в курсе, что такое ***bisect*** (а если не знаете,
но хотите узнать, обратитесь к документации), так что всё, что нужно
сделать, это установить нужный пакет из соответствующей ревизии с
помощью *emerge* (ну и проверить его на искомую ошибку) после прогона
*${избранная-dvcs} bisect*. Как это сделал я:

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

Что тут происходит:

-  наши «снимки» из git будут считаться версией **awesome 3.4.999** (мы
   ищем ошибку между 3.4.4 and 3.4.5), на самом деле это неважно;
-  исходный код копируется в сторонку, *.git* подчищается, и с помощью
   *tar* мы получаем архив примерно того же свойства, что и у
   «официальных» версий;
-  далее мы просто обновляем Manifest для нашего ebuild'а (который
   является простой копией awesome-3.4.5.ebuild из официального дерева
   Portage) и устанавливаем эту версию

Секите на здоровье! (-;Е

P.S. А моя ошибка была исправлена в git через три дня после моего
сообщения. А никто и не заметил, хе-хе.

-------------

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
