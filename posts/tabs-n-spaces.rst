That's quite old and well-known, of course, but I now have to deal
with code like that (count the spaces!):

::

    class c_integral_type(c_type):
        def __init__(self, name, format, min, max):
           c_type.__init__(self, name, struct.calcsize(format))


or like that (MyOpera replaces tabs, so believe my comments):

::

        def genMemList( self, members ):              # indented with 4 spaces
    #        self.append( '\tdef members(self):\n' )  # indented with one <Tab>


So…
|image0|

--------------


Oh **noes**! That's what I had to deal with:

::

      % pylint buratino
       .......
    Your code has been rated at -1.79/10


My code isn't perfect, I'd be first to agree, but it scores 7/10, and
it's positive 7, mind you!
Bloody hell. So, back to work then

.. |image0| image:: http://www.emacswiki.org/pics/static/TabsSpacesBoth.png
