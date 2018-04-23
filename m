Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22a.google.com (mail-it0-x22a.google.com
 [IPv6:2607:f8b0:4001:c0b::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DAC0C2279CF13
 for <linux-nvdimm@lists.01.org>; Mon, 23 Apr 2018 08:55:26 -0700 (PDT)
Received: by mail-it0-x22a.google.com with SMTP id f6-v6so11611878ita.2
 for <linux-nvdimm@lists.01.org>; Mon, 23 Apr 2018 08:55:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180423061201.GC26268@magnolia>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
 <1520705944-6723-7-git-send-email-jix024@eng.ucsd.edu>
 <20180423061201.GC26268@magnolia>
From: Andiry Xu <jix024@eng.ucsd.edu>
Date: Mon, 23 Apr 2018 08:55:24 -0700
Message-ID: <CAD4SzjvGVNz1D3iWjrY7+=x7-5np_bzbe3YmRGz1KSXQ2Uisng@mail.gmail.com>
Subject: Re: [RFC v2 06/83] Add inode get/read methods.
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Tom Coughlan <coughlan@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Andiry Xu <jix024@cs.ucsd.edu>, miklos@szeredi.hu, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Steven Swanson <swanson@cs.ucsd.edu>, Steven Whitehouse <swhiteho@redhat.com>, Jian Xu <andiry.xu@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Apr 22, 2018 at 11:12 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> [haaa, I finally found time to read more of these]
>
> On Sat, Mar 10, 2018 at 10:17:47AM -0800, Andiry Xu wrote:
>> From: Andiry Xu <jix024@cs.ucsd.edu>
>>
>> These routines are incomplete and currently only support reserved inodes,
>> whose addresses are fixed. This is necessary for fill_super to work.
>> File/dir operations are left NULL.
>>
>> Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
>> ---
>>  fs/nova/inode.c | 176 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/nova/inode.h |   3 +
>>  2 files changed, 179 insertions(+)
>>  create mode 100644 fs/nova/inode.c
>>
>> diff --git a/fs/nova/inode.c b/fs/nova/inode.c
>> new file mode 100644
>> index 0000000..bfdc5dc
>> --- /dev/null
>> +++ b/fs/nova/inode.c
>> @@ -0,0 +1,176 @@
>> +/*
>> + * BRIEF DESCRIPTION
>> + *
>> + * Inode methods (allocate/free/read/write).
>> + *
>> + * Copyright 2015-2016 Regents of the University of California,
>> + * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
>> + * Copyright 2012-2013 Intel Corporation
>> + * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
>> + * Copyright 2003 Sony Corporation
>> + * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
>> + * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2. This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#include <linux/fs.h>
>> +#include <linux/aio.h>
>> +#include <linux/highuid.h>
>> +#include <linux/module.h>
>> +#include <linux/mpage.h>
>> +#include <linux/backing-dev.h>
>> +#include <linux/types.h>
>> +#include <linux/ratelimit.h>
>> +#include "nova.h"
>> +#include "inode.h"
>> +
>> +unsigned int blk_type_to_shift[NOVA_BLOCK_TYPE_MAX] = {12, 21, 30};
>> +uint32_t blk_type_to_size[NOVA_BLOCK_TYPE_MAX] = {0x1000, 0x200000, 0x40000000};
>> +
>> +void nova_set_inode_flags(struct inode *inode, struct nova_inode *pi,
>> +     unsigned int flags)
>> +{
>> +     inode->i_flags &=
>> +             ~(S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC);
>> +     if (flags & FS_SYNC_FL)
>> +             inode->i_flags |= S_SYNC;
>> +     if (flags & FS_APPEND_FL)
>> +             inode->i_flags |= S_APPEND;
>> +     if (flags & FS_IMMUTABLE_FL)
>> +             inode->i_flags |= S_IMMUTABLE;
>> +     if (flags & FS_NOATIME_FL)
>> +             inode->i_flags |= S_NOATIME;
>> +     if (flags & FS_DIRSYNC_FL)
>> +             inode->i_flags |= S_DIRSYNC;
>> +     if (!pi->i_xattr)
>> +             inode_has_no_xattr(inode);
>> +     inode->i_flags |= S_DAX;
>> +}
>> +
>> +/* copy persistent state to struct inode */
>> +static int nova_read_inode(struct super_block *sb, struct inode *inode,
>> +     u64 pi_addr)
>> +{
>> +     struct nova_inode_info *si = NOVA_I(inode);
>> +     struct nova_inode *pi, fake_pi;
>> +     struct nova_inode_info_header *sih = &si->header;
>> +     int ret = -EIO;
>> +     unsigned long ino;
>> +
>> +     ret = nova_get_reference(sb, pi_addr, &fake_pi,
>> +                     (void **)&pi, sizeof(struct nova_inode));
>> +     if (ret) {
>> +             nova_dbg("%s: read pi @ 0x%llx failed\n",
>> +                             __func__, pi_addr);
>> +             goto bad_inode;
>> +     }
>> +
>> +     inode->i_mode = sih->i_mode;
>
> Hm, do you validate the on-pmem metadata as it's read in?  What if
> i_mode is garbage?
>

I have checksum for inode and all metadata structures in the
NOVA-fortis code. I removed them in this patchset to make the code
shorter and simpler.

>> +     i_uid_write(inode, le32_to_cpu(pi->i_uid));
>> +     i_gid_write(inode, le32_to_cpu(pi->i_gid));
>> +//   set_nlink(inode, le16_to_cpu(pi->i_links_count));
>
> C++ comment?
>

Will fix.

>> +     inode->i_generation = le32_to_cpu(pi->i_generation);
>> +     nova_set_inode_flags(inode, pi, le32_to_cpu(pi->i_flags));
>> +     ino = inode->i_ino;
>> +
>> +     /* check if the inode is active. */
>> +     if (inode->i_mode == 0 || pi->deleted == 1) {
>> +             /* this inode is deleted */
>> +             ret = -ESTALE;
>> +             goto bad_inode;
>> +     }
>> +
>> +     inode->i_blocks = sih->i_blocks;
>
> Not le64_to_cpu(sih->i_blocks)?  Or is that somewhere else I'm
> missing...
>

sih is the in-DRAM inode structure, so le64_to_cpu is not needed. When
we read inode from pmem (nova_inode *pi) to sih, we need
le64_to_cpu(). The endian checking is not performed thoroughly as it
only supports x86-64 now.

>> +
>> +     switch (inode->i_mode & S_IFMT) {
>> +     case S_IFREG:
>> +             break;
>> +     case S_IFDIR:
>> +             break;
>> +     case S_IFLNK:
>> +             break;
>> +     default:
>> +             init_special_inode(inode, inode->i_mode,
>> +                                le32_to_cpu(pi->dev.rdev));
>> +             break;
>> +     }
>> +
>> +     /* Update size and time after rebuild the tree */
>> +     inode->i_size = le64_to_cpu(sih->i_size);
>
> FWIW the type of i_size is loff_t, which is an unsigned type.  Despite
> this, the VFS does not support files with negative sizes... which means
> that this probably ought to check for that.
>

I will think about that. Thanks.

Thanks,
Andiry

> --D
>
>> +     inode->i_atime.tv_sec = (__s32)le32_to_cpu(pi->i_atime);
>> +     inode->i_ctime.tv_sec = (__s32)le32_to_cpu(pi->i_ctime);
>> +     inode->i_mtime.tv_sec = (__s32)le32_to_cpu(pi->i_mtime);
>> +     inode->i_atime.tv_nsec = inode->i_mtime.tv_nsec =
>> +                                      inode->i_ctime.tv_nsec = 0;
>> +     set_nlink(inode, le16_to_cpu(pi->i_links_count));
>> +     return 0;
>> +
>> +bad_inode:
>> +     make_bad_inode(inode);
>> +     return ret;
>> +}
>> +
>> +/* Get the address in PMEM of an inode by inode number.  Allocate additional
>> + * block to store additional inodes if necessary.
>> + */
>> +int nova_get_inode_address(struct super_block *sb, u64 ino,
>> +     u64 *pi_addr, int extendable)
>> +{
>> +     if (ino < NOVA_NORMAL_INODE_START) {
>> +             *pi_addr = nova_get_reserved_inode_addr(sb, ino);
>> +             return 0;
>> +     }
>> +
>> +     *pi_addr = 0;
>> +     return 0;
>> +}
>> +
>> +struct inode *nova_iget(struct super_block *sb, unsigned long ino)
>> +{
>> +     struct nova_inode_info *si;
>> +     struct inode *inode;
>> +     u64 pi_addr;
>> +     int err;
>> +
>> +     inode = iget_locked(sb, ino);
>> +     if (unlikely(!inode))
>> +             return ERR_PTR(-ENOMEM);
>> +     if (!(inode->i_state & I_NEW))
>> +             return inode;
>> +
>> +     si = NOVA_I(inode);
>> +
>> +     nova_dbgv("%s: inode %lu\n", __func__, ino);
>> +
>> +     err = nova_get_inode_address(sb, ino, &pi_addr, 0);
>> +     if (err) {
>> +             nova_dbg("%s: get inode %lu address failed %d\n",
>> +                      __func__, ino, err);
>> +             goto fail;
>> +     }
>> +
>> +     if (pi_addr == 0) {
>> +             nova_dbg("%s: failed to get pi_addr for inode %lu\n",
>> +                      __func__, ino);
>> +             err = -EACCES;
>> +             goto fail;
>> +     }
>> +
>> +     err = nova_read_inode(sb, inode, pi_addr);
>> +     if (unlikely(err)) {
>> +             nova_dbg("%s: failed to read inode %lu\n", __func__, ino);
>> +             goto fail;
>> +
>> +     }
>> +
>> +     inode->i_ino = ino;
>> +
>> +     unlock_new_inode(inode);
>> +     return inode;
>> +fail:
>> +     iget_failed(inode);
>> +     return ERR_PTR(err);
>> +}
>> +
>> diff --git a/fs/nova/inode.h b/fs/nova/inode.h
>> index f9187e3..dbd5256 100644
>> --- a/fs/nova/inode.h
>> +++ b/fs/nova/inode.h
>> @@ -184,4 +184,7 @@ static inline int nova_persist_inode(struct nova_inode *pi)
>>       return 0;
>>  }
>>
>> +int nova_get_inode_address(struct super_block *sb, u64 ino,
>> +     u64 *pi_addr, int extendable);
>> +struct inode *nova_iget(struct super_block *sb, unsigned long ino);
>>  #endif
>> --
>> 2.7.4
>>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
