Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x231.google.com (mail-ua0-x231.google.com
 [IPv6:2607:f8b0:400c:c08::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D8E3C21D2DD17
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 13:33:49 -0700 (PDT)
Received: by mail-ua0-x231.google.com with SMTP id k43so11892591uaf.3
 for <linux-nvdimm@lists.01.org>; Fri, 04 Aug 2017 13:36:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804200446.GD24087@magnolia>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150181370272.32119.9941879917087053701.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170804200446.GD24087@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 4 Aug 2017 13:36:01 -0700
Message-ID: <CAPcyv4jTfchiWLB6zMrdKYTiymjJyzuxBGhh8TRKAbY8rsXWnA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] fs, xfs: introduce FALLOC_FL_UNSEAL_BLOCK_MAP
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

On Fri, Aug 4, 2017 at 1:04 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Thu, Aug 03, 2017 at 07:28:23PM -0700, Dan Williams wrote:
>> Provide an explicit fallocate operation type for clearing the
>> S_IOMAP_IMMUTABLE flag. Like the enable case it requires CAP_IMMUTABLE
>> and it can only be performed while no process has the file mapped.
>>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
>> Suggested-by: Dave Chinner <david@fromorbit.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  fs/open.c                   |   17 +++++++++++------
>>  fs/xfs/xfs_bmap_util.c      |   42 ++++++++++++++++++++++++++++++++++++++++++
>>  fs/xfs/xfs_bmap_util.h      |    3 +++
>>  fs/xfs/xfs_file.c           |    4 +++-
>>  include/linux/falloc.h      |    3 ++-
>>  include/uapi/linux/falloc.h |    1 +
>>  6 files changed, 62 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/open.c b/fs/open.c
>> index e3aae59785ae..ccfd8d3becc8 100644
>> --- a/fs/open.c
>> +++ b/fs/open.c
>> @@ -274,13 +274,17 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>>               return -EINVAL;
>>
>>       /*
>> -      * Seal block map operation should only be used exclusively, and
>> -      * with the IMMUTABLE capability.
>> +      * Seal/unseal block map operations should only be used
>> +      * exclusively, and with the IMMUTABLE capability.
>>        */
>> -     if (mode & FALLOC_FL_SEAL_BLOCK_MAP) {
>> +     if (mode & (FALLOC_FL_SEAL_BLOCK_MAP | FALLOC_FL_UNSEAL_BLOCK_MAP)) {
>>               if (!capable(CAP_LINUX_IMMUTABLE))
>>                       return -EPERM;
>> -             if (mode & ~FALLOC_FL_SEAL_BLOCK_MAP)
>> +             if (mode == (FALLOC_FL_SEAL_BLOCK_MAP
>> +                                     | FALLOC_FL_UNSEAL_BLOCK_MAP))
>> +                     return -EINVAL;
>> +             if (mode & ~(FALLOC_FL_SEAL_BLOCK_MAP
>> +                                     | FALLOC_FL_UNSEAL_BLOCK_MAP))
>>                       return -EINVAL;
>>       }
>>
>> @@ -303,9 +307,10 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>>               return -ETXTBSY;
>>
>>       /*
>> -      * We cannot allow any allocation changes on an iomap immutable file
>> +      * We cannot allow any allocation changes on an iomap immutable
>> +      * file, but we can allow clearing the immutable state.
>>        */
>> -     if (IS_IOMAP_IMMUTABLE(inode))
>> +     if (IS_IOMAP_IMMUTABLE(inode) && !(mode & FALLOC_FL_UNSEAL_BLOCK_MAP))
>>               return -ETXTBSY;
>>
>>       /*
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index 46d8eb9e19fc..70ac2d33ab27 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -1494,6 +1494,48 @@ xfs_seal_file_space(
>>       return error;
>>  }
>>
>> +int
>> +xfs_unseal_file_space(
>> +     struct xfs_inode        *ip,
>> +     xfs_off_t               offset,
>> +     xfs_off_t               len)
>> +{
>> +     struct inode            *inode = VFS_I(ip);
>> +     struct address_space    *mapping = inode->i_mapping;
>> +     int                     error;
>> +
>> +     ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
>
> Same assert-on-the-iolock comment as the previous patch.

Ok.

>
>> +
>> +     if (offset)
>> +             return -EINVAL;
>> +
>> +     xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +     /*
>> +      * It does not make sense to unseal less than the full range of
>> +      * the file.
>> +      */
>> +     error = -EINVAL;
>> +     if (len < i_size_read(inode))
>> +             goto out_unlock;
>
> Hmm, should we be picky and require len == i_size_read() here?

Yes, I think so, otherwise we may have raced someone who increased the
file size with unwritten extents.

>
>> +     /*
>> +      * Provide safety against one thread changing the policy of not
>> +      * requiring fsync/msync (for block allocations) behind another
>> +      * thread's back.
>> +      */
>> +     error = -EBUSY;
>> +     if (mapping_mapped(mapping))
>> +             goto out_unlock;
>> +
>> +     inode->i_flags &= ~S_IOMAP_IMMUTABLE;
>
> It occurred to me, should we jump out early from the seal/unseal
> operations if the flag state matches whatever the user is asking for?
> This is perhaps not necessary for unseal since we don't do a lot of
> work.
>

Yes, I think I had that semantic in v1, but lost in the cleanups. Will
bring it back.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
