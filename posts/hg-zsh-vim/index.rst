.. title: Mercurial zsh completion with vim
.. slug: hg-zsh-vim
.. date: 2012-06-20 19:06:23
.. tags: hg,programmierung,vim

How to re-format output of *hg help <command>* for use in `Mercurial
zsh\_completion file
<http://selenic.com/repo/hg/file/tip/contrib/zsh_completion>`__.

.. TEASER_END

We start with simple generic template copied from some other command
like export::

    _hg_cmd_graft() {
      _arguments -s -w : $_hg_global_opts \
      '*:revision:_hg_labels'
    }


Let's copy graft-specific options from ``hg help graft`` output::

      -c --continue    resume interrupted graft
      -e --edit        invoke editor on commit messages
         --log         append graft info to log message
      -D --currentdate record the current date as commit date
      -U --currentuser record the current user as committer
      -d --date DATE   record the specified date as commit date
      -u --user USER   record the specified user as committer
      -t --tool VALUE  specify merge tool
      -n --dry-run     do not perform actions, just print output


Now select help text and reformat it with a bit of regexps::


    :'<,'>s:^\s\+\(-[a-zA-Z0-9]\) \(--[a-z-]\+\)\s\+:  '(\2 \1)'{\1,\2}'[

    :'<,'>s:^\s\+\(--[a-z-]\+\)\s\+:  '\1[

    :'<,'>s:$:]' \

    :'<,'>s:'\[[A-Z]\+\s\+:'[


And the result is::


    _hg_cmd_graft() {
      _arguments -s -w : $_hg_global_opts \
      '(--continue -c)'{-c,--continue}'[resume interrupted graft]' \
      '(--edit -e)'{-e,--edit}'[invoke editor on commit messages]' \
      '--log[append graft info to log message]' \
      '(--currentdate -D)'{-D,--currentdate}'[record the current date as commit date]' \
      '(--currentuser -U)'{-U,--currentuser}'[record the current user as committer]' \
      '(--date -d)'{-d,--date}'[record the specified date as commit date]' \
      '(--user -u)'{-u,--user}'[record the specified user as committer]' \
      '(--tool -t)'{-t,--tool}'[specify merge tool]' \
      '(--dry-run -n)'{-n,--dry-run}'[do not perform actions, just print output]' \
      '*:revision:_hg_labels'
    }


Vim have helped you as it could, now decide is there anything left to
be done.
