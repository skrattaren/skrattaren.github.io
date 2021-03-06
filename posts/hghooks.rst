.. title: Two (probably) useful Mercurial hooks
.. slug: hghooks
.. date: 2011-03-16 15:03:48
.. tags: hg,linux

Here's two `Mercurial <http://mercurial.selenic.com/>`__
`hooks <http://mercurial.selenic.com/wiki/Hook>`__ I wrote for my work.
One is a reminder to mention `Trac <http://trac.edgewall.com/>`__
tickets in commit messages, and the other notifies a developer when
someone (not them) touches their part of project.

.. TEASER_END

Here's reminder. It's commit hook, run after commit was made. If you
forgot to write something like "fixes #666", it'd ``echo`` *"Have you
forgot to mention ticket?"* and commit message back to you, just in time
for ``hg rollback`` (or ``hg commit --amend`` in recent Mercurial versions)
and changing message. Or ignoring it, of course.

.. code-block:: shell

    #!/bin/sh

    ci_msg=$(hg log -r "${HG_NODE}" --template "{desc}")
    echo "$ci_msg" | grep -E -q '#[[:digit:]]{1,4}' && exit 0
    echo "Have you forgot to mention ticket?
    hg log -r "${HG_NODE}" --template "{desc}\n"

And here's notifier. It's intended to be *incoming* hook and looks if
files in certain directories were modifiled by anyone except certain
person. And sends message via ssmtp.

.. code-block:: shell

    #!/bin/sh

    notify() {
        cp -f /var/hg/ntf.templ /tmp
        echo "See https://<HG-SERVER>/<REPO>/rev/${HG_NODE}" >> /tmp/ntf.templ
        hg log -r ${HG_NODE} -p >> /tmp/ntf.templ
        sendmail recipient@mail.domain < "/tmp/ntf.templ"
    }

    hg log -r ${HG_NODE} --template "{author}" | grep -q '<AUTHOR-TO-BE-IGNORED>' && exit 0
    hg log -r ${HG_NODE} --template "{files}" | grep -E -q '<FILE-REGEX>' && notify


Regex example (looks for files in ``$(hg root)/modules/`` and
``$(hg root)/lib/modules/``):

.. code-block::

    (^| )(lib/)?modules

Sample ``/var/hg/ntf.templ``:

.. code-block::

    To: recipient@mail.domain
    From: notifier@mail.domain
    Subject: Achtung Minen!

    <Notification message body>
