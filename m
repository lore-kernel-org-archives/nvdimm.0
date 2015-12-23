Return-Path: <linux-ext4-owner@vger.kernel.org>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: A blocksize problem about dax and ext4
Date: Wed, 23 Dec 2015 21:18:05 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BEC985F@G9W0745.americas.hpqcorp.net>
References: <CAM=YXF-aXxp19=uFDExUswpEfKXNN6LJScxAB-7-u-AgRiXJ2g@mail.gmail.com>
 <CAPcyv4gYHuSWuugnELSO6B1rye+b89io3zJVUXwRt0wE1ZfPrA@mail.gmail.com>
In-Reply-To: <CAPcyv4gYHuSWuugnELSO6B1rye+b89io3zJVUXwRt0wE1ZfPrA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Cholerae Hu <choleraehyq@gmail.com>, Ted Tso <tytso@mit.edu>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "david@fromorbit.com" <david@fromorbit.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>


> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Dan Williams
> Sent: Wednesday, December 23, 2015 11:16 AM
> To: Cholerae Hu <choleraehyq@gmail.com>
> Cc: linux-nvdimm@lists.01.org
> Subject: Re: A blocksize problem about dax and ext4
> 
> On Wed, Dec 23, 2015 at 4:03 AM, Cholerae Hu <choleraehyq@gmail.com>
> wrote:
...
> > [root@localhost cholerae]# mount -o dax /dev/pmem0 /mnt/mem
> > mount: wrong fs type, bad option, bad superblock on /dev/pmem0,
> >        missing codepage or helper program, or other error
> >
> >        In some cases useful info is found in syslog - try
> >        dmesg | tail or so.
> > [root@localhost cholerae]# dmesg | tail
...
> > [   81.779582] EXT4-fs (pmem0): error: unsupported blocksize for dax
...

> What's the fs block size?  For example:
> # dumpe2fs -h /dev/pmem0  | grep "Block size"
> dumpe2fs 1.42.9 (28-Dec-2013)
> Block size:               4096
> Depending on the size of /dev/pmem0 it may have automatically set it
> to a block size less than 4 KiB which is incompatible with "-o dax".

I noticed a few things while trying that out on both ext4 and xfs.

$ sudo mkfs.ext4 -F -b 1024 /dev/pmem0
$ sudo mount -o dax /dev/pmem0 /mnt/ext4-pmem0
$ sudo mkfs.xfs -f -b size=1024 /dev/pmem0
$ sudo mount -o dax /dev/pmem0 /mnt/xfs-pmem0

[  199.679195] EXT4-fs (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
[  199.724931] EXT4-fs (pmem0): error: unsupported block size 1024 for dax 
[  859.077766] XFS (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
[  859.118106] XFS (pmem0): Filesystem block size invalid for DAX Turning DAX off.
[  859.156950] XFS (pmem0): Mounting V4 Filesystem
[  859.183626] XFS (pmem0): Ending clean mount


1. ext4 fails to mount the filesystem, while xfs just disables DAX.
It seems like they should they be the same.

2. if CONFIG_FS_DAX is not supported, ext4 fails to mount, but prints
the message at the KERN_INFO level. All the rest of its mount errors
use KERN_ERR.

Completely unknown mount options are reported like this at the
KERN_ERR level:
[ 2188.194775] EXT4-fs (pmem0): Unrecognized mount option "xyzzy" or missing value

In contrast, if CONFIG_FS_DAX is not supported, then xfs lumps it in
with the rest of the unknown mount options, which are reported with 
xfs_warn():
[ 2347.654182] XFS (pmem0): unknown mount option [xyzzy].


3. It might be worth printing the problematic filesystem block size
 (here and in a few other similar messages).  

I like how xfs' wording of "Filesystem block size" helps distinguish
the value from the block device's logical block size.


Code excerpts
=============
fs/xfs/xfs_super.c:
#ifdef CONFIG_FS_DAX
                } else if (!strcmp(this_char, MNTOPT_DAX)) {
                        mp->m_flags |= XFS_MOUNT_DAX;
#endif
...
        if (mp->m_flags & XFS_MOUNT_DAX) {
                xfs_warn(mp,
        "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
                if (sb->s_blocksize != PAGE_SIZE) {
                        xfs_alert(mp,
                "Filesystem block size invalid for DAX Turning DAX off.");
                        mp->m_flags &= ~XFS_MOUNT_DAX;
                } else if (!sb->s_bdev->bd_disk->fops->direct_access) {
                        xfs_alert(mp,
                "Block device does not support DAX Turning DAX off.");
                        mp->m_flags &= ~XFS_MOUNT_DAX;
                }
        }

fs/ext4/super.c:
        } else if (token == Opt_dax) {
#ifdef CONFIG_FS_DAX
                ext4_msg(sb, KERN_WARNING,
                "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
                        sbi->s_mount_opt |= m->mount_opt;
#else
                ext4_msg(sb, KERN_INFO, "dax option not supported");
                return -1;
#endif

---
Robert Elliott, HPE Persistent Memory


