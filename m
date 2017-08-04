Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x231.google.com (mail-vk0-x231.google.com
 [IPv6:2607:f8b0:400c:c05::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 34AE621D491B1
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 13:53:17 -0700 (PDT)
Received: by mail-vk0-x231.google.com with SMTP id u133so10095639vke.3
 for <linux-nvdimm@lists.01.org>; Fri, 04 Aug 2017 13:55:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804205337.GG24087@magnolia>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150181371519.32119.2762945986660101008.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170804201412.GE24087@magnolia>
 <CAPcyv4himTRCu9t2zyyxHEDRKmNQ=h7z9aNxqdfEuxSM=A4bhg@mail.gmail.com>
 <20170804205337.GG24087@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 4 Aug 2017 13:55:29 -0700
Message-ID: <CAPcyv4gVx8JZN1vWcMR1bqZXPzTqGjjQJVT3OLPVCYa7MiH1GQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] xfs: toggle XFS_DIFLAG2_IOMAP_IMMUTABLE in
 response to fallocate
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 4, 2017 at 1:53 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Fri, Aug 04, 2017 at 01:47:32PM -0700, Dan Williams wrote:
>> On Fri, Aug 4, 2017 at 1:14 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>> > On Thu, Aug 03, 2017 at 07:28:35PM -0700, Dan Williams wrote:
>> >> After validating the state of the file as not having holes, shared
>> >> extents, or active mappings try to commit the
>> >> XFS_DIFLAG2_IOMAP_IMMUTABLE flag to the on-disk inode metadata. If that
>> >> succeeds then allow the S_IOMAP_IMMUTABLE to be set on the vfs inode.
>> >>
>> >> Cc: Jan Kara <jack@suse.cz>
>> >> Cc: Jeff Moyer <jmoyer@redhat.com>
>> >> Cc: Christoph Hellwig <hch@lst.de>
>> >> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> >> Suggested-by: Dave Chinner <david@fromorbit.com>
>> >> Suggested-by: "Darrick J. Wong" <darrick.wong@oracle.com>
>> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> >> ---
>> >>  fs/xfs/xfs_bmap_util.c |   32 ++++++++++++++++++++++++++++++++
>> >>  1 file changed, 32 insertions(+)
>> >>
>> >> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> >> index 70ac2d33ab27..8464c25a2403 100644
>> >> --- a/fs/xfs/xfs_bmap_util.c
>> >> +++ b/fs/xfs/xfs_bmap_util.c
>> >> @@ -1436,9 +1436,11 @@ xfs_seal_file_space(
>> >>       xfs_off_t               offset,
>> >>       xfs_off_t               len)
>> >>  {
>> >> +     struct xfs_mount        *mp = ip->i_mount;
>> >>       struct inode            *inode = VFS_I(ip);
>> >>       struct address_space    *mapping = inode->i_mapping;
>> >>       int                     error;
>> >> +     struct xfs_trans        *tp;
>> >>
>> >>       ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
>> >>
>> >> @@ -1454,6 +1456,10 @@ xfs_seal_file_space(
>> >>       if (error)
>> >>               return error;
>> >>
>> >> +     error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
>> >> +     if (error)
>> >> +             return error;
>> >> +
>> >>       xfs_ilock(ip, XFS_ILOCK_EXCL);
>> >>       /*
>> >>        * Either the size changed after we performed allocation /
>> >> @@ -1486,10 +1492,20 @@ xfs_seal_file_space(
>> >>       if (error < 0)
>> >>               goto out_unlock;
>> >>
>> >> +     xfs_trans_ijoin(tp, ip, 0);
>> >
>> > FWIW if you change that third parameter to XFS_ILOCK_EXCL then
>> > xfs_trans_commit will do the xfs_iunlock(ip, XFS_ILOCK_EXCL) for you if
>> > the commit succeeds...
>> >
>> >> +     ip->i_d.di_flags2 |= XFS_DIFLAG2_IOMAP_IMMUTABLE;
>> >> +     xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>> >> +     error = xfs_trans_commit(tp);
>> >> +     tp = NULL; /* nothing to cancel */
>> >> +     if (error)
>> >> +             goto out_unlock;
>> >> +
>> >>       inode->i_flags |= S_IOMAP_IMMUTABLE;
>> >
>> > ...and then you can just return out here.
>>
>> Do we not need to hold XFS_ILOCK_EXCL over ->i_flags changes, or is
>> XFS_IOLOCK_EXCL enough?
>
> Oh, heh, I missed a piece.  Set the flag before the transaction commit,
> because if the commit fails the fs is shut down anyway. :)

Ah, got it, thanks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
