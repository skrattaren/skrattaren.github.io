.. title: Django: limiting querysets in admin forms
.. slug: django-querysets
.. date: 2008-11-27 01:11:27
.. tags: python,django,programmierung

Let's suppose you have two related types of objects in your Django app.
Call them **Object** and **SuperObject**, related *ManyToMany*'ly. And
when you add/change **SuperObject** in Django admin, there's all
**Object**\s available for selection. But you need to limit the
choices, and limit dynamically (perhaps, depending on current user).
Here's quite straightforward but working technique.


.. TEASER_END

.. code-block:: python

    def make_metaform(user):
        class MetaForm(forms.ModelForm):
            class Meta:
                model = SuperObject
            objects_list = forms.ModelMultipleChoiceField(
                    queryset=Object.objects.filter(objectmod__user__id=user.id,
                                                     objectmod__can_read=True))
        return MetaForm


    class MetaAdmin(ZpixObject):
        def __call__(self, request, url):
            self.form = make_metaform(request.user)
            return ZpixObject.__call__(self, request, url)


What do we do here:

-  function **make_metaform** takes **User** object and returns
   **forms.Form** subclass (class factory)
-  this function creates common **forms.ModelForm** for **SuperObject**
-  then it overrides standard (for **ManyToMany** relationship)
   **objects_list** attribute with the same
   **forms.ModelMultipleChoiceField**, but having other *queryset*
   parameter
-  in our example we filter **Object**\s by permissions, stored in
   other table/model — **ObjectMod**
-  we should use modified subclass **ModelAdmin** for managing
   **SuperObject**\s in admin
-  as new **MetaAdmin** is created (**__call__**\ed), we call
   **metaform** function and assign its result to standard
   **ModelAdmin** attribute **form**
-  then we call standard **ModelAdmin** class method

