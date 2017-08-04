Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x229.google.com (mail-vk0-x229.google.com
 [IPv6:2607:f8b0:400c:c05::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 044FC21AEB0CD
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 13:29:19 -0700 (PDT)
Received: by mail-vk0-x229.google.com with SMTP id r199so9877305vke.4
 for <linux-nvdimm@lists.01.org>; Fri, 04 Aug 2017 13:31:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804200037.GC24087@magnolia>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150181369070.32119.1019092252036976783.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170804200037.GC24087@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 4 Aug 2017 13:31:28 -0700
Message-ID: <CAPcyv4gfkt0QTPwTWZmXfFWAzJUovexkKCiAZhqgmjAbtEr7tA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] fs, xfs: introduce S_IOMAP_IMMUTABLE
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

On Fri, Aug 4, 2017 at 1:00 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Thu, Aug 03, 2017 at 07:28:10PM -0700, Dan Williams wrote:
>> An inode with this flag set indicates that the file's block map cannot
>> be changed from the currently allocated set.
>>
>> The implementation of toggling the flag and sealing the state of the
>> extent map is saved for a later patch. The functionality provided by
>> S_IOMAP_IMMUTABLE, once toggle support is added, will be a superset of
>> that provided by S_SWAPFILE, and it is targeted to replace it.
>>
>> For now, only xfs and the core vfs are updated to consider the new flag.
>>
>> The additional checks that are added for this flag, beyond what we are
>> already doing for swapfiles, are:
>> * fail writes that try to extend the file size
>> * fail attempts to directly change the allocation map via fallocate or
>>   xfs ioctls. This can be done centrally by blocking
>>   xfs_alloc_file_space and xfs_free_file_space when the flag is set.
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
>>  fs/attr.c              |   10 ++++++++++
>>  fs/open.c              |    6 ++++++
>>  fs/read_write.c        |    3 +++
>>  fs/xfs/xfs_bmap_util.c |    6 ++++++
>>  fs/xfs/xfs_ioctl.c     |    6 ++++++
>>  include/linux/fs.h     |    2 ++
>>  mm/filemap.c           |    5 +++++
>>  7 files changed, 38 insertions(+)
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
>> diff --git a/fs/open.c b/fs/open.c
>> index 35bb784763a4..7395860d7164 100644
>> --- a/fs/open.c
>> +++ b/fs/open.c
>> @@ -292,6 +292,12 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>>               return -ETXTBSY;
>>
>>       /*
>> +      * We cannot allow any allocation changes on an iomap immutable file
>> +      */
>> +     if (IS_IOMAP_IMMUTABLE(inode))
>> +             return -ETXTBSY;
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
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index 93e955262d07..fe0f8f7f4bb7 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -1044,6 +1044,9 @@ xfs_alloc_file_space(
>>       if (XFS_FORCED_SHUTDOWN(mp))
>>               return -EIO;
>>
>> +     if (IS_IOMAP_IMMUTABLE(VFS_I(ip)))
>> +             return -ETXTBSY;
>> +
>
> Hm.  The 'seal this up' caller in the next patch doesn't check for
> ETXTBSY (or if it does I missed that), so if you try to seal an already
> sealed file you'll get an error code even though you actually got the
> state you wanted.

That's a good point, I'll fix that up.

>
> Second question: How might we handle the situation where a filesystem
> /has/ to alter a block mapping?  Hypothetically, if the block layer
> tells the fs that some range of storage has gone bad and the fs decides
> to punch out that part of the file (or mark it unwritten or whatever) to
> avoid a machine check, can we lock out file IO, forcibly remove the
> mapping from memory, make whatever block map updates we want, and then
> unlock?

It's not clear that the filesystem /has/ to change the block mappings
when the backing media supports error clearing. Unlike bad DRAM ranges
where the address is permanently mapped out, we can clear pmem and
disk errors by writing new data. The bad block can be repaired or
remapped internal to the hardware device.

As far as I can see no amount of fs locking will keep in-flight DMA
from assuming it can continue to write to the storage address it
thought was immutable. So, I think that means that the only error
management that can be expected while the file is immutable is
blkdev_issue_zeroout() to clear the error, or otherwise hope that the
DMA operation can generate the properly sized/aligned write request
that can clear the error.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
