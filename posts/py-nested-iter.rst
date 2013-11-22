Просто образчик вложенного итератора на Python, через рекурсивное
выражение ***yield***.

Just a (probably) useful examle of nested Python generator written in
Python using recursive ***yield*** expression.

...

::

    [color=#408080][i]#!/usr/bin/env python2.6[/i][/color]

    [color=#408080][i]# -*- coding: utf-8 -*-[/i][/color]



    sample [color=#666666]=[/color] ([color=#666666]1[/color], [color=#666666]2[/color], ([color=#666666]3[/color], [color=#666666]4[/color], [color=#666666]5[/color]), [color=#666666]6[/color], (([color=#666666]7[/color], ), [color=#666666]8[/color]), [color=#666666]9[/color])



    [color=#008000][b]def[/b][/color] [color=#0000FF]cycle[/color](smth):
        [color=#008000][b]for[/b][/color] i [color=#AA22FF][b]in[/b][/color] smth:
            [color=#008000][b]if[/b][/color] [color=#008000]isinstance[/color](i, [color=#008000]int[/color]):
                [color=#008000][b]yield[/b][/color] i[color=#666666]**[/color][color=#666666]2[/color]
            [color=#008000][b]else[/b][/color]:
                [color=#008000][b]for[/b][/color] j [color=#AA22FF][b]in[/b][/color] cycle(i):
                    [color=#008000][b]yield[/b][/color] j


    [color=#008000][b]for[/b][/color] j [color=#AA22FF][b]in[/b][/color] cycle(sample):
        [color=#008000][b]print[/b][/color](j)
    -------

    1

    4

    9

    16

    25

    36

    49

    64

    81

| 
| `**Pygmented** <http://pygments.org/>`__
