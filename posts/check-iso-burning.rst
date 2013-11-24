.. title: How to check if your ISO-image has been burnt properly
.. slug: check-iso-burning
.. date: 2009-02-08 13:02:17
.. tags: linux,eng

If you has burnt some .iso-image with known md5-checksum, you can
verify if disk is valid and was burnt properly

::

    dd if=<your-CD/DVD-ROM-device> | md5sum


Example:

::

    # dd if=/dev/hdc | md5sum && md5sum /mnt/win_e:/software/linux/systemrescuecd-x86-1.0.4.iso
    68f9c2d885d95c82bfe6c7df736ae0a3  -
       <dd output skipped>
    68f9c2d885d95c82bfe6c7df736ae0a3  /mnt/win_e:/software/linux/systemrescuecd-x86-1.0.4.iso


As you can see, md5sums are the same, so disk is valid.
If someone knows how it could be done under MS Windows, please comment
here.
