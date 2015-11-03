Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 3 Nov 2015 12:16:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 14/15] dax: dirty extent notification
Message-ID: <20151103011653.GO10656@dastard>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151102043058.6610.15559.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151102043058.6610.15559.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@fb.com, jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Nov 01, 2015 at 11:30:58PM -0500, Dan Williams wrote:
> DAX-enabled block device drivers can use hints from fs/dax.c to
> optimize their internal tracking of potentially dirty cpu cache lines.
> If a DAX mapping is being used for synchronous operations, dax_do_io(),
> a dax-enabled block-driver knows that fs/dax.c will handle immediate
> flushing.  For asynchronous mappings, i.e.  returned to userspace via
> mmap, the driver can track active extents of the media for flushing.

So, essentially, you are marking the calls into the mapping calls
with BLKDAX_F_DIRTY when the mapping is requested for a write page
fault?  Hence allowing the block device to track "dirty pages"
exactly?

But, really, if we're going to use Ross's mapping tree patches that
use exceptional entries to track dirty pfns, why do we need to this
special interface from DAX to the block device? Ross's changes will
track mmap'd ranges that are dirtied at the filesytem inode level,
and the fsync/writeback will trigger CPU cache writeback of those
dirty ranges. This will work for block devices that are mapped by
DAX, too, because they have a inode+mapping tree, too.

And if we are going to use Ross's infrastructure (which, when we
work the kinks out of, I think we will), we really should change
dax_do_io() to track pfns that are dirtied this way, too. That will
allow us to get rid of all the cache flushing from the DAX layer
(they'll get pushed into fsync/writeback) and so we only take the
CPU cache flushing penalties when synchronous operations are
requested by userspace...

> We can later extend the DAX paths to indicate when an async mapping is
> "closed" allowing the active extents to be marked clean.

Yes, that's a basic feature of Ross's patches. Hence I think this
special case DAX<->bdev interface is the wrong direction to be
taking.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
