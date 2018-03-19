Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0274F20954B94
 for <linux-nvdimm@lists.01.org>; Mon, 19 Mar 2018 11:02:34 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id l12-v6so18339511otj.7
 for <linux-nvdimm@lists.01.org>; Mon, 19 Mar 2018 11:09:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180319174559.GG1757@magnolia>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152112916514.24669.8643877835071945330.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180319174559.GG1757@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Mar 2018 11:09:02 -0700
Message-ID: <CAPcyv4hM5HOn-Gjn-Nqp_5rPL9ZK2MAjW79WvZaS7DbJnKDhbA@mail.gmail.com>
Subject: Re: [PATCH v6 14/15] xfs: prepare xfs_break_layouts() for another
 layout type
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 19, 2018 at 10:45 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, Mar 15, 2018 at 08:52:45AM -0700, Dan Williams wrote:
>> When xfs is operating as the back-end of a pNFS block server, it prevents
>> collisions between local and remote operations by requiring a lease to
>> be held for remotely accessed blocks. Local filesystem operations break
>> those leases before writing or mutating the extent map of the file.
>>
>> A similar mechanism is needed to prevent operations on pinned dax
>> mappings, like device-DMA, from colliding with extent unmap operations.
>>
>> BREAK_WRITE and BREAK_TRUNCATE are introduced as two distinct levels of
>> layout breaking.
>>
>> Layouts are broken in the BREAK_WRITE case to ensure that layout-holders
>> do not collide with local writes. Additionally, layouts are broken in
>> the BREAK_TRUNCATE case to make sure the layout-holder has a consistent
>> view of the file's extent map. While BREAK_WRITE breaks can be satisfied
>> be recalling FL_LAYOUT leases, BREAK_TRUNCATE breaks additionally
>> require waiting for busy dax-pages to go idle.
>>
>> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Reported-by: Dave Chinner <david@fromorbit.com>
>> Reported-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  fs/xfs/xfs_file.c  |   23 +++++++++++++++++------
>>  fs/xfs/xfs_inode.h |   18 ++++++++++++++++--
>>  fs/xfs/xfs_ioctl.c |    2 +-
>>  fs/xfs/xfs_iops.c  |    5 +++--
>>  4 files changed, 37 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 5742d395a4e4..399c5221f101 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -352,7 +352,7 @@ xfs_file_aio_write_checks(
>>
>>       xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
>>       *iolock |= XFS_MMAPLOCK_EXCL;
>> -     error = xfs_break_layouts(inode, iolock);
>> +     error = xfs_break_layouts(inode, iolock, BREAK_WRITE);
>>       if (error) {
>>               *iolock &= ~XFS_MMAPLOCK_EXCL;
>>               xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
>> @@ -762,7 +762,8 @@ xfs_file_write_iter(
>>  int
>>  xfs_break_layouts(
>>       struct inode            *inode,
>> -     uint                    *iolock)
>> +     uint                    *iolock,
>> +     enum layout_break_reason reason)
>>  {
>>       struct xfs_inode        *ip = XFS_I(inode);
>>       int                     ret;
>> @@ -770,9 +771,19 @@ xfs_break_layouts(
>>       ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
>>                               | XFS_MMAPLOCK_EXCL));
>>
>> -     ret = xfs_break_leased_layouts(inode, iolock);
>> -     if (ret > 0)
>> -             ret = 0;
>> +     switch (reason) {
>> +     case BREAK_TRUNCATE:
>> +             /* fall through */
>> +     case BREAK_WRITE:
>> +             ret = xfs_break_leased_layouts(inode, iolock);
>> +             if (ret > 0)
>> +                     ret = 0;
>> +             break;
>> +     default:
>> +             ret = -EINVAL;
>> +             break;
>> +     }
>> +
>>       return ret;
>>  }
>>
>> @@ -802,7 +813,7 @@ xfs_file_fallocate(
>>               return -EOPNOTSUPP;
>>
>>       xfs_ilock(ip, iolock);
>> -     error = xfs_break_layouts(inode, &iolock);
>> +     error = xfs_break_layouts(inode, &iolock, BREAK_TRUNCATE);
>>       if (error)
>>               goto out_unlock;
>>
>> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
>> index 74c63f3a720f..1a66c7afcf45 100644
>> --- a/fs/xfs/xfs_inode.h
>> +++ b/fs/xfs/xfs_inode.h
>> @@ -379,6 +379,20 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
>>                                       >> XFS_ILOCK_SHIFT)
>>
>>  /*
>> + * Layouts are broken in the BREAK_WRITE case to ensure that
>> + * layout-holders do not collide with local writes. Additionally,
>> + * layouts are broken in the BREAK_TRUNCATE case to make sure the
>> + * layout-holder has a consistent view of the file's extent map. While
>> + * BREAK_WRITE breaks can be satisfied be recalling FL_LAYOUT leases,
>> + * BREAK_TRUNCATE breaks additionally require waiting for busy dax-pages
>> + * to go idle.
>> + */
>> +enum layout_break_reason {
>> +        BREAK_WRITE,
>
> I wonder if this belongs in a system header file since the same general
> principle is going to apply to ext4 and others?  If this really is a
> special xfs thing, then please use the "XFS_" prefix.
>
>> +        BREAK_TRUNCATE,
>
> The "truncate" part of the name misled me for a bit.  That operation is
> really about "make sure there are no busy dax pages because we're about
> to change some file pmem^Wblock mappings", right?  Truncation, hole
> punching, reflinking, and zero_range (because it punches the range and
> reallocates unwritten extents) all have to wait for busy dax pages to
> become free before they can begin unmapping blocks.  So this isn't just
> about truncation specifically; can I suggest "BREAK_UNMAPI" ?

I like that name better.

It isn't clear that this needs to go to a system header because I
expect ext4 will only support BREAK_UNMAPI for dax and not care about
BREAK_WRITE since that is an XFS-only / pNFS-only distinction in
current code. However, I'll let Jan chime in if this guess is
incorrect and ext4 plans to add pNFS block-server support.

> (I also haven't figured out whether the same requirements apply to
> things that *add* extent maps to the file, but I have to run to a
> meeting in a few so wanted to get this email sent.)

Add should not be a problem because DMA only ever starts after extents
are added, i.e. there's no risk of DMA starting to invalid address
because fs/dax.c arranges for extents to be allocated at fault time.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
