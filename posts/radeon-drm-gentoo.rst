.. title: Gentoo: DRM, Radeon/RadeonHD, ATI R6xx/R7xx
.. slug: radeon-drm-gentoo
.. date: 2009-03-28 15:03:39
.. tags: linux

Here's brief summary of one hour on
`**#radeon** <http://dri.freedesktop.org/wiki/ATIRadeon>`__ IRC channel:

-  old DRM modules don't create */dev/dri/\** for ATI R6xx/R7xx-cards,
   that's normal;
-  kernel (up to, but not incl. 2.6.30) DRM aren't that old, but neither
   aren't new enough to support the cards in question;
-  moreover, DRM mainline lacks their support too: therefore
   `x11-base/x11-drm <http://gentoo-portage.com/x11-base/x11-drm>`__
   doesn't suit;
-  in order to build DRM modules for R6xx/R7xx, one should git-clone
   source from specific git branch (see `Xorg
   Wiki <http://wiki.x.org/wiki/radeon:r6xx_r7xx_branch>`__)
-  use `ebuild from x11
   overlay <http://git.overlays.gentoo.org/gitweb/?p=proj/x11.git;a=tree;f=x11-base/x11-drm;h=ff0cf2072e97cae3a01ebba8e78b6cf902663bad;hb=HEAD>`__
   with *DRM\_LIVE\_BRANCH="r6xx-r7xx-support"* added to your
   */etc/make.conf*

--------------

**Added later:** described technique has no use, if you're running
kernel 2.6.30 and later. Just compile DRM-modules and have fun.
