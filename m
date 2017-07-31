Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x22c.google.com (mail-vk0-x22c.google.com
 [IPv6:2607:f8b0:400c:c05::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6408821C91265
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 10:30:08 -0700 (PDT)
Received: by mail-vk0-x22c.google.com with SMTP id g189so14674554vke.5
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 10:32:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170731164625.GB4477@magnolia>
References: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150135741519.35318.16765137368329971936.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170731164625.GB4477@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 31 Jul 2017 10:32:15 -0700
Message-ID: <CAPcyv4in0cPR0xZUX8C4Oahu_OE2xNNuXWYQHyv=8nn3Scckcg@mail.gmail.com>
Subject: Re: [PATCH 1/3] fs, xfs: introduce S_IOMAP_IMMUTABLE
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

On Mon, Jul 31, 2017 at 9:46 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Sat, Jul 29, 2017 at 12:43:35PM -0700, Dan Williams wrote:
>> An inode with this flag set indicates that the file's block map cannot
>> be changed, no size change, deletion, hole-punch, range collapse, or
>> reflink.
>>
>> The implementation of toggling the flag and sealing the state of the
>> extent map is saved for a later patch. The functionality provided by
>> S_IOMAP_IMMUTABLE, once toggle support is added, will be a superset of
>> that provided by S_SWAPFILE, and it is targeted to replace it.
>>
>> For now, only xfs and the core vfs are updated to consider the new flag.
>>
>> The additional check that is added for this flag, beyond what we are
>> already doing for swapfiles, is to truncate or abort writes that try to
>> extend the file size.
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
>>  fs/attr.c          |   10 ++++++++++
>>  fs/namei.c         |    3 ++-
>>  fs/open.c          |    6 ++++++
>>  fs/read_write.c    |    3 +++
>>  fs/xfs/xfs_ioctl.c |    6 ++++++
>>  include/linux/fs.h |    2 ++
>>  mm/filemap.c       |    9 +++++++++
>>  7 files changed, 38 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/attr.c b/fs/attr.c
>> index 135304146120..8573e364bd06 100644
>> --- a/fs/attr.c
>> +++ b/fs/attr.c
>> @@ -112,6 +112,16 @@ EXPORT_SYMBOL(setattr_prepare);
>>   */
>>  int inode_newsize_ok(const struct inode *inode, loff_t offset)
>>  {
>> +     if (IS_IOMAP_IMMUTABLE(inode)) {
>> +             /*
>> +              * Any size change is disallowed. Size increases may
>> +              * dirty metadata that an application is not prepared to
>> +              * sync, and a size decrease may expose free blocks to
>> +              * in-flight DMA.
>> +              */
>> +             return -ETXTBSY;
>> +     }
>> +
>>       if (inode->i_size < offset) {
>>               unsigned long limit;
>>
>> diff --git a/fs/namei.c b/fs/namei.c
>> index ddb6a7c2b3d4..588f1135c42c 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -2793,7 +2793,8 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
>>               return -EPERM;
>>
>>       if (check_sticky(dir, inode) || IS_APPEND(inode) ||
>> -         IS_IMMUTABLE(inode) || IS_SWAPFILE(inode) || HAS_UNMAPPED_ID(inode))
>> +         IS_IMMUTABLE(inode) || IS_SWAPFILE(inode) || HAS_UNMAPPED_ID(inode)
>> +         || IS_IOMAP_IMMUTABLE(inode))
>
> This caught my eye because why wouldn't we be able to unlink a file
> whose block map is immutable?  Link count has "nothing" to do with that.
>
> :)
>
> Hmm... I guess the reasoning here is that if we're IOMAP_IMMUTABLE'd,
> we're not allowed to touch the link count since (we assume) nobody's
> who's interested in *inode is going to call fsync on it to flush the
> metadata to disk?
>
> If that's the case, then shouldn't there be a corresponding may_create
> check to prevent us from linking a file into a directory?
>
> (I don't really see why link/unlink shouldn't be allowed...)

True, unlink should be allowed, the blocks will still be immutable as
long as the file is open so I think we're good.

>>               return -EPERM;
>>       if (isdir) {
>>               if (!d_is_dir(victim))
>> diff --git a/fs/open.c b/fs/open.c
>> index 35bb784763a4..7395860d7164 100644
>> --- a/fs/open.c
>> +++ b/fs/open.c
>> @@ -292,6 +292,12 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>>               return -ETXTBSY;
>>
>>       /*
>> +      * We cannot allow any allocation changes on an iomap immutable file
>
> If it's a (regular allocation) or (unshare blocks) fallocate call, we
> could return zero immediately since no writes will be able to hit
> ENOSPC because we know that the block mappings are there and no CoW is
> required.

Sounds good assuming the regular allocation is staying within the
range of the current file size, and fail otherwise.

>
>> +      */
>> +     if (IS_IOMAP_IMMUTABLE(inode))
>> +             return -ETXTBSY;
>
> I've been wondering in the back of my head if we could allow a
> size-extending FALLOC_FL_ZERO_RANGE here that would fsync at the end?
> The use case I had in mind was extending files without having to turn
> off the IOMAP_IMMUTABLE flag, since (in theory, anyway) we'd bzero() the
> memory and then increase i_size, so userspace should never be able to
> access storage that isn't totally finalized.
>
> OTOH that also seems like a huge weird loophole in IOMAP_IMMUTABLE, so
> maybe everyone would prefer to shoot down this use case now?

It seems useful, because the alternative feels more error prone if
applications are forced to toggle IOMAP_IMMUTABLE.

>
>> +
>> +     /*
>>        * Revalidate the write permissions, in case security policy has
>>        * changed since the files were opened.
>>        */
>> diff --git a/fs/read_write.c b/fs/read_write.c
>> index 0cc7033aa413..dc673be7c7cb 100644
>> --- a/fs/read_write.c
>> +++ b/fs/read_write.c
>> @@ -1706,6 +1706,9 @@ int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
>>       if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
>>               return -ETXTBSY;
>>
>> +     if (IS_IOMAP_IMMUTABLE(inode_in) || IS_IOMAP_IMMUTABLE(inode_out))
>> +             return -ETXTBSY;
>> +
>>       /* Don't reflink dirs, pipes, sockets... */
>>       if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
>>               return -EISDIR;
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index e75c40a47b7d..2e64488bc4de 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -1755,6 +1755,12 @@ xfs_ioc_swapext(
>>               goto out_put_tmp_file;
>>       }
>>
>> +     if (IS_IOMAP_IMMUTABLE(file_inode(f.file)) ||
>> +         IS_IOMAP_IMMUTABLE(file_inode(tmp.file))) {
>> +             error = -EINVAL;
>> +             goto out_put_tmp_file;
>> +     }
>
> Someone's going to have to audit more of the XFS ioctls to make sure
> that none of them can touch the block mapping, but as this is an RFC it
> doesn't need to be done right this instant.

Speaking of things that need to be done before this mechanism can move
out of RFC, you had mentioned wanting to get your current devel
backlog cleared before moving ahead with this. I can offer some review
cycles, you'll just need to tolerate a higher
question-to-review-comment ratio given my relative XFS experience.

>
>> +
>>       /*
>>        * We need to ensure that the fds passed in point to XFS inodes
>>        * before we cast and access them as XFS structures as we have no
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 6e1fd5d21248..0a254b768855 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -1829,6 +1829,7 @@ struct super_operations {
>>  #else
>>  #define S_DAX                0       /* Make all the DAX code disappear */
>>  #endif
>> +#define S_IOMAP_IMMUTABLE 16384 /* logical-to-physical extent map is fixed */
>>
>>  /*
>>   * Note that nosuid etc flags are inode-specific: setting some file-system
>> @@ -1867,6 +1868,7 @@ struct super_operations {
>>  #define IS_AUTOMOUNT(inode)  ((inode)->i_flags & S_AUTOMOUNT)
>>  #define IS_NOSEC(inode)              ((inode)->i_flags & S_NOSEC)
>>  #define IS_DAX(inode)                ((inode)->i_flags & S_DAX)
>> +#define IS_IOMAP_IMMUTABLE(inode) ((inode)->i_flags & S_IOMAP_IMMUTABLE)
>>
>>  #define IS_WHITEOUT(inode)   (S_ISCHR(inode->i_mode) && \
>>                                (inode)->i_rdev == WHITEOUT_DEV)
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index a49702445ce0..e4a6529da2bd 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -2806,6 +2806,15 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
>>       if (unlikely(pos >= inode->i_sb->s_maxbytes))
>>               return -EFBIG;
>>
>> +     /* Are we about to mutate the block map on an immutable file? */
>> +     if (IS_IOMAP_IMMUTABLE(inode)
>> +                     && (pos + iov_iter_count(from) > i_size_read(inode))) {
>> +             if (pos < i_size_read(inode))
>> +                     iov_iter_truncate(from, i_size_read(inode) - pos);
>
> Writes past the end get truncated to stop at EOF?  I'd have thought that
> would be an error since userspace is asking for metadata updates it
> previously said it would never need...

It's an error if the current position is >= EOF, but otherwise allow a
truncated write. I'm fine either way.

...but then again if we allow FALLOC_FL_ZERO_RANGE to resize the file,
why not synchronous writes too? It turns IOMAP_IMMUTABLE into a flag
that only allows blocks to be added to a file, but not removed. That
would seem to dovetail well with synchronous mmap faults when / if XFS
grows that feature.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
