# Increase a LVM partition

To check the partition sizes you can use the `lsblk` command.
The `vgdisplay` command allow to see free space that hasnt been allocated on any partition.


First, extend your partition using `lvextend`

```sh
lvextend -L +[size_to_add]G /dev/[volume_group]/[lvm_partition]
```

The second step is to check the file system. This command must be run before resizing it.

```sh
e2fsck -fy /dev/[volume_group]/[lvm_partition]
```

Finally, resize the file system to expand it to the same size as the LVM partition.

```sh
resize2fs /dev/[volume_group]/[lvm_partition]
```

If the file system is larger than the lvm partition, trying to mount the partition will result in a bad fstype error.
