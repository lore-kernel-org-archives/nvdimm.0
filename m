Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB91521E1DAF2
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 16:55:37 -0700 (PDT)
Date: Fri, 4 Aug 2017 16:57:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 4/5] xfs: introduce XFS_DIFLAG2_IOMAP_IMMUTABLE
Message-ID: <20170804235740.GH24087@magnolia>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150181371001.32119.599597939855384271.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170804203312.GF24087@magnolia> <20170804234615.GG21024@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170804234615.GG21024@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, luto@kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Aug 05, 2017 at 09:46:15AM +1000, Dave Chinner wrote:
> On Fri, Aug 04, 2017 at 01:33:12PM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 03, 2017 at 07:28:30PM -0700, Dan Williams wrote:
> > > Add an on-disk inode flag to record the state of the S_IOMAP_IMMUTABLE
> > > in-memory vfs inode flags. This allows the protections against reflink
> > > and hole punch to be automatically restored on a sub-sequent boot when
> > > the in-memory inode is established.
> > > 
> > > The FS_XFLAG_IOMAP_IMMUTABLE is introduced to allow xfs_io to read the
> > > state of the flag, but toggling the flag requires going through
> > > fallocate(FALLOC_FL_[UN]SEAL_BLOCK_MAP). Support for toggling this
> > > on-disk state is saved for a later patch.
> > > 
> > > Cc: Jan Kara <jack@suse.cz>
> > > Cc: Jeff Moyer <jmoyer@redhat.com>
> > > Cc: Christoph Hellwig <hch@lst.de>
> > > Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > Suggested-by: Dave Chinner <david@fromorbit.com>
> > > Suggested-by: "Darrick J. Wong" <darrick.wong@oracle.com>
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_format.h |    5 ++++-
> > >  fs/xfs/xfs_inode.c         |    2 ++
> > >  fs/xfs/xfs_ioctl.c         |    1 +
> > >  fs/xfs/xfs_iops.c          |    8 +++++---
> > >  include/uapi/linux/fs.h    |    1 +
> > >  5 files changed, 13 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > index d4d9bef20c3a..9e720e55776b 100644
> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > @@ -1063,12 +1063,15 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
> > >  #define XFS_DIFLAG2_DAX_BIT	0	/* use DAX for this inode */
> > >  #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
> > >  #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
> > > +#define XFS_DIFLAG2_IOMAP_IMMUTABLE_BIT 3 /* set S_IOMAP_IMMUTABLE for this inode */
> > 
> > So... the greedy part of my brain that doesn't want to give out flags2
> > bits has been wondering,
> 
> FWIW, I made di_flags2 a 64 bit value in the first place precisely
> so we didn't have a scarcity problem and can just give out flag
> bits for enabling new functionality like this...

Ok.  That's what I thought.

> > what if we just didn't have an on-disk
> > IOMAP_IMMUTABLE bit, and set FS_XFLAG based only on the in-core
> > S_IOMAP_IMMUTABLE bit?  If a program wants the immutable iomap
> > semantics, they will have to code some variant on the following:
> > 
> > fd = open(...);
> > ret = fallocate(fd, FALLOC_FL_SEAL_BLOCK_MAP, 0, len...)
> > if (ret) {
> > 	printf("couldn't seal block map");
> > 	close(fd);
> > 	return;
> > }
> > 
> > mmap(fd...);
> > /* do sensitive io operations here */
> > munmap(fd...);
> > 
> > close(fd);
> > 
> > Therefore the cost of not having the on-disk flag is that we'll have to
> > do more unshare/alloc/test/set cycles than we would if we could remember
> > the iomap-immutable state across unmounts and inode reclaiming.
> > However, if the data map is already ready to go, this shouldn't have a
> > lot of overhead since we only have to iterate the in-core extents.
> > 
> > Just trying to make sure we /need/ the inode flag bit. :)
> 
> IMO, fallocate() is for making permanent changes to file extents. If
> this is not going to be a permanent state change but only a
> runtime-while-the-inode-is-in-cache flag, then it's probably not the
> right interface to use.
> 
> This also seems problematic for applications other than DAX where
> the block map may be sealed, the fd closed and access handed off to
> another entity for remote storage access. If the inode gets
> reclaimed due to memory pressure, the system loses the fact that
> that the inode has been sealed. Hence another process can come
> along, re-read the inode and modify the block map because it hasn't
> been sealed in this new cache life cycle.....

<nod> Ok, I'm convinced. :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
