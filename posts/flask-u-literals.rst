If you had tried to use `Flask <http://flask.pocoo.org/>`__ sessions
and got something like that:

::

      File "/usr/lib64/python2.7/site-packages/flask/app.py", line 889, in __call__
        return self.wsgi_app(environ, start_response)
      File "/usr/lib64/python2.7/site-packages/flask/app.py", line 871, in wsgi_app
        with self.request_context(environ):
      File "/usr/lib64/python2.7/site-packages/flask/app.py", line 836, in request_context
        return _RequestContext(self, environ)
      File "/usr/lib64/python2.7/site-packages/flask/ctx.py", line 33, in __init__
        self.session = app.open_session(self.request)
      File "/usr/lib64/python2.7/site-packages/flask/app.py", line 431, in open_session
        secret_key=key)
      File "/usr/lib64/python2.7/site-packages/werkzeug/contrib/securecookie.py", line 308, in load_cookie
        return cls.unserialize(data, secret_key)
      File "/usr/lib64/python2.7/site-packages/werkzeug/contrib/securecookie.py", line 255, in unserialize
        mac = hmac(secret_key, None, cls.hash_method)
      File "/usr/lib64/python2.7/hmac.py", line 133, in new
        return HMAC(key, msg, digestmod)
      File "/usr/lib64/python2.7/hmac.py", line 72, in __init__
        self.outer.update(key.translate(trans_5C))


...you might be obscured. Fear not! The reason may lurk in

::

    from __future__ import unicode_literals


Just declare your SECRET\_KEY as \`bytes\` object and get happy again!

::

    SECRET_KEY = b'smthverrysekret'

