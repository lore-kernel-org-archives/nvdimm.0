Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au
 [211.29.132.249])
 by ml01.01.org (Postfix) with ESMTP id 8EDDA21276751
 for <linux-nvdimm@lists.01.org>; Wed, 29 May 2019 15:14:51 -0700 (PDT)
Date: Thu, 30 May 2019 08:14:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/18] dax: Introduce IOMAP_DAX_COW to CoW edges during
 writes
Message-ID: <20190529221445.GE16786@dread.disaster.area>
References: <1e9951c1-d320-e480-3130-dc1f4b81ef2c@cn.fujitsu.com>
 <20190523115109.2o4txdjq2ft7fzzc@fiona>
 <1620c513-4ce2-84b0-33dc-2675246183ea@cn.fujitsu.com>
 <20190528091729.GD9607@quack2.suse.cz>
 <a3a919e6-ecad-bdf6-423c-fc01f9cfa661@cn.fujitsu.com>
 <20190529024749.GC16786@dread.disaster.area>
 <376256fd-dee4-5561-eb4e-546e227303cd@cn.fujitsu.com>
 <20190529040719.GL5221@magnolia>
 <20190529044658.GD16786@dread.disaster.area>
 <20190529134629.GA32147@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190529134629.GA32147@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: kilobyte@angband.pl, "Darrick J. Wong" <darrick.wong@oracle.com>, nborisov@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-nvdimm@lists.01.org, dsterba@suse.cz, willy@infradead.org, linux-fsdevel@vger.kernel.org, hch@lst.de, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 29, 2019 at 03:46:29PM +0200, Jan Kara wrote:
> On Wed 29-05-19 14:46:58, Dave Chinner wrote:
> >  iomap_apply()
> > 
> >  	->iomap_begin()
> > 		map old data extent that we copy from
> > 
> > 		allocate new data extent we copy to in data fork,
> > 		immediately replacing old data extent
> > 
> > 		return transaction handle as private data

This holds the inode block map locked exclusively across the IO,
so....

> > 
> > 	dax_iomap_actor()
> > 		copies data from old extent to new extent
> > 
> > 	->iomap_end
> > 		commits transaction now data has been copied, making
> > 		the COW operation atomic with the data copy.
> > 
> > 
> > This, in fact, should be how we do all DAX writes that require
> > allocation, because then we get rid of the need to zero newly
> > allocated or unwritten extents before we copy the data into it. i.e.
> > we only need to write once to newly allocated storage rather than
> > twice.
> 
> You need to be careful though. You need to synchronize with page faults so
> that they cannot see and expose in page tables blocks you've allocated
> before their contents is filled.

... so the page fault will block trying to map the blocks because
it can't get the xfs_inode->i_ilock until the allocation transaciton
commits....

> This race was actually the strongest
> motivation for pre-zeroing of blocks. OTOH copy_from_iter() in
> dax_iomap_actor() needs to be able to fault pages to copy from (and these
> pages may be from the same file you're writing to) so you cannot just block
> faulting for the file through I_MMAP_LOCK.

Right, it doesn't take the I_MMAP_LOCK, but it would block further
in. And, really, I'm not caring all this much about this corner
case. i.e.  anyone using a "mmap()+write() zero copy" pattern on DAX
within a file is unbeleivably naive - the data still gets copied by
the CPU in the write() call. It's far simpler and more effcient to
just mmap() both ranges of the file(s) and memcpy() in userspace....

FWIW, it's to avoid problems with stupid userspace stuff that nobody
really should be doing that I want range locks for the XFS inode
locks.  If userspace overlaps the ranges and deadlocks in that case,
they they get to keep all the broken bits because, IMO, they are
doing something monumentally stupid. I'd probably be making it
return EDEADLOCK back out to userspace in the case rather than
deadlocking but, fundamentally, I think it's broken behaviour that
we should be rejecting with an error rather than adding complexity
trying to handle it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
