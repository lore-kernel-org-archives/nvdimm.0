Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 7 Oct 2015 08:15:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] block, dax: fix lifetime of in-kernel dax mappings
Message-ID: <20151006211525.GC32150@dastard>
References: <20150930002927.37133.331.stgit@dwillia2-desk3.jf.intel.com>
 <20150930004136.37133.66059.stgit@dwillia2-desk3.jf.intel.com>
 <20150930233529.GE3902@dastard>
 <CAPcyv4gw=sGqH=bTP7zkMgQCeJefrCbXNW9CHfqHCqd=DcKbPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gw=sGqH=bTP7zkMgQCeJefrCbXNW9CHfqHCqd=DcKbPQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 05, 2015 at 06:57:19PM -0700, Dan Williams wrote:
> On Wed, Sep 30, 2015 at 4:35 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Sep 29, 2015 at 08:41:36PM -0400, Dan Williams wrote:
> >> +static void __pmem *__dax_map_bh(const struct buffer_head *bh, unsigned blkbits,
> >> +             unsigned long *pfn, long *len)
> >
> > Please don't use bufferheads for this. Please pass an inode, the
> > block and length to map, similar to dax_clear_blocks().
> >
> > Why? Because dax_clear_blocks() needs to do this "mapping" too,
> > and it is called from contexts where there are no bufferheads.
> > There's a good chance we'll need more mapping contexts like this in
> > future, so lets not propagate bufferheads deeper into this code
> > than we absilutely need to.
> >
> > We should be trying to limit/remove bufferheads in the DAX code, not
> > propagating them deeper into the code...
> 
> So I gave this a try but ran into the road block that get_block() is
> performing the inode to bdev conversion and that is filesystem
> specific.  However, I'll at least not pass the bh into this map
> routine and will call it dax_map_atomic() which is more accurate.

Right, we still need the bh for the get_block call - that much is
unavoidable right now, but I'm angling towards converting XFS to
use a struct iomap and ->map_blocks method similar to the
exportfs calls for PNFS in future. Having a dedicated structure and
set of methods for obtaining and manipulating extent mappings on
inodes will make all these bufferhead issues go away...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
