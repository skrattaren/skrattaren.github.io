.. title: Gentoo: DRM, Radeon/RadeonHD, ATI R6xx/R7xx
.. slug: radeon-drm-gentoo
.. date: 2009-03-28 15:03:39
.. tags: linux

Результат часового разбирательства на канале
`**#radeon** <http://dri.freedesktop.org/wiki/ATIRadeon>`__:

-  старые версии drm не создают */dev/dri/\** для карт на базе
   R6xx/R7xx, это норма;
-  версии ядрёного DRM (в ядрах до 2.6.30) не столь стары, как говорят,
   но всё равно недостаточно новы для этих карт;
-  более того, поддержки этих карт в основной ветке DRM пока тоже нет,
   таким образом,
   `x11-base/x11-drm <http://gentoo-portage.com/x11-base/x11-drm>`__ для
   них тоже не годится (похоже);
-  для сборки модулей, поддерживающих эти карты, нужно тянуть исходники
   из отдельной ветки git (см. `Xorg
   Wiki <http://wiki.x.org/wiki/radeon:r6xx_r7xx_branch>`__)
-  для этого есть `ebuild из оверлея
   x11 <http://git.overlays.gentoo.org/gitweb/?p=proj/x11.git;a=tree;f=x11-base/x11-drm;h=ff0cf2072e97cae3a01ebba8e78b6cf902663bad;hb=HEAD>`__,
   только не забудьте добавить *DRM\_LIVE\_BRANCH="r6xx-r7xx-support"* к
   своему */etc/make.conf*

--------------

**Позднейшая добавка:** при использовании ядра 2.6.30 и выше эти
манипуляции не нужны, просто включите соответствующие DRM-модули.

