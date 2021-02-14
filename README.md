# rpinit

```
==> Available disks
/dev/disk0 (internal):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                         251.0 GB   disk0
   1:             Apple_APFS_ISC ⁨⁩                        524.3 MB   disk0s1
   2:                 Apple_APFS ⁨Container disk3⁩         245.1 GB   disk0s2
   3:        Apple_APFS_Recovery ⁨⁩                        5.4 GB     disk0s3

/dev/disk3 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +245.1 GB   disk3
                                 Physical Store disk0s2
   1:                APFS Volume ⁨Macintosh HD⁩            15.1 GB    disk3s1
   2:              APFS Snapshot ⁨com.apple.os.update-...⁩ 15.1 GB    disk3s1s1
   3:                APFS Volume ⁨Preboot⁩                 346.8 MB   disk3s2
   4:                APFS Volume ⁨Recovery⁩                1.1 GB     disk3s3
   5:                APFS Volume ⁨Data⁩                    61.7 GB    disk3s5
   6:                APFS Volume ⁨VM⁩                      2.1 GB     disk3s6

/dev/disk4 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *15.9 GB    disk4
   1:             Windows_FAT_32 ⁨boot⁩                    268.4 MB   disk4s1
   2:                      Linux ⁨⁩                        1.6 GB     disk4s2
                    (free space)                         14.1 GB    -

==> Guessing the SD card is /dev/disk4
==> Enter disk number: 4
==> Skipping download; os.zip already exists
==> Verifying integrity
==> Decompressing OS
==> Unmounting /dev/disk4
Unmount of all volumes on disk4 was successful
==> Copying os.img to /dev/rdisk4
1776+0 records in
1776+0 records out
1862270976 bytes transferred in 165.248902 secs (11269491 bytes/sec)
==> Waiting for data to be flushed
==> Setting up Wi-Fi
==> Setting up SSH
==> Ejecting disk
Disk /dev/rdisk4 ejected
==> Done
```
