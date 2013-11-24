Here's two `Mercurial <http://mercurial.selenic.com/>`__
`hooks <http://mercurial.selenic.com/wiki/Hook>`__ I wrote for my work.
One is a reminder to mention `Trac <http://trac.edgewall.com/>`__
tickets in commit messages, and the other notifies a developer when
someone (not him) touches his part of project. ...

--------------


Here's reminder. It's commit hook, run after commit was made. If you
forgot to write something like "fixes #666", it'd *echo* "Have you
forgot to mention ticket?" and commit message back to you, just in time
for *hg rollback* (or *hg commit --amend* in recent Mercurial versions)
and changing message. Or ignoring it, of course.

::

    #!/bin/sh

    ci_msg=$(hg log -r "${HG_NODE}" --template "{desc}")

    echo $ci_msg | egrep -q '#[[:digit:]]{1,4}' && exit 0

    echo "Have you forgot to mention ticket?"hg log -r "${HG_NODE}" --template "{desc}\n"



--------------


And here's notifier. It's intended to be *incoming* hook and looks if
files in certain directories were modifiled by anyone except certain
person. And sends message via ssmtp.

::


    #!/bin/sh

    notify() {
        cp -f /var/hg/ntf.templ /tmp
        echo "See http://hg.server/repo/rev/${HG_NODE}" >> /tmp/ntf.templ
        hg log -r ${HG_NODE} -p >> /tmp/ntf.templ
        sendmail recipient@mail.domain < "/tmp/ntf.templ"
    }



    hg log -r ${HG_NODE} --template "{author}" | grep -q 'author-to-be-ignored' && exit 0

    hg log -r ${HG_NODE} --template "{files}" | egrep -q 'regexp for files' && notify

    exit 0


Regexp example (looks for files in *\`hg root\`/modules/* and *\`hg
root\`/lib/modules/*):

::

    (^| )(lib/)?modules


Sample */var/hg/ntf.templ*:

::


    To: recipient@mail.domain

    From: notifier@mail.domain

    Subject: Achtung Minen!



    <Notification message body>


`**Pygmented** <http://pygments.org/>`__
