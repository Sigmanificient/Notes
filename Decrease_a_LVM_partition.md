# Decreate a LVM partition

If you are trying the shrink a volume that contains a root file system (`/`), you will need to proceed within a Live user.

In this case, you may run the following commands to load the lvm partitions:

```
vgscan
vgchange -ay
```

Otherwise, just unmount the partition with the `umount` command.

Check the file system to get started:
```
e2fsck -fy /dev/[volume]/[lvm_partition]
```

This command will ouput the available space that can be shrinked without losing any data.

Resize the file system before resizing the lvm partition:

```
resize2fs /dev/[volume]/[lvm_partition] [fixed_size]
```

Then, you must resize the volume to the newer file system size

```
lvreduce --size [fixed_size]G /dev/[volume_group]/[lvm_partition]
```