Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE95D2035BB1C
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 21:57:26 -0800 (PST)
Date: Mon, 13 Nov 2017 22:01:29 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fs, dax: unify IOMAP_F_DIRTY read vs write handling
 policy in the dax core
Message-ID: <20171114060129.GB15810@infradead.org>
References: <151062258598.8554.8157038002895095232.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171114041228.GA4094@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171114041228.GA4094@dastard>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 14, 2017 at 03:12:28PM +1100, Dave Chinner wrote:
> On Mon, Nov 13, 2017 at 05:27:54PM -0800, Dan Williams wrote:
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index b43be199fbdf..888b60189983 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -1087,9 +1087,9 @@ xfs_file_iomap_begin(
> >  		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
> >  	}
> >  
> > -	if ((flags & IOMAP_WRITE) && xfs_ipincount(ip) &&
> > -	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> > -		iomap->flags |= IOMAP_F_DIRTY;
> > +	if (xfs_ipincount(ip))
> > +		if (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP)
> > +			iomap->flags |= IOMAP_F_DIRTY;
> 
> Please make a helper for this, and use it in xfs_file_fsync() where
> the same dirty checks are done. e.g.

Let's keep that sort of cleanup separate.  I initially considered
it when doing the MAP_SYNC work, but fsync works a little different
in that it looks at ili_last_lsn, so your little helper below won't
work as-is.  You can send it as an incremental patch later and we
can see if we can come up with something workable.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
