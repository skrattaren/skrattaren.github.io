.. title: Django: ограничение выборки в формах админки
.. slug: django-querysets
.. date: 2008-11-27 01:11:27
.. tags: python,django,programmierung

Допустим, у Вас в приложении Django есть две модели, **Object** и
**SuperObject**, связанных через **ManyToMany**. И когда Вы добавляете
или изменяете **SuperObject**, Вы видите в форме список из всех
**Object**'ов. А вы их хотите ограничить, причём динамически — скажем,
по правам доступа для текущего пользователя. Добиться этого можно,
например, так.


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


Что мы тут делаем:

-  функция **make_metaform** принимает в качестве аргумента объект типа
   **User** и возвращает подкласс **forms.Form** (фабрика классов)
-  функция создаёт обычный класс **forms.ModelForm** для модели
   **SuperObject**
-  после чего мы перегружаем стандартный (для отношения **ManyToMany**)
   атрибут **objects_list** таким же полем
   **forms.ModelMultipleChoiceField**, но с другим *queryset*
-  в этом примере **Object**'ы фильтруются по разрешениям, хранящимся в
   другой таблице-модели — **ObjectMod**
-  создаём подкласс **ModelAdmin** для управления **SuperObject**'ами в
   админке
-  как только новый экземпляр **MetaAdmin** создаётся («вызывается», то
   есть вызывается стандартный метод **__call__**), функция
   **metaform** создаёт новую форму, которая присваивается стадартному
   атрибуту **ModelAdmin** — **form**
-  после чего вызывается соответствующий метод класса **ModelAdmin**

