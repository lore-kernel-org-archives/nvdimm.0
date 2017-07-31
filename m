Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x232.google.com (mail-vk0-x232.google.com
 [IPv6:2607:f8b0:400c:c05::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D17C821D0918F
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 11:23:27 -0700 (PDT)
Received: by mail-vk0-x232.google.com with SMTP id d124so19343586vkf.2
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 11:25:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170731170939.GC4477@magnolia>
References: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150135742076.35318.12884268722541769179.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170731170939.GC4477@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 31 Jul 2017 11:25:34 -0700
Message-ID: <CAPcyv4hPr8b3UsshQ086hi7_KrE3-y0uGTpdi1eXc5R59mYmUw@mail.gmail.com>
Subject: Re: [PATCH 2/3] fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 31, 2017 at 10:09 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Sat, Jul 29, 2017 at 12:43:40PM -0700, Dan Williams wrote:
>> >From falloc.h:
>>
>>     FALLOC_FL_SEAL_BLOCK_MAP is used to seal (make immutable) all of the
>>     file logical-to-physical extent offset mappings in the file. The
>>     purpose is to allow an application to assume that there are no holes
>>     or shared extents in the file and that the metadata needed to find
>>     all the physical extents of the file is stable and can never be
>>     dirtied.
>>
>> For now this patch only permits setting / clearing the in-memory state
>> of S_IOMAP_IMMMUTABLE, persisting the state is saved for a later patch.
>>
>> The implementation is careful to not allow the immutable state to change
>> while any process might have any established mappings. It reuses the
>> existing xfs_reflink_unshare() and xfs_alloc_file_space() to unshare
>> extents and fill all holes in the file, or otherwise extend the file
>> size in the same operation that sets S_IOMAP_IMMUTABLE.
>>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Suggested-by: Dave Chinner <david@fromorbit.com>
>> Suggested-by: "Darrick J. Wong" <darrick.wong@oracle.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  fs/open.c                   |   26 ++++++++++++-
>>  fs/xfs/xfs_bmap_util.c      |   86 +++++++++++++++++++++++++++++++++++++++++++
>>  fs/xfs/xfs_bmap_util.h      |    2 +
>>  fs/xfs/xfs_file.c           |   14 +++++--
>>  include/linux/falloc.h      |    3 +-
>>  include/uapi/linux/falloc.h |   19 ++++++++++
>>  6 files changed, 142 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/open.c b/fs/open.c
>> index 7395860d7164..df075484fad5 100644
>> --- a/fs/open.c
>> +++ b/fs/open.c
>> @@ -241,7 +241,11 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>>       struct inode *inode = file_inode(file);
>>       long ret;
>>
>> -     if (offset < 0 || len <= 0)
>> +     if (offset < 0 || len < 0)
>> +             return -EINVAL;
>> +
>> +     /* Allow zero len only for the unseal operation */
>> +     if (!(mode & FALLOC_FL_SEAL_BLOCK_MAP) && len == 0)
>>               return -EINVAL;
>>
>>       /* Return error if mode is not supported */
>> @@ -273,6 +277,17 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>>           (mode & ~(FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_KEEP_SIZE)))
>>               return -EINVAL;
>>
>> +     /*
>> +      * Seal block map should only be used exclusively, and with
>> +      * the IMMUTABLE capability.
>> +      */
>> +     if (mode & FALLOC_FL_SEAL_BLOCK_MAP) {
>> +             if (mode & ~FALLOC_FL_SEAL_BLOCK_MAP)
>> +                     return -EINVAL;
>> +             if (!capable(CAP_LINUX_IMMUTABLE))
>> +                     return -EPERM;
>> +     }
>> +
>>       if (!(file->f_mode & FMODE_WRITE))
>>               return -EBADF;
>>
>> @@ -292,9 +307,14 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>>               return -ETXTBSY;
>>
>>       /*
>> -      * We cannot allow any allocation changes on an iomap immutable file
>> +      * We cannot allow any allocation changes on an iomap immutable
>> +      * file, however if the operation is FALLOC_FL_SEAL_BLOCK_MAP,
>> +      * call down to ->fallocate() to determine if the operations is
>> +      * allowed. ->fallocate() may either clear the flag when @len is
>> +      * zero, or validate that the requested operation is already the
>> +      * current state of the file.
>>        */
>> -     if (IS_IOMAP_IMMUTABLE(inode))
>> +     if (IS_IOMAP_IMMUTABLE(inode) && (!(mode & FALLOC_FL_SEAL_BLOCK_MAP)))
>>               return -ETXTBSY;
>>
>>       /*
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index 93e955262d07..c4fc79a0704f 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -1387,6 +1387,92 @@ xfs_zero_file_space(
>>
>>  }
>>
>> +int
>> +xfs_seal_file_space(
>> +     struct xfs_inode        *ip,
>> +     xfs_off_t               offset,
>> +     xfs_off_t               len)
>> +{
>> +     struct inode            *inode = VFS_I(ip);
>> +     struct address_space    *mapping = inode->i_mapping;
>> +     int                     error = 0;
>> +
>> +     if (offset)
>> +             return -EINVAL;
>> +
>> +     i_mmap_lock_read(mapping);
>
> (Are we allowed to take address_space->i_mmap_rwsem while holding
> xfs_inode->i_mmaplock?)

Empirically, yes. Lockdep complains when those locks are taken in the
reverse order.

That seems to be inconsistent with the "mmap_sem -> i_mmap_lock ->
page_lock" note in the xfs_ilock comment. Am I confusing what
i_mmap_lock means in that comment, is that the i_mmap_lock_read(), or
the i_mmaplock in the xfs_inode?

>
>> +     xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +     if (len == 0) {
>> +             /*
>> +              * Clear the immutable flag provided there are no active
>> +              * mappings. The active mapping check prevents an
>> +              * application that is assuming a static block map, for
>> +              * DAX or peer-to-peer DMA, from having this state
>> +              * silently change behind its back.
>> +              */
>> +             if (RB_EMPTY_ROOT(&mapping->i_mmap))
>> +                     inode->i_flags &= ~S_IOMAP_IMMUTABLE;
>> +             else
>> +                     error = -EBUSY;
>> +     } else if (IS_IOMAP_IMMUTABLE(inode)) {
>> +             if (len == i_size_read(inode)) {
>> +                     /*
>> +                      * The file is already in the correct state,
>> +                      * bail out without error below.
>> +                      */
>> +                     len = 0;
>> +             } else {
>> +                     /* too late to allocate more space */
>> +                     error = -ETXTBSY;
>> +             }
>> +     } else {
>> +             if (len < i_size_read(inode)) {
>> +                     /*
>> +                      * Since S_IOMAP_IMMUTABLE is inode global it
>> +                      * does not make sense to fallocate(immutable)
>> +                      * on a sub-range of the file.
>> +                      */
>> +                     error = -EINVAL;
>> +             } else if (!RB_EMPTY_ROOT(&mapping->i_mmap)) {
>> +                     /*
>> +                      * It's not strictly required to prevent setting
>> +                      * immutable while a file is already mapped, but
>> +                      * we do it for simplicity and symmetry with the
>> +                      * S_IOMAP_IMMUTABLE disable case.
>> +                      */
>> +                     error = -EBUSY;
>> +             } else
>> +                     inode->i_flags |= S_IOMAP_IMMUTABLE;
>> +     }
>> +     xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +     i_mmap_unlock_read(mapping);
>> +
>> +     if (error || len == 0)
>> +             return error;
>> +
>> +     /*
>> +      * From here, the immutable flag is already set, so new
>> +      * operations that would change the block map are prevented by
>> +      * upper layer code paths. Wwe can proceed to unshare and
>> +      * allocate zeroed / written extents.
>> +      */
>> +     error = xfs_reflink_unshare(ip, offset, len);
>
> At this point we still hold the io and mmap locks and the vfs thinks the
> inode is iomap_immutable, but we haven't actually fixed the block
> mappings, which means that the flag is set but there could be holes and
> shared extents aplenty?
>
> That seems strange to me -- wouldn't we want to try to unshare and
> allocate, and only then take the ilock, check the mappings, and only set
> the flag if nobody's messed with the extent map since the unshare &
> allocated?  IOWs,
>
> if (len == 0)
>         return xfs_unseal_file_space();
>
> xfs_reflink_unshare(...);
> xfs_alloc_file_space(...);
>
> xfs_ilock(...);
> if (xfs_iomap_lacks_holes_and_shared_blocks(...)) {
>         VFS_I(ip)->i_flags |= S_IOMAP_IMMUTABLE;
>         ip->i_d.di_flags2 |= XFS_DIFLAG2_IOMAP_IMMUTABLE;
>         xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> } else {
>         error = -EBUSY;
> }
> xfs_iunlock(...);
>
> (I guess we hold sufficient locks, but still...)

Yes, that looks safer, especially if other vfs paths make assumptions
about the block map upon seeing that flag set.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
