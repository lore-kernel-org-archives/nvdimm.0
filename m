Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F30C121CEB141
 for <linux-nvdimm@lists.01.org>; Thu, 26 Oct 2017 08:44:21 -0700 (PDT)
Date: Thu, 26 Oct 2017 17:48:04 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 17/17] xfs: support for synchronous DAX faults
Message-ID: <20171026154804.GF31161@quack2.suse.cz>
References: <20171024152415.22864-1-jack@suse.cz>
 <20171024152415.22864-18-jack@suse.cz>
 <20171024222322.GX3666@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171024222322.GX3666@dastard>
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
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 25-10-17 09:23:22, Dave Chinner wrote:
> On Tue, Oct 24, 2017 at 05:24:14PM +0200, Jan Kara wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Return IOMAP_F_DIRTY from xfs_file_iomap_begin() when asked to prepare
> > blocks for writing and the inode is pinned, and has dirty fields other
> > than the timestamps.
> 
> That's "fdatasync dirty", not "fsync dirty".

Correct.

> IOMAP_F_DIRTY needs a far better description of it's semantics than
> "/* block mapping is not yet on persistent storage */" so we know
> exactly what filesystems are supposed to be implementing here. I
> suspect that what it really is meant to say is:
> 
> /*
>  * IOMAP_F_DIRTY indicates the inode has uncommitted metadata to
>  * written data and requires fdatasync to commit to persistent storage.
>  */

I'll update the comment. Thanks!

> [....]
> 
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index f179bdf1644d..b43be199fbdf 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -33,6 +33,7 @@
> >  #include "xfs_error.h"
> >  #include "xfs_trans.h"
> >  #include "xfs_trans_space.h"
> > +#include "xfs_inode_item.h"
> >  #include "xfs_iomap.h"
> >  #include "xfs_trace.h"
> >  #include "xfs_icache.h"
> > @@ -1086,6 +1087,10 @@ xfs_file_iomap_begin(
> >  		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
> >  	}
> >  
> > +	if ((flags & IOMAP_WRITE) && xfs_ipincount(ip) &&
> > +	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> > +		iomap->flags |= IOMAP_F_DIRTY;
> 
> This is the very definition of an inode that is "fdatasync dirty".
> 
> Hmmmm, shouldn't this also be set for read faults, too?

No, read faults don't need to set IOMAP_F_DIRTY since user cannot write any
data to the page which he'd then like to be persistent. The only reason why
I thought it could be useful for a while was that it would be nice to make
MAP_SYNC mapping provide the guarantee that data you see now is the data
you'll see after a crash but we cannot provide that guarantee for RO
mapping anyway if someone else has the page mapped as well. So I just
decided not to return IOMAP_F_DIRTY for read faults.

But now that I look at XFS implementation again, it misses handling
of VM_FAULT_NEEDSYNC in xfs_filemap_pfn_mkwrite() (ext4 gets this right).
I'll fix this by using __xfs_filemap_fault() for xfs_filemap_pfn_mkwrite()
as well since it mostly duplicates it anyway... Thanks for inquiring!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
