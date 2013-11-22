Допустим, у Вас в приложении Django есть две модели, **Object** и
**SuperObject**, связанных через **ManyToMany**. И когда Вы добавляете
или изменяете **SuperObject**, Вы видите в форме список из всех
**Object**\ ов. А вы их хотите ограничить, причём динамически — скажем,
по правам доступа для текущего пользователя. Добиться этого можно,
например, так.

Let's suppose you have two related types of objects in your Django app.
Call them **Object** and **SuperObject**, related *ManyToMany*'ly. And
when you add/change **SuperObject** in Django admin, there's all
**Object**\ s available for selection. But you need to limit the
choices, and limit dynamically (perhaps, depending on current user).
Here's quite straightforward but working technique.

...

::

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

`**Pygmented** <http://pygments.org/>`__

Что мы тут делаем:

-  функция **make\_metaform** принимает в качестве аргумента объект типа
   **User** и возвращает подкласс **forms.Form** (фабрика классов)
-  функция создаёт обычный класс **forms.ModelForm** для модели
   **SuperObject**
-  после чего мы перегружаем стандартный (для отношения **ManyToMany**)
   атрибут **objects\_list** таким же полем
   **forms.ModelMultipleChoiceField**, но с другим *queryset*
-  в этом примере **Object**\ ы фильтруются по разрешениям, хранящимся в
   другой таблице-модели — **ObjectMod**
-  создаём подкласс **ModelAdmin** для управления **SuperObject**\ ами в
   админке
-  как только новый экземпляр **MetaAdmin** создаётся («вызывается», то
   есть вызывается стандартный метод **\_\_call\_\_**), функция
   **metaform** создаёт новую форму, которая присваивается стадартному
   атрибуту **ModelAdmin** — **form**
-  после чего вызывается соответствующий метод класса **ModelAdmin**

What do we do here:

-  function **make\_metaform** takes **User** object and returns
   **forms.Form** subclass (class factory)
-  this function creates common **forms.ModelForm** for **SuperObject**
-  then it overrides standard (for **ManyToMany** relationship)
   **objects\_list** attribute with the same
   **forms.ModelMultipleChoiceField**, but having other *queryset*
   parameter
-  in our example we filter **Object**\ s by permissions, stored in
   other table/model — **ObjectMod**
-  we should use modified subclass **ModelAdmin** for managing
   **SuperObject**\ s in admin
-  as new **MetaAdmin** is created (**\_\_call\_\_**\ ed), we call
   **metaform** function and assign its result to standard
   **ModelAdmin** attribute **form**
-  then we call standard **ModelAdmin** class method

